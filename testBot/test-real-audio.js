const { Client, GatewayIntentBits } = require("discord.js");
const { LavalinkManager } = require("lavalink-client");

const client = new Client({
    intents: [
        GatewayIntentBits.Guilds,
        GatewayIntentBits.GuildVoiceStates,
        GatewayIntentBits.GuildMessages,
        GatewayIntentBits.MessageContent
    ]
});

const lavalink = new LavalinkManager({
    nodes: [{
        authorization: "YOUR_LAVALINK_PASSWORD",
        host: "YOUR_LAVALINK_HOST",
        port: 2333,
        id: "testnode",
        secure: false,
    }],
    sendToShard: (guildId, payload) => client.guilds.cache.get(guildId)?.shard?.send(payload),
    client: { id: "YOUR_BOT_CLIENT_ID", username: "EICHIRO" },
    autoSkip: true,
    playerOptions: {
        defaultSearchPlatform: "scsearch", // Gunakan SoundCloud karena sudah terbukti working
        volumeDecrementer: 1.0, // Volume penuh
    }
});

client.lavalink = lavalink;

client.on("ready", () => {
    console.log(`✅ Bot ${client.user.tag} is ready!`);
    console.log(`📊 Connected to ${client.guilds.cache.size} guilds`);
    
    // List all guilds and voice channels
    client.guilds.cache.forEach(guild => {
        console.log(`🏠 Guild: ${guild.name} (${guild.id})`);
        const voiceChannels = guild.channels.cache.filter(c => c.type === 2); // Voice channels
        voiceChannels.forEach(vc => {
            console.log(`  🔊 Voice Channel: ${vc.name} (${vc.id}) - Members: ${vc.members.size}`);
        });
    });
    
    client.lavalink.init(client.user);
});

client.lavalink.nodeManager.on("connect", (node) => {
    console.log(`✅ Lavalink Node ${node.id} connected!`);
    console.log(`🌐 Connected to: ${node.options.host}:${node.options.port}`);
});

// Event ketika track mulai dimainkan
client.lavalink.on("trackStart", (player, track) => {
    console.log(`🎵 NOW PLAYING: ${track.info.title} by ${track.info.author}`);
    console.log(`📍 In guild: ${player.guildId}`);
    console.log(`🔊 Voice channel: ${player.voiceChannelId}`);
    console.log(`⏱️ Duration: ${Math.floor(track.info.duration / 1000)}s`);
    console.log(`🎚️ Volume: ${player.volume}%`);
});

// Event ketika player terhubung ke voice channel
client.lavalink.on("playerCreate", (player) => {
    console.log(`🎤 Player created for guild: ${player.guildId}`);
});

// Event ketika ada error
client.lavalink.on("trackError", (player, track, payload) => {
    console.log(`❌ Track error: ${payload.exception?.message}`);
});

client.lavalink.on("trackStuck", (player, track, payload) => {
    console.log(`⚠️ Track stuck: ${track.info.title}`);
});

// Message handler untuk command manual
client.on("messageCreate", async (message) => {
    if (message.author.bot) return;
    if (!message.content.startsWith("!")) return;
    
    const args = message.content.slice(1).split(" ");
    const command = args.shift().toLowerCase();
    
    if (command === "play") {
        const query = args.join(" ");
        if (!query) {
            return message.reply("❌ Please provide a song name!");
        }
        
        const member = message.member;
        if (!member?.voice?.channelId) {
            return message.reply("❌ You need to be in a voice channel!");
        }
        
        try {
            console.log(`🎯 Attempting to play: "${query}"`);
            console.log(`👤 Requested by: ${message.author.tag}`);
            console.log(`🔊 Voice channel: ${member.voice.channel.name} (${member.voice.channelId})`);
            
            // Create or get player
            let player = client.lavalink.getPlayer(message.guildId);
            if (!player) {
                player = await client.lavalink.createPlayer({
                    guildId: message.guildId,
                    voiceChannelId: member.voice.channelId,
                    textChannelId: message.channelId,
                    selfDeaf: true,
                    selfMute: false,
                    volume: 100
                });
                console.log(`🎤 Created new player for guild: ${message.guildId}`);
            }
            
            // Connect to voice channel
            if (!player.connected) {
                await player.connect();
                console.log(`🔗 Connected to voice channel: ${member.voice.channel.name}`);
            }
            
            // Search for the song - try multiple sources
            const sources = ["scsearch", "ytsearch"];
            let results = null;
            
            for (const source of sources) {
                console.log(`🔍 Searching with ${source}: "${query}"`);
                try {
                    results = await player.search({
                        query: query,
                        source: source
                    }, message.author);
                    
                    console.log(`📊 ${source} - Load type: ${results.loadType}`);
                    console.log(`📊 ${source} - Tracks found: ${results.tracks ? results.tracks.length : 0}`);
                    
                    if (results.tracks && results.tracks.length > 0) {
                        console.log(`✅ Found tracks with ${source}!`);
                        break;
                    }
                } catch (error) {
                    console.log(`❌ ${source} error:`, error.message);
                }
            }
            
            if (!results || !results.tracks || results.tracks.length === 0) {
                return message.reply("❌ No tracks found!");
            }
            
            // Add track to queue
            const track = results.tracks[0];
            await player.queue.add(track);
            
            console.log(`➕ Added to queue: ${track.info.title} by ${track.info.author}`);
            console.log(`📊 Queue length: ${player.queue.tracks.length}`);
            
            // Start playing if not already playing
            if (!player.playing && !player.paused) {
                await player.play();
                console.log(`▶️ Started playing!`);
            }
            
            await message.reply(`✅ **Added to queue:**\n🎵 **${track.info.title}** by **${track.info.author}**\n⏱️ Duration: ${Math.floor(track.info.duration / 1000)}s\n📍 Position: #${player.queue.tracks.length}`);
            
        } catch (error) {
            console.error("❌ Play command error:", error);
            await message.reply(`❌ Error: ${error.message}`);
        }
    }
    
    if (command === "stop") {
        const player = client.lavalink.getPlayer(message.guildId);
        if (player) {
            await player.destroy();
            console.log(`⏹️ Player stopped and destroyed`);
            await message.reply("⏹️ Stopped and disconnected!");
        } else {
            await message.reply("❌ No player found!");
        }
    }
    
    if (command === "volume") {
        const volume = parseInt(args[0]);
        if (isNaN(volume) || volume < 0 || volume > 100) {
            return message.reply("❌ Volume must be between 0-100!");
        }
        
        const player = client.lavalink.getPlayer(message.guildId);
        if (player) {
            await player.setVolume(volume);
            console.log(`🎚️ Volume set to: ${volume}%`);
            await message.reply(`🎚️ Volume set to ${volume}%`);
        } else {
            await message.reply("❌ No player found!");
        }
    }
});

client.on("raw", d => client.lavalink.sendRawData(d));

console.log("🚀 Starting bot...");
client.login("YOUR_DISCORD_BOT_TOKEN_HERE");