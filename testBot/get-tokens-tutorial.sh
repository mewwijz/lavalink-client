#!/bin/bash

# ==========================================================
# ==           GET TOKENS TUTORIAL SCRIPT                ==
# ==     COMPREHENSIVE GUIDE FOR ALL TOKEN TYPES         ==
# ==========================================================

echo "🔑 COMPREHENSIVE TOKEN ACQUISITION TUTORIAL"
echo "============================================="

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

echo ""
echo -e "${BLUE}📋 TOKEN TYPES NEEDED FOR LAVALINK:${NC}"
echo "=================================="
echo -e "${GREEN}✅ YouTube OAuth Tokens${NC} (CRITICAL - Rate limit bypass)"
echo -e "${GREEN}✅ Apple Music JWT Token${NC} (REQUIRED - Apple Music integration)"
echo -e "${YELLOW}⚠️  YouTube Cookies${NC} (OPTIONAL - Session persistence)"
echo -e "${YELLOW}⚠️  YouTube poToken${NC} (OPTIONAL - Anti-detection)"
echo -e "${CYAN}ℹ️  Spotify Credentials${NC} (OPTIONAL - Spotify integration)"

echo ""
echo -e "${PURPLE}🎯 TUTORIAL MENU:${NC}"
echo "=================="
echo "1. YouTube OAuth Tokens (CRITICAL)"
echo "2. Apple Music JWT Token (REQUIRED)"
echo "3. YouTube Cookies (OPTIONAL)"
echo "4. YouTube poToken (OPTIONAL)"
echo "5. Spotify Credentials (OPTIONAL)"
echo "6. Show Configuration Locations"
echo "7. Validate Current Configuration"
echo "8. Exit"

while true; do
    echo ""
    read -p "Choose tutorial (1-8): " choice
    
    case $choice in
        1)
            echo ""
            echo -e "${GREEN}🔑 YOUTUBE OAUTH TOKENS TUTORIAL${NC}"
            echo "================================="
            echo ""
            echo -e "${YELLOW}📍 WHY YOU NEED THIS:${NC}"
            echo "- Bypass YouTube rate limits (403 errors)"
            echo "- Stable audio playback without interruptions"
            echo "- Support for large playlists (1000+ tracks)"
            echo "- High-quality audio stream access"
            echo ""
            echo -e "${BLUE}📋 STEP-BY-STEP GUIDE:${NC}"
            echo ""
            echo "STEP 1: Go to Google OAuth Playground"
            echo "URL: https://developers.google.com/oauthplayground/"
            echo ""
            echo "STEP 2: Configure OAuth Playground"
            echo "- Click gear icon (⚙️) in top right"
            echo "- Check 'Use your own OAuth credentials'"
            echo "- Enter your OAuth Client ID and Secret"
            echo "  (Get these from Google Cloud Console)"
            echo ""
            echo "STEP 3: Select YouTube API Scopes"
            echo "- In left panel, find 'YouTube API v3'"
            echo "- Select: https://www.googleapis.com/auth/youtube"
            echo "- Click 'Authorize APIs'"
            echo ""
            echo "STEP 4: Get Authorization Code"
            echo "- Login with your Google account"
            echo "- Grant permissions"
            echo "- Copy the authorization code"
            echo ""
            echo "STEP 5: Exchange for Tokens"
            echo "- Click 'Exchange authorization code for tokens'"
            echo "- Copy the 'refresh_token' and 'access_token'"
            echo ""
            echo -e "${GREEN}✅ RESULT:${NC}"
            echo "refresh_token: 1//04xyz-your-refresh-token-here"
            echo "access_token: ya29.a0xyz-your-access-token-here"
            echo ""
            echo -e "${PURPLE}📍 CONFIGURATION LOCATION:${NC}"
            echo "File: application-with-apple-music-token.yml"
            echo "Lines 77-78 in plugins.youtube.oauth section"
            ;;
        2)
            echo ""
            echo -e "${GREEN}🎵 APPLE MUSIC JWT TOKEN TUTORIAL${NC}"
            echo "=================================="
            echo ""
            echo -e "${YELLOW}📍 WHY YOU NEED THIS:${NC}"
            echo "- Apple Music search integration"
            echo "- High-quality metadata from Apple Music"
            echo "- ISRC-based track matching"
            echo "- Apple Music playlist support"
            echo ""
            echo -e "${BLUE}📋 STEP-BY-STEP GUIDE:${NC}"
            echo ""
            echo "STEP 1: Apple Developer Account"
            echo "- Sign up at: https://developer.apple.com/"
            echo "- Enroll in Apple Developer Program (\$99/year)"
            echo ""
            echo "STEP 2: Create MusicKit Identifier"
            echo "- Go to: https://developer.apple.com/account/resources/identifiers/list"
            echo "- Click '+' to create new identifier"
            echo "- Select 'Media IDs' → 'MusicKit'"
            echo "- Enter description and bundle ID"
            echo ""
            echo "STEP 3: Create Private Key"
            echo "- Go to: https://developer.apple.com/account/resources/authkeys/list"
            echo "- Click '+' to create new key"
            echo "- Enable 'MusicKit' service"
            echo "- Download the .p8 private key file"
            echo ""
            echo "STEP 4: Generate JWT Token"
            echo "- Use online JWT generator or custom script"
            echo "- Required claims:"
            echo "  - iss: Your Team ID (10 characters)"
            echo "  - iat: Current timestamp"
            echo "  - exp: Expiration timestamp (max 6 months)"
            echo "  - aud: 'appstoreconnect-v1'"
            echo ""
            echo "STEP 5: Alternative - Extract from Apple Music Web"
            echo "- Open Apple Music in browser: https://music.apple.com/"
            echo "- Login to your account"
            echo "- Open Developer Tools (F12)"
            echo "- Go to Network tab"
            echo "- Play any song"
            echo "- Look for requests to 'amp-api.music.apple.com'"
            echo "- Copy 'Authorization: Bearer' token from headers"
            echo ""
            echo -e "${GREEN}✅ RESULT:${NC}"
            echo "JWT Token format: eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJZT1VSX1RFQU1fSUQi...signature"
            echo ""
            echo -e "${PURPLE}📍 CONFIGURATION LOCATION:${NC}"
            echo "File: application-with-apple-music-token.yml"
            echo "Line 112 in plugins.lavasrc.applemusic.mediaAPIToken"
            ;;
        3)
            echo ""
            echo -e "${YELLOW}🍪 YOUTUBE COOKIES TUTORIAL${NC}"
            echo "============================"
            echo ""
            echo -e "${YELLOW}📍 WHY YOU NEED THIS:${NC}"
            echo "- Session persistence across restarts"
            echo "- Better reliability for long-running sessions"
            echo "- Reduced authentication challenges"
            echo "- Improved bot detection avoidance"
            echo ""
            echo -e "${BLUE}📋 STEP-BY-STEP GUIDE:${NC}"
            echo ""
            echo "STEP 1: Open YouTube in Browser"
            echo "- Go to: https://www.youtube.com/"
            echo "- Login to your account (use dedicated account)"
            echo ""
            echo "STEP 2: Extract Cookies"
            echo "- Open Developer Tools (F12)"
            echo "- Go to 'Application' or 'Storage' tab"
            echo "- Find 'Cookies' → 'https://www.youtube.com'"
            echo ""
            echo "STEP 3: Copy Important Cookies"
            echo "- VISITOR_INFO1_LIVE"
            echo "- YSC"
            echo "- PREF"
            echo "- LOGIN_INFO (if logged in)"
            echo ""
            echo "STEP 4: Format Cookies"
            echo "Format: 'name1=value1; name2=value2; name3=value3'"
            echo ""
            echo -e "${GREEN}✅ RESULT:${NC}"
            echo "VISITOR_INFO1_LIVE=xyz123; YSC=abc456; PREF=f1=50000000"
            echo ""
            echo -e "${PURPLE}📍 CONFIGURATION LOCATION:${NC}"
            echo "File: application-with-apple-music-token.yml"
            echo "Line 84 in plugins.youtube.cookies.cookie"
            ;;
        4)
            echo ""
            echo -e "${YELLOW}🎯 YOUTUBE POTOKEN TUTORIAL${NC}"
            echo "==========================="
            echo ""
            echo -e "${YELLOW}📍 WHY YOU NEED THIS:${NC}"
            echo "- Advanced anti-detection capabilities"
            echo "- Bypass bot protection mechanisms"
            echo "- More stable long-term operation"
            echo "- Reduced risk of IP blocking"
            echo ""
            echo -e "${BLUE}📋 STEP-BY-STEP GUIDE:${NC}"
            echo ""
            echo "STEP 1: Use Browser Extension"
            echo "- Install 'Cookie Editor' or similar extension"
            echo "- Go to: https://www.youtube.com/"
            echo "- Login to your account"
            echo ""
            echo "STEP 2: Extract poToken"
            echo "- Open Developer Tools (F12)"
            echo "- Go to 'Network' tab"
            echo "- Play any video"
            echo "- Look for requests to 'youtubei.googleapis.com'"
            echo "- Find 'po_token' parameter in request"
            echo ""
            echo "STEP 3: Alternative - Use Script"
            echo "- Run JavaScript in browser console:"
            echo "  window.ytInitialData?.responseContext?.serviceTrackingParams"
            echo "- Look for 'c' parameter (this is poToken)"
            echo ""
            echo -e "${GREEN}✅ RESULT:${NC}"
            echo "poToken format: MnwxM3wxNjkwMjA4NDAwfDEuMC4wfDF8dGVzdA=="
            echo ""
            echo -e "${PURPLE}📍 CONFIGURATION LOCATION:${NC}"
            echo "File: application-with-apple-music-token.yml"
            echo "Line 87 in plugins.youtube.poToken"
            ;;
        5)
            echo ""
            echo -e "${CYAN}🎶 SPOTIFY CREDENTIALS TUTORIAL${NC}"
            echo "==============================="
            echo ""
            echo -e "${YELLOW}📍 WHY YOU NEED THIS:${NC}"
            echo "- Spotify search integration"
            echo "- Enhanced metadata from Spotify"
            echo "- Spotify playlist support"
            echo "- Better track matching accuracy"
            echo ""
            echo -e "${BLUE}📋 STEP-BY-STEP GUIDE:${NC}"
            echo ""
            echo "STEP 1: Spotify Developer Dashboard"
            echo "- Go to: https://developer.spotify.com/dashboard/"
            echo "- Login with your Spotify account"
            echo ""
            echo "STEP 2: Create New App"
            echo "- Click 'Create an App'"
            echo "- Enter app name and description"
            echo "- Accept terms and create"
            echo ""
            echo "STEP 3: Get Credentials"
            echo "- Copy 'Client ID'"
            echo "- Click 'Show Client Secret'"
            echo "- Copy 'Client Secret'"
            echo ""
            echo "STEP 4: Configure App Settings"
            echo "- Add redirect URI: http://localhost:8080/callback"
            echo "- Save settings"
            echo ""
            echo -e "${GREEN}✅ RESULT:${NC}"
            echo "Client ID: 1234567890abcdef1234567890abcdef"
            echo "Client Secret: abcdef1234567890abcdef1234567890abcdef12"
            echo ""
            echo -e "${PURPLE}📍 CONFIGURATION LOCATION:${NC}"
            echo "File: application-with-apple-music-token.yml"
            echo "Lines 105-106 in plugins.lavasrc.spotify section"
            ;;
        6)
            echo ""
            echo -e "${PURPLE}📍 CONFIGURATION LOCATIONS SUMMARY${NC}"
            echo "=================================="
            echo ""
            echo -e "${GREEN}🔑 YouTube OAuth Tokens:${NC}"
            echo "File: application-with-apple-music-token.yml"
            echo "Lines 77-78: plugins.youtube.oauth.refreshToken & accessToken"
            echo ""
            echo -e "${GREEN}🎵 Apple Music Token:${NC}"
            echo "File: application-with-apple-music-token.yml"
            echo "Line 112: plugins.lavasrc.applemusic.mediaAPIToken"
            echo ""
            echo -e "${YELLOW}🍪 YouTube Cookies:${NC}"
            echo "File: application-with-apple-music-token.yml"
            echo "Line 84: plugins.youtube.cookies.cookie"
            echo ""
            echo -e "${YELLOW}🎯 YouTube poToken:${NC}"
            echo "File: application-with-apple-music-token.yml"
            echo "Line 87: plugins.youtube.poToken"
            echo ""
            echo -e "${CYAN}🎶 Spotify Credentials:${NC}"
            echo "File: application-with-apple-music-token.yml"
            echo "Lines 105-106: plugins.lavasrc.spotify.clientId & clientSecret"
            ;;
        7)
            echo ""
            echo -e "${BLUE}🔍 VALIDATING CURRENT CONFIGURATION${NC}"
            echo "==================================="
            echo ""
            
            if [ -f "application-with-apple-music-token.yml" ]; then
                echo -e "${GREEN}✅ Configuration file found${NC}"
                
                # Check YAML syntax
                if command -v python3 &> /dev/null; then
                    if python3 -c "import yaml; yaml.safe_load(open('application-with-apple-music-token.yml'))" 2>/dev/null; then
                        echo -e "${GREEN}✅ YAML syntax is valid${NC}"
                    else
                        echo -e "${RED}❌ YAML syntax error${NC}"
                    fi
                else
                    echo -e "${YELLOW}⚠️  Python3 not found - cannot validate YAML syntax${NC}"
                fi
                
                # Check for token placeholders
                echo ""
                echo -e "${BLUE}🔍 Checking token configuration:${NC}"
                
                if grep -q "YOUR_YOUTUBE_OAUTH_REFRESH_TOKEN_HERE" application-with-apple-music-token.yml; then
                    echo -e "${RED}❌ YouTube OAuth refresh token not configured${NC}"
                else
                    echo -e "${GREEN}✅ YouTube OAuth refresh token configured${NC}"
                fi
                
                if grep -q "YOUR_YOUTUBE_OAUTH_ACCESS_TOKEN_HERE" application-with-apple-music-token.yml; then
                    echo -e "${RED}❌ YouTube OAuth access token not configured${NC}"
                else
                    echo -e "${GREEN}✅ YouTube OAuth access token configured${NC}"
                fi
                
                if grep -q "YOUR_APPLE_MUSIC_TOKEN_HERE" application-with-apple-music-token.yml; then
                    echo -e "${RED}❌ Apple Music token not configured${NC}"
                else
                    echo -e "${GREEN}✅ Apple Music token configured${NC}"
                fi
                
                if grep -q "YOUR_YOUTUBE_COOKIES_HERE" application-with-apple-music-token.yml; then
                    echo -e "${YELLOW}⚠️  YouTube cookies not configured (optional)${NC}"
                else
                    echo -e "${GREEN}✅ YouTube cookies configured${NC}"
                fi
                
                if grep -q "YOUR_YOUTUBE_POTOKEN_HERE" application-with-apple-music-token.yml; then
                    echo -e "${YELLOW}⚠️  YouTube poToken not configured (optional)${NC}"
                else
                    echo -e "${GREEN}✅ YouTube poToken configured${NC}"
                fi
                
            else
                echo -e "${RED}❌ Configuration file not found${NC}"
                echo "Expected: application-with-apple-music-token.yml"
            fi
            ;;
        8)
            echo ""
            echo -e "${GREEN}🎯 TOKEN TUTORIAL COMPLETE!${NC}"
            echo ""
            echo -e "${BLUE}📋 NEXT STEPS:${NC}"
            echo "1. Follow the tutorials above to get your tokens"
            echo "2. Edit application-with-apple-music-token.yml"
            echo "3. Replace token placeholders with real tokens"
            echo "4. Restart Lavalink server"
            echo "5. Enjoy enhanced music server capabilities!"
            echo ""
            echo -e "${GREEN}🚀 Happy music streaming!${NC}"
            break
            ;;
        *)
            echo -e "${RED}❌ Invalid choice. Please select 1-8.${NC}"
            ;;
    esac
done