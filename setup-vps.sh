#!/bin/bash

# VPS Setup Script for Bot Garden
# This script prepares VPS for Bot Garden deployment based on analysis

set -e

echo "🚀 Bot Garden VPS Setup Script"
echo "=============================="
echo "Based on VPS analysis data"
echo ""

# Load environment variables
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
else
    echo "❌ No .env file found. Please create one first."
    exit 1
fi

# Check required variables
if [ -z "$VPS_HOST" ] || [ -z "$VPS_USER" ]; then
    echo "❌ Missing VPS configuration. Set VPS_HOST and VPS_USER in .env file"
    exit 1
fi

VPS_PORT=${VPS_PORT:-"22"}
SSH_OPTS="-p $VPS_PORT"

echo "🎯 Target: $VPS_USER@$VPS_HOST:$VPS_PORT"
echo ""

# Function to run remote commands
run_remote() {
    local description="$1"
    local command="$2"
    
    echo ">>> $description"
    if ssh $SSH_OPTS $VPS_USER@$VPS_HOST "$command"; then
        echo "✅ $description - completed"
    else
        echo "❌ $description - failed"
        exit 1
    fi
    echo ""
}

echo "🔧 PHASE 1: INSTALL REQUIRED SOFTWARE"
echo "====================================="

# Update system
run_remote "Updating package lists" "apt update"

# Install Docker
run_remote "Installing Docker" "
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    systemctl enable docker
    systemctl start docker
    rm get-docker.sh
"

# Install Docker Compose
run_remote "Installing Docker Compose" "
    apt install -y docker-compose-plugin
"

# Install required tools
run_remote "Installing Git, Rsync, and other tools" "
    apt install -y git rsync htop nano curl wget unzip
"

# Install Nginx
run_remote "Installing Nginx" "
    apt install -y nginx
    systemctl enable nginx
    systemctl start nginx
"

echo "🛡️  PHASE 2: SECURITY HARDENING"
echo "==============================="

# Configure SSH security
run_remote "Hardening SSH configuration" "
    cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
    sed -i 's/#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
    sed -i 's/#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
    sed -i 's/#*PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config
    echo 'SSH configuration updated'
"

echo ""
echo "⚠️  FIREWALL CONFIGURATION SKIPPED"
echo "=================================="
echo "Firewall setup removed to prevent SSH lockout."
echo "Configure firewall manually via VPS control panel if needed."
echo ""

echo "📁 PHASE 3: PREPARE DIRECTORIES"
echo "==============================="

# Setup deployment directories
VPS_PATH=${VPS_PATH:-"/var/www/botgarden"}
run_remote "Creating deployment directories" "
    mkdir -p $VPS_PATH
    mkdir -p /var/log/botgarden
    chown -R root:root $VPS_PATH
    chmod -R 755 $VPS_PATH
    ls -la $VPS_PATH
"

echo "🐳 PHASE 4: DOCKER VERIFICATION"
echo "==============================="

# Test Docker installation
run_remote "Testing Docker installation" "
    docker --version
    docker compose version
    
    # Start Docker service if not running
    systemctl start docker
    sleep 3
    
    # Test Docker functionality
    if docker run --rm hello-world >/dev/null 2>&1; then
        echo 'Docker is working correctly'
    else
        echo 'Docker may have issues - check logs: journalctl -xeu docker.service'
    fi
    
    docker system info | head -10
"

echo "🌐 PHASE 5: NGINX CONFIGURATION"
echo "==============================="

# Configure Nginx for Bot Garden
run_remote "Configuring Nginx for Bot Garden" "
    # Backup default config
    cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.backup
    
    # Create basic config for Bot Garden
    cat > /etc/nginx/sites-available/botgarden << 'EOF'
server {
    listen 80;
    server_name _;
    
    # Security headers
    add_header X-Frame-Options \"SAMEORIGIN\" always;
    add_header X-Content-Type-Options \"nosniff\" always;
    add_header X-XSS-Protection \"1; mode=block\" always;
    
    # Health check
    location /health {
        access_log off;
        return 200 \"VPS Ready for Bot Garden\";
        add_header Content-Type text/plain;
    }
    
    # Default response
    location / {
        return 200 \"Bot Garden VPS Ready\";
        add_header Content-Type text/plain;
    }
}
EOF
    
    # Enable the site
    ln -sf /etc/nginx/sites-available/botgarden /etc/nginx/sites-enabled/
    rm -f /etc/nginx/sites-enabled/default
    
    # Test and reload nginx
    nginx -t
    systemctl reload nginx
"

echo "🔍 PHASE 6: FINAL VERIFICATION"
echo "=============================="

# System status check
run_remote "Final system verification" "
    echo '=== System Status ==='
    uptime
    echo ''
    echo '=== Memory Usage ==='
    free -h
    echo ''
    echo '=== Disk Usage ==='
    df -h /
    echo ''
    echo '=== Docker Status ==='
    systemctl is-active docker
    echo ''
    echo '=== Nginx Status ==='
    systemctl is-active nginx
    echo ''
    echo '=== Listening Ports ==='
    ss -tuln | grep -E ':22 |:80 |:443 ' || echo 'No standard ports found'
"

# Test web server
echo "🌐 Testing web server..."
if curl -f --connect-timeout 10 --max-time 15 http://$VPS_HOST/health >/dev/null 2>&1; then
    echo "✅ Web server is responding"
else
    echo "⚠️  Web server test failed (may be normal if no public IP or firewall)"
fi

echo ""
echo "🎉 VPS SETUP COMPLETED!"
echo "======================"
echo ""
echo "✅ Installed:"
echo "   - Docker & Docker Compose"
echo "   - Git, rsync, nginx"
echo "   - SSH security hardened"
echo "   - Bot Garden directories ready"
echo ""
echo "⚠️  SECURITY NOTES:"
echo "   - SSH root login has been disabled for security"
echo "   - Firewall setup was SKIPPED to prevent lockout"
echo "   - Configure firewall manually via VPS control panel"
echo ""
echo "🚀 Ready for Bot Garden deployment:"
echo "   ./deploy-vps.sh production"
echo ""

# Save setup completion marker
ssh $SSH_OPTS $VPS_USER@$VPS_HOST "echo 'VPS setup completed: $(date)' > $VPS_PATH/setup-complete.txt"

echo "📋 Setup log saved to: $VPS_PATH/setup-complete.txt"
