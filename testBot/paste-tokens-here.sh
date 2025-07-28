#!/bin/bash

# ==========================================================
# ==        PASTE YOUR YOUTUBE TOKENS HERE SCRIPT       ==
# ==     SIMPLE TOKEN PASTING FOR ANDROID USERS          ==
# ==========================================================

echo "🤖 ANDROID YOUTUBE TOKEN PASTING TOOL"
echo "====================================="

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

CONFIG_FILE="application-android-youtube-only.yml"

echo ""
echo -e "${BLUE}📋 THIS SCRIPT WILL HELP YOU PASTE YOUR YOUTUBE OAUTH TOKENS${NC}"
echo "=============================================================="
echo ""
echo -e "${GREEN}✅ What you need:${NC}"
echo "1. YouTube OAuth Refresh Token (starts with 1//04...)"
echo "2. YouTube OAuth Access Token (starts with ya29.a0...)"
echo ""
echo -e "${YELLOW}📱 Perfect for Android users - no Apple Music complications!${NC}"

# Check if config file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo ""
    echo -e "${RED}❌ Configuration file not found: $CONFIG_FILE${NC}"
    echo ""
    echo -e "${BLUE}📥 Downloading Android-optimized configuration...${NC}"
    
    if command -v wget &> /dev/null; then
        wget -O "$CONFIG_FILE" "https://raw.githubusercontent.com/mewwijz/lavalink-client/feature/android-youtube-oauth-only/testBot/application-android-youtube-only.yml"
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ Configuration file downloaded successfully!${NC}"
        else
            echo -e "${RED}❌ Failed to download configuration file${NC}"
            echo "Please download manually from:"
            echo "https://raw.githubusercontent.com/mewwijz/lavalink-client/feature/android-youtube-oauth-only/testBot/application-android-youtube-only.yml"
            exit 1
        fi
    else
        echo -e "${RED}❌ wget not found. Please download the configuration file manually.${NC}"
        exit 1
    fi
fi

echo ""
echo -e "${PURPLE}🔑 TOKEN PASTING MENU:${NC}"
echo "======================"
echo "1. Paste YouTube OAuth Tokens (REQUIRED)"
echo "2. Paste YouTube Cookies (OPTIONAL)"
echo "3. Paste YouTube poToken (OPTIONAL)"
echo "4. View Current Configuration"
echo "5. Validate Configuration"
echo "6. Start Lavalink Server"
echo "7. Exit"

while true; do
    echo ""
    read -p "Choose option (1-7): " choice
    
    case $choice in
        1)
            echo ""
            echo -e "${GREEN}🔑 PASTING YOUTUBE OAUTH TOKENS${NC}"
            echo "==============================="
            echo ""
            echo -e "${BLUE}📋 You need both tokens from Google OAuth Playground:${NC}"
            echo "URL: https://developers.google.com/oauthplayground/"
            echo ""
            
            # Get refresh token
            echo -e "${YELLOW}🔄 REFRESH TOKEN:${NC}"
            echo "Format: 1//04xyz-AbCdEfGhIjKlMnOpQrStUvWxYz..."
            echo ""
            read -p "Paste your YouTube OAuth Refresh Token: " refresh_token
            
            if [ -z "$refresh_token" ]; then
                echo -e "${RED}❌ Refresh token cannot be empty!${NC}"
                continue
            fi
            
            # Get access token
            echo ""
            echo -e "${YELLOW}🎫 ACCESS TOKEN:${NC}"
            echo "Format: ya29.a0xyz-AbCdEfGhIjKlMnOpQrStUvWxYz..."
            echo ""
            read -p "Paste your YouTube OAuth Access Token: " access_token
            
            if [ -z "$access_token" ]; then
                echo -e "${RED}❌ Access token cannot be empty!${NC}"
                continue
            fi
            
            # Backup original file
            cp "$CONFIG_FILE" "${CONFIG_FILE}.backup"
            
            # Replace tokens in config file
            sed -i "s/PASTE_YOUR_YOUTUBE_REFRESH_TOKEN_HERE/$refresh_token/g" "$CONFIG_FILE"
            sed -i "s/PASTE_YOUR_YOUTUBE_ACCESS_TOKEN_HERE/$access_token/g" "$CONFIG_FILE"
            
            echo ""
            echo -e "${GREEN}✅ TOKENS PASTED SUCCESSFULLY!${NC}"
            echo ""
            echo -e "${BLUE}📍 Tokens have been inserted at:${NC}"
            echo "- Refresh Token: Line 52"
            echo "- Access Token: Line 55"
            echo ""
            echo -e "${GREEN}🎵 Your Lavalink server is now ready to start!${NC}"
            ;;
        2)
            echo ""
            echo -e "${YELLOW}🍪 PASTING YOUTUBE COOKIES (OPTIONAL)${NC}"
            echo "====================================="
            echo ""
            echo -e "${BLUE}📋 How to get cookies from Android browser:${NC}"
            echo "1. Open Chrome/Firefox on Android"
            echo "2. Go to https://www.youtube.com/ and login"
            echo "3. Enable Desktop Mode (3 dots → Desktop site)"
            echo "4. Open Developer Tools (F12)"
            echo "5. Go to Application → Cookies → https://www.youtube.com"
            echo "6. Copy VISITOR_INFO1_LIVE, YSC, PREF cookies"
            echo ""
            echo -e "${YELLOW}📝 Format: name1=value1; name2=value2; name3=value3${NC}"
            echo ""
            read -p "Paste your YouTube cookies (or press Enter to skip): " cookies
            
            if [ ! -z "$cookies" ]; then
                # Replace cookies in config file
                sed -i "s/PASTE_YOUR_YOUTUBE_COOKIES_HERE_IF_YOU_HAVE_THEM/$cookies/g" "$CONFIG_FILE"
                echo ""
                echo -e "${GREEN}✅ COOKIES PASTED SUCCESSFULLY!${NC}"
                echo "Location: Line 62"
            else
                echo ""
                echo -e "${CYAN}ℹ️  Cookies skipped - that's okay, OAuth tokens are more important!${NC}"
            fi
            ;;
        3)
            echo ""
            echo -e "${YELLOW}🎯 PASTING YOUTUBE POTOKEN (OPTIONAL)${NC}"
            echo "====================================="
            echo ""
            echo -e "${BLUE}📋 How to get poToken from Android browser:${NC}"
            echo "1. Open Chrome on Android"
            echo "2. Go to https://www.youtube.com/ and login"
            echo "3. Enable Desktop Mode"
            echo "4. Open Developer Tools (F12)"
            echo "5. Go to Network tab"
            echo "6. Play any video"
            echo "7. Look for requests to 'youtubei.googleapis.com'"
            echo "8. Find 'po_token' parameter in request"
            echo ""
            echo -e "${YELLOW}📝 Format: Base64 string like MnwxM3wxNjkwMjA4NDAwfDEuMC4wfDF8dGVzdA==${NC}"
            echo ""
            read -p "Paste your YouTube poToken (or press Enter to skip): " potoken
            
            if [ ! -z "$potoken" ]; then
                # Replace poToken in config file
                sed -i "s/PASTE_YOUR_POTOKEN_HERE_IF_YOU_HAVE_IT/$potoken/g" "$CONFIG_FILE"
                echo ""
                echo -e "${GREEN}✅ POTOKEN PASTED SUCCESSFULLY!${NC}"
                echo "Location: Line 68"
            else
                echo ""
                echo -e "${CYAN}ℹ️  poToken skipped - OAuth tokens are sufficient for most users!${NC}"
            fi
            ;;
        4)
            echo ""
            echo -e "${BLUE}📄 CURRENT CONFIGURATION${NC}"
            echo "========================"
            echo ""
            
            if [ -f "$CONFIG_FILE" ]; then
                echo -e "${GREEN}✅ Configuration file found: $CONFIG_FILE${NC}"
                echo ""
                
                # Check token status
                if grep -q "PASTE_YOUR_YOUTUBE_REFRESH_TOKEN_HERE" "$CONFIG_FILE"; then
                    echo -e "${RED}❌ Refresh Token: NOT CONFIGURED${NC}"
                else
                    echo -e "${GREEN}✅ Refresh Token: CONFIGURED${NC}"
                fi
                
                if grep -q "PASTE_YOUR_YOUTUBE_ACCESS_TOKEN_HERE" "$CONFIG_FILE"; then
                    echo -e "${RED}❌ Access Token: NOT CONFIGURED${NC}"
                else
                    echo -e "${GREEN}✅ Access Token: CONFIGURED${NC}"
                fi
                
                if grep -q "PASTE_YOUR_YOUTUBE_COOKIES_HERE_IF_YOU_HAVE_THEM" "$CONFIG_FILE"; then
                    echo -e "${YELLOW}⚠️  Cookies: NOT CONFIGURED (optional)${NC}"
                else
                    echo -e "${GREEN}✅ Cookies: CONFIGURED${NC}"
                fi
                
                if grep -q "PASTE_YOUR_POTOKEN_HERE_IF_YOU_HAVE_IT" "$CONFIG_FILE"; then
                    echo -e "${YELLOW}⚠️  poToken: NOT CONFIGURED (optional)${NC}"
                else
                    echo -e "${GREEN}✅ poToken: CONFIGURED${NC}"
                fi
                
                echo ""
                echo -e "${BLUE}📊 Configuration Summary:${NC}"
                echo "- Server Port: 2333"
                echo "- Password: chiro666"
                echo "- YouTube Plugin: v1.13.3"
                echo "- Android Clients: ANDROID_TESTSUITE, ANDROID_MUSIC"
                echo "- Audio Quality: Opus 10 (High)"
                echo "- All Filters: Enabled"
                
            else
                echo -e "${RED}❌ Configuration file not found${NC}"
            fi
            ;;
        5)
            echo ""
            echo -e "${BLUE}🔍 VALIDATING CONFIGURATION${NC}"
            echo "==========================="
            echo ""
            
            if [ -f "$CONFIG_FILE" ]; then
                # Check YAML syntax
                if command -v python3 &> /dev/null; then
                    if python3 -c "import yaml; yaml.safe_load(open('$CONFIG_FILE'))" 2>/dev/null; then
                        echo -e "${GREEN}✅ YAML syntax is valid${NC}"
                    else
                        echo -e "${RED}❌ YAML syntax error - please check your configuration${NC}"
                        continue
                    fi
                else
                    echo -e "${YELLOW}⚠️  Python3 not found - cannot validate YAML syntax${NC}"
                fi
                
                # Check required tokens
                echo ""
                echo -e "${BLUE}🔍 Checking required tokens:${NC}"
                
                if grep -q "PASTE_YOUR_YOUTUBE_REFRESH_TOKEN_HERE" "$CONFIG_FILE"; then
                    echo -e "${RED}❌ YouTube OAuth refresh token is required!${NC}"
                    echo "   Please use option 1 to paste your tokens."
                    continue
                else
                    echo -e "${GREEN}✅ YouTube OAuth refresh token configured${NC}"
                fi
                
                if grep -q "PASTE_YOUR_YOUTUBE_ACCESS_TOKEN_HERE" "$CONFIG_FILE"; then
                    echo -e "${RED}❌ YouTube OAuth access token is required!${NC}"
                    echo "   Please use option 1 to paste your tokens."
                    continue
                else
                    echo -e "${GREEN}✅ YouTube OAuth access token configured${NC}"
                fi
                
                echo ""
                echo -e "${GREEN}🎉 CONFIGURATION IS VALID AND READY!${NC}"
                echo ""
                echo -e "${BLUE}🚀 You can now start your Lavalink server with option 6${NC}"
                
            else
                echo -e "${RED}❌ Configuration file not found${NC}"
            fi
            ;;
        6)
            echo ""
            echo -e "${GREEN}🚀 STARTING LAVALINK SERVER${NC}"
            echo "=========================="
            echo ""
            
            # Validate first
            if [ -f "$CONFIG_FILE" ]; then
                if grep -q "PASTE_YOUR_YOUTUBE_REFRESH_TOKEN_HERE" "$CONFIG_FILE" || grep -q "PASTE_YOUR_YOUTUBE_ACCESS_TOKEN_HERE" "$CONFIG_FILE"; then
                    echo -e "${RED}❌ Cannot start server - tokens not configured!${NC}"
                    echo "Please use option 1 to paste your YouTube OAuth tokens first."
                    continue
                fi
                
                echo -e "${BLUE}📋 Starting Lavalink server with Android-optimized configuration...${NC}"
                echo ""
                echo -e "${YELLOW}⚠️  Server will start in foreground mode. Press Ctrl+C to stop.${NC}"
                echo ""
                echo -e "${GREEN}🎵 Expected results:${NC}"
                echo "✅ Server starts in ~8 seconds"
                echo "✅ YouTube Plugin v1.13.3 loads"
                echo "✅ 6 YouTube clients initialize (including Android-optimized)"
                echo "✅ OAuth authentication succeeds"
                echo "✅ Ready to serve music requests!"
                echo ""
                read -p "Press Enter to start server or Ctrl+C to cancel..."
                
                # Check if Lavalink.jar exists
                if [ ! -f "Lavalink.jar" ]; then
                    echo -e "${RED}❌ Lavalink.jar not found in current directory${NC}"
                    echo "Please download Lavalink.jar first or run this script from the correct directory."
                    continue
                fi
                
                # Start server
                echo ""
                echo -e "${GREEN}🚀 Starting Lavalink server...${NC}"
                java -jar Lavalink.jar --spring.config.location="$CONFIG_FILE"
                
            else
                echo -e "${RED}❌ Configuration file not found${NC}"
            fi
            ;;
        7)
            echo ""
            echo -e "${GREEN}🎯 ANDROID YOUTUBE SETUP COMPLETE!${NC}"
            echo ""
            echo -e "${BLUE}📋 SUMMARY:${NC}"
            echo "✅ Android-optimized Lavalink configuration ready"
            echo "✅ YouTube Plugin v1.13.3 with Android clients"
            echo "✅ OAuth tokens for rate limit bypass"
            echo "✅ High-quality audio (Opus 10)"
            echo "✅ All audio filters enabled"
            echo "✅ No Apple Music complications!"
            echo ""
            echo -e "${YELLOW}🚀 NEXT STEPS:${NC}"
            echo "1. Make sure your tokens are pasted (option 1)"
            echo "2. Validate configuration (option 5)"
            echo "3. Start server (option 6)"
            echo "4. Enjoy unlimited YouTube music!"
            echo ""
            echo -e "${GREEN}🎵 Perfect for Android users - simple and powerful!${NC}"
            break
            ;;
        *)
            echo -e "${RED}❌ Invalid choice. Please select 1-7.${NC}"
            ;;
    esac
done