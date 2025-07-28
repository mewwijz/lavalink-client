const { Client, GatewayIntentBits } = require("discord.js");
const { LavalinkManager } = require("lavalink-client");
require('dotenv').config();

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
        authorization: process.env.LAVALINK_PASSWORD || "YOUR_LAVALINK_PASSWORD",
        host: process.env.LAVALINK_HOST || "YOUR_LAVALINK_HOST", 
        port: parseInt(process.env.LAVALINK_PORT) || 2333,
        id: "testnode",
        secure: false,
    }],
    sendToShard: (guildId, payload) => client.guilds.cache.get(guildId)?.shard?.send(payload),
    client: { id: process.env.BOT_CLIENT_ID || "YOUR_BOT_CLIENT_ID", username: "EICHIRO" },
    autoSkip: true,
    playerOptions: {
        defaultSearchPlatform: "scsearch",
        volumeDecrementer: 1.0,
        applyVolumeAsFilter: false,
    }
});

client.lavalink = lavalink;

client.on("ready", () => {
    console.log(`✅ Bot ${client.user.tag} is ready!`);
    client.lavalink.init(client.user);
});

client.lavalink.nodeManager.on("connect", (node) => {
    console.log(`✅ Lavalink connected: ${node.options.host}:${node.options.port}`);
});

client.lavalink.on("trackStart", (player, track) => {
    console.log(`🎵 NOW PLAYING: ${track.info.title} by ${track.info.author}`);
    console.log(`⏱️ Duration: ${Math.floor(track.info.duration / 1000)}s`);
    console.log(`🎚️ Volume: ${player.volume}%`);
});

client.lavalink.on("trackEnd", (player, track, payload) => {
    console.log(`⏹️ FINISHED: ${track.info.title} (${payload.reason})`);
});

client.on("messageCreate", async (message) => {
    if (message.author.bot) return;
    if (!message.content.startsWith("!")) return;
    
    const args = message.content.slice(1).split(" ");
    const command = args.shift().toLowerCase();
    
    // Command untuk play musik dengan query
    if (command === "play") {
        const query = args.join(" ");
        if (!query) {
            return message.reply(`❌ **Usage:** \`!play <song name or URL>\`

**Examples:**
\`!play bohemian rhapsody queen\`
\`!play imagine dragons believer\`
\`!play https://www.youtube.com/watch?v=dQw4w9WgXcQ\`
\`!play https://soundcloud.com/user/track\`

**Supported sources:**
🎵 YouTube (ytsearch)
🎵 SoundCloud (scsearch)
🎵 Direct URLs`);
        }
        
        const member = message.member;
        if (!member?.voice?.channelId) {
            return message.reply("❌ You need to join a voice channel first!");
        }
        
        try {
            console.log(`🎯 Playing request: "${query}" by ${message.author.tag}`);
            
            // Get or create player
            let player = client.lavalink.getPlayer(message.guildId);
            if (!player) {
                player = await client.lavalink.createPlayer({
                    guildId: message.guildId,
                    voiceChannelId: member.voice.channelId,
                    textChannelId: message.channelId,
                    selfDeaf: false,
                    selfMute: false,
                    volume: 100
                });
                await player.connect();
                console.log(`🔗 Connected to ${member.voice.channel.name}`);
            }
            
            // Search with multiple sources
            const searchSources = [
                { source: "scsearch", name: "SoundCloud" },
                { source: "ytsearch", name: "YouTube" }
            ];
            
            let results = null;
            let usedSource = null;
            
            // If it's a URL, try direct search first
            if (query.includes("http")) {
                console.log(`🔗 Trying direct URL: ${query}`);
                try {
                    results = await player.search({ query: query }, message.author);
                    if (results.tracks && results.tracks.length > 0) {
                        usedSource = "Direct URL";
                        console.log(`✅ Direct URL worked!`);
                    }
                } catch (error) {
                    console.log(`❌ Direct URL failed: ${error.message}`);
                }
            }
            
            // If direct URL failed or it's not a URL, try search sources
            if (!results || !results.tracks || results.tracks.length === 0) {
                for (const { source, name } of searchSources) {
                    console.log(`🔍 Searching with ${name} (${source}): "${query}"`);
                    try {
                        results = await player.search({
                            query: query,
                            source: source
                        }, message.author);
                        
                        console.log(`📊 ${name} - Load type: ${results.loadType}, Tracks: ${results.tracks?.length || 0}`);
                        
                        if (results.tracks && results.tracks.length > 0) {
                            usedSource = name;
                            console.log(`✅ Found with ${name}!`);
                            break;
                        }
                    } catch (error) {
                        console.log(`❌ ${name} error: ${error.message}`);
                    }
                }
            }
            
            if (!results || !results.tracks || results.tracks.length === 0) {
                return message.reply("❌ No tracks found! Try a different search term or URL.");
            }
            
            // Add track(s) to queue
            const track = results.tracks[0];
            await player.queue.add(track);
            
            console.log(`➕ Added: ${track.info.title} by ${track.info.author}`);
            
            // Start playing if not already playing
            if (!player.playing && !player.paused) {
                await player.play();
                console.log(`▶️ Started playback`);
            }
            
            await message.reply(`✅ **Added to queue:**
🎵 **${track.info.title}** by **${track.info.author}**
📱 Source: ${usedSource}
⏱️ Duration: ${Math.floor(track.info.duration / 1000)}s
📍 Position: #${player.queue.tracks.length}
🎚️ Volume: ${player.volume}%`);
            
        } catch (error) {
            console.error("❌ Play error:", error);
            await message.reply(`❌ Error: ${error.message}`);
        }
    }
    
    // Command untuk skip lagu
    if (command === "skip") {
        const player = client.lavalink.getPlayer(message.guildId);
        if (player && player.queue.current) {
            const current = player.queue.current;
            await player.skip();
            console.log(`⏭️ Skipped: ${current.info.title}`);
            await message.reply(`⏭️ Skipped: **${current.info.title}**`);
        } else {
            await message.reply("❌ Nothing is playing!");
        }
    }
    
    // Command untuk stop dan disconnect
    if (command === "stop") {
        const player = client.lavalink.getPlayer(message.guildId);
        if (player) {
            await player.destroy();
            console.log(`⏹️ Stopped and disconnected`);
            await message.reply("⏹️ Stopped and disconnected from voice channel!");
        } else {
            await message.reply("❌ No active player!");
        }
    }
    
    // Command untuk pause/resume
    if (command === "pause") {
        const player = client.lavalink.getPlayer(message.guildId);
        if (player) {
            if (player.paused) {
                await player.resume();
                await message.reply("▶️ Resumed!");
            } else {
                await player.pause();
                await message.reply("⏸️ Paused!");
            }
        } else {
            await message.reply("❌ No active player!");
        }
    }
    
    // Command untuk set volume
    if (command === "volume") {
        const volume = parseInt(args[0]);
        if (isNaN(volume) || volume < 0 || volume > 100) {
            return message.reply("❌ Volume must be between 0-100!\nExample: `!volume 50`");
        }
        
        const player = client.lavalink.getPlayer(message.guildId);
        if (player) {
            await player.setVolume(volume);
            console.log(`🎚️ Volume: ${volume}%`);
            await message.reply(`🎚️ Volume set to ${volume}%`);
        } else {
            await message.reply("❌ No active player!");
        }
    }
    
    // Command untuk show queue
    if (command === "queue") {
        const player = client.lavalink.getPlayer(message.guildId);
        if (player) {
            const current = player.queue.current;
            const upcoming = player.queue.tracks.slice(0, 5); // Show first 5
            
            let queueText = "";
            if (current) {
                queueText += `🎵 **Now Playing:**\n${current.info.title} by ${current.info.author}\n\n`;
            }
            
            if (upcoming.length > 0) {
                queueText += `📋 **Up Next:**\n`;
                upcoming.forEach((track, index) => {
                    queueText += `${index + 1}. ${track.info.title} by ${track.info.author}\n`;
                });
                
                if (player.queue.tracks.length > 5) {
                    queueText += `\n... and ${player.queue.tracks.length - 5} more tracks`;
                }
            } else if (!current) {
                queueText = "📋 Queue is empty!";
            }
            
            await message.reply(queueText);
        } else {
            await message.reply("❌ No active player!");
        }
    }
    
    // Command untuk help
    if (command === "help") {
        const helpText = `🎵 **Music Bot Commands:**

**Basic Commands:**
\`!play <song/URL>\` - Play music
\`!skip\` - Skip current song
\`!stop\` - Stop and disconnect
\`!pause\` - Pause/Resume playback

**Controls:**
\`!volume <0-100>\` - Set volume
\`!queue\` - Show current queue

**Examples:**
\`!play bohemian rhapsody queen\`
\`!play imagine dragons believer\`
\`!play https://www.youtube.com/watch?v=dQw4w9WgXcQ\`
\`!play https://soundcloud.com/user/track\`

**Supported Sources:**
🎵 SoundCloud (recommended)
🎵 YouTube
🎵 Direct URLs`;
        
        await message.reply(helpText);
    }
});

client.on("raw", d => client.lavalink.sendRawData(d));

console.log("🎵 Music Bot Starting...");
console.log("📝 Type !help for commands");
console.log("🔍 Debug - Token loaded:", process.env.DISCORD_TOKEN ? "✅ YES" : "❌ NO");
console.log("🔍 Debug - Token length:", process.env.DISCORD_TOKEN ? process.env.DISCORD_TOKEN.length : "undefined");
client.login(process.env.DISCORD_TOKEN);