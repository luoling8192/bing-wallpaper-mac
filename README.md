# 🖼️ Bing Wallpaper for macOS

Automatically update your macOS wallpaper with Bing's daily image.

## ✨ Features

- 🔄 Auto-updates wallpaper daily at 9 AM
- 🖼️ Downloads high-quality images from Bing
- 🧹 Auto-cleans wallpapers older than 7 days
- 💪 Lightweight and efficient
- ⚡️ Easy to install and use

## 🚀 Usage

Simply run the script:
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/luoling8192/bing-wallpaper-mac/HEAD/install.sh)"
```

## 🗑️ Uninstallation

To remove the app:
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/luoling8192/bing-wallpaper-mac/HEAD/uninstall.sh)"
```

## 📁 File Structure

- `bing_wallpaper.sh`: Main script for downloading and setting wallpaper
- `setup.sh`: Installation script
- `~/.wallpapers/`: Directory where wallpapers are stored
- `~/Library/LaunchAgents/com.${USER}.bingwallpaper.plist`: LaunchAgent configuration

## 🤝 Contributing

Feel free to submit issues and enhancement requests!

## 📝 License

MIT License - feel free to use and modify as you like!

## 🙏 Acknowledgments

- Bing for providing beautiful daily images
- macOS community for inspiration

## ⚠️ Requirements

- macOS 10.12 or later
- curl (usually pre-installed on macOS)
- Internet connection

## 💡 Tips

- The script runs daily at 9 AM, but you can modify the time in the plist file
- Wallpapers are stored in `~/.wallpapers` directory
- Logs can be found in `/tmp/bing_wallpaper.out` and `/tmp/bing_wallpaper.err`

---
Made with ❤️ for macOS users
