#!/bin/bash

# Create wallpaper directory
WALLPAPER_DIR="$HOME/.wallpapers"
mkdir -p "$WALLPAPER_DIR"

# Download Bing daily wallpaper
download_bing_wallpaper() {
    # Get Bing wallpaper JSON data
    bing_json=$(curl -s "https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1")
    
    # Extract wallpaper URL
    image_url="https://www.bing.com$(echo $bing_json | grep -o '"url":"[^"]*"' | cut -d'"' -f4)"
    
    # Get current date as filename
    current_date=$(date +%Y%m%d)
    wallpaper_path="$WALLPAPER_DIR/bing_${current_date}.jpg"
    
    # Download wallpaper
    curl -s "$image_url" -o "$wallpaper_path"
    
    echo "$wallpaper_path"
}

# Set desktop wallpaper
set_wallpaper() {
    wallpaper_path=$1
    osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$wallpaper_path\""
}

# Clean up wallpapers older than 7 days
cleanup_old_wallpapers() {
    find "$WALLPAPER_DIR" -type f -mtime +7 -delete
}

# Main program
main() {
    wallpaper_path=$(download_bing_wallpaper)
    set_wallpaper "$wallpaper_path"
    cleanup_old_wallpapers
}

main
