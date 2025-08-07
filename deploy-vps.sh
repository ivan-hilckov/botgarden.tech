#!/bin/bash

# Bot Garden Deployment Script
# Usage: ./deploy.sh [environment]
# Example: ./deploy.sh production

set -e

# Configuration
ENVIRONMENT=${1:-development}
PROJECT_NAME="botgarden-tech"

echo "🚀 Deploying Bot Garden Landing Page - Environment: $ENVIRONMENT"

# Load environment variables
if [ -f .env ]; then
    echo "📋 Loading environment variables..."
    export $(cat .env | grep -v '^#' | xargs)
else
    echo "⚠️  No .env file found. Using defaults or environment variables."
fi

# Development deployment (local)
if [ "$ENVIRONMENT" = "development" ] || [ "$ENVIRONMENT" = "dev" ]; then
    echo "🔧 Starting development environment..."
    
    # Install dependencies if needed
    if [ ! -d node_modules ]; then
        echo "📦 Installing dependencies..."
        npm install
    fi
    
    # Start local development server
    echo "🌐 Starting local server at http://localhost:3000"
    npm run dev
    
# Production deployment (VPS)
elif [ "$ENVIRONMENT" = "production" ] || [ "$ENVIRONMENT" = "prod" ]; then
    echo "🏭 Deploying to production server..."
    
    # Check required variables first
    if [ -z "$VPS_HOST" ] || [ -z "$VPS_USER" ]; then
        echo "❌ Error: VPS_HOST and VPS_USER must be set in .env file"
        echo "Example .env:"
        echo "VPS_HOST=your-server.com"
        echo "VPS_USER=your-username"
        echo "VPS_PORT=49339"
        exit 1
    fi
    
    VPS_PATH=${VPS_PATH:-"/var/www/botgarden"}
    VPS_PORT=${VPS_PORT:-"22"}
    SSH_OPTS="-p $VPS_PORT"
    
    echo "🎯 Target: $VPS_USER@$VPS_HOST:$VPS_PORT"
    echo "📁 Deploy path: $VPS_PATH"
    echo ""
    
    # Simple deployment readiness check
    echo "🔍 Checking basic deployment requirements..."
    
    # Test SSH connectivity
    if ! ssh $SSH_OPTS -o ConnectTimeout=5 $VPS_USER@$VPS_HOST "echo 'SSH OK'" >/dev/null 2>&1; then
        echo "❌ SSH connection failed!"
        echo ""
        echo "💡 Troubleshooting steps:"
        echo "1. Check .env configuration (VPS_HOST, VPS_USER, VPS_PORT)"
        echo "2. Verify SSH access manually"
        echo "3. Run VPS analysis: ./collect-vps-data.sh"
        echo ""
        exit 1
    fi
    
    # Check if Nginx is available (for static deployment)
    if ! ssh $SSH_OPTS $VPS_USER@$VPS_HOST "nginx -v" >/dev/null 2>&1; then
        echo "⚠️  Nginx not found on VPS!"
        echo ""
        echo "Options:"
        echo "1. Run VPS setup: ./setup-vps.sh"
        echo "2. Continue anyway (may fail)"
        echo "3. Cancel deployment"
        echo ""
        echo "Choose option (1-3): "
        read -r choice
        case $choice in
            1)
                echo "🚀 Running VPS setup..."
                ./setup-vps.sh
                echo "✅ VPS setup completed. Continuing with deployment..."
                ;;
            2)
                echo "⚠️  Continuing without Nginx verification..."
                ;;
            3|*)
                echo "❌ Deployment cancelled"
                exit 1
                ;;
        esac
    else
        echo "✅ SSH and Nginx verified, proceeding with static deployment"
    fi
    echo ""
    
    echo "📡 Connecting to $VPS_USER@$VPS_HOST:$VPS_PORT"
    echo "📁 Deploying to $VPS_PATH"
    
    # Use static deployment script
    echo "🌐 Deploying static files..."
    ./deploy-static.sh
    
# Build only (for CI/CD)
elif [ "$ENVIRONMENT" = "build" ]; then
    echo "🔨 Building production assets..."
    
    # Create dist directory
    mkdir -p dist
    
    # Copy public files to dist
    cp -r public/* dist/
    
    echo "✅ Build complete. Files are in ./dist/"
    
else
    echo "❌ Unknown environment: $ENVIRONMENT"
    echo "Usage: ./deploy.sh [development|production|build]"
    exit 1
fi

echo "🎉 Deployment complete!"
