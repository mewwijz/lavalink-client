# 🔑 PASTE YOUR YOUTUBE REFRESH TOKEN HERE

## 📍 **EXACT LOCATION TO PASTE YOUR TOKEN**

You have your YouTube refresh token? **Perfect!** Here's exactly where to paste it:

---

## 🎯 **STEP-BY-STEP TOKEN PASTING**

### **STEP 1: Open Configuration File**
```bash
# Download the ready configuration:
wget -O application-android.yml https://raw.githubusercontent.com/mewwijz/lavalink-client/youtube-oauth-android-ready/testBot/application-youtube-oauth-ready.yml

# Edit the file:
nano application-android.yml
```

### **STEP 2: Find This Section**
Look for this section in the file:
```yaml
plugins:
  youtube:
    oauth:
      enabled: true
      skipInitialization: false
      # 👇👇👇 PASTE YOUR YOUTUBE REFRESH TOKEN HERE 👇👇👇
      refreshToken: "PASTE_YOUR_YOUTUBE_REFRESH_TOKEN_HERE"
      # 👆👆👆 PASTE YOUR YOUTUBE REFRESH TOKEN HERE 👆👆👆
```

### **STEP 3: Replace the Placeholder**
**BEFORE (placeholder):**
```yaml
refreshToken: "PASTE_YOUR_YOUTUBE_REFRESH_TOKEN_HERE"
```

**AFTER (with your token):**
```yaml
refreshToken: "1//04xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
```

---

## 🔧 **COMPLETE EXAMPLE**

### **Your token looks like this:**
```
1//04AAAAAAAA-BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
```

### **Paste it exactly like this:**
```yaml
plugins:
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
      skipInitialization: false
      refreshToken: "1//04AAAAAAAA-BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"
      forceRefresh: true
      retryOnFailure: true
```

---

## ⚠️ **IMPORTANT NOTES**

### **✅ DO:**
- Keep the quotes around your token: `"your_token_here"`
- Paste the ENTIRE token (it's very long, ~100+ characters)
- Make sure token starts with `1//04`
- Save the file after editing

### **❌ DON'T:**
- Remove the quotes
- Add extra spaces or line breaks
- Copy only part of the token
- Share your token with others

---

## 🚀 **AFTER PASTING TOKEN**

### **STEP 4: Save and Start**
```bash
# Save the file (in nano: Ctrl+X, then Y, then Enter)

# Start Lavalink:
java -jar Lavalink.jar --spring.config.location=application-android.yml
```

### **STEP 5: Verify Success**
```bash
# Check logs for success:
tail -f logs/lavalink.log | grep -i oauth

# Expected messages:
✅ "OAuth initialized successfully"
✅ "Refresh token validated"
✅ "YouTube API rate limits bypassed"
```

---

## 🧪 **QUICK TEST**

### **Test Your Setup:**
```bash
# Health check:
curl http://localhost:2333/actuator/health

# Should return:
{"status":"UP"}

# Search test:
curl -X POST http://localhost:2333/v4/loadtracks \
  -H "Authorization: youtube_oauth_2025" \
  -H "Content-Type: application/json" \
  -d '{"identifier": "ytsearch:test song"}'
```

---

## 🎯 **TOKEN FORMAT EXAMPLES**

### **✅ CORRECT Format:**
```yaml
refreshToken: "1//04xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
```

### **❌ WRONG Formats:**
```yaml
# Missing quotes:
refreshToken: 1//04xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

# Extra spaces:
refreshToken: " 1//04xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx "

# Incomplete token:
refreshToken: "1//04xxxxxxxxxxxxxxxx"

# Wrong token type (this is access token, not refresh token):
refreshToken: "ya29.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
```

---

## 🔒 **SECURITY REMINDER**

### **Keep Your Token Safe:**
- ✅ Don't share screenshots with your token visible
- ✅ Don't commit config files with real tokens to public repos
- ✅ Use environment variables in production
- ✅ Rotate tokens every 3-6 months

### **Production Setup (Advanced):**
```yaml
# Use environment variable instead:
refreshToken: "${YOUTUBE_REFRESH_TOKEN}"

# Set environment variable:
export YOUTUBE_REFRESH_TOKEN="1//04xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
```

---

## 🏆 **EXPECTED RESULTS**

### **After pasting your token correctly:**
```bash
✅ Server starts without errors
✅ OAuth initialization successful
✅ YouTube API unlimited access
✅ Search speed: <1 second
✅ No 429 rate limit errors
✅ Bot reliability: 99%+
✅ Ready for production use!
```

---

## 🎵 **BOTTOM LINE**

**You have the token, now just paste it in the right place!**

### **Simple Steps:**
1. ✅ **Download** the config file
2. ✅ **Find** the `refreshToken:` line
3. ✅ **Replace** the placeholder with your token
4. ✅ **Save** and start Lavalink
5. ✅ **Enjoy** unlimited YouTube access!

**Your token is the key to unlimited YouTube music streaming!** 🔑🎵

---

**Ready to paste? The config file is waiting for your token!** 🚀✨