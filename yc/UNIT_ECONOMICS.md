# Unit Economics - Agent Factory

**For:** Y Combinator Application & Interview  
**Last Updated:** 2024-01-XX

---

## Overview

This document calculates and tracks unit economics for Agent Factory. Unit economics show whether our business model is viable at the unit level (per customer).

---

## Key Metrics

### CAC (Customer Acquisition Cost)

**Definition:** How much it costs to acquire one paying customer.

**Formula:** Marketing Spend / New Paying Customers

**Current:** $[X] per customer

**By Channel:**
- Organic/SEO: $[X]
- Paid Ads: $[X]
- Partnerships: $[X]
- Referrals: $[X]
- Other: $[X]

**Target:** < $50 per customer

**Trend:** [Increasing / Decreasing / Stable]

---

### LTV (Lifetime Value)

**Definition:** Total revenue from a customer over their lifetime.

**Formula:** ARPU × Average Customer Lifetime

**ARPU (Average Revenue Per User):**
- Current: $[X]/month
- By Plan:
  - Pro: $99/month
  - Business: $499/month
  - Enterprise: $[X]/month (custom)

**Average Customer Lifetime:**
- Current: [X] months
- Churn Rate: [X]%/month
- Lifetime = 1 / Churn Rate = [X] months

**LTV Calculation:**
- LTV = $[X]/month × [X] months = $[X]

**Target:** > $1,800 per customer

**Trend:** [Increasing / Decreasing / Stable]

---

### LTV:CAC Ratio

**Formula:** LTV / CAC

**Current:** [X]:1

**Target:** > 3:1 (ideally > 10:1)

**Assessment:** [ ] Good / [ ] Needs Improvement

---

### Payback Period

**Definition:** How long it takes to recover CAC.

**Formula:** CAC / (MRR × Gross Margin)

**Current:** [X] months

**Target:** < 6 months (ideally < 3 months)

**Assessment:** [ ] Good / [ ] Needs Improvement

---

### Gross Margin

**Definition:** Revenue minus cost of goods sold (COGS).

**Formula:** (Revenue - COGS) / Revenue × 100%

**COGS Breakdown:**
- LLM API costs: $[X]/month per customer
- Infrastructure (Supabase, Redis): $[X]/month per customer
- Support costs: $[X]/month per customer
- Other: $[X]/month per customer
- **Total COGS:** $[X]/month per customer

**Gross Margin:**
- Revenue: $[X]/month per customer
- COGS: $[X]/month per customer
- Gross Margin: $[X]/month = [X]%

**Target:** > 70% (ideally > 80%)

**Trend:** [Increasing / Decreasing / Stable]

---

## Unit Economics by Plan Tier

### Free Tier
- **CAC:** $0 (no acquisition cost, organic)
- **ARPU:** $0
- **LTV:** $0
- **Gross Margin:** N/A
- **Purpose:** User acquisition, conversion funnel

### Pro Tier ($99/month)
- **CAC:** $[X]
- **ARPU:** $99/month
- **Average Lifetime:** [X] months
- **LTV:** $[X]
- **COGS:** $[X]/month
- **Gross Margin:** [X]%
- **LTV:CAC:** [X]:1
- **Payback:** [X] months

### Business Tier ($499/month)
- **CAC:** $[X]
- **ARPU:** $499/month
- **Average Lifetime:** [X] months
- **LTV:** $[X]
- **COGS:** $[X]/month
- **Gross Margin:** [X]%
- **LTV:CAC:** [X]:1
- **Payback:** [X] months

### Enterprise Tier (Custom)
- **CAC:** $[X] (higher due to sales cycle)
- **ARPU:** $[X]/month (custom pricing)
- **Average Lifetime:** [X] months (longer)
- **LTV:** $[X]
- **COGS:** $[X]/month
- **Gross Margin:** [X]%
- **LTV:CAC:** [X]:1
- **Payback:** [X] months

---

## Cost Structure

### Variable Costs (Per Customer)

**LLM API Costs:**
- Cost per agent run: $[X]
- Average runs per customer/month: [X]
- Total LLM cost: $[X]/month per customer

**Infrastructure Costs:**
- Supabase: $[X]/month per customer
- Redis: $[X]/month per customer
- Hosting: $[X]/month per customer
- Total infrastructure: $[X]/month per customer

**Support Costs:**
- Support time per customer: [X] hours/month
- Cost per hour: $[X]
- Total support: $[X]/month per customer

**Total Variable Costs:** $[X]/month per customer

### Fixed Costs (Per Month)

- Team salaries: $[X]/month
- Office/overhead: $[X]/month
- Tools/services: $[X]/month
- Marketing (fixed): $[X]/month
- Other: $[X]/month

**Total Fixed Costs:** $[X]/month

---

## Unit Economics Trends

### Month 1
- CAC: $[X]
- LTV: $[X]
- LTV:CAC: [X]:1
- Payback: [X] months
- Gross Margin: [X]%

### Month 3
- CAC: $[X]
- LTV: $[X]
- LTV:CAC: [X]:1
- Payback: [X] months
- Gross Margin: [X]%

### Month 6
- CAC: $[X]
- LTV: $[X]
- LTV:CAC: [X]:1
- Payback: [X] months
- Gross Margin: [X]%

### Month 12
- CAC: $[X]
- LTV: $[X]
- LTV:CAC: [X]:1
- Payback: [X] months
- Gross Margin: [X]%

---

## Optimization Opportunities

### Reduce CAC
- [ ] Improve conversion rates (funnel optimization)
- [ ] Focus on lower-CAC channels (organic, referrals)
- [ ] Improve product-led growth
- [ ] Optimize marketing spend

### Increase LTV
- [ ] Reduce churn (improve retention)
- [ ] Upsell (Pro → Business → Enterprise)
- [ ] Increase ARPU (pricing optimization)
- [ ] Add new revenue streams (marketplace, services)

### Improve Gross Margin
- [ ] Optimize LLM costs (caching, batching, model selection)
- [ ] Optimize infrastructure costs (right-size resources)
- [ ] Automate support (reduce support costs)
- [ ] Scale (spread fixed costs)

---

## Benchmarking

### Industry Benchmarks

**SaaS Unit Economics:**
- LTV:CAC: > 3:1 (good), > 10:1 (excellent)
- Payback Period: < 12 months (good), < 6 months (excellent)
- Gross Margin: > 70% (good), > 80% (excellent)
- Churn: < 5%/month (good), < 2%/month (excellent)

**Our Performance vs. Benchmarks:**
- LTV:CAC: [X]:1 vs. > 3:1 → [ ] Good / [ ] Needs Improvement
- Payback: [X] months vs. < 12 months → [ ] Good / [ ] Needs Improvement
- Gross Margin: [X]% vs. > 70% → [ ] Good / [ ] Needs Improvement
- Churn: [X]%/month vs. < 5%/month → [ ] Good / [ ] Needs Improvement

---

## TODO: Founders to Fill In

**Required Information:**
- [ ] Actual CAC by channel
- [ ] Actual LTV calculation
- [ ] Actual payback period
- [ ] Actual gross margin
- [ ] Cost structure (variable and fixed)
- [ ] Unit economics by plan tier
- [ ] Trends over time
- [ ] Optimization opportunities

**Action Items:**
- [ ] Track marketing spend by channel
- [ ] Track customer acquisition by channel
- [ ] Calculate CAC by channel
- [ ] Track ARPU by plan tier
- [ ] Track churn rates
- [ ] Calculate LTV
- [ ] Track COGS per customer
- [ ] Calculate gross margin
- [ ] Update this document monthly

---

**Next:** See `/yc/YC_METRICS_CHECKLIST.md` for complete metrics tracking.
