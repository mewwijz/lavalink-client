require('dotenv').config();

console.log("🔍 Debug Token Information:");
console.log("================================");

// Check if .env file exists
const fs = require('fs');
const envExists = fs.existsSync('.env');
console.log(`📁 .env file exists: ${envExists ? '✅ YES' : '❌ NO'}`);

if (!envExists) {
    console.log("❌ ERROR: .env file not found!");
    console.log("📝 Please create .env file from .env.template");
    console.log("💡 Run: cp .env.template .env");
    process.exit(1);
}

// Check environment variables
console.log(`🔑 DISCORD_TOKEN: ${process.env.DISCORD_TOKEN ? '✅ SET' : '❌ NOT SET'}`);
console.log(`🤖 BOT_CLIENT_ID: ${process.env.BOT_CLIENT_ID ? '✅ SET' : '❌ NOT SET'}`);
console.log(`🖥️  LAVALINK_HOST: ${process.env.LAVALINK_HOST || '❌ NOT SET'}`);
console.log(`🔌 LAVALINK_PORT: ${process.env.LAVALINK_PORT || '❌ NOT SET'}`);
console.log(`🔐 LAVALINK_PASSWORD: ${process.env.LAVALINK_PASSWORD ? '✅ SET' : '❌ NOT SET'}`);

// Validate token format
if (process.env.DISCORD_TOKEN) {
    const token = process.env.DISCORD_TOKEN;
    console.log(`📏 Token length: ${token.length} characters`);
    
    // Discord bot tokens should be around 59-70 characters
    if (token.length < 50) {
        console.log("⚠️  WARNING: Token seems too short");
    } else if (token.length > 80) {
        console.log("⚠️  WARNING: Token seems too long");
    } else {
        console.log("✅ Token length looks good");
    }
    
    // Check token format (should have dots)
    const parts = token.split('.');
    if (parts.length === 3) {
        console.log("✅ Token format looks correct (3 parts separated by dots)");
    } else {
        console.log("❌ Token format incorrect (should have 3 parts separated by dots)");
    }
    
    // Don't show the actual token for security
    console.log(`🔒 Token preview: ${token.substring(0, 10)}...${token.substring(token.length - 10)}`);
} else {
    console.log("❌ No token found in environment variables");
}

console.log("================================");
console.log("💡 Next steps:");
console.log("1. Make sure .env file exists");
console.log("2. Add your Discord bot token to DISCORD_TOKEN=");
console.log("3. Add your bot client ID to BOT_CLIENT_ID=");
console.log("4. Configure Lavalink settings");
console.log("5. Run: node music-player.js");