#!/bin/bash

# Default configuration
CONFIG_FILE="$HOME/.config/bing-wallpaper/config"
DEFAULT_CONFIG=(
    "RESOLUTION=auto"             # Options: auto, UHD, FHD, HD
    "AUTO_CLEANUP=true"           # Whether to cleanup old wallpapers
    "CLEANUP_DAYS=7"              # Days to keep wallpapers
    "SAVE_PATH=$HOME/.wallpapers" # Where to save wallpapers
)

# Resolution definitions
RESOLUTION_UHD="UHD"
RESOLUTION_FHD="1920x1080"
RESOLUTION_HD="1366x768"

RESOLUTION_NAME_UHD="4K (3840x2160)"
RESOLUTION_NAME_FHD="Full HD (1920x1080)"
RESOLUTION_NAME_HD="HD (1366x768)"

# Get resolution value
get_resolution_value() {
    local res=$1
    case "$res" in
    "UHD") echo "$RESOLUTION_UHD" ;;
    "FHD") echo "$RESOLUTION_FHD" ;;
    "HD") echo "$RESOLUTION_HD" ;;
    *) echo "$RESOLUTION_FHD" ;; # Default to FHD
    esac
}

# Get resolution display name
get_resolution_name() {
    local res=$1
    case "$res" in
    "UHD") echo "$RESOLUTION_NAME_UHD" ;;
    "FHD") echo "$RESOLUTION_NAME_FHD" ;;
    "HD") echo "$RESOLUTION_NAME_HD" ;;
    *) echo "$RESOLUTION_NAME_FHD" ;; # Default to FHD
    esac
}

# Check dependencies
check_dependencies() {
    if ! command -v jq &>/dev/null; then
        echo "Error: jq is required but not installed."
        echo "Please install jq first:"
        echo "  Homebrew: brew install jq"
        echo "  MacPorts: sudo port install jq"
        exit 1
    fi
}

# Get screen resolution
get_screen_resolution() {
    # Get screen resolution using system_profiler
    local resolution=$(system_profiler SPDisplaysDataType | grep -o "[0-9]* x [0-9]*" | head -n1 | tr -d ' ')
    echo "$resolution"
}

# Get best matching resolution
get_matching_resolution() {
    local screen_res=$1
    local width=$(echo "$screen_res" | cut -d'x' -f1)

    # Choose resolution based on screen width
    if [ "$width" -ge 3840 ]; then
        echo "UHD"
    elif [ "$width" -ge 1920 ]; then
        echo "FHD"
    else
        echo "HD"
    fi
}

# Configuration management functions
init_config() {
    mkdir -p "$(dirname "$CONFIG_FILE")"
    if [[ ! -f "$CONFIG_FILE" ]]; then
        printf "%s\n" "${DEFAULT_CONFIG[@]}" >"$CONFIG_FILE"
    fi
}

load_config() {
    init_config
    source "$CONFIG_FILE"
}

show_config() {
    echo "Current configuration:"
    cat "$CONFIG_FILE"
}

set_config() {
    local key=$1
    local value=$2
    local temp_file=$(mktemp)

    if grep -q "^$key=" "$CONFIG_FILE"; then
        sed "s|^$key=.*|$key=$value|" "$CONFIG_FILE" >"$temp_file"
    else
        cp "$CONFIG_FILE" "$temp_file"
        echo "$key=$value" >>"$temp_file"
    fi

    mv "$temp_file" "$CONFIG_FILE"
}

configure() {
    echo "Bing Wallpaper Configuration"
    echo "------------------------"

    echo "Select resolution:"
    echo "1) Auto (detect screen resolution)"
    echo "2) $(get_resolution_name UHD)"
    echo "3) $(get_resolution_name FHD)"
    echo "4) $(get_resolution_name HD)"
    read -p "Enter choice (1-4): " res_choice

    case $res_choice in
    1) set_config "RESOLUTION" "auto" ;;
    2) set_config "RESOLUTION" "UHD" ;;
    3) set_config "RESOLUTION" "FHD" ;;
    4) set_config "RESOLUTION" "HD" ;;
    *) echo "Invalid choice, keeping current setting" ;;
    esac

    read -p "Enable auto cleanup? (y/n): " cleanup_choice
    if [[ "$cleanup_choice" =~ ^[Yy]$ ]]; then
        set_config "AUTO_CLEANUP" "true"
        read -p "Days to keep wallpapers (default 7): " days
        [[ -n "$days" ]] && set_config "CLEANUP_DAYS" "$days"
    else
        set_config "AUTO_CLEANUP" "false"
    fi

    read -p "Enter wallpaper save path (default: $HOME/.wallpapers): " save_path
    [[ -n "$save_path" ]] && set_config "SAVE_PATH" "$save_path"

    echo "Configuration updated:"
    show_config
}

# Download Bing daily wallpaper
download_bing_wallpaper() {
    local target_resolution="$RESOLUTION"

    # Auto-detect resolution if set to auto
    if [ "$target_resolution" = "auto" ]; then
        local screen_res=$(get_screen_resolution)
        target_resolution=$(get_matching_resolution "$screen_res")
        echo "Detected screen resolution: $screen_res"
        echo "Using wallpaper resolution: $(get_resolution_name "$target_resolution")"
    fi

    # Get current date as filename
    local current_date
    current_date=$(date +%Y%m%d)
    local wallpaper_path="$SAVE_PATH/bing_${current_date}_${target_resolution}.jpg"
    local metadata_path="${wallpaper_path%.*}.txt"

    # Check if today's wallpaper already exists
    local should_download=true
    if [ -f "$wallpaper_path" ] && [ "$FORCE_DOWNLOAD" != "true" ]; then
        echo "Found existing wallpaper for today"
        if [ -f "$metadata_path" ]; then
            echo "Current wallpaper:"
            echo "Title: $(head -n1 "$metadata_path")"
            echo "Copyright: $(tail -n1 "$metadata_path")"
        fi

        read -p "Do you want to redownload? (y/n): " redownload
        if [[ ! "$redownload" =~ ^[Yy]$ ]]; then
            echo "Using existing wallpaper"
            should_download=false
        fi
    fi

    if [ "$should_download" = true ]; then
        # Remove existing files if they exist
        rm -f "$wallpaper_path" "$metadata_path"

        # Get Bing wallpaper JSON data
        local bing_json
        bing_json=$(curl -s "https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1")

        # Extract base wallpaper URL using jq
        local base_url
        base_url="https://www.bing.com$(echo "$bing_json" | jq -r '.images[0].url')"
        echo "Base URL: $base_url"

        # Get image metadata
        local image_title
        image_title=$(echo "$bing_json" | jq -r '.images[0].title')
        local image_copyright
        image_copyright=$(echo "$bing_json" | jq -r '.images[0].copyright')

        # Modify URL based on resolution
        local image_url
        local resolution_value=$(get_resolution_value "$target_resolution")
        if [ -n "$resolution_value" ]; then
            image_url=$(echo "$base_url" | sed "s/1920x1080/$resolution_value/")
            echo "Modified URL for ${resolution_value}: $image_url"
        else
            image_url="$base_url"
            echo "Using default URL: $image_url"
        fi

        # Create directory if not exists
        mkdir -p "$SAVE_PATH"

        # Download wallpaper
        echo "Downloading wallpaper..."
        if curl -s "$image_url" -o "$wallpaper_path"; then
            echo "✓ Download successful"
            echo "Title: $image_title"
            echo "Copyright: $image_copyright"
            # Save metadata
            echo "$image_title" >"$metadata_path"
            echo "$image_copyright" >>"$metadata_path"
        else
            echo "✗ Error: Failed to download wallpaper"
            return 1
        fi
    fi

    # Always return the wallpaper path, whether it's new or existing
    echo "$wallpaper_path"
    return 0
}

# Set desktop wallpaper
set_wallpaper() {
    wallpaper_path=$1
    osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$wallpaper_path\""
}

# Clean up wallpapers older than specified days
cleanup_old_wallpapers() {
    if [[ "$AUTO_CLEANUP" == "true" ]]; then
        find "$SAVE_PATH" -type f -mtime "+$CLEANUP_DAYS" -delete
    fi
}

# Main program
main() {
    # Check dependencies first
    check_dependencies

    # Handle command line arguments
    case "$1" in
    --help | -h)
        echo "Usage: $(basename "$0") [OPTIONS]"
        echo ""
        echo "Options:"
        echo "  --help, -h        Show this help message"
        echo "  --config          Configure settings"
        echo "  --show-config     Show current configuration"
        echo "  --force, -f       Force download without asking"
        exit 0
        ;;
    --config)
        configure
        exit 0
        ;;
    --show-config)
        show_config
        exit 0
        ;;
    esac

    # Set force flag based on argument
    local force_download=false
    if [ "$1" = "--force" ] || [ "$1" = "-f" ]; then
        force_download=true
    fi

    # Normal operation
    load_config

    # Run download with output
    echo "Starting Bing wallpaper update..."
    echo "----------------------------------------"

    # Capture both output and return value
    local output
    if [ "$force_download" = true ]; then
        output=$(FORCE_DOWNLOAD=true download_bing_wallpaper)
    else
        output=$(download_bing_wallpaper)
    fi
    local status=$?

    # Print the output
    echo "$output"
    echo "----------------------------------------"

    # Get the last line (wallpaper path) if successful
    if [ $status -eq 0 ]; then
        local wallpaper_path
        wallpaper_path=$(echo "$output" | tail -n1)

        echo "Setting wallpaper..."
        set_wallpaper "$wallpaper_path"

        if [[ "$AUTO_CLEANUP" == "true" ]]; then
            echo "Running cleanup..."
            cleanup_old_wallpapers
        fi

        echo "✓ Wallpaper update completed"
    else
        echo "✗ Failed to update wallpaper"
        exit 1
    fi
}

main "$@"
