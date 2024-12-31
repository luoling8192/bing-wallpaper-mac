#!/bin/bash

# Define colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Define paths
LAUNCH_AGENT="$HOME/Library/LaunchAgents/com.${USER}.bingwallpaper.plist"
SCRIPT_PATH="/usr/local/bin/bing_wallpaper"
WALLPAPER_DIR="$HOME/.wallpapers"
CONFIG_DIR="$HOME/.config/bing-wallpaper"

echo -e "${YELLOW}Uninstalling Bing Wallpaper...${NC}"

# Unload and remove LaunchAgent
if [ -f "$LAUNCH_AGENT" ]; then
    echo "• Stopping background service..."
    launchctl unload "$LAUNCH_AGENT"
    rm "$LAUNCH_AGENT"
fi

# Remove script
if [ -f "$SCRIPT_PATH" ]; then
    echo "• Removing script..."
    sudo rm "$SCRIPT_PATH"
fi

# Remove wallpapers
if [ -d "$WALLPAPER_DIR" ]; then
    echo "• Removing wallpaper directory..."
    rm -rf "$WALLPAPER_DIR"
fi

# Remove configuration
if [ -d "$CONFIG_DIR" ]; then
    echo "• Removing configuration..."
    rm -rf "$CONFIG_DIR"
fi

echo -e "${GREEN}Uninstallation completed!${NC}"
echo "Thank you for using Bing Wallpaper. Feel free to reinstall anytime!"
