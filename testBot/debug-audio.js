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
        defaultSearchPlatform: "scsearch",
        volumeDecrementer: 1.0,
        applyVolumeAsFilter: false, // Important: Use native volume
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

// Comprehensive event monitoring
client.lavalink.on("trackStart", (player, track) => {
    console.log(`🎵 TRACK STARTED: ${track.info.title}`);
    console.log(`📊 Player Status:`);
    console.log(`   - Connected: ${player.connected}`);
    console.log(`   - Playing: ${player.playing}`);
    console.log(`   - Paused: ${player.paused}`);
    console.log(`   - Volume: ${player.volume}%`);
    console.log(`   - Position: ${player.position}ms`);
    console.log(`   - Voice Channel: ${player.voiceChannelId}`);
    console.log(`   - Guild: ${player.guildId}`);
});

client.lavalink.on("trackEnd", (player, track, payload) => {
    console.log(`⏹️ TRACK ENDED: ${track.info.title}`);
    console.log(`📊 End Reason: ${payload.reason}`);
});

client.lavalink.on("trackError", (player, track, payload) => {
    console.log(`❌ TRACK ERROR: ${track.info.title}`);
    console.log(`📊 Error: ${payload.exception?.message}`);
});

client.lavalink.on("trackStuck", (player, track, payload) => {
    console.log(`⚠️ TRACK STUCK: ${track.info.title}`);
    console.log(`📊 Threshold: ${payload.thresholdMs}ms`);
});

client.lavalink.on("playerUpdate", (player, payload) => {
    if (player.playing) {
        console.log(`🔄 Player Update - Position: ${Math.floor(payload.state.position/1000)}s, Connected: ${payload.state.connected}`);
    }
});

client.on("messageCreate", async (message) => {
    if (message.author.bot) return;
    if (!message.content.startsWith("!")) return;
    
    const args = message.content.slice(1).split(" ");
    const command = args.shift().toLowerCase();
    
    if (command === "test") {
        const member = message.member;
        if (!member?.voice?.channelId) {
            return message.reply("❌ Join a voice channel first!");
        }
        
        try {
            console.log(`\n🧪 STARTING COMPREHENSIVE AUDIO TEST`);
            console.log(`👤 User: ${message.author.tag}`);
            console.log(`🔊 Voice Channel: ${member.voice.channel.name} (${member.voice.channelId})`);
            console.log(`🏠 Guild: ${message.guild.name} (${message.guildId})`);
            
            // Step 1: Create player with optimal settings
            console.log(`\n📝 Step 1: Creating player...`);
            let player = client.lavalink.getPlayer(message.guildId);
            if (player) {
                await player.destroy();
                console.log(`🗑️ Destroyed existing player`);
            }
            
            player = await client.lavalink.createPlayer({
                guildId: message.guildId,
                voiceChannelId: member.voice.channelId,
                textChannelId: message.channelId,
                selfDeaf: false, // IMPORTANT: Don't self-deaf
                selfMute: false,
                volume: 100,
                // Additional options for better audio
                instaUpdateFiltersFix: true,
                applyVolumeAsFilter: false,
            });
            
            console.log(`✅ Player created successfully`);
            
            // Step 2: Connect to voice channel
            console.log(`\n📝 Step 2: Connecting to voice channel...`);
            await player.connect();
            
            // Wait for connection
            await new Promise(resolve => setTimeout(resolve, 2000));
            
            if (!player.connected) {
                console.log(`❌ Failed to connect to voice channel`);
                return message.reply("❌ Failed to connect to voice channel!");
            }
            
            console.log(`✅ Successfully connected to voice channel`);
            await message.reply("✅ Connected to voice channel! Searching for music...");
            
            // Step 3: Search for a reliable track
            console.log(`\n📝 Step 3: Searching for music...`);
            const testQueries = [
                { query: "never gonna give you up rick astley", source: "scsearch" },
                { query: "bohemian rhapsody queen", source: "scsearch" },
                { query: "imagine dragons believer", source: "scsearch" }
            ];
            
            let selectedTrack = null;
            for (const test of testQueries) {
                console.log(`🔍 Trying: ${test.query} (${test.source})`);
                try {
                    const results = await player.search(test, message.author);
                    console.log(`📊 Load type: ${results.loadType}, Tracks: ${results.tracks?.length || 0}`);
                    
                    if (results.tracks && results.tracks.length > 0) {
                        selectedTrack = results.tracks[0];
                        console.log(`✅ Found: ${selectedTrack.info.title} by ${selectedTrack.info.author}`);
                        break;
                    }
                } catch (error) {
                    console.log(`❌ Search error: ${error.message}`);
                }
            }
            
            if (!selectedTrack) {
                console.log(`❌ No tracks found with any search method`);
                return message.reply("❌ Could not find any playable tracks!");
            }
            
            // Step 4: Add to queue and play
            console.log(`\n📝 Step 4: Adding track to queue and playing...`);
            await player.queue.add(selectedTrack);
            console.log(`➕ Added to queue: ${selectedTrack.info.title}`);
            
            // Ensure volume is at maximum
            await player.setVolume(100);
            console.log(`🎚️ Volume set to 100%`);
            
            // Start playing
            if (!player.playing) {
                await player.play();
                console.log(`▶️ Started playback`);
            }
            
            await message.reply(`🎵 **NOW PLAYING:**\n**${selectedTrack.info.title}** by **${selectedTrack.info.author}**\n\n🔊 **LISTEN CAREFULLY - AUDIO SHOULD BE PLAYING NOW!**\n⏱️ Duration: ${Math.floor(selectedTrack.info.duration / 1000)}s\n🎚️ Volume: 100%`);
            
            // Step 5: Monitor playback for 60 seconds
            console.log(`\n📝 Step 5: Monitoring playback...`);
            console.log(`🎧 AUDIO SHOULD BE PLAYING NOW - PLEASE CONFIRM IF YOU HEAR SOUND!`);
            
            let monitorCount = 0;
            const monitorInterval = setInterval(() => {
                monitorCount++;
                const position = Math.floor(player.position / 1000);
                const duration = Math.floor(selectedTrack.info.duration / 1000);
                
                console.log(`📊 [${monitorCount}s] Playing: ${player.playing}, Position: ${position}/${duration}s, Connected: ${player.connected}`);
                
                if (monitorCount >= 60 || !player.playing) {
                    clearInterval(monitorInterval);
                    console.log(`\n🏁 Monitoring completed!`);
                    
                    if (player.playing) {
                        console.log(`✅ Track is still playing - audio should be audible`);
                    } else {
                        console.log(`⚠️ Track stopped playing`);
                    }
                }
            }, 1000);
            
        } catch (error) {
            console.error(`❌ Test error:`, error);
            await message.reply(`❌ Test failed: ${error.message}`);
        }
    }
    
    if (command === "stop") {
        const player = client.lavalink.getPlayer(message.guildId);
        if (player) {
            await player.destroy();
            console.log(`⏹️ Player stopped and destroyed`);
            await message.reply("⏹️ Stopped!");
        }
    }
    
    if (command === "status") {
        const player = client.lavalink.getPlayer(message.guildId);
        if (player) {
            const current = player.queue.current;
            const status = `📊 **Player Status:**
Connected: ${player.connected}
Playing: ${player.playing}
Paused: ${player.paused}
Volume: ${player.volume}%
Position: ${Math.floor(player.position/1000)}s
Voice Channel: <#${player.voiceChannelId}>
${current ? `\n🎵 **Current Track:**\n${current.info.title} by ${current.info.author}` : ''}`;
            await message.reply(status);
        } else {
            await message.reply("❌ No active player");
        }
    }
});

client.on("raw", d => client.lavalink.sendRawData(d));

console.log("🚀 Starting comprehensive audio test bot...");
console.log("📝 Commands:");
console.log("   !test - Run comprehensive audio test");
console.log("   !status - Check player status");
console.log("   !stop - Stop player");

client.login(process.env.DISCORD_TOKEN);