#!/bin/bash

# 创建存储壁纸的目录
WALLPAPER_DIR="$HOME/.wallpapers"
mkdir -p "$WALLPAPER_DIR"

# 下载必应每日壁纸
download_bing_wallpaper() {
    # 获取必应壁纸 JSON 数据
    bing_json=$(curl -s "https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1")
    
    # 提取壁纸 URL
    image_url="https://www.bing.com$(echo $bing_json | grep -o '"url":"[^"]*"' | cut -d'"' -f4)"
    
    # 获取当前日期作为文件名
    current_date=$(date +%Y%m%d)
    wallpaper_path="$WALLPAPER_DIR/bing_${current_date}.jpg"
    
    # 下载壁纸
    curl -s "$image_url" -o "$wallpaper_path"
    
    echo "$wallpaper_path"
}

# 设置桌面壁纸
set_wallpaper() {
    wallpaper_path=$1
    osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$wallpaper_path\""
}

# 清理7天前的壁纸
cleanup_old_wallpapers() {
    find "$WALLPAPER_DIR" -type f -mtime +7 -delete
}

# 主程序
main() {
    wallpaper_path=$(download_bing_wallpaper)
    set_wallpaper "$wallpaper_path"
    cleanup_old_wallpapers
}

main
