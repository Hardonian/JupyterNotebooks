# Financial Model - Agent Factory

**For:** Y Combinator Application & Interview  
**Last Updated:** 2024-01-XX

---

## Overview

This document provides financial projections for Agent Factory. See `/yc/FINANCIAL_MODEL.xlsx` for detailed spreadsheet (if created).

---

## Key Assumptions

### Revenue Assumptions

**Pricing Tiers:**
- Free: $0/month (100 runs/month)
- Pro: $99/month (10K runs/month)
- Business: $499/month (100K runs/month)
- Enterprise: Custom (assume $10K/month average)

**Conversion Rates:**
- Free → Pro: [X]%
- Pro → Business: [X]%
- Business → Enterprise: [X]%

**Churn Rates:**
- Pro: [X]%/month
- Business: [X]%/month
- Enterprise: [X]%/month

### Cost Assumptions

**Infrastructure Costs:**
- LLM API costs: $[X] per 10K agent runs
- Supabase: $[X]/month (base) + $[X] per user
- Redis: $[X]/month
- Hosting: $[X]/month
- Other: $[X]/month

**Team Costs:**
- Average salary: $[X]/year
- Benefits (20%): $[X]/year
- Total per person: $[X]/year

**Marketing Costs:**
- CAC target: $[X]
- Marketing spend: [X]% of revenue

---

## 12-Month Projections

### Revenue Projections

| Month | Free Users | Pro Users | Business Users | Enterprise | MRR | ARR |
|-------|-----------|-----------|----------------|------------|-----|-----|
| 1     | [X]       | [X]       | [X]            | [X]        | $[X]| $[X]|
| 3     | [X]       | [X]       | [X]            | [X]        | $[X]| $[X]|
| 6     | [X]       | [X]       | [X]            | [X]        | $[X]| $[X]|
| 12    | [X]       | [X]       | [X]            | [X]        | $[X]| $[X]|

**Revenue Breakdown:**
- SaaS Subscriptions: $[X]/month
- Marketplace (30% share): $[X]/month
- Professional Services: $[X]/month
- Enterprise Licensing: $[X]/month

### Cost Projections

| Month | Infrastructure | Team | Marketing | Other | Total Burn |
|-------|----------------|------|-----------|-------|------------|
| 1     | $[X]          | $[X] | $[X]      | $[X]  | $[X]       |
| 3     | $[X]          | $[X] | $[X]      | $[X]  | $[X]       |
| 6     | $[X]          | $[X] | $[X]      | $[X]  | $[X]       |
| 12    | $[X]          | $[X] | $[X]      | $[X]  | $[X]       |

### Unit Economics

| Metric | Month 1 | Month 3 | Month 6 | Month 12 |
|--------|---------|---------|---------|----------|
| CAC    | $[X]    | $[X]    | $[X]    | $[X]     |
| LTV    | $[X]    | $[X]    | $[X]    | $[X]     |
| LTV:CAC| [X]:1   | [X]:1   | [X]:1   | [X]:1    |
| Payback| [X] mo  | [X] mo  | [X] mo  | [X] mo   |
| Gross Margin| [X]% | [X]% | [X]% | [X]% |

---

## 3-Year Projections (High-Level)

### Year 1
- **Revenue:** $[X] ARR
- **Customers:** [X] paying customers
- **Team:** [X] people
- **Break-Even:** Month [X]

### Year 2
- **Revenue:** $[X] ARR
- **Customers:** [X] paying customers
- **Team:** [X] people
- **Profitability:** [ ] Profitable / [ ] Not yet

### Year 3
- **Revenue:** $[X] ARR
- **Customers:** [X] paying customers
- **Team:** [X] people
- **Profitability:** [ ] Profitable / [ ] Not yet

---

## Scenario Analysis

### Conservative Scenario
- **Assumptions:** [Lower growth, higher churn, higher CAC]
- **Year 1 Revenue:** $[X] ARR
- **Break-Even:** Month [X]

### Base Case Scenario
- **Assumptions:** [Current assumptions]
- **Year 1 Revenue:** $[X] ARR
- **Break-Even:** Month [X]

### Optimistic Scenario
- **Assumptions:** [Higher growth, lower churn, lower CAC]
- **Year 1 Revenue:** $[X] ARR
- **Break-Even:** Month [X]

---

## Key Metrics

### Growth Metrics
- **MoM Growth Rate:** [X]%
- **CAGR (Year 1):** [X]%

### Efficiency Metrics
- **CAC Payback Period:** [X] months
- **Magic Number:** [X] (should be > 0.75)
- **Rule of 40:** [X]% (Growth % + Profit Margin %)

### Retention Metrics
- **Net Revenue Retention:** [X]% (should be > 100%)
- **Gross Revenue Retention:** [X]% (should be > 90%)

---

## Funding Requirements

**To Reach Break-Even:**
- **Amount Needed:** $[X]
- **Timeline:** [X] months
- **Use:** [Description]

**To Scale Aggressively:**
- **Amount Needed:** $[X]
- **Timeline:** [X] months
- **Use:** [Description]

---

## TODO: Founders to Fill In

**Required Information:**
- [ ] All revenue projections (users, MRR, ARR)
- [ ] All cost projections (infrastructure, team, marketing)
- [ ] Unit economics (CAC, LTV, payback, gross margin)
- [ ] Scenario analysis (conservative, base, optimistic)
- [ ] Key metrics (growth, efficiency, retention)
- [ ] Funding requirements

**Optional but Helpful:**
- [ ] Create Excel/Google Sheets model (`/yc/FINANCIAL_MODEL.xlsx`)
- [ ] Sensitivity analysis (what if assumptions change?)
- [ ] Comparison to industry benchmarks

---

**Next:** See `/yc/UNIT_ECONOMICS.md` for detailed unit economics analysis.
