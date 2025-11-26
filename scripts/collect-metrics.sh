#!/bin/bash
# Metrics Collection Script
# Collects baseline metrics and generates snapshot

set -e

echo "📊 Agent Factory Metrics Collection"
echo "===================================="
echo ""
echo "Founder, CEO & Operator: Scott Hardie"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

TIMESTAMP=$(date +%Y-%m-%d)
METRICS_FILE="yc/METRICS_SNAPSHOT.md"

# Check if production URL is set
if [ -z "$PRODUCTION_URL" ]; then
    if [ -n "$SKIP_INTERACTIVE" ] || [ ! -t 0 ]; then
        # Non-interactive mode (CI/CD)
        PRODUCTION_URL=${1:-http://localhost:8000}
    else
        # Interactive mode
        echo -e "${YELLOW}⚠️  PRODUCTION_URL not set${NC}"
        echo "Set it with: export PRODUCTION_URL=https://your-domain.com"
        echo "Or provide as argument: ./scripts/collect-metrics.sh https://your-domain.com"
        echo ""
        read -p "Enter production URL (or press Enter to use localhost:8000): " url
        PRODUCTION_URL=${url:-http://localhost:8000}
    fi
fi

echo "Using URL: $PRODUCTION_URL"
echo ""

# Test connection
echo "🔍 Testing connection..."
if command -v curl &> /dev/null; then
    HEALTH=$(curl -s "$PRODUCTION_URL/health" || echo "{}")
    if echo "$HEALTH" | grep -q "healthy\|status"; then
        echo -e "${GREEN}✅ Connection successful${NC}"
    else
        echo -e "${YELLOW}⚠️  Health check failed or server not running${NC}"
        echo "Start server: uvicorn agent_factory.api.main:app --reload"
    fi
else
    echo "⚠️  curl not found, skipping connection test"
fi

echo ""
echo "📋 Collecting metrics..."
echo ""

# Try to get metrics endpoint
METRICS_DATA=""
if command -v curl &> /dev/null; then
    METRICS_DATA=$(curl -s "$PRODUCTION_URL/metrics" 2>/dev/null || echo "")
fi

# Generate metrics snapshot
cat > "$METRICS_FILE" << EOF
# Metrics Snapshot

**Date:** $TIMESTAMP  
**Founder, CEO & Operator:** Scott Hardie  
**Source:** Production deployment at $PRODUCTION_URL

---

## Current Metrics (Baseline)

### Users
- **Total Signups:** [TO BE FILLED - check database or admin panel]
- **Active Users (DAU):** [TO BE FILLED]
- **Activated Users:** [TO BE FILLED] (deployed first agent)
- **Retention:**
  - Day 1: [TO BE FILLED]%
  - Day 7: [TO BE FILLED]%
  - Day 30: [TO BE FILLED]%

**How to Get:**
\`\`\`sql
-- Query database for user counts
SELECT COUNT(*) as total_users FROM users;
SELECT COUNT(*) as activated_users FROM users WHERE activated_at IS NOT NULL;
\`\`\`

### Usage
- **Agent Runs:** [TO BE FILLED - check telemetry events]
- **API Calls:** [TO BE FILLED]
- **Workflows Executed:** [TO BE FILLED]
- **Blueprints Installed:** [TO BE FILLED]

**How to Get:**
\`\`\`sql
-- Query telemetry events
SELECT COUNT(*) as agent_runs FROM events WHERE event_type = 'AGENT_RUN';
SELECT COUNT(*) as blueprint_installs FROM events WHERE event_type = 'BLUEPRINT_INSTALL';
\`\`\`

Or check metrics endpoint: \`curl $PRODUCTION_URL/metrics\`

### Revenue
- **MRR:** \$0 (pre-revenue)
- **ARR:** \$0
- **Customers:** 0 (paying)
- **ARPU:** [TO BE FILLED]

**Status:** Pre-revenue - need first paying customers

### Growth
- **MoM Growth Rate:** [TO BE FILLED]%
- **Signup Rate:** [TO BE FILLED] signups/week
- **Activation Rate:** [TO BE FILLED]% (signup → activation)

---

## Metrics Collection Commands

### Check Health
\`\`\`bash
curl $PRODUCTION_URL/health
\`\`\`

### Get Metrics (Prometheus format)
\`\`\`bash
curl $PRODUCTION_URL/metrics
\`\`\`

### Query Database Directly
\`\`\`bash
# Connect to Supabase/PostgreSQL
psql \$DATABASE_URL

# Count users
SELECT COUNT(*) FROM users;

# Count agent runs
SELECT COUNT(*) FROM events WHERE event_type = 'AGENT_RUN';

# Count by date
SELECT DATE(created_at), COUNT(*) 
FROM events 
WHERE event_type = 'AGENT_RUN' 
GROUP BY DATE(created_at) 
ORDER BY DATE(created_at) DESC;
\`\`\`

---

## Metrics Infrastructure Status

**Telemetry:** ✅ Ready (agent_factory/telemetry/)  
**Metrics Endpoint:** ✅ Ready ($PRODUCTION_URL/metrics)  
**Health Check:** ✅ Ready ($PRODUCTION_URL/health)  
**Dashboard:** ⚠️ Not deployed (infrastructure ready)

**Events Tracked:**
- \`USER_SIGNUP\`, \`USER_LOGIN\`, \`USER_ACTIVATED\`
- \`AGENT_RUN\`, \`WORKFLOW_RUN\`
- \`BLUEPRINT_INSTALL\`
- \`BILLING_USAGE\`, \`REVENUE\`
- \`REFERRAL_SENT\`, \`REFERRAL_CONVERTED\`

---

## Next Steps

1. **Use the app yourself:**
   - Create agents
   - Run agents
   - Install blueprints
   - Generate activity

2. **Query metrics:**
   - Use commands above
   - Check database directly
   - Use metrics endpoint

3. **Set up dashboard:**
   - Mixpanel (recommended for quick setup)
   - Amplitude
   - Grafana + Prometheus

4. **Document baseline:**
   - Fill in numbers above (even if zeros)
   - Update this file weekly
   - Track progress

---

**Last Updated:** $TIMESTAMP  
**Next Update:** [Set weekly reminder]

EOF

echo -e "${GREEN}✅ Metrics snapshot created: $METRICS_FILE${NC}"
echo ""
echo "Next steps:"
echo "  1. Use the app to generate activity"
echo "  2. Query database or metrics endpoint"
echo "  3. Fill in numbers in $METRICS_FILE"
echo "  4. Set up metrics dashboard (Mixpanel/Amplitude)"
echo ""
echo "To query database:"
echo "  psql \$DATABASE_URL"
echo "  SELECT COUNT(*) FROM users;"
echo "  SELECT COUNT(*) FROM events WHERE event_type = 'AGENT_RUN';"
