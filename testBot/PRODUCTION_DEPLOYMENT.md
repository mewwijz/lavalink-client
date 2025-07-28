# 🏭 PRODUCTION DEPLOYMENT GUIDE

## 🎯 **PRODUCTION-READY SETUP**

### **SYSTEM REQUIREMENTS:**
```bash
✅ Java 17 or 21 (OpenJDK recommended)
✅ Minimum 1GB RAM (2GB recommended)
✅ 1GB free disk space
✅ Ubuntu 20.04+ / CentOS 8+ / Debian 11+
✅ Internet connection for YouTube API
```

### **SECURITY CHECKLIST:**
```bash
✅ Change default password from "chiro666_secure_2025"
✅ Use dedicated accounts for OAuth tokens
✅ Enable firewall (only port 2333 open)
✅ Regular token rotation (30-90 days)
✅ Monitor logs for suspicious activity
✅ Use HTTPS reverse proxy (nginx/apache)
```

## 🚀 **DEPLOYMENT STEPS:**

### **STEP 1: Server Preparation**
```bash
# Update system:
sudo apt update && sudo apt upgrade -y

# Install Java 17:
sudo apt install openjdk-17-jdk -y

# Verify Java:
java -version

# Create lavalink user:
sudo useradd -m -s /bin/bash lavalink
sudo su - lavalink
```

### **STEP 2: Lavalink Installation**
```bash
# Create directories:
mkdir -p ~/lavalink/{plugins,logs,config}
cd ~/lavalink

# Download Lavalink:
wget https://github.com/lavalink-devs/Lavalink/releases/download/4.1.1/Lavalink.jar

# Download plugins:
cd plugins
wget https://maven.lavalink.dev/releases/dev/lavalink/youtube/youtube-plugin/1.13.3/youtube-plugin-1.13.3.jar
wget https://jitpack.io/com/github/topi314/lavasrc/lavasrc-plugin/4.7.3/lavasrc-plugin-4.7.3.jar
cd ..
```

### **STEP 3: Configuration**
```bash
# Download production config:
cd config
wget https://raw.githubusercontent.com/mewwijz/lavalink-client/feature/lavalink-complete-fix-2025/testBot/application-minimal.yml

# Edit password (IMPORTANT):
nano application-minimal.yml
# Change password: "chiro666_secure_2025" to your secure password
```

### **STEP 4: Systemd Service**
```bash
# Create service file:
sudo nano /etc/systemd/system/lavalink.service
```

**Service file content:**
```ini
[Unit]
Description=Lavalink Music Server
After=network.target

[Service]
Type=simple
User=lavalink
Group=lavalink
WorkingDirectory=/home/lavalink/lavalink
ExecStart=/usr/bin/java -Xms1G -Xmx2G -XX:+UseG1GC -XX:+UseStringDeduplication -jar Lavalink.jar --spring.config.location=config/application-minimal.yml
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
```

### **STEP 5: Start Service**
```bash
# Reload systemd:
sudo systemctl daemon-reload

# Enable auto-start:
sudo systemctl enable lavalink

# Start service:
sudo systemctl start lavalink

# Check status:
sudo systemctl status lavalink

# View logs:
sudo journalctl -u lavalink -f
```

## 🔒 **SECURITY HARDENING:**

### **Firewall Configuration:**
```bash
# Install UFW:
sudo apt install ufw -y

# Default policies:
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow SSH:
sudo ufw allow ssh

# Allow Lavalink:
sudo ufw allow 2333/tcp

# Enable firewall:
sudo ufw enable
```

### **Reverse Proxy (Nginx):**
```bash
# Install Nginx:
sudo apt install nginx -y

# Create config:
sudo nano /etc/nginx/sites-available/lavalink
```

**Nginx config:**
```nginx
server {
    listen 80;
    server_name your-domain.com;
    
    location / {
        proxy_pass http://localhost:2333;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # WebSocket support
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
```

```bash
# Enable site:
sudo ln -s /etc/nginx/sites-available/lavalink /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

## 📊 **MONITORING & MAINTENANCE:**

### **Health Monitoring:**
```bash
# Create health check script:
nano ~/health-check.sh
```

**Health check script:**
```bash
#!/bin/bash
HEALTH=$(curl -s http://localhost:2333/actuator/health | grep -o '"status":"UP"')
if [ -z "$HEALTH" ]; then
    echo "$(date): Lavalink is DOWN - Restarting service"
    sudo systemctl restart lavalink
else
    echo "$(date): Lavalink is UP"
fi
```

```bash
# Make executable:
chmod +x ~/health-check.sh

# Add to crontab (check every 5 minutes):
crontab -e
# Add line: */5 * * * * /home/lavalink/health-check.sh >> /home/lavalink/health.log
```

### **Log Rotation:**
```bash
# Create logrotate config:
sudo nano /etc/logrotate.d/lavalink
```

**Logrotate config:**
```
/home/lavalink/lavalink/logs/*.log {
    daily
    rotate 7
    compress
    delaycompress
    missingok
    notifempty
    create 644 lavalink lavalink
    postrotate
        sudo systemctl reload lavalink
    endscript
}
```

## 🔧 **PERFORMANCE TUNING:**

### **JVM Optimization:**
```bash
# Edit service file for high-performance:
sudo nano /etc/systemd/system/lavalink.service

# Replace ExecStart with:
ExecStart=/usr/bin/java -Xms2G -Xmx4G -XX:+UseG1GC -XX:+UseStringDeduplication -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+UseJVMCICompiler -jar Lavalink.jar --spring.config.location=config/application-minimal.yml
```

### **System Optimization:**
```bash
# Increase file limits:
sudo nano /etc/security/limits.conf
# Add:
lavalink soft nofile 65536
lavalink hard nofile 65536

# Network optimization:
sudo nano /etc/sysctl.conf
# Add:
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 65536 16777216

# Apply changes:
sudo sysctl -p
```

## 📈 **SCALING & LOAD BALANCING:**

### **Multiple Instances:**
```bash
# Create multiple configs:
cp config/application-minimal.yml config/application-node1.yml
cp config/application-minimal.yml config/application-node2.yml

# Edit ports:
# Node 1: port 2333
# Node 2: port 2334

# Create separate services:
sudo cp /etc/systemd/system/lavalink.service /etc/systemd/system/lavalink-node2.service
# Edit node2 service to use port 2334 config
```

### **Load Balancer (HAProxy):**
```bash
# Install HAProxy:
sudo apt install haproxy -y

# Configure:
sudo nano /etc/haproxy/haproxy.cfg
```

**HAProxy config:**
```
backend lavalink_servers
    balance roundrobin
    server node1 localhost:2333 check
    server node2 localhost:2334 check

frontend lavalink_frontend
    bind *:2332
    default_backend lavalink_servers
```

## 🎯 **PRODUCTION CHECKLIST:**

```bash
✅ Java 17+ installed and configured
✅ Lavalink service running and enabled
✅ Firewall configured (only port 2333 open)
✅ Reverse proxy configured (optional but recommended)
✅ SSL certificate installed (Let's Encrypt recommended)
✅ Health monitoring script active
✅ Log rotation configured
✅ Backup strategy implemented
✅ Password changed from default
✅ OAuth tokens from dedicated accounts
✅ Performance monitoring active
✅ Documentation updated with server details
```

## 🚨 **EMERGENCY PROCEDURES:**

### **Service Recovery:**
```bash
# If service fails:
sudo systemctl stop lavalink
sudo systemctl start lavalink
sudo systemctl status lavalink

# If config corrupted:
cd ~/lavalink/config
cp application-minimal.yml application-minimal.yml.backup
wget -O application-minimal.yml https://raw.githubusercontent.com/mewwijz/lavalink-client/feature/lavalink-complete-fix-2025/testBot/application-minimal.yml

# If plugins corrupted:
cd ~/lavalink/plugins
rm *.jar
wget https://maven.lavalink.dev/releases/dev/lavalink/youtube/youtube-plugin/1.13.3/youtube-plugin-1.13.3.jar
```

### **Backup & Restore:**
```bash
# Create backup:
tar -czf lavalink-backup-$(date +%Y%m%d).tar.gz ~/lavalink/

# Restore backup:
cd ~
tar -xzf lavalink-backup-YYYYMMDD.tar.gz
sudo systemctl restart lavalink
```

## 🏆 **PRODUCTION SUCCESS METRICS:**

```bash
✅ Uptime: >99.9%
✅ Response time: <100ms
✅ Memory usage: <2GB
✅ CPU usage: <50%
✅ Error rate: <0.1%
✅ YouTube success rate: >95%
✅ Audio quality: High (Opus 10)
✅ Concurrent connections: 100+
```

**PRODUCTION DEPLOYMENT COMPLETE!** 🚀✨