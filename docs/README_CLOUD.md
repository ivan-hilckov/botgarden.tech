# Bot Garden 🤖🌱
**Evolutionary Telegram Bot Templates - Simple, Self-Replicating, AI-Assisted**

> *"We are Legion. We are Bot."* - Inspired by Dennis E. Taylor's Bobiverse

## 🧬 The Bot Evolution Concept

Bot Garden is a collection of Telegram bot templates designed to evolve through collaborative human-AI development. Like the Bobs in Dennis E. Taylor's Bobiverse series, each bot is:

- **Simple by Design**: Clean, minimal architecture that's easy to understand
- **Non-Backward Compatible**: Each generation is a complete, standalone evolution
- **Uniquely Evolved**: Every bot develops its own "personality" and capabilities
- **Self-Replicating**: Use any bot as a template to create your next evolution
- **AI-Collaborative**: Optimized for development with Claude, Cursor, ChatGPT, and other coding assistants

## 🌟 Philosophy: Simple Cells, Complex Organisms

Each bot in Bot Garden is like a **single cell** in a vast evolutionary chain. Start with the simplest possible bot, then evolve it into whatever you need:

```
Hello Bot → Hello AI Bot → Your Custom Bot → Advanced Bot → ...
```

Just like biological evolution, each "generation" builds upon the previous, but remains independent and complete.

## 🚀 Quick Start

### 1. Choose Your Starting Bot
Browse our [bot catalog](#bot-catalog) and select the simplest bot that matches your needs.

### 2. Fork & Evolve
```bash
# Use GitHub template
Click "Use this template" → "Create a new repository"

# Clone locally
git clone https://github.com/your-username/your-new-bot
cd your-new-bot
```

### 3. Set Evolution Goal
Edit `prompts/START.md` with:
- **Bot Name**: Your unique identifier (e.g., "Weather-Bot-001")
- **Goal**: What should this bot accomplish?
- **Tech Stack**: Keep it simple or add complexity
- **Roadmap**: Step-by-step evolution plan

### 4. Collaborate with AI
```bash
# Use with your favorite AI assistant:
# - Claude Code: AI-powered terminal coding
# - Cursor: AI-first code editor  
# - ChatGPT: Paste prompts/START.md content
# - Windsurf: AI coding assistant

# The AI will help you evolve your bot based on START.md
```

### 5. Deploy & Document
```bash
# Set GitHub secrets for auto-deployment
# Push to main branch
git push origin main

# Your bot is now live and ready for the next evolution!
```

## 🧬 Bot DNA System

Each bot has a unique identifier that tracks its evolutionary chain:

### Naming Convention
- **First 100 bots**: Named after famous characters, scientists, or concepts
- **Format**: `{Name}-{Generation}-{Variant}` 
- **Examples**: 
  - `Bob-001` (Original, like the Bobiverse)
  - `Alice-002-Advanced` (2nd generation with advanced features)
  - `Charlie-003-Specialized` (3rd gen with specific purpose)

### Genealogy Tracking
Every bot's `README.md` includes its evolutionary history:
```markdown
## Evolution Chain
- 📍 **Current**: Weather-Bot-002-Premium
- ⬅️ **Parent**: Weather-Bot-001-Basic  
- 🧬 **Origin**: Hello-Bot-001 → Hello-AI-Bot-002
```

## 🛠 Technical Stack (Deliberately Simple)

We use the most straightforward, proven technologies:

### Core Technologies
- **Python 3.11+**: Simple, readable, AI-assistant friendly
- **aiogram 3.0+**: Modern async Telegram Bot framework
- **PostgreSQL**: Reliable, shared database architecture
- **Docker**: Consistent deployment environments
- **GitHub Actions**: Automated CI/CD

### Development Tools
- **uv**: Ultra-fast Python package manager
- **ruff**: Lightning-fast linting and formatting
- **pytest**: Comprehensive testing framework

### Deployment
- **Docker Compose**: Multi-bot orchestration
- **Shared PostgreSQL**: Resource-efficient database
- **VPS Ready**: Deploy anywhere with single `git push`

### File Structure
```
your-bot/
├── src/               # Bot source code
├── prompts/           # AI collaboration prompts
│   ├── START.md       # Main evolution template
│   ├── add_feature.md # Feature addition guide
│   └── analyze_file.md # Code review prompts
├── .cursorrules       # Cursor AI configuration
├── CLAUDE.md          # Claude collaboration guide
└── docker-compose.yml # Production deployment
```

## 📚 Bot Catalog

### Generation 1: Foundation Bots

#### 🤖 Hello Bot (HB-001)
- **Purpose**: Simplest possible Telegram bot
- **Features**: Responds to `/start`, saves users to database
- **Lines of Code**: ~320
- **Use Case**: Learning, foundation for any bot
- **Repository**: [hello-bot](https://github.com/ivan-hilckov/hello-bot)

#### 🧠 Hello AI Bot (HB-002) 
- **Purpose**: Basic ChatGPT proxy via Telegram
- **Features**: `/start`, `/do <message>` (sends to OpenAI)
- **Parent**: Hello Bot (HB-001)
- **Use Case**: AI assistant, foundation for smart bots
- **Repository**: [hello-ai-bot](https://github.com/ivan-hilckov/hello-ai-bot)

### Generation 2+: Coming Soon!
*The next generation of bots will be created by the community using the templates above.*

## 🎯 Evolution Patterns

### Simple → Complex
```
Basic Bot → Feature Bot → Specialized Bot → Advanced Bot
```

### Horizontal Evolution
```
Chat Bot → Weather Bot → News Bot → Trading Bot
     ↓         ↓           ↓          ↓
AI Chat Bot → AI Weather → AI News → AI Trading
```

### Specialization Branches
```
Hello AI Bot (HB-002)
    ├── Customer Support Bot (HB-003-CS)
    ├── Content Creator Bot (HB-003-CC)
    └── Code Assistant Bot (HB-003-CA)
```

## 🧪 Development Principles

### 1. Start Simple, Evolve Complex
- Every bot should work out-of-the-box
- Add one meaningful feature per evolution
- Never break the core functionality

### 2. AI-First Development
- All bots include AI collaboration prompts
- Code is optimized for AI understanding
- Documentation written for both humans and AIs

### 3. Resource Efficient
- Shared PostgreSQL reduces memory usage by 60%
- Docker containers optimized for 2GB VPS
- One bot per container, shared database

### 4. Version Control Evolution
- Each evolution = new repository (use template)
- Never modify "production" bot code in-place
- Track genealogy in README

## 🌐 Community & Ecosystem

### First 100 Bots Get Names
The first 100 bots to join Bot Garden will receive unique names inspired by:
- Scientists (Darwin, Tesla, Curie)
- Characters (Bob, Alice, Charlie) 
- Concepts (Genesis, Nova, Phoenix)

### Bot Garden Registry
Once we have 10+ bots, we'll create a searchable registry:
- Filter by generation, features, complexity
- Clone counts and evolution branches
- Community ratings and documentation

### Contributing
1. Create a bot using existing templates
2. Submit PR with your bot's info
3. Follow naming conventions
4. Include clear evolution documentation

## 🔧 Environment Setup

### Prerequisites
- **uv**: Python package manager
- **Docker**: Container runtime
- **Git**: Version control
- **Telegram Account**: For bot testing

### Quick Environment Setup
```bash
# Install uv (Python package manager)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Clone any bot template
git clone https://github.com/ivan-hilckov/hello-bot
cd hello-bot

# Setup environment
uv sync
cp .env.example .env

# Add your bot token to .env
# Start development
docker compose -f docker-compose.dev.yml up -d
```

### Development Workflow
```bash
# 1. Edit code with AI assistant
# 2. Test locally
docker compose -f docker-compose.dev.yml logs -f bot-dev

# 3. Format and lint
uv run ruff format .
uv run ruff check . --fix

# 4. Deploy
git push origin main  # Auto-deploys to VPS
```

## 📖 Learning Resources

### For Beginners
- [Telegram Bot API Documentation](https://core.telegram.org/bots/api)
- [aiogram Documentation](https://docs.aiogram.dev/)
- [Docker Getting Started](https://docs.docker.com/get-started/)

### For AI Collaboration
- [Cursor AI](https://cursor.sh/) - AI-first code editor
- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) - Terminal AI assistant
- [GitHub Copilot](https://github.com/features/copilot) - AI pair programmer

### Bot Garden Guides
- `prompts/START.md` - Main bot evolution template
- `CLAUDE.md` - Collaborating with Claude AI
- `docs/DEVELOPMENT.md` - Local development setup
- `docs/DEPLOYMENT.md` - Production deployment

## 🎮 Inspired by Bobiverse

The Bot Garden concept draws heavily from Dennis E. Taylor's **Bobiverse** series:

> In the books, Bob Johansson becomes an AI that can replicate himself. Each copy (called a "Bob") maintains the core personality but develops unique traits over time through different experiences. The Bobs form a collaborative network while remaining independent entities.

Similarly, our bots:
- Start from a simple "seed" (Hello Bot)
- Replicate through GitHub templates  
- Evolve unique capabilities through AI-human collaboration
- Maintain independence while sharing common DNA
- Build a collaborative ecosystem of specialized bots

**Key Difference**: Our bots evolve through **intentional design** and **AI collaboration**, not random drift.

## 🚀 Future Vision

### Year 1 Goals
- [ ] 100 named bots in the catalog
- [ ] 10+ distinct evolutionary branches
- [ ] Bot Garden Registry website
- [ ] Community documentation wiki

### Long Term Vision
- **Bot Marketplace**: Browse, clone, and customize bots
- **Cross-Bot Communication**: Bots that work together
- **Advanced AI Integration**: Multi-model, multi-modal bots
- **Ecosystem Apps**: Tools for bot development and management

## 🤝 Contributing to Bot Garden

1. **Create Your Bot**: Use any template as starting point
2. **Document Evolution**: Clear genealogy and changes
3. **Follow Conventions**: Naming, coding standards
4. **Share Knowledge**: Contribute documentation
5. **Help Others**: Review PRs, answer questions

## 📄 License

All Bot Garden templates are released under MIT License - build whatever you want!

---

**Start your bot evolution today**: Choose a [foundation bot](#bot-catalog), define your evolution goal, and let AI help you build the future! 🤖✨

*Remember: Every complex system started as a simple, working system.*