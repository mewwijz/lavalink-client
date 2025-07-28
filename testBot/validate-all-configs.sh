#!/bin/bash

# ==========================================================
# ==        VALIDATE ALL LAVALINK CONFIGURATIONS         ==
# ==     COMPREHENSIVE YAML AND FUNCTIONALITY TEST       ==
# ==========================================================

echo "🔍 VALIDATING ALL LAVALINK CONFIGURATIONS"
echo "=========================================="

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Counters
TOTAL_CONFIGS=0
VALID_CONFIGS=0
INVALID_CONFIGS=0

# Function to validate YAML syntax
validate_yaml() {
    local file=$1
    echo -n "Testing $file... "
    
    if [ ! -f "$file" ]; then
        echo -e "${RED}❌ FILE NOT FOUND${NC}"
        return 1
    fi
    
    # Test with Python YAML parser
    python3 -c "
import yaml
import sys
try:
    with open('$file', 'r') as f:
        config = yaml.safe_load(f)
    if config is None:
        print('❌ EMPTY CONFIG')
        sys.exit(1)
    print('✅ VALID YAML')
    sys.exit(0)
except yaml.YAMLError as e:
    print(f'❌ YAML ERROR: {e}')
    sys.exit(1)
except Exception as e:
    print(f'❌ ERROR: {e}')
    sys.exit(1)
" 2>/dev/null
    
    return $?
}

# Function to check required sections
check_config_sections() {
    local file=$1
    echo -n "  Checking sections... "
    
    python3 -c "
import yaml
import sys
try:
    with open('$file', 'r') as f:
        config = yaml.safe_load(f)
    
    required_sections = ['server', 'lavalink']
    missing = []
    
    for section in required_sections:
        if section not in config:
            missing.append(section)
    
    if missing:
        print(f'❌ MISSING: {missing}')
        sys.exit(1)
    
    # Check server section
    if 'port' not in config['server']:
        print('❌ MISSING: server.port')
        sys.exit(1)
    
    # Check lavalink section
    if 'server' not in config['lavalink']:
        print('❌ MISSING: lavalink.server')
        sys.exit(1)
    
    if 'password' not in config['lavalink']['server']:
        print('❌ MISSING: lavalink.server.password')
        sys.exit(1)
    
    print('✅ ALL SECTIONS PRESENT')
    sys.exit(0)
    
except Exception as e:
    print(f'❌ ERROR: {e}')
    sys.exit(1)
" 2>/dev/null
    
    return $?
}

# Function to check YouTube plugin configuration
check_youtube_config() {
    local file=$1
    echo -n "  Checking YouTube config... "
    
    python3 -c "
import yaml
import sys
try:
    with open('$file', 'r') as f:
        config = yaml.safe_load(f)
    
    # Check if YouTube plugin is in plugins list
    if 'plugins' not in config['lavalink']:
        print('❌ NO PLUGINS SECTION')
        sys.exit(1)
    
    youtube_found = False
    for plugin in config['lavalink']['plugins']:
        if 'youtube-plugin' in plugin.get('dependency', ''):
            youtube_found = True
            break
    
    if not youtube_found:
        print('❌ YOUTUBE PLUGIN NOT FOUND')
        sys.exit(1)
    
    # Check plugin configuration
    if 'plugins' in config and 'youtube' in config['plugins']:
        youtube_config = config['plugins']['youtube']
        if 'enabled' in youtube_config and not youtube_config['enabled']:
            print('❌ YOUTUBE DISABLED')
            sys.exit(1)
    
    print('✅ YOUTUBE CONFIG OK')
    sys.exit(0)
    
except Exception as e:
    print(f'❌ ERROR: {e}')
    sys.exit(1)
" 2>/dev/null
    
    return $?
}

echo -e "${BLUE}📋 CONFIGURATION FILES TO TEST:${NC}"
echo ""

# List of configuration files to test
configs=(
    "application-minimal.yml"
    "application-no-errors.yml"
    "application-working.yml"
    "application-ultimate-fixed.yml"
    "application-optimized.yml"
)

# Test each configuration
for config in "${configs[@]}"; do
    echo -e "${YELLOW}🔍 TESTING: $config${NC}"
    TOTAL_CONFIGS=$((TOTAL_CONFIGS + 1))
    
    # Validate YAML syntax
    if validate_yaml "$config"; then
        # Check required sections
        if check_config_sections "$config"; then
            # Check YouTube configuration
            if check_youtube_config "$config"; then
                echo -e "  ${GREEN}✅ OVERALL: VALID AND READY${NC}"
                VALID_CONFIGS=$((VALID_CONFIGS + 1))
            else
                echo -e "  ${RED}❌ OVERALL: YOUTUBE CONFIG ISSUES${NC}"
                INVALID_CONFIGS=$((INVALID_CONFIGS + 1))
            fi
        else
            echo -e "  ${RED}❌ OVERALL: MISSING REQUIRED SECTIONS${NC}"
            INVALID_CONFIGS=$((INVALID_CONFIGS + 1))
        fi
    else
        echo -e "  ${RED}❌ OVERALL: YAML SYNTAX ERROR${NC}"
        INVALID_CONFIGS=$((INVALID_CONFIGS + 1))
    fi
    echo ""
done

# Test if quick configs exist (created by scripts)
echo -e "${BLUE}🔍 CHECKING GENERATED CONFIGS:${NC}"
echo ""

generated_configs=(
    "quick-fix.yml"
    "quick-minimal.yml"
)

for config in "${generated_configs[@]}"; do
    if [ -f "$config" ]; then
        echo -e "${YELLOW}🔍 TESTING GENERATED: $config${NC}"
        TOTAL_CONFIGS=$((TOTAL_CONFIGS + 1))
        
        if validate_yaml "$config"; then
            if check_config_sections "$config"; then
                if check_youtube_config "$config"; then
                    echo -e "  ${GREEN}✅ OVERALL: VALID AND READY${NC}"
                    VALID_CONFIGS=$((VALID_CONFIGS + 1))
                else
                    echo -e "  ${RED}❌ OVERALL: YOUTUBE CONFIG ISSUES${NC}"
                    INVALID_CONFIGS=$((INVALID_CONFIGS + 1))
                fi
            else
                echo -e "  ${RED}❌ OVERALL: MISSING REQUIRED SECTIONS${NC}"
                INVALID_CONFIGS=$((INVALID_CONFIGS + 1))
            fi
        else
            echo -e "  ${RED}❌ OVERALL: YAML SYNTAX ERROR${NC}"
            INVALID_CONFIGS=$((INVALID_CONFIGS + 1))
        fi
        echo ""
    fi
done

# Summary
echo -e "${BLUE}📊 VALIDATION SUMMARY:${NC}"
echo "======================"
echo -e "Total Configurations: ${BLUE}$TOTAL_CONFIGS${NC}"
echo -e "Valid Configurations: ${GREEN}$VALID_CONFIGS${NC}"
echo -e "Invalid Configurations: ${RED}$INVALID_CONFIGS${NC}"
echo ""

if [ $VALID_CONFIGS -gt 0 ]; then
    echo -e "${GREEN}✅ SUCCESS: $VALID_CONFIGS working configuration(s) available!${NC}"
    echo ""
    echo -e "${BLUE}🚀 RECOMMENDED FOR IMMEDIATE USE:${NC}"
    
    if [ -f "application-minimal.yml" ]; then
        echo "java -jar Lavalink.jar --spring.config.location=application-minimal.yml"
    elif [ -f "application-no-errors.yml" ]; then
        echo "java -jar Lavalink.jar --spring.config.location=application-no-errors.yml"
    elif [ -f "application-working.yml" ]; then
        echo "java -jar Lavalink.jar --spring.config.location=application-working.yml"
    fi
else
    echo -e "${RED}❌ ERROR: No valid configurations found!${NC}"
    echo ""
    echo -e "${YELLOW}🔧 SUGGESTED ACTIONS:${NC}"
    echo "1. Run ./fix-yaml-error.sh to generate working config"
    echo "2. Run ./fix-apple-music-error.sh for Apple Music issues"
    echo "3. Download fresh config from GitHub repository"
fi

echo ""

# Additional checks
echo -e "${BLUE}🔍 ADDITIONAL CHECKS:${NC}"
echo "===================="

# Check if Python is available
if command -v python3 &> /dev/null; then
    echo -e "Python 3: ${GREEN}✅ Available${NC}"
else
    echo -e "Python 3: ${RED}❌ Not found (needed for validation)${NC}"
fi

# Check if Java is available
if command -v java &> /dev/null; then
    java_version=$(java -version 2>&1 | head -n 1)
    echo -e "Java: ${GREEN}✅ Available${NC} ($java_version)"
else
    echo -e "Java: ${RED}❌ Not found (needed to run Lavalink)${NC}"
fi

# Check if Lavalink.jar exists
if [ -f "Lavalink.jar" ]; then
    echo -e "Lavalink.jar: ${GREEN}✅ Found${NC}"
elif [ -f "../Lavalink.jar" ]; then
    echo -e "Lavalink.jar: ${GREEN}✅ Found in parent directory${NC}"
else
    echo -e "Lavalink.jar: ${YELLOW}⚠️  Not found in current directory${NC}"
fi

# Check plugins directory
if [ -d "plugins" ]; then
    plugin_count=$(ls plugins/*.jar 2>/dev/null | wc -l)
    if [ $plugin_count -gt 0 ]; then
        echo -e "Plugins: ${GREEN}✅ Found $plugin_count plugin(s)${NC}"
    else
        echo -e "Plugins: ${YELLOW}⚠️  Directory exists but no .jar files${NC}"
    fi
elif [ -d "../plugins" ]; then
    plugin_count=$(ls ../plugins/*.jar 2>/dev/null | wc -l)
    if [ $plugin_count -gt 0 ]; then
        echo -e "Plugins: ${GREEN}✅ Found $plugin_count plugin(s) in parent directory${NC}"
    else
        echo -e "Plugins: ${YELLOW}⚠️  Directory exists but no .jar files${NC}"
    fi
else
    echo -e "Plugins: ${YELLOW}⚠️  Directory not found${NC}"
fi

echo ""
echo -e "${GREEN}🎯 VALIDATION COMPLETE!${NC}"

if [ $VALID_CONFIGS -gt 0 ]; then
    exit 0
else
    exit 1
fi