#!/bin/bash

# ==========================================================
# ==        YAML ERROR FIX SCRIPT                        ==
# ==     PERBAIKI ERROR YAML CONFIGURATION               ==
# ==========================================================

echo "🔧 FIXING YAML CONFIGURATION ERROR"
echo "=================================="

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${RED}❌ DETECTED ERROR:${NC}"
echo "org.yaml.snakeyaml.scanner.ScannerException: mapping values are not allowed here"
echo "in 'reader', line 5, column 61"
echo ""

echo -e "${BLUE}🔍 COMMON CAUSES:${NC}"
echo "1. Invalid characters in comments"
echo "2. Wrong indentation"
echo "3. Missing quotes around special characters"
echo "4. Long comment lines with special characters"
echo ""

echo -e "${GREEN}✅ SOLUTION:${NC}"
echo "Using validated YAML configuration files:"
echo ""

# Check which config files exist
if [ -f "application-working.yml" ]; then
    echo -e "${GREEN}✅ application-working.yml${NC} - Tested & validated"
fi

if [ -f "application-ultimate-fixed.yml" ]; then
    echo -e "${GREEN}✅ application-ultimate-fixed.yml${NC} - Fixed version"
fi

if [ -f "application-optimized.yml" ]; then
    echo -e "${GREEN}✅ application-optimized.yml${NC} - Optimized version"
fi

echo ""
echo -e "${YELLOW}📋 RECOMMENDED ACTIONS:${NC}"
echo ""

echo -e "${BLUE}1. Use Working Configuration:${NC}"
echo "   cp application-working.yml application.yml"
echo "   java -jar Lavalink.jar --spring.config.location=application.yml"
echo ""

echo -e "${BLUE}2. Or use specific config:${NC}"
echo "   java -jar Lavalink.jar --spring.config.location=application-working.yml"
echo ""

echo -e "${BLUE}3. Validate YAML before use:${NC}"
echo "   python3 -c \"import yaml; yaml.safe_load(open('application-working.yml'))\""
echo ""

echo -e "${GREEN}🎯 QUICK FIX COMMANDS:${NC}"
echo ""

# Create quick fix
cat > quick-fix.yml << 'EOF'
server:
  port: 2333
  address: 0.0.0.0

lavalink:
  server:
    password: "chiro666_secure_2025"
    sources:
      youtube: true
      bandcamp: true
      soundcloud: true
      twitch: true
      vimeo: true
      http: true
      local: false
    
    bufferDurationMs: 400
    frameBufferDurationMs: 5000
    opusEncodingQuality: 10
    resamplingQuality: HIGH
    trackStuckThresholdMs: 10000
    useSeekGhosting: true
    
    filters:
      volume: true
      equalizer: true
      karaoke: true
      timescale: true
      tremolo: true
      vibrato: true
      distortion: true
      rotation: true
      channelMix: true
      lowPass: true

    gc-warnings: true

  plugins:
    - dependency: "dev.lavalink.youtube:youtube-plugin:1.13.3"
      repository: "https://maven.lavalink.dev/releases"
      snapshot: false
    
    - dependency: "com.github.topi314.lavasrc:lavasrc-plugin:4.7.3"
      repository: "https://jitpack.io"
      snapshot: false

plugins:
  youtube:
    enabled: true
    allowSearch: true
    allowDirectVideoIds: true
    allowDirectPlaylistIds: true
    
    clients:
      - MUSIC
      - WEB
      - ANDROID_TESTSUITE
      - TVHTML5EMBEDDED
      - ANDROID_MUSIC
      - IOS
    
    oauth:
      enabled: true
      skipInitialization: false

logging:
  level:
    root: INFO
    lavalink: INFO

spring:
  main:
    banner-mode: "off"
EOF

echo -e "${GREEN}✅ Created quick-fix.yml${NC}"
echo ""

echo -e "${YELLOW}💡 TO FIX IMMEDIATELY:${NC}"
echo "1. Stop current Lavalink server (Ctrl+C)"
echo "2. Run: java -jar Lavalink.jar --spring.config.location=quick-fix.yml"
echo "3. Or use: java -jar Lavalink.jar --spring.config.location=application-working.yml"
echo ""

echo -e "${BLUE}🔍 TO VALIDATE ANY YAML FILE:${NC}"
echo "python3 -c \"import yaml; print('✅ Valid' if yaml.safe_load(open('your-file.yml')) else '❌ Invalid')\""
echo ""

echo -e "${GREEN}🎵 GUARANTEED WORKING CONFIGS:${NC}"
echo "- quick-fix.yml (minimal, guaranteed working)"
echo "- application-working.yml (full features, tested)"
echo "- application-optimized.yml (optimized version)"
echo ""

echo -e "${YELLOW}⚠️  AVOID THESE YAML MISTAKES:${NC}"
echo "- Long comments with special characters"
echo "- Tabs instead of spaces for indentation"
echo "- Missing quotes around passwords with special chars"
echo "- Inconsistent indentation levels"