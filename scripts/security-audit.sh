#!/bin/bash
# Security Audit Script
# Runs automated security scans and generates report

set -e

# Allow script to continue on errors in CI/CD
if [ -n "$SKIP_INTERACTIVE" ]; then
    set +e
fi

echo "🔒 Agent Factory Security Audit"
echo "================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Create reports directory
REPORTS_DIR="security-reports"
mkdir -p "$REPORTS_DIR"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo "📋 Running security scans..."
echo ""

# Check if tools are installed
echo "Checking dependencies..."
if ! command -v bandit &> /dev/null; then
    echo -e "${YELLOW}⚠️  bandit not installed. Installing...${NC}"
    pip install bandit
fi

if ! command -v safety &> /dev/null; then
    echo -e "${YELLOW}⚠️  safety not installed. Installing...${NC}"
    pip install safety
fi

# Run Bandit (Python security linter)
echo ""
echo "🔍 Running Bandit security scan..."
bandit -r agent_factory/ -f json -o "$REPORTS_DIR/bandit_${TIMESTAMP}.json" || true
bandit -r agent_factory/ -f txt -o "$REPORTS_DIR/bandit_${TIMESTAMP}.txt" || true

BANDIT_ISSUES=$(bandit -r agent_factory/ -f json | jq '.metrics._totals.HIGH + .metrics._totals.MEDIUM' 2>/dev/null || echo "0")

if [ "$BANDIT_ISSUES" -gt 0 ]; then
    echo -e "${RED}❌ Found $BANDIT_ISSUES security issues${NC}"
else
    echo -e "${GREEN}✅ No critical security issues found${NC}"
fi

# Run Safety (dependency vulnerability check)
echo ""
echo "🔍 Running Safety dependency check..."
safety check --json --output "$REPORTS_DIR/safety_${TIMESTAMP}.json" || true
safety check --output "$REPORTS_DIR/safety_${TIMESTAMP}.txt" || true

# Check for common security issues
echo ""
echo "🔍 Checking for common security issues..."

# Check for hardcoded secrets
echo "  - Checking for hardcoded secrets..."
SECRETS=$(grep -r "password\|secret\|api_key\|token" agent_factory/ --include="*.py" | grep -v ".env" | grep -v "example" | grep -v "test" | wc -l || echo "0")
if [ "$SECRETS" -gt 0 ]; then
    echo -e "  ${YELLOW}⚠️  Found $SECRETS potential secret references (review manually)${NC}"
else
    echo -e "  ${GREEN}✅ No obvious hardcoded secrets found${NC}"
fi

# Check for SQL injection risks
echo "  - Checking for SQL injection risks..."
SQL_RISKS=$(grep -r "execute\|query\|raw" agent_factory/ --include="*.py" | grep -v "test" | wc -l || echo "0")
if [ "$SQL_RISKS" -gt 0 ]; then
    echo -e "  ${YELLOW}⚠️  Found $SQL_RISKS SQL execution points (verify using parameterized queries)${NC}"
else
    echo -e "  ${GREEN}✅ No obvious SQL injection risks${NC}"
fi

# Generate summary report
echo ""
echo "📊 Generating summary report..."
cat > "$REPORTS_DIR/security_audit_summary_${TIMESTAMP}.md" << EOF
# Security Audit Summary

**Date:** $(date)
**Founder, CEO & Operator:** Scott Hardie
**Status:** Automated Scan

## Scan Results

### Bandit (Python Security Linter)
- **Report:** \`$REPORTS_DIR/bandit_${TIMESTAMP}.txt\`
- **JSON:** \`$REPORTS_DIR/bandit_${TIMESTAMP}.json\`
- **Issues Found:** $BANDIT_ISSUES

### Safety (Dependency Vulnerabilities)
- **Report:** \`$REPORTS_DIR/safety_${TIMESTAMP}.txt\`
- **JSON:** \`$REPORTS_DIR/safety_${TIMESTAMP}.json\`

### Manual Checks
- **Potential Secrets:** $SECRETS (review manually)
- **SQL Execution Points:** $SQL_RISKS (verify parameterized queries)

## Next Steps

1. Review Bandit report: \`cat $REPORTS_DIR/bandit_${TIMESTAMP}.txt\`
2. Review Safety report: \`cat $REPORTS_DIR/safety_${TIMESTAMP}.txt\`
3. Fix HIGH severity issues immediately
4. Fix MEDIUM severity issues within 1 week
5. Consider professional security audit for enterprise/education customers

## Files Generated

- \`$REPORTS_DIR/bandit_${TIMESTAMP}.txt\` - Bandit text report
- \`$REPORTS_DIR/bandit_${TIMESTAMP}.json\` - Bandit JSON report
- \`$REPORTS_DIR/safety_${TIMESTAMP}.txt\` - Safety text report
- \`$REPORTS_DIR/safety_${TIMESTAMP}.json\` - Safety JSON report
- \`$REPORTS_DIR/security_audit_summary_${TIMESTAMP}.md\` - This summary

---

**Note:** This is an automated scan. For enterprise/education customers, consider a professional security audit.

EOF

echo ""
echo -e "${GREEN}✅ Security audit complete!${NC}"
echo ""
echo "📄 Reports saved to: $REPORTS_DIR/"
echo "📋 Summary: $REPORTS_DIR/security_audit_summary_${TIMESTAMP}.md"
echo ""
echo "Next steps:"
echo "  1. Review reports: cat $REPORTS_DIR/bandit_${TIMESTAMP}.txt"
echo "  2. Fix HIGH severity issues"
echo "  3. Document fixes in yc/SECURITY_AUDIT.md"
