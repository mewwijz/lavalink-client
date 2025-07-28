#!/bin/bash

# ==========================================================
# ==        SCRIPT TRANSFER FILES KE VPS                 ==
# ==     COPY SEMUA FILES ULTIMATE KE SERVER ANDA       ==
# ==========================================================

echo "📦 TRANSFER ULTIMATE FILES TO VPS"
echo "=================================="

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Files yang perlu di-transfer
FILES=(
    "application-ultimate.yml"
    "application-optimized.yml" 
    "cookies.txt"
    "get-oauth-tokens.js"
    "start-lavalink-ultimate.sh"
    "start-lavalink.sh"
    "setup-complete.sh"
    "youtube-playback-test.js"
    "ULTIMATE_SUMMARY.md"
    "OAUTH_COOKIES_SETUP.md"
    "YOUTUBE_PLAYBACK_GUARANTEE.md"
    "FINAL_GUARANTEE.md"
    "COMPARISON_OLD_VS_NEW.md"
)

echo -e "${BLUE}📋 Files yang akan di-transfer:${NC}"
for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✅ $file${NC}"
    else
        echo -e "${YELLOW}⚠️  $file (not found)${NC}"
    fi
done

echo ""
echo -e "${YELLOW}📝 CARA TRANSFER KE VPS:${NC}"
echo ""

echo -e "${BLUE}OPSI 1: SCP (Secure Copy)${NC}"
echo "# Ganti USER, HOST, dan PATH sesuai VPS Anda"
echo "VPS_USER=\"your_username\""
echo "VPS_HOST=\"your_vps_ip\""
echo "VPS_PATH=\"/path/to/your/lavalink-client/testBot\""
echo ""
for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "scp $file \$VPS_USER@\$VPS_HOST:\$VPS_PATH/"
    fi
done

echo ""
echo -e "${BLUE}OPSI 2: RSYNC (Recommended)${NC}"
echo "# Sync semua files sekaligus"
echo "rsync -avz --progress \\"
for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "  $file \\"
    fi
done
echo "  \$VPS_USER@\$VPS_HOST:\$VPS_PATH/"

echo ""
echo -e "${BLUE}OPSI 3: MANUAL COPY-PASTE${NC}"
echo "1. Buka setiap file di sini"
echo "2. Copy isi file"
echo "3. Paste ke file baru di VPS"
echo "4. Save dengan nama yang sama"

echo ""
echo -e "${BLUE}OPSI 4: WGET (Jika files di-upload ke GitHub)${NC}"
echo "# Jika files sudah di-commit ke GitHub:"
echo "wget https://raw.githubusercontent.com/mewwijz/lavalink-client/main/testBot/application-ultimate.yml"
echo "# (ulangi untuk setiap file)"

echo ""
echo -e "${GREEN}✅ SETELAH TRANSFER:${NC}"
echo "1. chmod +x *.sh"
echo "2. Edit application-ultimate.yml dengan tokens Anda"
echo "3. Update cookies.txt dengan cookies asli"
echo "4. ./start-lavalink-ultimate.sh"

echo ""
echo -e "${YELLOW}💡 TIP: Gunakan RSYNC untuk transfer yang lebih efisien!${NC}"