#!/bin/bash
# Sync rice configuration to Arch VM
# Usage: ./sync-to-vm.sh [user@vm-ip]

VM_TARGET=${1:-"user@archvm"}
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Syncing Hyprland Rice to VM: $VM_TARGET"

# Create remote directory
ssh "$VM_TARGET" "mkdir -p ~/.config/hypr-rice"

# Sync all files except .git and build artifacts
rsync -avz --exclude=".git" --exclude="*.pyc" --exclude="__pycache__" \
    "$PROJECT_DIR/" "$VM_TARGET:~/.config/hypr-rice/"

echo "Sync complete. Run install.sh on the VM to apply the rice."
