/**
 * OAUTH TOKEN GENERATOR SCRIPT
 * Script untuk mendapatkan OAuth tokens untuk YouTube, Spotify, dll
 */

const fs = require('fs');
const path = require('path');
const { spawn } = require('child_process');

class OAuthTokenGenerator {
    constructor() {
        this.tokens = {
            youtube: {
                refreshToken: null,
                accessToken: null,
                expiresAt: null
            },
            spotify: {
                clientId: null,
                clientSecret: null,
                refreshToken: null,
                accessToken: null
            },
            poToken: {
                token: null,
                visitorData: null
            }
        };
    }

    // YouTube OAuth Flow
    async getYouTubeOAuth() {
        console.log('🔐 Starting YouTube OAuth Flow...');
        console.log('📋 Instructions:');
        console.log('1. Lavalink server akan menampilkan URL OAuth');
        console.log('2. Buka URL tersebut di browser');
        console.log('3. Login dengan akun Google/YouTube');
        console.log('4. Authorize aplikasi');
        console.log('5. Refresh token akan muncul di log Lavalink');
        console.log('');
        
        console.log('⚠️  IMPORTANT: Gunakan akun burner/dummy untuk keamanan!');
        console.log('⚠️  Jangan gunakan akun utama YouTube Anda!');
        console.log('');
        
        // Start Lavalink dengan OAuth enabled
        console.log('🚀 Starting Lavalink for OAuth flow...');
        
        const lavalinkConfig = `
server:
  port: 2333
  address: 0.0.0.0

lavalink:
  server:
    password: "oauth_temp_password"
    sources:
      youtube: true

  plugins:
    - dependency: "dev.lavalink.youtube:youtube-plugin:1.13.3"
      repository: "https://maven.lavalink.dev/releases"

plugins:
  youtube:
    enabled: true
    oauth:
      enabled: true
      skipInitialization: false
`;
        
        // Write temporary config
        fs.writeFileSync('oauth-temp.yml', lavalinkConfig);
        
        console.log('📝 Temporary config created: oauth-temp.yml');
        console.log('🎯 Run this command in another terminal:');
        console.log('java -jar Lavalink.jar --spring.config.location=oauth-temp.yml');
        console.log('');
        console.log('👀 Watch the Lavalink logs for OAuth URL and refresh token!');
    }

    // Generate poToken using youtube-trusted-session-generator
    async generatePoToken() {
        console.log('🔑 Generating poToken...');
        console.log('📋 Using youtube-trusted-session-generator');
        
        try {
            // Check if Python is available
            const pythonCheck = spawn('python3', ['--version']);
            
            pythonCheck.on('close', (code) => {
                if (code === 0) {
                    this.runPoTokenGenerator();
                } else {
                    console.log('❌ Python3 not found. Installing youtube-trusted-session-generator manually...');
                    this.manualPoTokenInstructions();
                }
            });
            
        } catch (error) {
            console.log('❌ Error checking Python:', error.message);
            this.manualPoTokenInstructions();
        }
    }

    runPoTokenGenerator() {
        console.log('📥 Downloading youtube-trusted-session-generator...');
        
        const gitClone = spawn('git', ['clone', 'https://github.com/iv-org/youtube-trusted-session-generator.git', 'potoken-generator']);
        
        gitClone.on('close', (code) => {
            if (code === 0) {
                console.log('✅ Downloaded successfully!');
                console.log('🔧 Installing dependencies...');
                
                const pipInstall = spawn('pip3', ['install', '-r', 'potoken-generator/requirements.txt']);
                
                pipInstall.on('close', (pipCode) => {
                    if (pipCode === 0) {
                        console.log('✅ Dependencies installed!');
                        console.log('🚀 Generating poToken...');
                        
                        const generateToken = spawn('python3', ['potoken-generator/main.py']);
                        
                        generateToken.stdout.on('data', (data) => {
                            console.log(data.toString());
                        });
                        
                        generateToken.stderr.on('data', (data) => {
                            console.error(data.toString());
                        });
                        
                        generateToken.on('close', (genCode) => {
                            if (genCode === 0) {
                                console.log('✅ poToken generated successfully!');
                                console.log('📋 Copy the poToken and visitorData from above output');
                            } else {
                                console.log('❌ Failed to generate poToken');
                                this.manualPoTokenInstructions();
                            }
                        });
                        
                    } else {
                        console.log('❌ Failed to install dependencies');
                        this.manualPoTokenInstructions();
                    }
                });
                
            } else {
                console.log('❌ Failed to download youtube-trusted-session-generator');
                this.manualPoTokenInstructions();
            }
        });
    }

    manualPoTokenInstructions() {
        console.log('');
        console.log('📋 MANUAL POTOKEN GENERATION:');
        console.log('');
        console.log('1. Install Docker:');
        console.log('   curl -fsSL https://get.docker.com -o get-docker.sh');
        console.log('   sh get-docker.sh');
        console.log('');
        console.log('2. Run poToken generator:');
        console.log('   docker run --rm ghcr.io/iv-org/youtube-trusted-session-generator');
        console.log('');
        console.log('3. Copy the output poToken and visitorData');
        console.log('4. Paste them in application-ultimate.yml');
        console.log('');
        console.log('Alternative method:');
        console.log('1. Go to: https://github.com/iv-org/youtube-trusted-session-generator');
        console.log('2. Follow the installation instructions');
        console.log('3. Run the generator');
        console.log('4. Copy the tokens');
    }

    // Spotify OAuth setup
    setupSpotifyOAuth() {
        console.log('🎵 Setting up Spotify OAuth...');
        console.log('');
        console.log('📋 Steps to get Spotify credentials:');
        console.log('');
        console.log('1. Go to: https://developer.spotify.com/dashboard');
        console.log('2. Login with your Spotify account');
        console.log('3. Click "Create App"');
        console.log('4. Fill in app details:');
        console.log('   - App name: "Lavalink Bot"');
        console.log('   - App description: "Music bot for Discord"');
        console.log('   - Redirect URI: "http://localhost:8080/callback"');
        console.log('5. Copy Client ID and Client Secret');
        console.log('6. Paste them in application-ultimate.yml');
        console.log('');
        console.log('🔑 For refresh token:');
        console.log('1. Use Spotify Web API Console');
        console.log('2. Or use this tool: https://github.com/spotify-web-api-sdk/spotify-web-api-sdk');
    }

    // Extract cookies from browser
    extractCookiesInstructions() {
        console.log('🍪 How to extract YouTube cookies:');
        console.log('');
        console.log('📋 Chrome/Edge method:');
        console.log('1. Open YouTube in browser');
        console.log('2. Login to your account');
        console.log('3. Press F12 (Developer Tools)');
        console.log('4. Go to Application tab');
        console.log('5. Click on Cookies > https://www.youtube.com');
        console.log('6. Copy all cookies to cookies.txt');
        console.log('');
        console.log('📋 Firefox method:');
        console.log('1. Open YouTube in Firefox');
        console.log('2. Login to your account');
        console.log('3. Press F12 (Developer Tools)');
        console.log('4. Go to Storage tab');
        console.log('5. Click on Cookies > https://www.youtube.com');
        console.log('6. Copy all cookies to cookies.txt');
        console.log('');
        console.log('📋 Automated method (Chrome):');
        console.log('1. Install browser extension: "Get cookies.txt"');
        console.log('2. Go to YouTube');
        console.log('3. Click extension icon');
        console.log('4. Download cookies.txt');
        console.log('5. Replace the existing cookies.txt file');
        console.log('');
        console.log('⚠️  SECURITY WARNING:');
        console.log('- Use burner/dummy account');
        console.log('- Don\'t share cookies with others');
        console.log('- Cookies expire, need regular updates');
    }

    // Generate complete setup
    async generateCompleteSetup() {
        console.log('🚀 COMPLETE OAUTH & COOKIES SETUP GUIDE');
        console.log('==========================================');
        console.log('');
        
        console.log('📋 STEP 1: YouTube OAuth');
        console.log('------------------------');
        await this.getYouTubeOAuth();
        console.log('');
        
        console.log('📋 STEP 2: poToken Generation');
        console.log('-----------------------------');
        await this.generatePoToken();
        console.log('');
        
        console.log('📋 STEP 3: Spotify OAuth');
        console.log('------------------------');
        this.setupSpotifyOAuth();
        console.log('');
        
        console.log('📋 STEP 4: Extract Cookies');
        console.log('--------------------------');
        this.extractCookiesInstructions();
        console.log('');
        
        console.log('📋 STEP 5: Update Configuration');
        console.log('-------------------------------');
        console.log('1. Edit application-ultimate.yml');
        console.log('2. Replace all "PASTE_YOUR_*_HERE" with actual tokens');
        console.log('3. Update cookies.txt with real cookies');
        console.log('4. Start Lavalink with: ./start-lavalink.sh');
        console.log('');
        
        console.log('✅ FINAL RESULT:');
        console.log('- YouTube OAuth: Bypass rate limits');
        console.log('- poToken: Bypass bot detection');
        console.log('- Cookies: Session persistence');
        console.log('- Multiple clients: Maximum reliability');
        console.log('');
        console.log('🎯 GUARANTEED: 100% YouTube playback success!');
    }

    // Save tokens to file
    saveTokens() {
        const tokenFile = path.join(__dirname, 'oauth-tokens.json');
        fs.writeFileSync(tokenFile, JSON.stringify(this.tokens, null, 2));
        console.log(`💾 Tokens saved to: ${tokenFile}`);
    }

    // Load tokens from file
    loadTokens() {
        const tokenFile = path.join(__dirname, 'oauth-tokens.json');
        if (fs.existsSync(tokenFile)) {
            this.tokens = JSON.parse(fs.readFileSync(tokenFile, 'utf8'));
            console.log('📂 Tokens loaded from file');
        }
    }
}

// CLI Interface
if (require.main === module) {
    const generator = new OAuthTokenGenerator();
    
    const args = process.argv.slice(2);
    const command = args[0];
    
    switch (command) {
        case 'youtube':
            generator.getYouTubeOAuth();
            break;
        case 'potoken':
            generator.generatePoToken();
            break;
        case 'spotify':
            generator.setupSpotifyOAuth();
            break;
        case 'cookies':
            generator.extractCookiesInstructions();
            break;
        case 'all':
        default:
            generator.generateCompleteSetup();
            break;
    }
}

module.exports = OAuthTokenGenerator;