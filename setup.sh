#!/bin/bash

# Define colors
GREEN='\033[0;32m'
NC='\033[0m'

# Define base directories
WALLPAPER_DIR="$HOME/.wallpapers"
SCRIPT_NAME="bing_wallpaper"

# Create wallpaper directory
mkdir -p "$WALLPAPER_DIR"

# Copy main script and set permissions
sudo cp ${SCRIPT_NAME}.sh /usr/local/bin/${SCRIPT_NAME}
sudo chmod +x /usr/local/bin/${SCRIPT_NAME}

# Create LaunchAgent configuration file
cat > "$HOME/Library/LaunchAgents/com.${USER}.bingwallpaper.plist" << EOL
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.${USER}.bingwallpaper</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/local/bin/${SCRIPT_NAME}</string>
    </array>
    <key>StartCalendarInterval</key>
    <dict>
        <key>Hour</key>
        <integer>9</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>
    <key>StandardErrorPath</key>
    <string>${HOME}/.wallpapers/bing_wallpaper.err</string>
    <key>StandardOutPath</key>
    <string>${HOME}/.wallpapers/bing_wallpaper.out</string>
</dict>
</plist>
EOL

# Load service
launchctl load "$HOME/Library/LaunchAgents/com.${USER}.bingwallpaper.plist"

# Run immediately
/usr/local/bin/${SCRIPT_NAME}

echo -e "${GREEN}Installation completed!${NC}"
echo -e "📋 Installation details:"
echo -e "  • Script location: /usr/local/bin/${SCRIPT_NAME}"
echo -e "  • Wallpaper directory: ${WALLPAPER_DIR}"
echo -e "  • Log files: ${WALLPAPER_DIR}/bing_wallpaper.{out,err}"
echo -e "  • Auto-updates daily at 9 AM"
echo -e "  • Run '${SCRIPT_NAME}' to update manually"
