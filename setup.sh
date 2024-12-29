#!/bin/bash

# 定义颜色输出
GREEN='\033[0;32m'
NC='\033[0m'

# 创建必要的目录
mkdir -p "$HOME/.wallpapers"
mkdir -p "$HOME/Library/LaunchAgents"

# 复制主脚本
sudo cp bing_wallpaper.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/bing_wallpaper.sh

# 创建 LaunchAgent 配置文件
cat > "$HOME/Library/LaunchAgents/com.${USER}.bingwallpaper.plist" << EOL
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.${USER}.bingwallpaper</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/local/bin/bing_wallpaper.sh</string>
    </array>
    <key>StartCalendarInterval</key>
    <dict>
        <key>Hour</key>
        <integer>9</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>
    <key>StandardErrorPath</key>
    <string>/tmp/bing_wallpaper.err</string>
    <key>StandardOutPath</key>
    <string>/tmp/bing_wallpaper.out</string>
</dict>
</plist>
EOL

# 加载服务
launchctl load "$HOME/Library/LaunchAgents/com.${USER}.bingwallpaper.plist"

# 立即运行一次
/usr/local/bin/bing_wallpaper.sh

echo -e "${GREEN}安装完成！每天早上9点将自动更换壁纸。${NC}"
