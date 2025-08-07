# Bot Garden Landing Page 🤖🌱

**Evolutionary Telegram Bot Templates Landing Page**

Visit: [botgarden.tech](https://botgarden.tech)

## 🚀 Quick Start

### Local Development
```bash
# Install dependencies
npm install

# Start development server
npm run dev
# Opens http://localhost:3000
```

### Production Deployment

1. **Configure Environment**
   ```bash
   cp env.example .env
   # Edit .env with your VPS details
   ```

2. **Deploy to VPS**
   ```bash
   ./deploy.sh production
   ```

## 📁 Project Structure

```
botgarden.tech/
├── public/                 # Static website files
│   ├── index.html         # Main landing page  
│   └── assets/            # Images, icons
├── Dockerfile             # Production container
├── nginx.conf             # Nginx configuration
├── docker-compose.yml     # Container orchestration
├── deploy.sh              # Deployment script
└── package.json           # Node.js dependencies
```

## 🛠 Technology Stack

- **Frontend**: HTML5, CSS3, Vanilla JavaScript
- **Production**: Docker + Nginx
- **Deployment**: SSH + Docker Compose
- **Development**: Node.js http-server

## 🎨 Features

- **Mobile-First Responsive Design**
- **SEO Optimized** with meta tags and structured data
- **Analytics Ready** with Yandex.Metrika integration and goal tracking
- **Performance Optimized** with gzip compression and caching
- **Accessibility Compliant** (WCAG 2.1 AA)
- **Docker Containerized** for consistent deployment
- **Zero-Config Production** deployment

## 📊 SEO & Performance

- **Lighthouse Score**: 95+ target
- **Page Load Time**: <2 seconds
- **Mobile Optimization**: 100% responsive
- **Meta Tags**: Complete Open Graph and Twitter Cards
- **Structured Data**: JSON-LD for search engines

## 🚀 Deployment Options

### Development
```bash
npm run dev           # Local development server
npm run build         # Build static assets
npm run preview       # Preview production build
```

### Production
```bash
./collect-vps-data.sh     # Collect VPS data for analysis
./setup-vps.sh           # Setup VPS environment  
./deploy-vps.sh production # Deploy to VPS
./deploy-vps.sh build     # Build only (for CI/CD)
```

### Docker
```bash
docker build -t botgarden .
docker run -p 80:80 botgarden
```

## 🔧 Configuration

### Environment Variables (.env)
```env
VPS_HOST=your-server.com     # Production server
VPS_USER=your-username       # SSH username
VPS_PORT=22                  # SSH port (default: 22)
VPS_PATH=/var/www/botgarden  # Deployment path
DOMAIN=botgarden.tech        # Domain name
EMAIL=your@email.com         # SSL certificate email
YANDEX_METRIKA_ID=103627063  # Yandex.Metrika counter ID
```

### Nginx Features
- Gzip compression
- Static asset caching
- Security headers
- Health check endpoint
- Error page handling

### Analytics & Tracking
Yandex.Metrika counter (ID: 103627063) with the following goals:
- **code-copy**: User copies code examples
- **cta-click**: Primary CTA button interactions
- **bot-clone**: Bot repository link clicks

All goals include additional parameters for detailed analysis.

## 🔍 VPS Analysis & Setup

Simple 3-script workflow for VPS deployment:

### 1. VPS Data Collection
```bash
./collect-vps-data.sh
```
**What it does:**
- Collects comprehensive VPS information (25+ data sections)
- Creates structured analysis file for optimization
- Tests SSH connectivity and system resources
- Analyzes hardware, software, security, performance
- Generates AI-readable report with recommendations

**Output:** `vps-analysis.txt` with detailed system information

### 2. VPS Environment Setup
```bash
./setup-vps.sh
```
**What it does:**
- Installs Docker & Docker Compose
- Installs required tools (Git, rsync, nginx)
- Secures SSH configuration
- Prepares Bot Garden directories
- Configures nginx for deployment

**Note:** Firewall setup excluded to prevent SSH lockout

### 3. Bot Garden Deployment
```bash
./deploy-vps.sh production
```
**What it does:**
- Deploys Bot Garden to prepared VPS
- Builds and starts Docker containers
- Performs health checks
- Provides deployment status

### Complete Workflow
```bash
# 1. Analyze VPS
./collect-vps-data.sh && cat vps-analysis.txt

# 2. Setup VPS environment  
./setup-vps.sh

# 3. Deploy Bot Garden
./deploy-vps.sh production
```

## 🎯 Bot Garden Concept

This landing page showcases the **Bot Garden** ecosystem - evolutionary Telegram bot templates inspired by Dennis E. Taylor's Bobiverse series.

### Core Philosophy
- **Simple bots, endless evolution**
- Start with Hello Bot (HB-001)
- Evolve through AI collaboration
- Production-ready from day one

### Current Bots
- **HB-001**: [Hello Bot](https://github.com/ivan-hilckov/hello-bot) - Simple foundation
- **HB-002**: [Hello AI Bot](https://github.com/ivan-hilckov/hello-ai-bot) - AI integration
- **HB-XXX**: Your evolution starts here

## 📈 Performance Targets

- ✅ **Page Load**: <2 seconds
- ✅ **Lighthouse SEO**: 95+
- ✅ **Mobile Responsive**: 100%
- ✅ **Accessibility**: WCAG 2.1 AA
- ✅ **Docker Build**: <30 seconds

## 🤝 Contributing

The landing page evolves alongside the Bot Garden ecosystem:

1. **Content Updates**: Bot catalog, success stories
2. **Performance Optimization**: Speed and SEO improvements  
3. **Feature Additions**: Interactive elements, animations
4. **Documentation**: Setup guides, tutorials

## 📄 License

MIT License - Build whatever you want!

---

**Start your bot evolution today**: Choose a foundation bot, define your evolution goal, and let AI help you build the future! 🤖✨
