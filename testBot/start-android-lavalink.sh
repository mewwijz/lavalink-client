#!/bin/bash

# ANDROID LAVALINK STARTER SCRIPT
# Quick setup script for Android users with YouTube OAuth

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║              ANDROID LAVALINK STARTER SCRIPT                ║"
echo "║            YouTube OAuth Ready - No Apple Music             ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Check if Lavalink.jar exists
if [ ! -f "Lavalink.jar" ]; then
    echo -e "${RED}❌ Lavalink.jar not found!${NC}"
    echo -e "${YELLOW}Please download Lavalink.jar first:${NC}"
    echo "wget https://github.com/lavalink-devs/Lavalink/releases/latest/download/Lavalink.jar"
    exit 1
fi

# Check if config exists
CONFIG_FILE="application-android.yml"
if [ ! -f "$CONFIG_FILE" ]; then
    echo -e "${BLUE}📥 Downloading Android-ready configuration...${NC}"
    wget -O "$CONFIG_FILE" "https://raw.githubusercontent.com/mewwijz/lavalink-client/youtube-oauth-android-ready/testBot/application-youtube-oauth-ready.yml"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Configuration downloaded successfully!${NC}"
    else
        echo -e "${RED}❌ Failed to download configuration!${NC}"
        exit 1
    fi
fi

# Check if token is configured
if grep -q "PASTE_YOUR_YOUTUBE_REFRESH_TOKEN_HERE" "$CONFIG_FILE"; then
    echo -e "${YELLOW}⚠️  YouTube OAuth token not configured!${NC}"
    echo ""
    echo -e "${BLUE}📝 SETUP REQUIRED:${NC}"
    echo "1. Edit the configuration file:"
    echo "   nano $CONFIG_FILE"
    echo ""
    echo "2. Find this line:"
    echo '   refreshToken: "PASTE_YOUR_YOUTUBE_REFRESH_TOKEN_HERE"'
    echo ""
    echo "3. Replace with your actual token:"
    echo '   refreshToken: "1//04xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"'
    echo ""
    echo "4. Save and run this script again"
    echo ""
    echo -e "${CYAN}💡 Need help getting a token? Check ANDROID_YOUTUBE_OAUTH_GUIDE.md${NC}"
    exit 1
fi

# Create logs directory
mkdir -p logs

# Display configuration info
echo -e "${BLUE}📋 CONFIGURATION INFO:${NC}"
echo "Config file: $CONFIG_FILE"
echo "Server port: 2333"
echo "Password: youtube_oauth_2025"
echo ""

# Check Java version
echo -e "${BLUE}☕ Checking Java version...${NC}"
java -version 2>&1 | head -n 1

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Java not found! Please install Java 17 or higher.${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}🚀 Starting Lavalink with Android configuration...${NC}"
echo -e "${YELLOW}Press Ctrl+C to stop${NC}"
echo ""

# Start Lavalink
java -jar Lavalink.jar --spring.config.location="$CONFIG_FILE"

# If we get here, Lavalink has stopped
echo ""
echo -e "${YELLOW}👋 Lavalink stopped.${NC}"

# Show quick status check
echo ""
echo -e "${BLUE}📊 QUICK STATUS CHECK:${NC}"
echo "To verify OAuth is working, check logs for:"
echo -e "${GREEN}✅ 'OAuth initialized successfully'${NC}"
echo -e "${GREEN}✅ 'Refresh token validated'${NC}"
echo -e "${GREEN}✅ 'YouTube API rate limits bypassed'${NC}"
echo ""
echo "Check logs with:"
echo "tail -f logs/lavalink.log | grep -i oauth"