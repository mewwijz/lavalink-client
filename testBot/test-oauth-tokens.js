#!/usr/bin/env node

/**
 * YOUTUBE OAUTH TOKEN TESTER
 * Test and validate YouTube OAuth tokens for Lavalink
 */

const https = require('https');
const fs = require('fs');
const yaml = require('js-yaml');

// Colors for console output
const colors = {
    reset: '\x1b[0m',
    red: '\x1b[31m',
    green: '\x1b[32m',
    yellow: '\x1b[33m',
    blue: '\x1b[34m',
    magenta: '\x1b[35m',
    cyan: '\x1b[36m'
};

console.log(`${colors.cyan}
╔══════════════════════════════════════════════════════════════╗
║                 YOUTUBE OAUTH TOKEN TESTER                  ║
║              Validate tokens before using in Lavalink       ║
╚══════════════════════════════════════════════════════════════╝
${colors.reset}`);

class YouTubeOAuthTester {
    constructor() {
        this.config = null;
        this.tokens = {
            refreshToken: null,
            accessToken: null
        };
    }

    async start() {
        console.log(`${colors.yellow}🧪 YOUTUBE OAUTH TOKEN TESTER${colors.reset}\n`);
        
        // Step 1: Load configuration
        await this.loadConfiguration();
        
        // Step 2: Extract tokens
        this.extractTokens();
        
        // Step 3: Test tokens
        await this.testTokens();
        
        // Step 4: Test YouTube API access
        await this.testYouTubeAPI();
        
        // Step 5: Display results
        this.displayResults();
    }

    async loadConfiguration() {
        console.log(`${colors.blue}📋 STEP 1: LOADING CONFIGURATION${colors.reset}`);
        
        const configFiles = [
            'application.yml',
            'application-with-oauth-tokens.yml',
            'application-oauth.yml'
        ];
        
        let configFound = false;
        
        for (const file of configFiles) {
            if (fs.existsSync(file)) {
                console.log(`${colors.green}✅ Found config file: ${file}${colors.reset}`);
                
                try {
                    const configContent = fs.readFileSync(file, 'utf8');
                    this.config = yaml.load(configContent);
                    configFound = true;
                    break;
                } catch (error) {
                    console.log(`${colors.red}❌ Error reading ${file}: ${error.message}${colors.reset}`);
                }
            }
        }
        
        if (!configFound) {
            console.log(`${colors.red}❌ No configuration file found!${colors.reset}`);
            console.log(`${colors.yellow}Expected files: ${configFiles.join(', ')}${colors.reset}\n`);
            process.exit(1);
        }
        
        console.log(`${colors.green}✅ Configuration loaded successfully${colors.reset}\n`);
    }

    extractTokens() {
        console.log(`${colors.blue}📋 STEP 2: EXTRACTING TOKENS${colors.reset}`);
        
        try {
            const youtubeConfig = this.config?.plugins?.youtube;
            
            if (!youtubeConfig) {
                throw new Error('YouTube plugin configuration not found');
            }
            
            const oauthConfig = youtubeConfig.oauth;
            
            if (!oauthConfig) {
                throw new Error('OAuth configuration not found');
            }
            
            if (!oauthConfig.enabled) {
                throw new Error('OAuth is disabled in configuration');
            }
            
            this.tokens.refreshToken = oauthConfig.refreshToken;
            this.tokens.accessToken = oauthConfig.accessToken;
            
            console.log(`${colors.green}✅ OAuth enabled: ${oauthConfig.enabled}${colors.reset}`);
            console.log(`${colors.green}✅ Skip initialization: ${oauthConfig.skipInitialization || false}${colors.reset}`);
            
            if (this.tokens.refreshToken) {
                const maskedRefresh = this.tokens.refreshToken.substring(0, 10) + '...' + this.tokens.refreshToken.substring(this.tokens.refreshToken.length - 10);
                console.log(`${colors.green}✅ Refresh token found: ${maskedRefresh}${colors.reset}`);
            } else {
                console.log(`${colors.yellow}⚠️  No refresh token found${colors.reset}`);
            }
            
            if (this.tokens.accessToken) {
                const maskedAccess = this.tokens.accessToken.substring(0, 10) + '...' + this.tokens.accessToken.substring(this.tokens.accessToken.length - 10);
                console.log(`${colors.green}✅ Access token found: ${maskedAccess}${colors.reset}`);
            } else {
                console.log(`${colors.yellow}⚠️  No access token found${colors.reset}`);
            }
            
        } catch (error) {
            console.log(`${colors.red}❌ Error extracting tokens: ${error.message}${colors.reset}`);
            process.exit(1);
        }
        
        console.log('');
    }

    async testTokens() {
        console.log(`${colors.blue}📋 STEP 3: TESTING TOKENS${colors.reset}`);
        
        // Test refresh token format
        if (this.tokens.refreshToken) {
            await this.testRefreshToken();
        }
        
        // Test access token format
        if (this.tokens.accessToken) {
            await this.testAccessToken();
        }
        
        console.log('');
    }

    async testRefreshToken() {
        console.log(`${colors.yellow}🔍 Testing refresh token...${colors.reset}`);
        
        // Check format
        if (!this.tokens.refreshToken.startsWith('1//04')) {
            console.log(`${colors.red}❌ Invalid refresh token format (should start with '1//04')${colors.reset}`);
            return;
        }
        
        console.log(`${colors.green}✅ Refresh token format is valid${colors.reset}`);
        
        // Test token by trying to refresh
        try {
            const newAccessToken = await this.refreshAccessToken();
            if (newAccessToken) {
                console.log(`${colors.green}✅ Refresh token is working (generated new access token)${colors.reset}`);
                this.tokens.accessToken = newAccessToken;
            }
        } catch (error) {
            console.log(`${colors.red}❌ Refresh token test failed: ${error.message}${colors.reset}`);
        }
    }

    async testAccessToken() {
        console.log(`${colors.yellow}🔍 Testing access token...${colors.reset}`);
        
        // Check format
        if (!this.tokens.accessToken.startsWith('ya29.')) {
            console.log(`${colors.red}❌ Invalid access token format (should start with 'ya29.')${colors.reset}`);
            return;
        }
        
        console.log(`${colors.green}✅ Access token format is valid${colors.reset}`);
        
        // Test token by making API call
        try {
            const isValid = await this.validateAccessToken();
            if (isValid) {
                console.log(`${colors.green}✅ Access token is valid and working${colors.reset}`);
            } else {
                console.log(`${colors.red}❌ Access token is invalid or expired${colors.reset}`);
            }
        } catch (error) {
            console.log(`${colors.red}❌ Access token test failed: ${error.message}${colors.reset}`);
        }
    }

    async refreshAccessToken() {
        return new Promise((resolve, reject) => {
            const postData = JSON.stringify({
                client_id: 'YOUR_CLIENT_ID_HERE',  // This would need to be configured
                client_secret: 'YOUR_CLIENT_SECRET_HERE',  // This would need to be configured
                refresh_token: this.tokens.refreshToken,
                grant_type: 'refresh_token'
            });
            
            const options = {
                hostname: 'oauth2.googleapis.com',
                port: 443,
                path: '/token',
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Content-Length': Buffer.byteLength(postData)
                }
            };
            
            const req = https.request(options, (res) => {
                let data = '';
                
                res.on('data', (chunk) => {
                    data += chunk;
                });
                
                res.on('end', () => {
                    try {
                        const response = JSON.parse(data);
                        if (response.access_token) {
                            resolve(response.access_token);
                        } else {
                            reject(new Error(response.error_description || 'Failed to refresh token'));
                        }
                    } catch (error) {
                        reject(new Error('Invalid response from token endpoint'));
                    }
                });
            });
            
            req.on('error', (error) => {
                reject(error);
            });
            
            req.write(postData);
            req.end();
        });
    }

    async validateAccessToken() {
        return new Promise((resolve, reject) => {
            const options = {
                hostname: 'www.googleapis.com',
                port: 443,
                path: '/oauth2/v1/tokeninfo?access_token=' + encodeURIComponent(this.tokens.accessToken),
                method: 'GET'
            };
            
            const req = https.request(options, (res) => {
                let data = '';
                
                res.on('data', (chunk) => {
                    data += chunk;
                });
                
                res.on('end', () => {
                    try {
                        const response = JSON.parse(data);
                        if (response.error) {
                            resolve(false);
                        } else {
                            resolve(true);
                        }
                    } catch (error) {
                        reject(error);
                    }
                });
            });
            
            req.on('error', (error) => {
                reject(error);
            });
            
            req.end();
        });
    }

    async testYouTubeAPI() {
        console.log(`${colors.blue}📋 STEP 4: TESTING YOUTUBE API ACCESS${colors.reset}`);
        
        if (!this.tokens.accessToken) {
            console.log(`${colors.yellow}⚠️  No access token available for API testing${colors.reset}`);
            return;
        }
        
        try {
            const apiResponse = await this.testYouTubeSearch();
            if (apiResponse) {
                console.log(`${colors.green}✅ YouTube API access is working${colors.reset}`);
                console.log(`${colors.green}✅ Search returned ${apiResponse.items?.length || 0} results${colors.reset}`);
            }
        } catch (error) {
            console.log(`${colors.red}❌ YouTube API test failed: ${error.message}${colors.reset}`);
        }
        
        console.log('');
    }

    async testYouTubeSearch() {
        return new Promise((resolve, reject) => {
            const options = {
                hostname: 'www.googleapis.com',
                port: 443,
                path: '/youtube/v3/search?part=snippet&q=test&type=video&maxResults=1',
                method: 'GET',
                headers: {
                    'Authorization': `Bearer ${this.tokens.accessToken}`
                }
            };
            
            const req = https.request(options, (res) => {
                let data = '';
                
                res.on('data', (chunk) => {
                    data += chunk;
                });
                
                res.on('end', () => {
                    try {
                        const response = JSON.parse(data);
                        if (response.error) {
                            reject(new Error(response.error.message));
                        } else {
                            resolve(response);
                        }
                    } catch (error) {
                        reject(error);
                    }
                });
            });
            
            req.on('error', (error) => {
                reject(error);
            });
            
            req.end();
        });
    }

    displayResults() {
        console.log(`${colors.cyan}╔══════════════════════════════════════════════════════════════╗${colors.reset}`);
        console.log(`${colors.cyan}║                        TEST RESULTS                         ║${colors.reset}`);
        console.log(`${colors.cyan}╚══════════════════════════════════════════════════════════════╝${colors.reset}\n`);
        
        console.log(`${colors.blue}📊 OAUTH CONFIGURATION STATUS:${colors.reset}`);
        
        // Configuration status
        const oauthEnabled = this.config?.plugins?.youtube?.oauth?.enabled;
        console.log(`OAuth Enabled: ${oauthEnabled ? colors.green + '✅ Yes' : colors.red + '❌ No'}${colors.reset}`);
        
        // Token status
        const hasRefreshToken = !!this.tokens.refreshToken;
        const hasAccessToken = !!this.tokens.accessToken;
        
        console.log(`Refresh Token: ${hasRefreshToken ? colors.green + '✅ Present' : colors.red + '❌ Missing'}${colors.reset}`);
        console.log(`Access Token: ${hasAccessToken ? colors.green + '✅ Present' : colors.yellow + '⚠️  Missing (will be auto-generated)'}${colors.reset}`);
        
        console.log(`\n${colors.blue}🎯 RECOMMENDATIONS:${colors.reset}`);
        
        if (!oauthEnabled) {
            console.log(`${colors.red}• Enable OAuth in your configuration${colors.reset}`);
        }
        
        if (!hasRefreshToken) {
            console.log(`${colors.red}• Add refresh token to your configuration${colors.reset}`);
            console.log(`${colors.yellow}  Run: node generate-oauth-tokens.js${colors.reset}`);
        }
        
        if (hasRefreshToken && oauthEnabled) {
            console.log(`${colors.green}• Your OAuth configuration looks good!${colors.reset}`);
            console.log(`${colors.green}• Lavalink should start without rate limits${colors.reset}`);
        }
        
        console.log(`\n${colors.blue}🚀 NEXT STEPS:${colors.reset}`);
        console.log('1. Fix any issues mentioned above');
        console.log('2. Restart your Lavalink server');
        console.log('3. Check logs for "OAuth initialized successfully"');
        console.log('4. Monitor for rate limit errors (should be none)\n');
        
        console.log(`${colors.green}✅ OAuth token testing complete!${colors.reset}`);
    }
}

// Handle graceful shutdown
process.on('SIGINT', () => {
    console.log(`\n${colors.yellow}👋 Shutting down token tester...${colors.reset}`);
    process.exit(0);
});

// Check if js-yaml is available
try {
    require('js-yaml');
} catch (error) {
    console.log(`${colors.red}❌ Missing dependency: js-yaml${colors.reset}`);
    console.log(`${colors.yellow}Install with: npm install js-yaml${colors.reset}\n`);
    process.exit(1);
}

// Start the token tester
const tester = new YouTubeOAuthTester();
tester.start().catch(error => {
    console.log(`${colors.red}❌ Error running token tester:${colors.reset}`);
    console.log(error.message);
    process.exit(1);
});

// Export for use as module
module.exports = YouTubeOAuthTester;