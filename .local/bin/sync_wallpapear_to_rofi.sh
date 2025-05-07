#!/bin/bash

# Configuration
ROFI_IMAGE_DIR="$HOME/.config/rofi/images"
ROFI_WALLPAPER="$ROFI_IMAGE_DIR/current_wallpaper"
WAYPAPER_CONFIG="$HOME/.config/waypaper/config.ini"

# Ensure the Rofi images directory exists
mkdir -p "$ROFI_IMAGE_DIR"

# Function to get the current wallpaper path from waypaper's config
get_current_wallpaper() {
    if [[ -f "$WAYPAPER_CONFIG" ]]; then
        # Read the 'wallpaper' key from config.ini and expand ~ to $HOME
        wallpaper_path=$(grep '^wallpaper' "$WAYPAPER_CONFIG" | cut -d '=' -f 2 | xargs)
        # Replace ~ with $HOME to ensure proper path resolution
        wallpaper_path="${wallpaper_path/#\~/$HOME}"
        echo "$wallpaper_path"
    else
        echo "Error: Waypaper config file not found at $WAYPAPER_CONFIG" >&2
        exit 1
    fi
}

# Function to update the Rofi wallpaper
update_rofi_wallpaper() {
    local wallpaper_path="$1"
    if [[ -f "$wallpaper_path" ]]; then
        # Copy the wallpaper to the Rofi images directory
        cp "$wallpaper_path" "$ROFI_WALLPAPER"
        echo "Updated Rofi wallpaper to $ROFI_WALLPAPER"
    else
        echo "Error: Wallpaper file not found at $wallpaper_path" >&2
        exit 1
    fi
}

# Function to monitor wallpaper changes
monitor_wallpaper_changes() {
    # Initial sync
    wallpaper_path=$(get_current_wallpaper)
    update_rofi_wallpaper "$wallpaper_path"

    # Monitor the waypaper config file for changes
    inotifywait -m "$WAYPAPER_CONFIG" -e modify |
    while read -r event; do
        echo "Detected change in waypaper config"
        wallpaper_path=$(get_current_wallpaper)
        update_rofi_wallpaper "$wallpaper_path"
    done
}

# Check if inotifywait is installed
if ! command -v inotifywait >/dev/null 2>&1; then
    echo "Error: inotifywait is required. Please install inotify-tools."
    exit 1
fi

# Run the monitoring function
monitor_wallpaper_changes
