#!/bin/bash
# Install Hyprland Rice on Arch Linux VM

set -e

echo "Installing Hyprland Rice..."

# Check if running on Arch Linux
if ! command -v pacman &> /dev/null; then
    echo "Error: This script is for Arch Linux only"
    exit 1
fi

# Install required packages
echo "Installing required packages..."
sudo pacman -S --needed --noconfirm \
    hyprland hyprpaper waybar rofi-wayland mako \
    foot kitty thunar brightnessctl \
    python python-pillow python-pip \
    ttf-jetbrains-mono papirus-icon-theme

# Install Python packages
pip install --user Pillow numpy

# Create necessary directories
mkdir -p ~/.config/{hypr,waybar,foot,kitty,rofi,mako}

# Set up the rice directory
RICE_DIR="$HOME/.config/hypr-rice"
cd "$RICE_DIR"

# Make scripts executable
chmod +x scripts/*.sh tools/*.py

# Copy some sample wallpapers if none exist
if [ ! -d "wallpapers" ] || [ -z "$(ls -A wallpapers 2>/dev/null)" ]; then
    echo "Setting up sample wallpapers..."
    mkdir -p wallpapers
    
    # Download some sample wallpapers (optional)
    # You can add your own wallpapers to the wallpapers directory
    echo "Add your wallpapers to ~/.config/hypr-rice/wallpapers/"
fi

# Apply initial configuration with a default theme
echo "Applying initial configuration..."

# Create a default color scheme if none exists
if [ ! -f "themes/colors.json" ]; then
    mkdir -p themes
    echo "{
  \"bg\": \"#282828\",
  \"fg\": \"#ebdbb2\",
  \"red\": \"#cc241d\",
  \"green\": \"#98971a\", 
  \"yellow\": \"#d79921\",
  \"blue\": \"#458588\",
  \"magenta\": \"#b16286\",
  \"cyan\": \"#689d6a\"
}" > themes/colors.json
fi

# Apply the theme
./scripts/apply_theme.sh

# Set up hyprpaper config
mkdir -p ~/.config/hypr
echo "# Hyprpaper will be configured by change_wallpaper.sh" > ~/.config/hypr/hyprpaper.conf

echo ""
echo "Installation complete!"
echo ""
echo "Usage:"
echo "  - Super+W: Change wallpaper (with auto-theming)"
echo "  - Super+Q: Open terminal"
echo "  - Super+R: Open application launcher"
echo "  - Run: python3 ~/.config/hypr-rice/tools/rice_config_gui.py (GUI config tool)"
echo ""
echo "Add your wallpapers to: ~/.config/hypr-rice/wallpapers/"
echo "Then use Super+W to switch wallpapers and auto-generate themes!"
