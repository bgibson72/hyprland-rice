#!/bin/bash
set -e
echo "Installing Hyprland Rice..."

if ! command -v pacman &> /dev/null; then
    echo "Error: This script is for Arch Linux only"
    exit 1
fi

echo "Installing packages with Python system packages..."
sudo pacman -S --needed --noconfirm \
    hyprland hyprpaper waybar rofi-wayland mako \
    foot kitty thunar brightnessctl \
    python python-pillow python-numpy \
    ttf-jetbrains-mono papirus-icon-theme

mkdir -p ~/.config/{hypr,waybar,foot,kitty,rofi,mako}

RICE_DIR="$HOME/.config/hypr-rice"
cd "$RICE_DIR"
chmod +x scripts/*.sh tools/*.py

mkdir -p wallpapers themes

if [ ! -f "themes/colors.json" ]; then
    echo '{"bg":"#282828","fg":"#ebdbb2","red":"#cc241d","green":"#98971a","yellow":"#d79921","blue":"#458588","magenta":"#b16286","cyan":"#689d6a"}' > themes/colors.json
fi

./scripts/apply_theme.sh

echo "Installation complete! Use Super+W to change wallpapers."
