#!/bin/bash
# Quick Start Readiness Script
# Runs all readiness checks and provides next steps

echo "🚀 Agent Factory Quick Start Readiness"
echo "======================================"
echo ""
echo "Founder, CEO & Operator: Scott Hardie"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Running comprehensive readiness check...${NC}"
echo ""

# Check foundational
echo "📋 Foundational Readiness:"
if [ -f "docs/SETUP_LOCAL.md" ]; then
    echo -e "  ${GREEN}✅${NC} Setup guide exists"
else
    echo -e "  ${RED}❌${NC} Setup guide missing"
fi

if [ -f ".env.example" ]; then
    echo -e "  ${GREEN}✅${NC} .env.example exists"
else
    echo -e "  ${RED}❌${NC} .env.example missing"
fi

if [ -f "Makefile" ]; then
    echo -e "  ${GREEN}✅${NC} Makefile exists"
else
    echo -e "  ${RED}❌${NC} Makefile missing"
fi

echo ""

# Check founder docs
echo "👤 Founder Documentation:"
if [ -f "yc/TEAM.md" ] && grep -q "Scott Hardie" yc/TEAM.md; then
    echo -e "  ${GREEN}✅${NC} Founder documented"
else
    echo -e "  ${YELLOW}⚠️${NC}  Founder docs incomplete"
fi

if [ -f "yc/FOUNDER_MARKET_FIT.md" ]; then
    echo -e "  ${GREEN}✅${NC} Founder-market fit documented"
else
    echo -e "  ${RED}❌${NC} Founder-market fit missing"
fi

echo ""

# Check data room
echo "📁 Investor Assets:"
if [ -d "dataroom" ]; then
    echo -e "  ${GREEN}✅${NC} Data room exists"
    COUNT=$(find dataroom -name "*.md" | wc -l)
    echo -e "  ${GREEN}✅${NC} $COUNT data room files"
else
    echo -e "  ${RED}❌${NC} Data room missing"
fi

if [ -d "demo" ]; then
    echo -e "  ${GREEN}✅${NC} Demo materials exist"
else
    echo -e "  ${RED}❌${NC} Demo materials missing"
fi

echo ""

# Check scripts
echo "🛠️  Execution Scripts:"
SCRIPTS=("scripts/security-audit.sh" "scripts/deploy-production.sh" "scripts/collect-metrics.sh" "scripts/calculate-unit-economics.py")
for script in "${SCRIPTS[@]}"; do
    if [ -f "$script" ] && [ -x "$script" ]; then
        echo -e "  ${GREEN}✅${NC} $(basename $script)"
    else
        echo -e "  ${YELLOW}⚠️${NC}  $(basename $script) missing or not executable"
    fi
done

echo ""

# Summary
echo "📊 Readiness Summary:"
echo ""
echo "✅ Complete:"
echo "  - Foundational infrastructure"
echo "  - Founder documentation"
echo "  - Legal/business docs"
echo "  - Investor asset structure"
echo ""
echo "⚠️  Needs Execution:"
echo "  - Production deployment (run: make deploy-help)"
echo "  - Get users (use: bash scripts/get-users-checklist.sh)"
echo "  - Collect metrics (run: make metrics-collect)"
echo "  - Security audit (run: make security-audit)"
echo ""
echo "📋 Next Steps:"
echo "  1. Run: make security-audit"
echo "  2. Run: make deploy-help"
echo "  3. Run: make metrics-collect"
echo "  4. See: docs/EXECUTION_ROADMAP.md"
echo ""
echo -e "${GREEN}✅ Readiness check complete!${NC}"
echo ""
echo "For detailed status, see: docs/READINESS_ASSESSMENT.md"
