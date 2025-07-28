#!/usr/bin/env node

/**
 * YOUTUBE OAUTH TOKEN GENERATOR
 * Automated script to help generate YouTube OAuth tokens for Lavalink
 */

const https = require('https');
const http = require('http');
const url = require('url');
const querystring = require('querystring');

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
║                 YOUTUBE OAUTH TOKEN GENERATOR                ║
║              For Lavalink YouTube Plugin v1.13.3            ║
╚══════════════════════════════════════════════════════════════╝
${colors.reset}`);

// Configuration
const OAUTH_CONFIG = {
    // Google OAuth 2.0 endpoints
    authUrl: 'https://accounts.google.com/o/oauth2/v2/auth',
    tokenUrl: 'https://oauth2.googleapis.com/token',
    
    // Required scopes for YouTube Data API
    scopes: [
        'https://www.googleapis.com/auth/youtube',
        'https://www.googleapis.com/auth/youtube.readonly'
    ],
    
    // Local server for OAuth callback
    redirectUri: 'http://localhost:8080/callback',
    port: 8080
};

class YouTubeOAuthGenerator {
    constructor() {
        this.clientId = null;
        this.clientSecret = null;
        this.server = null;
    }

    async start() {
        console.log(`${colors.yellow}🔑 YOUTUBE OAUTH TOKEN GENERATOR${colors.reset}\n`);
        
        // Step 1: Get client credentials
        await this.getClientCredentials();
        
        // Step 2: Start local server for callback
        await this.startCallbackServer();
        
        // Step 3: Generate authorization URL
        const authUrl = this.generateAuthUrl();
        
        // Step 4: Display instructions
        this.displayInstructions(authUrl);
    }

    async getClientCredentials() {
        console.log(`${colors.blue}📋 STEP 1: CLIENT CREDENTIALS${colors.reset}`);
        console.log('You need OAuth 2.0 credentials from Google Cloud Console.\n');
        
        console.log(`${colors.yellow}How to get credentials:${colors.reset}`);
        console.log('1. Go to: https://console.cloud.google.com/');
        console.log('2. Create new project or select existing one');
        console.log('3. Enable "YouTube Data API v3"');
        console.log('4. Go to "Credentials" → "Create Credentials" → "OAuth 2.0 Client IDs"');
        console.log('5. Application type: "Desktop application"');
        console.log('6. Download JSON file or copy Client ID and Client Secret\n');
        
        // For demo purposes, we'll use placeholder values
        // In real implementation, you'd prompt for user input
        console.log(`${colors.red}⚠️  DEMO MODE: Using placeholder credentials${colors.reset}`);
        console.log(`${colors.yellow}Replace these with your actual credentials:${colors.reset}\n`);
        
        this.clientId = 'YOUR_CLIENT_ID_HERE.apps.googleusercontent.com';
        this.clientSecret = 'YOUR_CLIENT_SECRET_HERE';
        
        console.log(`Client ID: ${colors.green}${this.clientId}${colors.reset}`);
        console.log(`Client Secret: ${colors.green}${this.clientSecret.replace(/./g, '*')}${colors.reset}\n`);
    }

    async startCallbackServer() {
        return new Promise((resolve) => {
            this.server = http.createServer((req, res) => {
                const parsedUrl = url.parse(req.url, true);
                
                if (parsedUrl.pathname === '/callback') {
                    const code = parsedUrl.query.code;
                    const error = parsedUrl.query.error;
                    
                    if (error) {
                        res.writeHead(400, {'Content-Type': 'text/html'});
                        res.end(`
                            <html>
                                <body style="font-family: Arial, sans-serif; text-align: center; padding: 50px;">
                                    <h1 style="color: red;">❌ Authorization Failed</h1>
                                    <p>Error: ${error}</p>
                                    <p>Please try again or check your credentials.</p>
                                </body>
                            </html>
                        `);
                        return;
                    }
                    
                    if (code) {
                        res.writeHead(200, {'Content-Type': 'text/html'});
                        res.end(`
                            <html>
                                <body style="font-family: Arial, sans-serif; text-align: center; padding: 50px;">
                                    <h1 style="color: green;">✅ Authorization Successful!</h1>
                                    <p>Authorization code received. Check your terminal for tokens.</p>
                                    <p>You can close this window now.</p>
                                </body>
                            </html>
                        `);
                        
                        // Exchange code for tokens
                        this.exchangeCodeForTokens(code);
                    }
                }
            });
            
            this.server.listen(OAUTH_CONFIG.port, () => {
                console.log(`${colors.green}🌐 Callback server started on port ${OAUTH_CONFIG.port}${colors.reset}\n`);
                resolve();
            });
        });
    }

    generateAuthUrl() {
        const params = {
            client_id: this.clientId,
            redirect_uri: OAUTH_CONFIG.redirectUri,
            scope: OAUTH_CONFIG.scopes.join(' '),
            response_type: 'code',
            access_type: 'offline',
            prompt: 'consent'
        };
        
        return `${OAUTH_CONFIG.authUrl}?${querystring.stringify(params)}`;
    }

    displayInstructions(authUrl) {
        console.log(`${colors.blue}📋 STEP 2: AUTHORIZATION${colors.reset}`);
        console.log('Click the link below to authorize your application:\n');
        
        console.log(`${colors.cyan}🔗 Authorization URL:${colors.reset}`);
        console.log(`${colors.yellow}${authUrl}${colors.reset}\n`);
        
        console.log(`${colors.green}📝 Instructions:${colors.reset}`);
        console.log('1. Click the authorization URL above');
        console.log('2. Sign in with your Google account');
        console.log('3. Grant permissions to your application');
        console.log('4. You will be redirected back to localhost');
        console.log('5. Tokens will be displayed in this terminal\n');
        
        console.log(`${colors.yellow}⏳ Waiting for authorization...${colors.reset}`);
        console.log(`${colors.magenta}Press Ctrl+C to cancel${colors.reset}\n`);
    }

    async exchangeCodeForTokens(code) {
        console.log(`${colors.blue}📋 STEP 3: EXCHANGING CODE FOR TOKENS${colors.reset}\n`);
        
        const postData = querystring.stringify({
            client_id: this.clientId,
            client_secret: this.clientSecret,
            code: code,
            grant_type: 'authorization_code',
            redirect_uri: OAUTH_CONFIG.redirectUri
        });
        
        const options = {
            hostname: 'oauth2.googleapis.com',
            port: 443,
            path: '/token',
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
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
                    const tokens = JSON.parse(data);
                    this.displayTokens(tokens);
                } catch (error) {
                    console.log(`${colors.red}❌ Error parsing token response:${colors.reset}`);
                    console.log(data);
                }
                
                // Close server
                this.server.close();
            });
        });
        
        req.on('error', (error) => {
            console.log(`${colors.red}❌ Error exchanging code for tokens:${colors.reset}`);
            console.log(error.message);
            this.server.close();
        });
        
        req.write(postData);
        req.end();
    }

    displayTokens(tokens) {
        console.log(`${colors.green}🎉 SUCCESS! TOKENS GENERATED${colors.reset}\n`);
        
        if (tokens.error) {
            console.log(`${colors.red}❌ Error: ${tokens.error}${colors.reset}`);
            console.log(`${colors.red}Description: ${tokens.error_description}${colors.reset}\n`);
            return;
        }
        
        console.log(`${colors.cyan}╔══════════════════════════════════════════════════════════════╗${colors.reset}`);
        console.log(`${colors.cyan}║                        YOUR TOKENS                          ║${colors.reset}`);
        console.log(`${colors.cyan}╚══════════════════════════════════════════════════════════════╝${colors.reset}\n`);
        
        if (tokens.refresh_token) {
            console.log(`${colors.yellow}🔑 REFRESH TOKEN (MOST IMPORTANT):${colors.reset}`);
            console.log(`${colors.green}${tokens.refresh_token}${colors.reset}\n`);
        }
        
        if (tokens.access_token) {
            console.log(`${colors.yellow}🎫 ACCESS TOKEN (OPTIONAL):${colors.reset}`);
            console.log(`${colors.green}${tokens.access_token}${colors.reset}\n`);
        }
        
        console.log(`${colors.blue}📋 TOKEN INFORMATION:${colors.reset}`);
        console.log(`Token Type: ${tokens.token_type || 'Bearer'}`);
        console.log(`Expires In: ${tokens.expires_in || 3600} seconds`);
        console.log(`Scope: ${tokens.scope || OAUTH_CONFIG.scopes.join(' ')}\n`);
        
        this.displayYamlConfiguration(tokens);
    }

    displayYamlConfiguration(tokens) {
        console.log(`${colors.cyan}╔══════════════════════════════════════════════════════════════╗${colors.reset}`);
        console.log(`${colors.cyan}║                   LAVALINK CONFIGURATION                    ║${colors.reset}`);
        console.log(`${colors.cyan}╚══════════════════════════════════════════════════════════════╝${colors.reset}\n`);
        
        console.log(`${colors.yellow}📝 Add this to your application.yml:${colors.reset}\n`);
        
        console.log(`${colors.green}plugins:
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
      skipInitialization: false${colors.reset}`);
        
        if (tokens.refresh_token) {
            console.log(`${colors.green}      refreshToken: "${tokens.refresh_token}"${colors.reset}`);
        }
        
        if (tokens.access_token) {
            console.log(`${colors.green}      accessToken: "${tokens.access_token}"${colors.reset}`);
        }
        
        console.log(`${colors.green}      forceRefresh: true
      retryOnFailure: true${colors.reset}\n`);
        
        console.log(`${colors.blue}🎯 NEXT STEPS:${colors.reset}`);
        console.log('1. Copy the refresh token to your Lavalink configuration');
        console.log('2. Restart your Lavalink server');
        console.log('3. Check logs for "OAuth initialized successfully"');
        console.log('4. Enjoy unlimited YouTube API access!\n');
        
        console.log(`${colors.yellow}⚠️  SECURITY NOTES:${colors.reset}`);
        console.log('• Store tokens securely (use environment variables in production)');
        console.log('• Use dedicated Google account for bot (not personal account)');
        console.log('• Rotate tokens regularly (every 3-6 months)');
        console.log('• Monitor usage in Google Cloud Console\n');
        
        console.log(`${colors.green}✅ OAuth token generation complete!${colors.reset}`);
    }
}

// Handle graceful shutdown
process.on('SIGINT', () => {
    console.log(`\n${colors.yellow}👋 Shutting down OAuth generator...${colors.reset}`);
    process.exit(0);
});

// Start the OAuth generator
const generator = new YouTubeOAuthGenerator();
generator.start().catch(error => {
    console.log(`${colors.red}❌ Error starting OAuth generator:${colors.reset}`);
    console.log(error.message);
    process.exit(1);
});

// Export for use as module
module.exports = YouTubeOAuthGenerator;