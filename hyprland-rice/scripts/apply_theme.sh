#!/bin/bash
# Apply extracted colors to all configuration files

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
COLORS_FILE="$PROJECT_DIR/themes/colors.json"

if [ ! -f "$COLORS_FILE" ]; then
    echo "Colors file not found: $COLORS_FILE"
    exit 1
fi

# Read colors from JSON (using Python for simplicity)
eval $(python3 -c "
import json
with open(\"$COLORS_FILE\") as f:
    colors = json.load(f)
for key, value in colors.items():
    print(f\"{key.upper()}={value}\")
")

echo "Applying theme colors..."

# Function to replace color placeholders
replace_colors() {
    local src_file="$1"
    local dst_file="$2"
    
    cp "$src_file" "$dst_file"
    
    # Replace color placeholders
    sed -i "s/{{BG_COLOR}}/$BG/g" "$dst_file"
    sed -i "s/{{FG_COLOR}}/$FG/g" "$dst_file"
    sed -i "s/{{ACCENT_COLOR}}/$BLUE/g" "$dst_file"
    sed -i "s/{{RED_COLOR}}/$RED/g" "$dst_file"
    sed -i "s/{{GREEN_COLOR}}/$GREEN/g" "$dst_file"
    sed -i "s/{{YELLOW_COLOR}}/$YELLOW/g" "$dst_file"
    sed -i "s/{{BLUE_COLOR}}/$BLUE/g" "$dst_file"
    sed -i "s/{{MAGENTA_COLOR}}/$MAGENTA/g" "$dst_file"
    sed -i "s/{{CYAN_COLOR}}/$CYAN/g" "$dst_file"
}

# Apply to Hyprland
replace_colors "$PROJECT_DIR/configs/hyprland.conf" "$HOME/.config/hypr/hyprland.conf"

# Apply to Waybar
mkdir -p "$HOME/.config/waybar"
cp "$PROJECT_DIR/configs/waybar-config.json" "$HOME/.config/waybar/config"
replace_colors "$PROJECT_DIR/configs/waybar-style.css" "$HOME/.config/waybar/style.css"

# Apply to terminals
mkdir -p "$HOME/.config/foot"
replace_colors "$PROJECT_DIR/configs/foot.ini" "$HOME/.config/foot/foot.ini"

mkdir -p "$HOME/.config/kitty"
replace_colors "$PROJECT_DIR/configs/kitty.conf" "$HOME/.config/kitty/kitty.conf"

# Apply to Rofi
mkdir -p "$HOME/.config/rofi"
cp "$PROJECT_DIR/configs/rofi-config.rasi" "$HOME/.config/rofi/config.rasi"
mkdir -p "$PROJECT_DIR/themes"
replace_colors "$PROJECT_DIR/configs/rofi-theme.rasi" "$PROJECT_DIR/themes/rofi-theme.rasi"

# Apply to Mako
mkdir -p "$HOME/.config/mako"
replace_colors "$PROJECT_DIR/configs/mako.conf" "$HOME/.config/mako/config"

# Reload applications
pkill waybar && waybar &
makoctl reload
pkill foot
pkill kitty

echo "Theme applied successfully!"
