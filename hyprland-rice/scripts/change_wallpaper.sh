#!/bin/bash
# Wallpaper changer with automatic theming

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
WALLPAPER_DIR="$PROJECT_DIR/wallpapers"

# Create wallpapers directory if it doesnt exist
mkdir -p "$WALLPAPER_DIR"

if [ "$#" -eq 0 ]; then
    # Show wallpaper selector using rofi
    WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) -exec basename {} \; | rofi -dmenu -p "Select wallpaper:")
    
    if [ -z "$WALLPAPER" ]; then
        echo "No wallpaper selected"
        exit 1
    fi
    
    WALLPAPER_PATH="$WALLPAPER_DIR/$WALLPAPER"
else
    WALLPAPER_PATH="$1"
fi

if [ ! -f "$WALLPAPER_PATH" ]; then
    echo "Wallpaper not found: $WALLPAPER_PATH"
    exit 1
fi

echo "Setting wallpaper: $WALLPAPER_PATH"

# Extract colors from wallpaper
python3 "$SCRIPT_DIR/extract_colors.py" "$WALLPAPER_PATH"

# Apply the new theme
"$SCRIPT_DIR/apply_theme.sh"

# Set wallpaper using hyprctl
hyprctl hyprpaper wallpaper ",$WALLPAPER_PATH"

# Also update hyprpaper config
echo "preload = $WALLPAPER_PATH
wallpaper = ,$WALLPAPER_PATH" > "$HOME/.config/hypr/hyprpaper.conf"

echo "Wallpaper and theme updated!"
