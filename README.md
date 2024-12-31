# 🖼️ Bing Wallpaper for macOS

Automatically update your macOS wallpaper with Bing's daily image.

## ✨ Features

- 🔄 Auto-updates wallpaper every hour
- 🖼️ Downloads high-quality images from Bing
- 🧹 Supports multiple resolutions (4K, Full HD, HD)
- 🔍 Auto-detects screen resolution
- 🧹 Auto-cleans wallpapers older than 7 days
- ⚙️ Configurable settings
- 💪 Lightweight and efficient
- ⚡️ Easy to install and use

## 🚀 Installation

### Prerequisites

- macOS 10.12 or later
- [jq](https://stedolan.github.io/jq/) (JSON processor)
  ```bash
  # Install using Homebrew
  brew install jq
  
  # Or using MacPorts
  sudo port install jq
  ```

### Install

Simply run the script:
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/luoling8192/bing-wallpaper-mac/HEAD/install.sh)"
```

## 🗑️ Configuration

The script can be configured using the following commands:

```bash
# Show help message
bing_wallpaper --help

# Output:
# Usage: bing_wallpaper [OPTIONS]
#
# Options:
#   --help, -h        Show this help message
#   --config          Configure settings
#   --show-config     Show current configuration

# Run configuration wizard
bing_wallpaper --config

# View current settings
bing_wallpaper --show-config
```

Configuration options include:
- Resolution (Auto/4K/Full HD/HD)
- Auto-cleanup settings
- Wallpaper save location

## 🗑️ Uninstallation

To remove the app:
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/luoling8192/bing-wallpaper-mac/HEAD/uninstall.sh)"
```

## 📁 File Structure

- `bing_wallpaper.sh`: Main script for downloading and setting wallpaper
- `~/.wallpapers/`: Directory where wallpapers are stored
- `~/.config/bing-wallpaper/config`: Configuration file
- `~/Library/LaunchAgents/com.${USER}.bingwallpaper.plist`: LaunchAgent configuration

## 📝 Logs

Log files are stored in:
- `~/.wallpapers/bing_wallpaper.out`: Standard output
- `~/.wallpapers/bing_wallpaper.err`: Error messages

## 🤝 Contributing

Feel free to submit issues and enhancement requests!

## 📝 License

MIT License - feel free to use and modify as you like!

## 🙏 Acknowledgments

- Bing for providing beautiful daily images
- macOS community for inspiration

## 💡 Tips

- The script runs hourly to check for new wallpapers
- Images are downloaded based on your screen resolution by default
- Each wallpaper includes a text file with its title and copyright information
- Old wallpapers are automatically cleaned up after 7 days (configurable)

---
Made with ❤️ for macOS users
