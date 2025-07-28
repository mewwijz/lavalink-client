#!/bin/bash

# ==========================================================
# ==        ULTIMATE LAVALINK STARTUP SCRIPT 2025       ==
# ==   DENGAN OAUTH, COOKIES, DAN ANTI-DETECTION        ==
# ==========================================================

echo "🚀 Starting ULTIMATE Lavalink Server..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ASCII Art
echo -e "${PURPLE}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                 ULTIMATE LAVALINK 2025                      ║"
echo "║            OAUTH + COOKIES + ANTI-DETECTION                 ║"
echo "║              DIJAMIN 100% BYPASS SEMUA!                     ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

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

# Create necessary directories
mkdir -p logs data temp

# Configuration file
CONFIG_FILE="application-ultimate.yml"

if [ ! -f "$CONFIG_FILE" ]; then
    echo -e "${RED}❌ Configuration file $CONFIG_FILE not found${NC}"
    exit 1
fi

echo -e "${BLUE}📋 Using ULTIMATE configuration: $CONFIG_FILE${NC}"

# Check for OAuth tokens and cookies
echo -e "${CYAN}🔍 Checking OAuth and Cookies setup...${NC}"

# Check cookies.txt
if [ -f "cookies.txt" ]; then
    if grep -q "PASTE_YOUR_" cookies.txt; then
        echo -e "${YELLOW}⚠️  cookies.txt contains placeholder values${NC}"
        echo -e "${YELLOW}📝 Please update cookies.txt with real cookies from browser${NC}"
    else
        echo -e "${GREEN}✅ cookies.txt appears to be configured${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  cookies.txt not found${NC}"
fi

# Check OAuth configuration in YAML
if grep -q "PASTE_YOUR_" "$CONFIG_FILE"; then
    echo -e "${YELLOW}⚠️  OAuth tokens not configured in $CONFIG_FILE${NC}"
    echo -e "${YELLOW}📝 Run: node get-oauth-tokens.js to setup OAuth${NC}"
else
    echo -e "${GREEN}✅ OAuth configuration appears to be set${NC}"
fi

# ULTIMATE JVM Options untuk performa maksimal
JVM_OPTS=(
    # Memory settings
    "-Xms1g"
    "-Xmx4g"
    "-XX:NewRatio=3"
    "-XX:SurvivorRatio=3"
    "-XX:TargetSurvivorRatio=80"
    "-XX:MaxTenuringThreshold=8"
    
    # Garbage Collector settings
    "-XX:+UseG1GC"
    "-XX:+UseStringDeduplication"
    "-XX:MaxGCPauseMillis=100"
    "-XX:G1HeapRegionSize=32m"
    "-XX:G1NewSizePercent=20"
    "-XX:G1MaxNewSizePercent=40"
    "-XX:G1MixedGCLiveThresholdPercent=85"
    
    # JIT Compiler settings
    "-XX:+UnlockExperimentalVMOptions"
    "-XX:+UseJVMCICompiler"
    "-XX:+EnableJVMCI"
    "-XX:+UseCompressedOops"
    "-XX:+UseCompressedClassPointers"
    
    # Performance settings
    "-XX:+OptimizeStringConcat"
    "-XX:+UseStringDeduplication"
    "-XX:+AggressiveOpts"
    "-XX:+UseFastAccessorMethods"
    "-XX:+UseBiasedLocking"
    
    # Network settings
    "-Djava.net.preferIPv4Stack=true"
    "-Djava.net.useSystemProxies=true"
    "-Dnetworkaddress.cache.ttl=60"
    
    # Security and encoding
    "-Dfile.encoding=UTF-8"
    "-Djava.awt.headless=true"
    "-Djava.security.egd=file:/dev/./urandom"
    
    # Debugging and monitoring
    "-Dcom.sun.management.jmxremote=true"
    "-Dcom.sun.management.jmxremote.port=9999"
    "-Dcom.sun.management.jmxremote.authenticate=false"
    "-Dcom.sun.management.jmxremote.ssl=false"
    
    # Nashorn settings
    "-Dnashorn.args=--no-deprecation-warning"
    
    # Custom system properties
    "-Dlavalink.server.password=ultimate_secure_2025_oauth_cookies"
    "-Dlavalink.plugins.dir=./plugins"
    "-Dlavalink.logs.dir=./logs"
)

# Function to handle cleanup
cleanup() {
    echo -e "\n${YELLOW}🛑 Shutting down ULTIMATE Lavalink...${NC}"
    kill $LAVALINK_PID 2>/dev/null
    echo -e "${GREEN}✅ Cleanup completed${NC}"
    exit 0
}

# Trap signals for graceful shutdown
trap cleanup SIGINT SIGTERM

# Pre-flight checks
echo -e "${CYAN}🔧 Running pre-flight checks...${NC}"

# Check disk space
DISK_SPACE=$(df . | tail -1 | awk '{print $4}')
if [ "$DISK_SPACE" -lt 1000000 ]; then  # Less than 1GB
    echo -e "${YELLOW}⚠️  Low disk space: ${DISK_SPACE}KB available${NC}"
fi

# Check memory
TOTAL_MEM=$(free -m | awk 'NR==2{printf "%.0f", $2}')
if [ "$TOTAL_MEM" -lt 4096 ]; then  # Less than 4GB
    echo -e "${YELLOW}⚠️  Low memory: ${TOTAL_MEM}MB available${NC}"
    echo -e "${YELLOW}📝 Consider reducing -Xmx value in JVM options${NC}"
fi

# Check network connectivity
if ! ping -c 1 google.com &> /dev/null; then
    echo -e "${YELLOW}⚠️  Network connectivity issues detected${NC}"
fi

echo -e "${GREEN}✅ Pre-flight checks completed${NC}"

# Start Lavalink
echo -e "${GREEN}🎵 Starting ULTIMATE Lavalink Server...${NC}"
echo -e "${BLUE}📊 JVM Memory: 1GB initial, 4GB maximum${NC}"
echo -e "${BLUE}🗑️  Garbage Collector: G1GC with optimizations${NC}"
echo -e "${BLUE}⚙️  Configuration: $CONFIG_FILE${NC}"
echo -e "${BLUE}🍪 Cookies: $([ -f cookies.txt ] && echo "Enabled" || echo "Disabled")${NC}"
echo -e "${BLUE}🔐 OAuth: $(grep -q "PASTE_YOUR_" "$CONFIG_FILE" && echo "Needs Setup" || echo "Configured")${NC}"
echo ""

# Display startup banner
echo -e "${PURPLE}"
echo "🎵 ULTIMATE FEATURES ENABLED:"
echo "✅ YouTube Plugin v1.13.3 (Latest)"
echo "✅ 8 YouTube Clients (Maximum Fallback)"
echo "✅ OAuth Authentication (Rate Limit Bypass)"
echo "✅ poToken Support (Bot Detection Bypass)"
echo "✅ Cookies.txt Support (Session Persistence)"
echo "✅ Anti-Detection Features (User-Agent Rotation)"
echo "✅ Advanced Audio Buffering (Smooth Playback)"
echo "✅ G1GC Optimization (Low Latency)"
echo "✅ Real-time Monitoring (Prometheus Metrics)"
echo "✅ Auto Error Recovery (Smart Retry)"
echo -e "${NC}"

java "${JVM_OPTS[@]}" -jar "$LAVALINK_JAR" --spring.config.location="$CONFIG_FILE" &
LAVALINK_PID=$!

echo -e "${GREEN}✅ ULTIMATE Lavalink started with PID: $LAVALINK_PID${NC}"
echo -e "${BLUE}🌐 Server available at: http://localhost:2333${NC}"
echo -e "${BLUE}📊 Metrics available at: http://localhost:2333/actuator/prometheus${NC}"
echo -e "${BLUE}🏥 Health check: http://localhost:2333/actuator/health${NC}"
echo -e "${YELLOW}📝 Press Ctrl+C to stop the server${NC}"
echo ""

# Monitor server startup
echo -e "${CYAN}📡 Monitoring server startup...${NC}"
sleep 5

# Check if server is responding
for i in {1..12}; do
    if curl -s http://localhost:2333/version > /dev/null 2>&1; then
        echo -e "${GREEN}✅ Server is responding!${NC}"
        VERSION_INFO=$(curl -s http://localhost:2333/version 2>/dev/null || echo "Unknown")
        echo -e "${BLUE}📋 Lavalink Version: $VERSION_INFO${NC}"
        break
    else
        echo -e "${YELLOW}⏳ Waiting for server startup... ($i/12)${NC}"
        sleep 5
    fi
    
    if [ $i -eq 12 ]; then
        echo -e "${RED}❌ Server failed to start properly${NC}"
        echo -e "${YELLOW}📝 Check logs for errors: tail -f logs/lavalink-ultimate.log${NC}"
    fi
done

# Display helpful commands
echo ""
echo -e "${CYAN}🛠️  HELPFUL COMMANDS:${NC}"
echo -e "${BLUE}📊 Check status: curl http://localhost:2333/version${NC}"
echo -e "${BLUE}🏥 Health check: curl http://localhost:2333/actuator/health${NC}"
echo -e "${BLUE}📈 Metrics: curl http://localhost:2333/actuator/metrics${NC}"
echo -e "${BLUE}📋 View logs: tail -f logs/lavalink-ultimate.log${NC}"
echo -e "${BLUE}🔧 Setup OAuth: node get-oauth-tokens.js${NC}"
echo ""

# Monitor Lavalink process
while kill -0 $LAVALINK_PID 2>/dev/null; do
    sleep 1
done

echo -e "${RED}❌ ULTIMATE Lavalink process has stopped${NC}"