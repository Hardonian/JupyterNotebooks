#!/bin/bash
# Production Deployment Helper Script
# Guides through production deployment process

set -e

echo "🚀 Agent Factory Production Deployment Helper"
echo "=============================================="
echo ""
echo "Founder, CEO & Operator: Scott Hardie"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}This script will guide you through production deployment.${NC}"
echo ""

# Check prerequisites
echo "📋 Checking prerequisites..."
echo ""

# Check if .env.example exists
if [ ! -f .env.example ]; then
    echo "❌ .env.example not found!"
    exit 1
fi
echo "✅ .env.example found"

# Check if git is initialized
if [ ! -d .git ]; then
    echo "❌ Git not initialized!"
    exit 1
fi
echo "✅ Git repository found"

# Check Python
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 not found!"
    exit 1
fi
echo "✅ Python 3 found"

echo ""
echo -e "${YELLOW}⚠️  IMPORTANT: Before deploying, ensure you have:${NC}"
echo "  1. Production database (Supabase recommended)"
echo "  2. OpenAI API key (or Anthropic)"
echo "  3. Hosting account (Vercel/Render)"
echo "  4. Domain (optional but recommended)"
echo ""

read -p "Do you have all prerequisites? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "Please set up prerequisites first. See docs/deploy-strategy.md"
    exit 1
fi

echo ""
echo "Choose deployment platform:"
echo "  1) Vercel (Recommended - Easiest)"
echo "  2) Render"
echo "  3) Docker (Self-hosted)"
echo "  4) Skip (I'll deploy manually)"
echo ""
read -p "Enter choice (1-4): " choice

case $choice in
    1)
        echo ""
        echo "📦 Vercel Deployment"
        echo "==================="
        echo ""
        echo "Steps:"
        echo "  1. Create Vercel account: https://vercel.com"
        echo "  2. Install Vercel CLI: npm i -g vercel"
        echo "  3. Login: vercel login"
        echo "  4. Link project: vercel link"
        echo "  5. Set environment variables in Vercel dashboard"
        echo "  6. Deploy: vercel --prod"
        echo ""
        echo "Required environment variables:"
        echo "  - DATABASE_URL"
        echo "  - OPENAI_API_KEY (or ANTHROPIC_API_KEY)"
        echo "  - JWT_SECRET_KEY"
        echo "  - (See .env.example for full list)"
        echo ""
        echo "📖 Full guide: docs/deploy-strategy.md"
        ;;
    2)
        echo ""
        echo "📦 Render Deployment"
        echo "===================="
        echo ""
        echo "Steps:"
        echo "  1. Create Render account: https://render.com"
        echo "  2. Create new Web Service"
        echo "  3. Connect GitHub repository"
        echo "  4. Set environment variables in Render dashboard"
        echo "  5. Deploy (automatic on git push)"
        echo ""
        echo "Configuration file: deployment/render.yaml"
        echo "📖 Full guide: docs/deploy-strategy.md"
        ;;
    3)
        echo ""
        echo "📦 Docker Deployment"
        echo "==================="
        echo ""
        echo "Steps:"
        echo "  1. Build image: docker build -t agent-factory ."
        echo "  2. Run container: docker-compose -f docker/docker-compose.prod.yml up"
        echo ""
        echo "📖 Full guide: docker/README.md"
        ;;
    4)
        echo ""
        echo "Skipping automated deployment."
        echo "See docs/deploy-strategy.md for manual deployment steps."
        ;;
    *)
        echo "Invalid choice"
        exit 1
        ;;
esac

echo ""
echo "🔍 Pre-deployment checklist:"
echo ""
echo "Before deploying, verify:"
echo "  [ ] Production database created and accessible"
echo "  [ ] Environment variables documented"
echo "  [ ] Database migrations tested locally"
echo "  [ ] Health check endpoint works locally"
echo "  [ ] API keys valid and have credits"
echo ""

read -p "Run pre-deployment checks? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "Running checks..."
    
    # Check if .env exists
    if [ -f .env ]; then
        echo "✅ .env file exists"
    else
        echo "⚠️  .env file not found (create from .env.example)"
    fi
    
    # Check database connection (if DATABASE_URL set)
    if [ -f .env ] && grep -q "DATABASE_URL" .env; then
        echo "✅ DATABASE_URL found in .env"
    else
        echo "⚠️  DATABASE_URL not set"
    fi
    
    # Check API keys
    if [ -f .env ] && (grep -q "OPENAI_API_KEY" .env || grep -q "ANTHROPIC_API_KEY" .env); then
        echo "✅ LLM API key found"
    else
        echo "⚠️  LLM API key not set"
    fi
    
    # Test health endpoint locally
    echo ""
    echo "Testing health endpoint locally..."
    if command -v curl &> /dev/null; then
        # Try to start server in background and test
        echo "  (Start server manually: uvicorn agent_factory.api.main:app --reload)"
        echo "  (Then test: curl http://localhost:8000/health)"
    fi
fi

echo ""
echo -e "${GREEN}✅ Deployment helper complete!${NC}"
echo ""
echo "Next steps:"
echo "  1. Deploy to chosen platform"
echo "  2. Test production URL: curl https://your-domain.com/health"
echo "  3. Document production URL in docs/VENTURE_OS_LOG.md"
echo "  4. Update dataroom docs with production URL"
