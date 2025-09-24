# Hyprland Adaptive Rice

A minimal, highly customizable Hyprland rice that automatically adapts all UI colors to your wallpaper.

## Features

- 🎨 **Automatic Color Extraction**: Generates beautiful color schemes from wallpapers
- 🖥️ **Complete UI Theming**: Themes Hyprland, Waybar, terminals, rofi, and notifications
- 🎯 **Minimal but Functional**: Clean interface with essential features
- 🛠️ **Easy Customization**: GUI tool and simple configuration files
- 🔄 **Hot Swapping**: Change wallpapers and themes instantly with Super+W
- 📱 **Cross-Platform Development**: Develop on Mac, deploy to Arch VM

## Components

- **Compositor**: Hyprland with adaptive border colors
- **Status Bar**: Waybar with dynamic theming  
- **Terminal**: Foot (lightweight) or Kitty (feature-rich)
- **Launcher**: Rofi-wayland with matching colors
- **Notifications**: Mako with themed styling
- **Color Extraction**: Python-based intelligent color analysis

## Development Setup (Mac → Arch VM)

### Prerequisites
- Python 3.8+ (for color extraction)
- Arch Linux VM with Hyprland

### Quick Start

1. **Clone/Download** this project to your Mac
2. **Sync to VM**:
   ```bash
   cd hyprland-rice
   ./vm-deploy/sync-to-vm.sh user@your-arch-vm
   ```
3. **Install on VM**:
   ```bash
   ssh user@your-arch-vm
   cd ~/.config/hypr-rice  
   ./vm-deploy/install.sh
   ```

### Manual Installation

If you prefer manual setup:

```bash
# Install packages on Arch
sudo pacman -S hyprland waybar rofi-wayland mako foot kitty python python-pillow

# Clone this repo
git clone <this-repo> ~/.config/hypr-rice
cd ~/.config/hypr-rice

# Make scripts executable  
chmod +x scripts/*.sh tools/*.py

# Install
./vm-deploy/install.sh
```

## Usage

### Basic Controls
- **Super+W**: Change wallpaper (opens selector, auto-applies theme)
- **Super+Q**: Open terminal
- **Super+R**: Open application launcher  
- **Super+C**: Close window
- **Super+1-6**: Switch workspaces

### GUI Configuration Tool
```bash
python3 ~/.config/hypr-rice/tools/rice_config_gui.py
```

Features:
- Browse and manage wallpapers
- Preview current color scheme
- Configure terminal preferences
- One-click wallpaper switching with live preview

### Adding Wallpapers
1. Copy wallpapers to `~/.config/hypr-rice/wallpapers/`
2. Use Super+W to select and apply
3. Or use the GUI tool for easier management

### Manual Theme Generation
```bash
cd ~/.config/hypr-rice
python3 scripts/extract_colors.py /path/to/wallpaper.jpg
./scripts/apply_theme.sh
```

## Project Structure

```
hyprland-rice/
├── scripts/
│   ├── extract_colors.py      # Color extraction from wallpapers
│   ├── apply_theme.sh         # Apply colors to all configs
│   └── change_wallpaper.sh    # Wallpaper switching + theming
├── configs/                   # Template configuration files
│   ├── hyprland.conf         # Hyprland compositor config
│   ├── waybar-*.{json,css}   # Status bar config and styling
│   ├── foot.ini              # Foot terminal config
│   ├── kitty.conf            # Kitty terminal config  
│   ├── rofi-*.rasi           # Application launcher theming
│   └── mako.conf             # Notification styling
├── themes/                    # Generated theme files
│   └── colors.json           # Current color scheme
├── wallpapers/               # Your wallpaper collection
├── tools/
│   └── rice_config_gui.py    # GUI configuration tool
└── vm-deploy/                # VM deployment scripts
    ├── sync-to-vm.sh         # Sync from Mac to VM  
    └── install.sh            # Install script for Arch
```

## Customization

### Color Extraction Algorithm
The color extractor uses intelligent clustering to find:
- **Background**: Darkest dominant color
- **Foreground**: Brightest dominant color  
- **Accents**: Distributed across color spectrum

### Modifying Configurations
All config templates use placeholder variables:
- `{{BG_COLOR}}`: Background color
- `{{FG_COLOR}}`: Foreground color
- `{{ACCENT_COLOR}}`: Primary accent (usually blue)
- `{{RED_COLOR}}`, `{{GREEN_COLOR}}`, etc.: Themed accent colors

### Adding New Applications
1. Create config template in `configs/`
2. Add color replacement logic to `apply_theme.sh`
3. Add reload commands as needed

## Troubleshooting

### Colors Not Applying
- Ensure Pillow is installed: `pip install Pillow`
- Check permissions on scripts: `chmod +x scripts/*.sh`
- Verify wallpaper path and format (JPG/PNG)

### GUI Tool Issues
- Install tkinter: `sudo pacman -S tk`
- Run from project directory: `cd ~/.config/hypr-rice && python3 tools/rice_config_gui.py`

### VM Sync Issues
- Verify SSH key setup between Mac and VM
- Check VM IP address and username
- Ensure rsync is installed on both systems

## Screenshots

*Add screenshots of your rice in action here*

## Contributing

1. Test changes on your Mac (color extraction, GUI tool)
2. Sync to VM for integration testing
3. Submit pull request with examples

## License

MIT License - Feel free to customize and share!

---

*Enjoy your adaptive Hyprland rice! 🎨✨*
