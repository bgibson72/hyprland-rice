#!/bin/bash

# Strict mode
set -euo pipefail
IFS=$'\n\t'

# Configuration
CONFIG_DIR_SOURCE="\\home\\bryan\\Matuprland" # Source of your config files
CONFIG_DIR_TARGET="$HOME/.config"
INSTALL_COMMAND="sudo pacman -S --noconfirm" # Adjust if using an AUR helper e.g. yay -S --noconfirm

# List of applications to install (derived from directory names)
# Add or remove from this list as needed.
APPS=(
    "bat"        # bat/
    "cava"       # cava/
    "fastfetch"  # fastfetch/
    "foot"       # foot/
    # gtk-3.0 is a theming engine, not an app itself. Handled by copying gtk-3.0/
    "hyprland"   # hypr/ - Hyprland window manager itself
    "kvantum"    # Kvantum/
    "lazygit"    # lazygit/
    # librewolf is a browser, installation might be different (e.g., AUR or flatpak)
    # matugen is a tool, installation might be different
    "qt5ct"      # qt5ct/
    "qt6ct"      # qt6ct/
    "rofi"       # rofi/
    # shell/ likely contains shell configurations, not an app.
    "starship"   # starship/
    "swappy"     # swappy/
    "swayimg"    # swayimg/
    "swaync"     # swaync/
    "tmux"       # tmux/
    "waybar"     # waybar/
    "wlogout"    # wlogout/
    "yazi"       # yazi/
    "zathura"    # zathura/
    # zsh is a shell, usually installed as a dependency or base package.
    # Add other essential packages for a Hyprland setup
    "hyprpicker" # Color picker
    "wl-clipboard" # Clipboard support for Wayland
    "cliphist"     # Clipboard history manager
    "jq"           # JSON processor, often useful for scripts
    "polkit-kde-agent" # For authentication dialogs in KDE/Qt apps
    "pipewire"     # Audio server
    "wireplumber"  # Session manager for PipeWire
    "pipewire-audio"
    "pipewire-alsa"
    "pipewire-pulse"
    "pipewire-jack"
    "xdg-desktop-portal-hyprland" # For screen sharing, etc.
    "xdg-desktop-portal-gtk"      # GTK portal
    "noto-fonts"   # General purpose fonts
    "noto-fonts-cjk" # Fonts for Chinese, Japanese, Korean
    "noto-fonts-emoji" # Emoji fonts
    "ttf-jetbrains-mono-nerd" # Popular Nerd Font for icons in terminal/bar
    "ttf-font-awesome" # Font Awesome icons
    "grim"         # For screenshots
    "slurp"        # For selecting a region for screenshots
    "pamixer"      # For controlling volume
    "pavucontrol"  # Volume control GUI (PulseAudio compatible)
    "brightnessctl" # For controlling screen brightness
    "bluez"        # Bluetooth stack
    "bluez-utils"  # Bluetooth utilities
    "networkmanager" # Network management
    "nm-connection-editor" # GUI for NetworkManager
    "thunar"       # A lightweight file manager (or choose your preferred one)
    # Add any other specific dependencies for your listed apps if not covered by their pacman package
)

# --- Installation Phase ---
echo ">>> Starting application installation..."

# Update system first
sudo pacman -Syu --noconfirm

for app in "${APPS[@]}"; do
    echo ">>> Installing $app..."
    if $INSTALL_COMMAND "$app"; then
        echo ">>> Successfully installed $app."
    else
        echo ">>> WARNING: Failed to install $app. It might be an AUR package or not exist in repositories."
        echo ">>> Please install it manually if needed."
    fi
done

echo ">>> Application installation phase complete."
echo

# --- Configuration Copying Phase ---
echo ">>> Starting configuration file copying..."

# Create target config directory if it doesn't exist
mkdir -p "$CONFIG_DIR_TARGET"

# Config directories to copy (matches your Maturpland structure)
# Add or remove from this list based on what you want to copy.
CONFIG_DIRS_TO_COPY=(
    "bat"
    "cava"
    "fastfetch"
    "foot"
    "gtk-3.0"
    "hypr"
    "Kvantum"
    "lazygit"
    "librewolf" # Browser profiles are usually more complex to manage this way.
    "matugen"
    "qt5ct"
    "qt6ct"
    "rofi"
    "starship"
    "swappy"
    "swayimg"
    "swaync"
    "tmux"
    "waybar"
    "wlogout"
    "yazi"
    "zathura"
)

for dir_name in "${CONFIG_DIRS_TO_COPY[@]}"; do
    SOURCE_PATH="$CONFIG_DIR_SOURCE/$dir_name"
    TARGET_PATH="$CONFIG_DIR_TARGET/$dir_name"

    if [ -d "$SOURCE_PATH" ]; then
        echo ">>> Copying configuration for $dir_name..."
        # Remove existing target directory to avoid merging issues (optional, be careful)
        if [ -d "$TARGET_PATH" ]; then
            echo "    Removing existing $TARGET_PATH..."
            rm -rf "$TARGET_PATH"
        fi
        cp -r "$SOURCE_PATH" "$CONFIG_DIR_TARGET/"
        echo ">>> Successfully copied $dir_name to $CONFIG_DIR_TARGET."
    else
        echo ">>> WARNING: Source configuration directory $SOURCE_PATH not found. Skipping $dir_name."
    fi
done

# --- Special file/directory handling ---

# Bashrc (example, if you have a bashrc directory)
BASHRC_SOURCE_DIR="$CONFIG_DIR_SOURCE/bashrc"
BASHRC_TARGET_FILE="$HOME/.bashrc" # Or link individual files to .bash_profile or .bashrc.d
if [ -d "$BASHRC_SOURCE_DIR" ]; then
    echo ">>> Setting up bash configuration..."
    # This is an example. You might want to concatenate, source, or link files.
    # For simplicity, let's assume you want to replace .bashrc with a main file from your bashrc dir
    # Or, more commonly, you'd source files from .bashrc
    # e.g., if [ -f "$BASHRC_SOURCE_DIR/00-init" ]; then cat "$BASHRC_SOURCE_DIR/00-init" >> "$BASHRC_TARGET_FILE"; fi
    echo "    Note: Bashrc setup needs to be customized based on your bashrc/ structure."
    echo "    Copying .bashrc directory to $HOME/.bashrc_custom_configs and reminding user to source it."
    cp -r "$BASHRC_SOURCE_DIR" "$HOME/.bashrc_custom_configs"
    echo "    Run 'echo ". $HOME/.bashrc_custom_configs/00-init" >> $HOME/.bashrc' or similar for each file."

fi

# Zsh (example, if you have a zsh directory with .zshrc or .zaliases)
ZSH_SOURCE_DIR="$CONFIG_DIR_SOURCE/zsh"
ZSHRC_TARGET_FILE="$HOME/.zshrc"
ZALIASES_TARGET_FILE="$HOME/.zaliases" # Or wherever you source aliases

if [ -d "$ZSH_SOURCE_DIR" ]; then
    echo ">>> Setting up Zsh configuration..."
    if [ -f "$ZSH_SOURCE_DIR/zshrc" ]; then # Assuming you might have a full zshrc
        echo "    Copying zshrc to $ZSHRC_TARGET_FILE..."
        cp "$ZSH_SOURCE_DIR/zshrc" "$ZSHRC_TARGET_FILE"
    fi
    if [ -f "$ZSH_SOURCE_DIR/zaliases" ]; then
        echo "    Copying zaliases to $ZALIASES_TARGET_FILE..."
        cp "$ZSH_SOURCE_DIR/zaliases" "$ZALIASES_TARGET_FILE"
        echo "    Ensure your $ZSHRC_TARGET_FILE sources $ZALIASES_TARGET_FILE (e.g., add 'source $ZALIASES_TARGET_FILE')."
    fi
    # Add other zsh files as needed
fi


# Bin scripts
BIN_SOURCE_DIR="$CONFIG_DIR_SOURCE/bin"
BIN_TARGET_DIR="$HOME/.local/bin"
if [ -d "$BIN_SOURCE_DIR" ]; then
    echo ">>> Copying custom scripts to $BIN_TARGET_DIR..."
    mkdir -p "$BIN_TARGET_DIR"
    cp -r "$BIN_SOURCE_DIR"/* "$BIN_TARGET_DIR/"
    chmod +x "$BIN_TARGET_DIR"/* # Make them executable
    echo "    Ensure $BIN_TARGET_DIR is in your PATH."
fi

# mimeapps.list
MIMEAPPS_SOURCE="$CONFIG_DIR_SOURCE/mimeapps.list"
MIMEAPPS_TARGET="$CONFIG_DIR_TARGET/mimeapps.list"
if [ -f "$MIMEAPPS_SOURCE" ]; then
    echo ">>> Copying mimeapps.list..."
    cp "$MIMEAPPS_SOURCE" "$MIMEAPPS_TARGET"
fi

# swayimg.desktop (application shortcut)
SWAYIMG_DESKTOP_SOURCE="$CONFIG_DIR_SOURCE/swayimg.desktop"
DESKTOP_ENTRIES_TARGET="$HOME/.local/share/applications"
if [ -f "$SWAYIMG_DESKTOP_SOURCE" ]; then
    echo ">>> Copying swayimg.desktop..."
    mkdir -p "$DESKTOP_ENTRIES_TARGET"
    cp "$SWAYIMG_DESKTOP_SOURCE" "$DESKTOP_ENTRIES_TARGET/"
    update-desktop-database "$DESKTOP_ENTRIES_TARGET" # Update desktop entry database
fi


echo
echo ">>> Configuration copying phase complete."
echo
echo ">>> Installation script finished."
echo ">>> PLEASE NOTE:"
echo ">>> 1. Review any WARNING messages above for packages that might have failed to install (e.g., AUR packages)."
echo ">>> 2. Some configurations (like shell rc files, LibreWolf profiles) might need manual setup or adjustments."
echo ">>> 3. Ensure $HOME/.local/bin is in your PATH to use custom scripts."
echo ">>> 4. You may need to log out and log back in for all changes to take effect, especially for Hyprland and shell configurations."
echo ">>> 5. For Matugen, you might need to run it initially to generate themes for various applications."

exit 0
