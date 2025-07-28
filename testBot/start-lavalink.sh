#!/bin/bash

# ==========================================================
# ==        LAVALINK STARTUP SCRIPT TERBARU 2025         ==
# ==     OPTIMIZED UNTUK YOUTUBE PLAYBACK STABILITY      ==
# ==========================================================

echo "🚀 Starting Lavalink Server with Optimized Configuration..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if Java is installed
if ! command -v java &> /dev/null; then
    echo -e "${RED}❌ Java is not installed. Please install Java 17 or higher.${NC}"
    exit 1
fi

# Check Java version
JAVA_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}' | cut -d'.' -f1)
if [ "$JAVA_VERSION" -lt 17 ]; then
    echo -e "${RED}❌ Java 17 or higher is required. Current version: $JAVA_VERSION${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Java version check passed${NC}"

# Download Lavalink if not exists
LAVALINK_JAR="Lavalink.jar"
LAVALINK_VERSION="4.0.7"
LAVALINK_URL="https://github.com/lavalink-devs/Lavalink/releases/download/$LAVALINK_VERSION/Lavalink.jar"

if [ ! -f "$LAVALINK_JAR" ]; then
    echo -e "${YELLOW}📥 Downloading Lavalink $LAVALINK_VERSION...${NC}"
    curl -L -o "$LAVALINK_JAR" "$LAVALINK_URL"
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Failed to download Lavalink${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✅ Lavalink downloaded successfully${NC}"
fi

# Create logs directory
mkdir -p logs

# JVM Options untuk performa optimal
JVM_OPTS=(
    "-Xms512m"
    "-Xmx2g"
    "-XX:+UseG1GC"
    "-XX:+UseStringDeduplication"
    "-XX:MaxGCPauseMillis=150"
    "-XX:+UnlockExperimentalVMOptions"
    "-XX:+UseJVMCICompiler"
    "-Dnashorn.args=--no-deprecation-warning"
    "-Dfile.encoding=UTF-8"
    "-Djava.awt.headless=true"
    "-Dcom.sun.management.jmxremote=true"
    "-Dcom.sun.management.jmxremote.port=9999"
    "-Dcom.sun.management.jmxremote.authenticate=false"
    "-Dcom.sun.management.jmxremote.ssl=false"
)

# Configuration file
CONFIG_FILE="application-optimized.yml"

if [ ! -f "$CONFIG_FILE" ]; then
    echo -e "${RED}❌ Configuration file $CONFIG_FILE not found${NC}"
    exit 1
fi

echo -e "${BLUE}📋 Using configuration: $CONFIG_FILE${NC}"

# Function to handle cleanup
cleanup() {
    echo -e "\n${YELLOW}🛑 Shutting down Lavalink...${NC}"
    kill $LAVALINK_PID 2>/dev/null
    exit 0
}

# Trap signals for graceful shutdown
trap cleanup SIGINT SIGTERM

# Start Lavalink
echo -e "${GREEN}🎵 Starting Lavalink Server...${NC}"
echo -e "${BLUE}📊 JVM Options: ${JVM_OPTS[*]}${NC}"
echo -e "${BLUE}⚙️ Configuration: $CONFIG_FILE${NC}"
echo ""

java "${JVM_OPTS[@]}" -jar "$LAVALINK_JAR" --spring.config.location="$CONFIG_FILE" &
LAVALINK_PID=$!

echo -e "${GREEN}✅ Lavalink started with PID: $LAVALINK_PID${NC}"
echo -e "${BLUE}🌐 Server will be available at: http://localhost:2333${NC}"
echo -e "${YELLOW}📝 Press Ctrl+C to stop the server${NC}"
echo ""

# Monitor Lavalink process
while kill -0 $LAVALINK_PID 2>/dev/null; do
    sleep 1
done

echo -e "${RED}❌ Lavalink process has stopped${NC}"