#!/bin/bash

# Static Deployment Script for Bot Garden
# Deploys static files directly to nginx without Docker

set -e

echo "🚀 Static Bot Garden Deployment"
echo "==============================="

# Load environment variables
if [ -f .env ]; then
    echo "📋 Loading environment variables from .env..."
    export $(cat .env | grep -v '^#' | xargs)
fi

# Check required variables
if [ -z "$VPS_HOST" ] || [ -z "$VPS_USER" ]; then
    echo "❌ Missing VPS configuration. Set VPS_HOST and VPS_USER in .env file"
    exit 1
fi

VPS_PATH=${VPS_PATH:-"/var/www/botgarden"}
VPS_PORT=${VPS_PORT:-"22"}
SSH_OPTS="-p $VPS_PORT"

echo "🎯 Target: $VPS_USER@$VPS_HOST:$VPS_PORT"
echo "📁 Deploy path: $VPS_PATH"
echo ""

# Test SSH connectivity
echo "🔍 Testing SSH connection..."
if ! ssh $SSH_OPTS -o ConnectTimeout=5 $VPS_USER@$VPS_HOST "echo 'SSH OK'" >/dev/null 2>&1; then
    echo "❌ SSH connection failed!"
    exit 1
fi
echo "✅ SSH connection verified"

# Create web directory 
echo "📁 Preparing web directory..."
ssh $SSH_OPTS $VPS_USER@$VPS_HOST "
    mkdir -p $VPS_PATH/html
    chown -R www-data:www-data $VPS_PATH/html || true
"

# Copy static files
echo "📤 Uploading static files..."
rsync -avz -e "ssh $SSH_OPTS" --delete \
    public/ $VPS_USER@$VPS_HOST:$VPS_PATH/html/

# Configure Nginx for static files
echo "🌐 Configuring Nginx..."
ssh $SSH_OPTS $VPS_USER@$VPS_HOST "
    cat > /etc/nginx/sites-available/botgarden << 'EOF'
server {
    listen 80;
    server_name _;
    
    root $VPS_PATH/html;
    index index.html;
    
    # Security headers
    add_header X-Frame-Options \"SAMEORIGIN\" always;
    add_header X-Content-Type-Options \"nosniff\" always;
    add_header X-XSS-Protection \"1; mode=block\" always;
    add_header Referrer-Policy \"no-referrer-when-downgrade\" always;
    
    # Main location
    location / {
        try_files \$uri \$uri/ /index.html;
        add_header Cache-Control \"public, max-age=3600\";
    }
    
    # Static assets cache
    location ~* \.(css|js|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control \"public, immutable\";
        add_header Vary Accept-Encoding;
    }
    
    # Health check
    location /health {
        access_log off;
        return 200 \"Bot Garden is running\";
        add_header Content-Type text/plain;
    }
    
    # Error pages
    error_page 404 /index.html;
}
EOF

    # Enable the site
    ln -sf /etc/nginx/sites-available/botgarden /etc/nginx/sites-enabled/
    rm -f /etc/nginx/sites-enabled/default
    
    # Test and reload nginx
    nginx -t && systemctl reload nginx
"

# Health check
echo "🏥 Performing health check..."
sleep 3

if curl -f --connect-timeout 10 --max-time 15 http://$VPS_HOST/health >/dev/null 2>&1; then
    echo "✅ Deployment successful! Site is healthy."
    echo "🌐 Your site is available at: http://$VPS_HOST"
else
    echo "⚠️  Health check failed, but site may still be working"
    echo "🌐 Check manually: http://$VPS_HOST"
fi

echo ""
echo "🎉 Static deployment completed!"
echo "================================"
echo "📋 Deployment summary:"
echo "   - Static files deployed to: $VPS_PATH/html"
echo "   - Nginx configured and reloaded"
echo "   - Site available at: http://$VPS_HOST"
echo ""
