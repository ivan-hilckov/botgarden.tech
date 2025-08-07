#!/bin/bash

# VPS Data Collection Script for AI Analysis
# This script collects comprehensive VPS information in a structured format
# for AI assistant to analyze and optimize deployment strategy

set -e

SCRIPT_VERSION="1.0.0"
LOG_FILE="vps-analysis.txt"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S %Z')

echo "🔍 Collecting VPS data for AI analysis..."
echo "========================================"

# Load environment variables
if [ -f .env ]; then
    echo "📋 Loading environment variables from .env..."
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
echo "📄 Output: $LOG_FILE"
echo ""

# Function to collect data via SSH
collect_data() {
    local section="$1"
    local command="$2"
    local label="$3"
    
    echo "Collecting: $label"
    
    echo "=== $section ===" >> "$LOG_FILE"
    echo "Command: $command" >> "$LOG_FILE"
    echo "Timestamp: $TIMESTAMP" >> "$LOG_FILE"
    echo "" >> "$LOG_FILE"
    
    if ssh $SSH_OPTS $VPS_USER@$VPS_HOST "$command" >> "$LOG_FILE" 2>&1; then
        echo "✅ $label - collected"
    else
        echo "⚠️  $label - failed to collect"
        echo "ERROR: Failed to collect $label" >> "$LOG_FILE"
    fi
    
    echo "" >> "$LOG_FILE"
    echo "--- END $section ---" >> "$LOG_FILE"
    echo "" >> "$LOG_FILE"
}

# Initialize log file
cat > "$LOG_FILE" << EOF
VPS ANALYSIS DATA FOR AI ASSISTANT
===================================
Generated: $TIMESTAMP
Script Version: $SCRIPT_VERSION
Target VPS: $VPS_USER@$VPS_HOST:$VPS_PORT
Local User: $(whoami)
Local System: $(uname -s)

INSTRUCTIONS FOR AI:
This file contains structured data about the VPS environment.
Please analyze this data and provide:
1. Deployment optimization recommendations
2. Performance tuning suggestions  
3. Security improvements
4. Resource allocation advice
5. Bot Garden specific optimizations

=====================================

EOF

# Test SSH connectivity first
echo "1. Testing SSH connectivity..."
if ssh $SSH_OPTS -o ConnectTimeout=10 $VPS_USER@$VPS_HOST "echo 'SSH_CONNECTION_OK'" >> "$LOG_FILE" 2>&1; then
    echo "✅ SSH connection successful"
else
    echo "❌ SSH connection failed"
    echo "SSH_CONNECTION_FAILED" >> "$LOG_FILE"
    exit 1
fi

# System Information
echo ""
echo "2. Collecting system information..."
collect_data "SYSTEM_INFO" "cat /etc/os-release; echo '---'; uname -a; echo '---'; uptime; echo '---'; whoami; echo '---'; pwd" "OS and kernel info"

# Hardware Resources
echo "3. Collecting hardware information..."
collect_data "HARDWARE_CPU" "cat /proc/cpuinfo" "CPU information"
collect_data "HARDWARE_MEMORY" "free -h; echo '---'; cat /proc/meminfo" "Memory information"
collect_data "HARDWARE_DISK" "df -h; echo '---'; lsblk; echo '---'; du -sh /var /home /tmp 2>/dev/null || echo 'Some directories not accessible'" "Disk information"

# Network Configuration
echo "4. Collecting network configuration..."
collect_data "NETWORK_INTERFACES" "ip addr show 2>/dev/null || ifconfig 2>/dev/null || echo 'Network info not available'" "Network interfaces"
collect_data "NETWORK_LISTENING" "ss -tuln 2>/dev/null || netstat -tuln 2>/dev/null || echo 'Port info not available'" "Listening ports"
collect_data "NETWORK_ROUTES" "ip route show 2>/dev/null || route -n 2>/dev/null || echo 'Route info not available'" "Network routes"

# Software Environment
echo "5. Collecting software environment..."
collect_data "SOFTWARE_PACKAGES" "which apt yum dnf pacman 2>/dev/null | head -1; echo '---'; dpkg --version 2>/dev/null || rpm --version 2>/dev/null || echo 'Package manager info not available'" "Package managers"
collect_data "SOFTWARE_DOCKER" "docker --version 2>/dev/null || echo 'Docker not installed'; echo '---'; docker info 2>/dev/null || echo 'Docker info not available'; echo '---'; docker ps -a 2>/dev/null || echo 'Docker containers not accessible'" "Docker environment"
collect_data "SOFTWARE_COMPOSE" "docker-compose --version 2>/dev/null || echo 'Docker Compose not installed'" "Docker Compose"
collect_data "SOFTWARE_WEBSERVER" "nginx -v 2>&1 || echo 'Nginx not installed'; echo '---'; apache2 -v 2>/dev/null || httpd -v 2>/dev/null || echo 'Apache not installed'" "Web servers"

# Services and Processes
echo "6. Collecting services information..."
collect_data "SERVICES_SYSTEMD" "systemctl list-units --type=service --state=active 2>/dev/null || service --status-all 2>/dev/null || echo 'Service info not available'" "Active services"
collect_data "SERVICES_PROCESSES" "ps aux --sort=-%mem | head -15; echo '---'; ps aux --sort=-%cpu | head -15" "Running processes"

# Security Configuration  
echo "7. Collecting security configuration..."
collect_data "SECURITY_SSH" "grep -E '(Port|PermitRootLogin|PasswordAuthentication|PubkeyAuthentication)' /etc/ssh/sshd_config 2>/dev/null || echo 'SSH config not accessible'" "SSH configuration"
collect_data "SECURITY_FIREWALL" "ufw status verbose 2>/dev/null || iptables -L -n 2>/dev/null || echo 'Firewall info not accessible'" "Firewall status"
collect_data "SECURITY_USERS" "cat /etc/passwd | grep -E '(root|ubuntu|debian|centos|admin|www-data)' 2>/dev/null || echo 'User info not accessible'" "System users"

# File System and Permissions
echo "8. Collecting filesystem information..."
collect_data "FILESYSTEM_STRUCTURE" "ls -la /; echo '---'; ls -la /var/www/ 2>/dev/null || echo '/var/www not accessible'; echo '---'; ls -la /home/ 2>/dev/null || echo '/home not accessible'" "Directory structure"
collect_data "FILESYSTEM_MOUNTS" "mount | grep -E '(ext|xfs|btrfs)' || echo 'Mount info not available'" "File system mounts"

# Performance Metrics
echo "9. Collecting performance metrics..."
collect_data "PERFORMANCE_LOAD" "cat /proc/loadavg; echo '---'; top -bn1 | head -20" "System load"
collect_data "PERFORMANCE_IO" "iostat -x 1 1 2>/dev/null || echo 'iostat not available'" "I/O statistics"

# Bot Garden Specific
echo "10. Collecting Bot Garden specific information..."
collect_data "BOTGARDEN_ENV" "echo 'Checking deployment environment'; echo 'VPS_PATH: ${VPS_PATH:-/var/www/botgarden}'; echo 'User: $(whoami)'; echo 'Groups: $(groups)'; echo 'Docker group: $(groups | grep docker && echo YES || echo NO)'" "Deployment environment"
collect_data "BOTGARDEN_PATHS" "ls -la ${VPS_PATH:-/var/www/botgarden} 2>/dev/null || echo 'Deployment path does not exist'; echo '---'; which git curl rsync wget 2>/dev/null || echo 'Some tools missing'" "Required tools and paths"

# Final system snapshot
echo "11. Collecting final system snapshot..."
collect_data "SNAPSHOT_FINAL" "date; echo '---'; df -h | head -10; echo '---'; free -h; echo '---'; ps aux | wc -l; echo 'Total processes'" "Final snapshot"

# Add analysis instructions
cat >> "$LOG_FILE" << EOF

=== ANALYSIS INSTRUCTIONS FOR AI ===

CRITICAL QUESTIONS TO ANSWER:
1. Is this VPS ready for Bot Garden deployment?
2. What are the main blockers (if any)?
3. What optimizations are needed?
4. What security improvements should be made?
5. What is the recommended deployment strategy?

RESOURCE ANALYSIS:
- Memory: Sufficient for how many Bot Garden instances?
- CPU: Performance expectations?
- Disk: Growth planning needed?
- Network: Any bandwidth considerations?

DEPLOYMENT STRATEGY:
- Docker installation needed?
- Nginx configuration required?
- SSL setup recommendations?
- Monitoring setup suggestions?

SECURITY REVIEW:
- SSH hardening needed?
- Firewall configuration optimal?
- User permissions appropriate?
- Any security vulnerabilities?

Please provide specific, actionable recommendations.

=== END ANALYSIS INSTRUCTIONS ===
EOF

echo ""
echo "✅ VPS data collection completed!"
echo "📄 Analysis file: $LOG_FILE"
echo ""
echo "🤖 Next steps:"
echo "   1. Review the generated file: cat $LOG_FILE"
echo "   2. Share this file with AI assistant for analysis"
echo "   3. Implement AI recommendations"
echo "   4. Run deployment: ./deploy.sh production"
echo ""

# Display summary
echo "📊 COLLECTION SUMMARY:"
echo "====================="
TOTAL_SECTIONS=$(grep -c "=== .* ===" "$LOG_FILE" || echo "0")
ERROR_SECTIONS=$(grep -c "ERROR: Failed to collect" "$LOG_FILE" || echo "0")
SUCCESS_SECTIONS=$((TOTAL_SECTIONS - ERROR_SECTIONS))

echo "Total sections: $TOTAL_SECTIONS"
echo "Successful: $SUCCESS_SECTIONS"
echo "Failed: $ERROR_SECTIONS"

if [ "$ERROR_SECTIONS" -eq 0 ]; then
    echo "🎉 All data collected successfully!"
else
    echo "⚠️  Some data collection failed - check the log file"
fi

echo ""
echo "📋 File size: $(wc -l < "$LOG_FILE") lines, $(du -h "$LOG_FILE" | cut -f1)"
