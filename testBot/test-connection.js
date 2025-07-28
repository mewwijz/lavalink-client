const { Client, GatewayIntentBits } = require("discord.js");
const { LavalinkManager } = require("lavalink-client");

// Test connection to Discord and Lavalink
const client = new Client({
    intents: [
        GatewayIntentBits.Guilds,
        GatewayIntentBits.GuildVoiceStates,
    ]
});

const lavalink = new LavalinkManager({
    nodes: [
        {
            authorization: "YOUR_LAVALINK_PASSWORD",
            host: "YOUR_LAVALINK_HOST",
            port: 2333,
            id: "testnode",
            secure: false,
        }
    ],
    sendToShard: (guildId, payload) => client.guilds.cache.get(guildId)?.shard?.send(payload),
    client: {
        id: "YOUR_BOT_CLIENT_ID",
        username: "TESTBOT",
    },
});

client.lavalink = lavalink;

// Event listeners for testing
client.on("ready", () => {
    console.log("✅ Discord Bot connected successfully!");
    console.log(`Bot: ${client.user.tag}`);
    console.log(`Guilds: ${client.guilds.cache.size}`);
    
    // Initialize lavalink
    client.lavalink.init(client.user);
});

client.lavalink.nodeManager.on("connect", (node) => {
    console.log("✅ Lavalink Node connected successfully!");
    console.log(`Node ID: ${node.id}`);
    console.log(`Node Host: ${node.options.host}:${node.options.port}`);
});

client.lavalink.nodeManager.on("disconnect", (node, reason) => {
    console.log("❌ Lavalink Node disconnected:", reason);
});

client.lavalink.nodeManager.on("error", (node, error) => {
    console.log("❌ Lavalink Node error:", error.message);
});

client.on("raw", d => client.lavalink.sendRawData(d));

// Test search functionality
setTimeout(async () => {
    try {
        console.log("\n🔍 Testing YouTube search...");
        
        // Create a test player for search
        const testPlayer = client.lavalink.createPlayer({
            guildId: "test",
            voiceChannelId: "test",
            textChannelId: "test",
            selfDeaf: true,
            selfMute: false,
        });
        
        // Test multiple sources
        const sources = ["ytsearch", "scsearch"];
        
        for (const source of sources) {
            console.log(`\n🔍 Testing ${source}...`);
            const results = await testPlayer.search({
                query: "never gonna give you up",
                source: source
            }, client.user);
            
            console.log(`Load type: ${results.loadType}`);
            console.log(`Tracks found: ${results.tracks ? results.tracks.length : 0}`);
            
            if (results.tracks && results.tracks.length > 0) {
                console.log(`✅ ${source} working!`);
                console.log(`Found: ${results.tracks[0].info.title} by ${results.tracks[0].info.author}`);
                console.log(`Duration: ${Math.floor(results.tracks[0].info.duration / 1000)}s`);
                break;
            } else {
                console.log(`❌ No tracks found for ${source}`);
                if (results.exception) {
                    console.log(`Exception: ${results.exception.message}`);
                }
            }
        }
        
        // Clean up test player
        testPlayer.destroy();
        
    } catch (error) {
        console.log("❌ Search error:", error.message);
    }
    
    // Exit after test
    setTimeout(() => {
        console.log("\n✅ All tests completed!");
        process.exit(0);
    }, 2000);
}, 5000);

// Login
client.login(process.env.DISCORD_TOKEN);