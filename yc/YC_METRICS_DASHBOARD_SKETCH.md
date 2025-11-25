# YC Metrics Dashboard Sketch - Agent Factory

**For:** Y Combinator Application & Interview  
**Last Updated:** 2024-01-XX

---

## Overview

This document describes what a basic metrics dashboard should show for YC prep. Founders should have these numbers handy during the interview.

---

## Dashboard Layout

### Top Row: Key Metrics (Always Visible)

```
┌─────────────────────────────────────────────────────────────────┐
│  MRR: $12,450  │  Users: 1,234  │  Growth: 23% MoM  │  ARR: $149K  │
└─────────────────────────────────────────────────────────────────┘
```

**Key Metrics:**
- **MRR (Monthly Recurring Revenue):** Current month revenue
- **Users:** Total active users (or paying users)
- **Growth:** Month-over-month growth rate
- **ARR (Annual Recurring Revenue):** MRR × 12

---

### Section 1: User Metrics

```
┌─────────────────────────────────────────────────────────────────┐
│  User Growth                                                    │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  DAU: 234  │  WAU: 567  │  MAU: 1,234  │  Growth: 23%  │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                 │
│  Retention                                                      │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  Day 1: 45%  │  Day 7: 32%  │  Day 30: 18%             │  │
│  └──────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

**Metrics:**
- **DAU/WAU/MAU:** Daily/Weekly/Monthly Active Users
- **Retention:** Day 1, Day 7, Day 30 retention rates
- **Growth:** User growth rate (MoM)

**YC Will Ask:**
- "How many active users do you have?"
- "What's your retention?"
- "How fast are you growing?"

---

### Section 2: Revenue Metrics

```
┌─────────────────────────────────────────────────────────────────┐
│  Revenue                                                        │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  MRR: $12,450  │  ARR: $149,400  │  Growth: 23% MoM     │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                 │
│  Revenue by Plan                                                │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  Free: $0 (1,000 users)                                  │  │
│  │  Pro: $9,900 (100 users × $99/month)                     │  │
│  │  Business: $2,495 (5 users × $499/month)                  │  │
│  │  Enterprise: $0 (0 customers, in pipeline)                 │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                 │
│  Revenue Trends                                                 │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  [Chart: MRR over time, last 6 months]                    │  │
│  └──────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

**Metrics:**
- **MRR/ARR:** Monthly/Annual Recurring Revenue
- **Revenue by Plan:** Breakdown by pricing tier
- **Revenue Trends:** MRR over time (chart)

**YC Will Ask:**
- "What's your revenue?"
- "How is revenue growing?"
- "What's your revenue mix?"

---

### Section 3: Conversion Funnel

```
┌─────────────────────────────────────────────────────────────────┐
│  Conversion Funnel                                              │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  1. Visitors: 10,000 (100%)                              │  │
│  │  2. Signups: 500 (5%)                                     │  │
│  │  3. Activated: 250 (50% of signups)                      │  │
│  │  4. Retained: 150 (60% of activated)                      │  │
│  │  5. Paying: 105 (70% of retained)                         │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                 │
│  Drop-off Points                                                │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  Visitor → Signup: 95% drop-off (biggest issue)          │  │
│  │  Signup → Activated: 50% drop-off                        │  │
│  │  Activated → Retained: 40% drop-off                       │  │
│  │  Retained → Paying: 30% drop-off                         │  │
│  └──────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

**Metrics:**
- **Funnel Stages:** Visitor → Signup → Activated → Retained → Paying
- **Conversion Rates:** % converting at each stage
- **Drop-off Points:** Where users are dropping off

**YC Will Ask:**
- "What's your conversion funnel?"
- "Where are users dropping off?"
- "What are you doing to improve conversion?"

---

### Section 4: Unit Economics

```
┌─────────────────────────────────────────────────────────────────┐
│  Unit Economics                                                 │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  CAC: $45  │  LTV: $1,800  │  LTV:CAC: 40:1  │  Payback: 2.3 months │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                 │
│  ARPU                                                            │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  Average: $118/month  │  By Plan: [Chart]               │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                 │
│  Gross Margin                                                    │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  Revenue: $12,450  │  COGS: $2,490  │  Margin: 80%       │  │
│  └──────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

**Metrics:**
- **CAC (Customer Acquisition Cost):** Marketing Spend / New Customers
- **LTV (Lifetime Value):** ARPU × Average Customer Lifetime
- **LTV:CAC Ratio:** Should be > 3:1 (ideally > 10:1)
- **Payback Period:** CAC / (MRR × Gross Margin) - Should be < 12 months
- **ARPU:** Average Revenue Per User
- **Gross Margin:** Revenue - COGS (infrastructure costs)

**YC Will Ask:**
- "What's your CAC?"
- "What's your LTV?"
- "What's your payback period?"
- "What are your unit economics?"

---

### Section 5: Product Metrics

```
┌─────────────────────────────────────────────────────────────────┐
│  Product Usage                                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  Agent Runs: 45,678 (this month)  │  Growth: 34% MoM    │  │
│  │  Blueprints Installed: 1,234  │  Active Agents: 567      │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                 │
│  Engagement                                                      │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  Avg Agent Runs/User/Week: 12  │  Avg Sessions/User: 8   │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                 │
│  Marketplace                                                     │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  Blueprints: 45  │  Installs: 1,234  │  Revenue: $3,456   │  │
│  └──────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

**Metrics:**
- **Agent Runs:** Total agent runs (usage metric)
- **Blueprints:** Marketplace activity
- **Engagement:** Agent runs per user per week
- **Marketplace Revenue:** Revenue from blueprint marketplace

**YC Will Ask:**
- "How many agent runs do you have?"
- "How engaged are your users?"
- "How active is your marketplace?"

---

### Section 6: Operational Metrics

```
┌─────────────────────────────────────────────────────────────────┐
│  Platform Health                                                │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  Uptime: 99.9%  │  Error Rate: 0.2%  │  Avg Latency: 450ms │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                 │
│  Infrastructure Costs                                           │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  LLM Costs: $2,100  │  Infrastructure: $390  │  Total: $2,490 │  │
│  │  Cost per Agent Run: $0.05  │  Cost per User: $2.02      │  │
│  └──────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

**Metrics:**
- **Uptime:** Platform availability (should be > 99.9%)
- **Error Rate:** % of requests that error (should be < 1%)
- **Latency:** Average response time
- **Infrastructure Costs:** LLM costs, hosting costs
- **Cost per Unit:** Cost per agent run, per user

**YC Will Ask:**
- "How reliable is your platform?"
- "What are your infrastructure costs?"
- "How do costs scale?"

---

## Key Numbers for YC Interview

**Have These Ready:**

1. **Users:** DAU, WAU, MAU, growth rate
2. **Revenue:** MRR, ARR, growth rate
3. **Conversion:** Funnel conversion rates, drop-off points
4. **Unit Economics:** CAC, LTV, LTV:CAC, payback period
5. **Product:** Agent runs, engagement, marketplace activity
6. **Operations:** Uptime, error rate, infrastructure costs

**Be Ready to Explain:**
- How you're growing (channels, tactics)
- Why users convert (or don't)
- Unit economics (are they good?)
- What you're optimizing (growth, retention, revenue)

---

## Implementation Notes

**Current State:**
- ✅ Telemetry infrastructure exists
- ✅ Analytics engine exists
- ⚠️ Need to deploy in production
- ⚠️ Need to collect real data
- ❌ Need to build dashboard UI

**Action Items:**
- [ ] Deploy telemetry in production
- [ ] Start collecting real metrics
- [ ] Build dashboard UI (React/Vue + FastAPI)
- [ ] Set up real-time updates
- [ ] Create metrics export (CSV/PDF)

**Suggested Tech Stack:**
- **Backend:** FastAPI (already exists)
- **Frontend:** React/Vue dashboard
- **Charts:** Chart.js, Recharts, or Plotly
- **Real-time:** WebSockets or Server-Sent Events

---

**Next:** See `/yc/YC_DISTRIBUTION_PLAN.md` for distribution strategy.
