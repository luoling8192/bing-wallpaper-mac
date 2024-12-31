#!/bin/bash

# Define colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Define base directories
WALLPAPER_DIR="$HOME/.wallpapers"
CONFIG_DIR="$HOME/.config/bing-wallpaper"
SCRIPT_NAME="bing_wallpaper"
SCRIPT_PATH="/usr/local/bin/${SCRIPT_NAME}"

# Check for jq dependency
check_dependencies() {
    if ! command -v jq &>/dev/null; then
        echo -e "${RED}Error: jq is required but not installed.${NC}"
        echo "Please install jq first:"
        echo "  Homebrew: brew install jq"
        echo "  MacPorts: sudo port install jq"
        return 1
    fi
    return 0
}

# Function to install or update the script
install_or_update() {
    # Create required directories
    mkdir -p "$WALLPAPER_DIR"
    mkdir -p "$CONFIG_DIR"

    # Copy main script and set permissions
    sudo cp ${SCRIPT_NAME}.sh ${SCRIPT_PATH}
    sudo chmod +x ${SCRIPT_PATH}

    # Create or update LaunchAgent configuration file
    cat >"$HOME/Library/LaunchAgents/com.${USER}.bingwallpaper.plist" <<EOL
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.${USER}.bingwallpaper</string>
    <key>ProgramArguments</key>
    <array>
        <string>${SCRIPT_PATH}</string>
        <string>--force</string>
    </array>
    <key>StartInterval</key>
    <integer>3600</integer>
    <key>StandardErrorPath</key>
    <string>${HOME}/.wallpapers/bing_wallpaper.err</string>
    <key>StandardOutPath</key>
    <string>${HOME}/.wallpapers/bing_wallpaper.out</string>
</dict>
</plist>
EOL

    # Unload existing service if it exists
    launchctl unload "$HOME/Library/LaunchAgents/com.${USER}.bingwallpaper.plist" 2>/dev/null

    # Load service
    launchctl load "$HOME/Library/LaunchAgents/com.${USER}.bingwallpaper.plist"

    # Run configuration if it's a fresh install
    if [ ! -f "$CONFIG_DIR/config" ]; then
        echo -e "${YELLOW}Running initial configuration...${NC}"
        ${SCRIPT_PATH} --config
    fi

    # Run immediately
    ${SCRIPT_PATH}
}

# Check dependencies first
if ! check_dependencies; then
    exit 1
fi

# Check if script is already installed
if [ -f "$SCRIPT_PATH" ]; then
    echo -e "${YELLOW}Existing installation found. Updating...${NC}"
    install_or_update
    echo -e "${GREEN}Update completed!${NC}"
else
    echo -e "${YELLOW}No existing installation found. Installing...${NC}"
    install_or_update
    echo -e "${GREEN}Installation completed!${NC}"
fi

echo -e "📋 Installation details:"
echo -e "  • Script location: ${SCRIPT_PATH}"
echo -e "  • Wallpaper directory: ${WALLPAPER_DIR}"
echo -e "  • Configuration directory: ${CONFIG_DIR}"
echo -e "  • Log files: ${WALLPAPER_DIR}/bing_wallpaper.{out,err}"
echo -e "  • Auto-updates every hour"
echo -e "\n📝 Usage:"
echo -e "  • Run '${SCRIPT_NAME}' to update manually"
echo -e "  • Run '${SCRIPT_NAME} --config' to change settings"
echo -e "  • Run '${SCRIPT_NAME} --show-config' to view current settings"
