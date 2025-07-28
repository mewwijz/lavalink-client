# 🔑 COMPLETE TOKEN CONFIGURATION GUIDE

## 🎯 **OVERVIEW**

This guide shows you **exactly where to place your tokens** in the Lavalink configuration file for:
- ✅ **YouTube OAuth tokens** (rate limit bypass)
- ✅ **Apple Music tokens** (Apple Music integration)
- ✅ **YouTube cookies** (session persistence)
- ✅ **poToken** (anti-detection)
- ✅ **Spotify credentials** (Spotify integration)

---

## 🔧 **CONFIGURATION FILE LOCATIONS**

### **📍 YouTube OAuth Tokens (CRITICAL for Rate Limit Bypass)**

**Location:** Lines 77-78 in `plugins.youtube.oauth` section

```yaml
plugins:
  youtube:
    # 🔑 OAUTH CONFIGURATION - PLACE YOUR YOUTUBE TOKENS HERE!
    oauth:
      enabled: true
      skipInitialization: false
      # OAuth tokens for rate limit bypass
      refreshToken: "YOUR_YOUTUBE_OAUTH_REFRESH_TOKEN_HERE"  # 👈 REPLACE WITH YOUR REFRESH TOKEN!
      accessToken: "YOUR_YOUTUBE_OAUTH_ACCESS_TOKEN_HERE"    # 👈 REPLACE WITH YOUR ACCESS TOKEN!
```

**Example with real tokens:**
```yaml
oauth:
  enabled: true
  skipInitialization: false
  refreshToken: "1//04xyz-AbCdEfGhIjKlMnOpQrStUvWxYz-refresh-token-here"
  accessToken: "ya29.a0xyz-AbCdEfGhIjKlMnOpQrStUvWxYz-access-token-here"
```

### **📍 Apple Music Token (for Apple Music Integration)**

**Location:** Line 112 in `plugins.lavasrc.applemusic` section

```yaml
plugins:
  lavasrc:
    # 🎯 APPLE MUSIC CONFIGURATION - PLACE YOUR TOKEN HERE!
    applemusic:
      countryCode: "ID"
      mediaAPIToken: "YOUR_APPLE_MUSIC_TOKEN_HERE"  # 👈 REPLACE WITH YOUR APPLE MUSIC TOKEN!
      playlistLoadLimit: 6
      albumLoadLimit: 6
```

**Example with real token:**
```yaml
applemusic:
  countryCode: "ID"
  mediaAPIToken: "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IldlYlBsYXlLaWQifQ.eyJpc3MiOiJBTVBXZWJQbGF5IiwiaWF0IjoxNjkwMjA4NDAwLCJleHAiOjE2OTc5ODQ0MDAsInJvb3RfaHR0cHNfb3JpZ2luIjpbImh0dHBzOi8vbXVzaWMuYXBwbGUuY29tIl19.signature_here"
  playlistLoadLimit: 6
  albumLoadLimit: 6
```

### **📍 YouTube Cookies (OPTIONAL - Session Persistence)**

**Location:** Line 84 in `plugins.youtube.cookies` section

```yaml
plugins:
  youtube:
    # 🍪 COOKIES CONFIGURATION (alternative/additional)
    cookies:
      enabled: true
      # Format: "name1=value1; name2=value2; name3=value3"
      cookie: "YOUR_YOUTUBE_COOKIES_HERE"  # 👈 OPTIONAL: Cookies from browser
```

**Example with real cookies:**
```yaml
cookies:
  enabled: true
  cookie: "VISITOR_INFO1_LIVE=xyz123abc; YSC=def456ghi; PREF=f1=50000000&f6=40000000"
```

### **📍 YouTube poToken (OPTIONAL - Anti-Detection)**

**Location:** Line 87 in `plugins.youtube` section

```yaml
plugins:
  youtube:
    # 🎯 POTOKEN CONFIGURATION (anti-detection)
    poToken: "YOUR_YOUTUBE_POTOKEN_HERE"  # 👈 OPTIONAL: poToken for anti-detection
```

**Example with real poToken:**
```yaml
poToken: "MnwxM3wxNjkwMjA4NDAwfDEuMC4wfDF8dGVzdA=="
```

### **📍 Spotify Credentials (OPTIONAL - Spotify Integration)**

**Location:** Lines 104-107 in `plugins.lavasrc.spotify` section

```yaml
plugins:
  lavasrc:
    # Spotify configuration (optional)
    spotify:
      clientId: "YOUR_SPOTIFY_CLIENT_ID_HERE"        # 👈 REPLACE WITH YOUR SPOTIFY CLIENT ID!
      clientSecret: "YOUR_SPOTIFY_CLIENT_SECRET_HERE" # 👈 REPLACE WITH YOUR SPOTIFY CLIENT SECRET!
      countryCode: "ID"
      playlistLoadLimit: 6
      albumLoadLimit: 6
```

---

## 🚀 **STEP-BY-STEP TOKEN SETUP**

### **STEP 1: Edit Configuration File**
```bash
# Open the configuration file
nano application-with-apple-music-token.yml
```

### **STEP 2: Replace Token Placeholders**

#### **🔑 YouTube OAuth (REQUIRED for rate limit bypass)**
1. Find line 77: `refreshToken: "YOUR_YOUTUBE_OAUTH_REFRESH_TOKEN_HERE"`
2. Replace with your actual refresh token
3. Find line 78: `accessToken: "YOUR_YOUTUBE_OAUTH_ACCESS_TOKEN_HERE"`
4. Replace with your actual access token

#### **🎵 Apple Music (REQUIRED for Apple Music features)**
1. Find line 112: `mediaAPIToken: "YOUR_APPLE_MUSIC_TOKEN_HERE"`
2. Replace with your actual Apple Music JWT token

#### **🍪 YouTube Cookies (OPTIONAL but recommended)**
1. Find line 84: `cookie: "YOUR_YOUTUBE_COOKIES_HERE"`
2. Replace with cookies from your browser (format: "name1=value1; name2=value2")

#### **🎯 YouTube poToken (OPTIONAL for anti-detection)**
1. Find line 87: `poToken: "YOUR_YOUTUBE_POTOKEN_HERE"`
2. Replace with your actual poToken

#### **🎶 Spotify (OPTIONAL for Spotify integration)**
1. Find line 105: `clientId: "YOUR_SPOTIFY_CLIENT_ID_HERE"`
2. Find line 106: `clientSecret: "YOUR_SPOTIFY_CLIENT_SECRET_HERE"`
3. Replace with your Spotify app credentials

### **STEP 3: Save and Restart Server**
```bash
# Save the file (Ctrl+X, then Y, then Enter in nano)

# Stop current server
pm2 stop lavalink

# Start with new configuration
java -jar Lavalink.jar --spring.config.location=application-with-apple-music-token.yml

# Or with pm2
pm2 start "java -jar Lavalink.jar --spring.config.location=application-with-apple-music-token.yml" --name lavalink
```

---

## 🎯 **TOKEN PRIORITY & REQUIREMENTS**

| Token Type | Priority | Required | Benefits |
|------------|----------|----------|----------|
| **YouTube OAuth** | 🔥 HIGH | YES | Rate limit bypass, stable playback |
| **Apple Music** | 🔥 HIGH | YES* | Apple Music search & metadata |
| **YouTube Cookies** | 🟡 MEDIUM | NO | Session persistence, better reliability |
| **YouTube poToken** | 🟡 MEDIUM | NO | Anti-detection, bot protection bypass |
| **Spotify Credentials** | 🟢 LOW | NO | Spotify search integration |

*Required only if you want Apple Music functionality

---

## 🔍 **TOKEN FORMATS & EXAMPLES**

### **YouTube OAuth Tokens**
```
Refresh Token: 1//04xyz-AbCdEfGhIjKlMnOpQrStUvWxYz...
Access Token:  ya29.a0xyz-AbCdEfGhIjKlMnOpQrStUvWxYz...
```

### **Apple Music JWT Token**
```
eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IldlYlBsYXlLaWQifQ.eyJpc3MiOiJBTVBXZWJQbGF5IiwiaWF0IjoxNjkwMjA4NDAwLCJleHAiOjE2OTc5ODQ0MDAsInJvb3RfaHR0cHNfb3JpZ2luIjpbImh0dHBzOi8vbXVzaWMuYXBwbGUuY29tIl19.signature_here
```

### **YouTube Cookies**
```
VISITOR_INFO1_LIVE=xyz123; YSC=abc456; PREF=f1=50000000
```

### **YouTube poToken**
```
MnwxM3wxNjkwMjA4NDAwfDEuMC4wfDF8dGVzdA==
```

### **Spotify Credentials**
```
Client ID:     1234567890abcdef1234567890abcdef
Client Secret: abcdef1234567890abcdef1234567890abcdef12
```

---

## ⚠️ **SECURITY BEST PRACTICES**

### **🔒 Token Security**
- ✅ **Never share tokens** publicly or in repositories
- ✅ **Use dedicated accounts** for bot tokens (not personal accounts)
- ✅ **Rotate tokens regularly** (every 30-90 days)
- ✅ **Store tokens securely** with proper file permissions
- ✅ **Monitor token usage** for suspicious activity

### **🛡️ Configuration Security**
- ✅ **Change default passwords** in configuration
- ✅ **Use strong passwords** for Lavalink server
- ✅ **Enable firewall** (only port 2333 open)
- ✅ **Use HTTPS** with reverse proxy
- ✅ **Regular backups** of working configurations

---

## 🎵 **EXPECTED RESULTS AFTER TOKEN SETUP**

### **✅ With YouTube OAuth Tokens**
```bash
✅ No rate limiting on YouTube searches
✅ Stable audio playback without interruptions
✅ Fast search results and metadata loading
✅ Support for large playlists (1000+ tracks)
✅ High-quality audio stream access
✅ Reduced "Video unavailable" errors
```

### **✅ With Apple Music Token**
```bash
✅ Apple Music search integration
✅ High-quality metadata from Apple Music
✅ ISRC-based track matching
✅ Apple Music playlist support
✅ Album artwork from Apple Music
✅ Enhanced search accuracy
```

### **✅ With YouTube Cookies**
```bash
✅ Session persistence across restarts
✅ Better reliability for long-running sessions
✅ Reduced authentication challenges
✅ Improved bot detection avoidance
```

### **✅ With YouTube poToken**
```bash
✅ Advanced anti-detection capabilities
✅ Bypass bot protection mechanisms
✅ More stable long-term operation
✅ Reduced risk of IP blocking
```

---

## 🔧 **TROUBLESHOOTING TOKEN ISSUES**

### **❌ Common Token Errors**

#### **YouTube OAuth Errors**
```
Error: "Invalid OAuth token" or "Token expired"
Solution: Generate new OAuth tokens using Google OAuth Playground
```

#### **Apple Music Token Errors**
```
Error: "Invalid token provided must have 3 parts separated by '.'"
Solution: Ensure JWT token has header.payload.signature format
```

#### **Cookie Format Errors**
```
Error: "Invalid cookie format"
Solution: Use format "name1=value1; name2=value2; name3=value3"
```

### **🔍 Token Validation Commands**
```bash
# Test YAML syntax
python3 -c "import yaml; yaml.safe_load(open('application-with-apple-music-token.yml'))"

# Check server startup
tail -f logs/lavalink.log

# Test server health
curl http://localhost:2333/actuator/health
```

---

## 🏆 **COMPLETE CONFIGURATION EXAMPLE**

Here's a complete example with all tokens configured:

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
    
    # YouTube OAuth tokens
    oauth:
      enabled: true
      skipInitialization: false
      refreshToken: "1//04xyz-your-actual-refresh-token-here"
      accessToken: "ya29.a0xyz-your-actual-access-token-here"
    
    # YouTube cookies
    cookies:
      enabled: true
      cookie: "VISITOR_INFO1_LIVE=xyz123; YSC=abc456; PREF=f1=50000000"
    
    # YouTube poToken
    poToken: "MnwxM3wxNjkwMjA4NDAwfDEuMC4wfDF8dGVzdA=="

  lavasrc:
    sources:
      spotify: true
      applemusic: true
      deezer: false
      yandexmusic: false
    
    # Apple Music configuration
    applemusic:
      countryCode: "ID"
      mediaAPIToken: "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IldlYlBsYXlLaWQifQ.your-actual-apple-music-jwt-token-here.signature"
      playlistLoadLimit: 6
      albumLoadLimit: 6
    
    # Spotify configuration
    spotify:
      clientId: "your-spotify-client-id-here"
      clientSecret: "your-spotify-client-secret-here"
      countryCode: "ID"
      playlistLoadLimit: 6
      albumLoadLimit: 6
```

---

## 🎯 **BOTTOM LINE**

**This guide provides exact locations and examples for all token types in your Lavalink configuration:**

- ✅ **YouTube OAuth tokens** → Lines 77-78 (CRITICAL for rate limits)
- ✅ **Apple Music token** → Line 112 (REQUIRED for Apple Music)
- ✅ **YouTube cookies** → Line 84 (OPTIONAL but recommended)
- ✅ **YouTube poToken** → Line 87 (OPTIONAL for anti-detection)
- ✅ **Spotify credentials** → Lines 105-106 (OPTIONAL for Spotify)

**Follow this guide to configure all your tokens correctly and get maximum performance from your Lavalink server!** 🎵✨

---

**Ready to configure your tokens and unlock the full potential of your music server!** 🚀