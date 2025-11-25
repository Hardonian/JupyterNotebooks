# YC Metrics Checklist - Agent Factory

**For:** Y Combinator Application & Interview  
**Last Updated:** 2024-01-XX

---

## Overview

This document maps what metrics YC partners will ask for vs. what the repository currently tracks. For each metric, we note:
- Whether it's instrumented today
- Where it's tracked (files/paths)
- If missing, how to instrument it

---

## A. USAGE METRICS

### Daily/Weekly/Monthly Active Users (DAU/WAU/MAU)

**YC Will Ask:** "How many daily/weekly/monthly active users do you have?"

**Current State:**
- ✅ **Instrumented:** Yes
- **Location:** `agent_factory/telemetry/analytics.py`
- **Implementation:**
  - `_compute_dau()` - Daily Active Users
  - `_compute_wau()` - Weekly Active Users  
  - `_compute_mau()` - Monthly Active Users
- **Data Source:** Telemetry events with `user_id`

**How It Works:**
- Tracks unique `user_id` from telemetry events
- DAU: users active in last 24 hours
- WAU: users active in last 7 days
- MAU: users active in last 30 days

**Gap:**
- ⚠️ **Need Real Data:** Currently tracks infrastructure, but need actual user data
- ⚠️ **User Definition:** Need to clarify what "active user" means (agent run? API call? login?)

**Action Items:**
- [ ] Deploy telemetry collection in production
- [ ] Define "active user" metric clearly
- [ ] Set up dashboard to view DAU/WAU/MAU
- [ ] Start collecting real user data

---

### Activation Rate

**YC Will Ask:** "What percentage of signups become activated users?"

**Current State:**
- ⚠️ **Partially Instrumented:** Can compute from events, but no explicit activation event
- **Location:** `agent_factory/telemetry/model.py` (EventType enum)
- **Available Events:**
  - `TENANT_CREATED` - Signup
  - `AGENT_RUN` - First agent run (could be activation)
  - `BLUEPRINT_INSTALL` - First blueprint install (could be activation)

**Gap:**
- ⚠️ **No Explicit Activation Event:** Need to define what "activation" means
- ⚠️ **No Funnel Tracking:** Can't easily compute activation rate

**Action Items:**
- [ ] Define activation criteria (e.g., "first agent run" or "first successful agent run")
- [ ] Add explicit `USER_ACTIVATED` event type
- [ ] Track activation funnel: Signup → First Login → First Agent Run → Activated
- [ ] Compute activation rate: Activated Users / Signups

**Suggested Implementation:**
```python
# In agent_factory/telemetry/model.py
class UserActivatedEvent(TelemetryEvent):
    """Event when user completes activation."""
    user_id: str
    activation_criteria: str  # "first_agent_run", "first_blueprint_install", etc.
```

---

### Retention Rate

**YC Will Ask:** "What's your Day 1, Day 7, Day 30 retention?"

**Current State:**
- ⚠️ **Not Explicitly Tracked:** Can compute from telemetry events, but no retention analysis
- **Location:** `agent_factory/telemetry/analytics.py` (has user tracking, but no retention metrics)

**Gap:**
- ⚠️ **No Retention Analysis:** Need to compute retention cohorts
- ⚠️ **No Retention Dashboard:** Can't easily view retention metrics

**Action Items:**
- [ ] Add retention analysis to `AnalyticsEngine`
- [ ] Track user cohorts by signup date
- [ ] Compute Day 1, Day 7, Day 30 retention
- [ ] Create retention dashboard

**Suggested Implementation:**
```python
# In agent_factory/telemetry/analytics.py
def get_retention_cohort(
    self,
    cohort_date: datetime,
    days: List[int] = [1, 7, 30]
) -> Dict[int, float]:
    """Compute retention for a cohort."""
    # Get users who signed up on cohort_date
    # Check if they were active on cohort_date + days
    # Return retention rates
```

---

### Engagement Metrics

**YC Will Ask:** "How engaged are your users? How often do they use the product?"

**Current State:**
- ✅ **Partially Instrumented:** Tracks agent runs, workflow runs, blueprint installs
- **Location:** `agent_factory/telemetry/analytics.py`
- **Available Metrics:**
  - `total_agent_runs` - Total agent runs
  - `total_workflow_runs` - Total workflow runs
  - `total_blueprint_installs` - Total blueprint installs
  - `agent_runs_by_agent` - Runs per agent
  - `workflow_runs_by_workflow` - Runs per workflow

**Gap:**
- ⚠️ **No Per-User Engagement:** Can't easily see engagement per user
- ⚠️ **No Engagement Score:** No single metric for engagement
- ⚠️ **No Frequency Analysis:** Can't see how often users use product

**Action Items:**
- [ ] Add per-user engagement metrics
- [ ] Compute engagement score (e.g., agent runs per user per week)
- [ ] Track usage frequency (daily, weekly, monthly users)
- [ ] Create engagement dashboard

**Suggested Metrics:**
- Agent runs per user per week
- Workflows per user per week
- Blueprints installed per user
- API calls per user per day
- Time spent in platform (if UI exists)

---

## B. GROWTH & ACQUISITION

### User Acquisition Channels

**YC Will Ask:** "Where do your users come from? What channels work best?"

**Current State:**
- ❌ **Not Tracked:** No channel attribution
- **Location:** None

**Gap:**
- ❌ **No Channel Tracking:** Can't see where users come from
- ❌ **No Attribution:** Can't measure channel effectiveness

**Action Items:**
- [ ] Add `signup_source` to `TENANT_CREATED` event
- [ ] Track channels: Organic, Paid, Referral, Partnership, etc.
- [ ] Add UTM parameter tracking
- [ ] Create channel attribution dashboard

**Suggested Implementation:**
```python
# In agent_factory/telemetry/model.py
class TenantCreatedEvent(TelemetryEvent):
    """Event when tenant signs up."""
    tenant_id: str
    signup_source: str  # "organic", "paid", "referral", "partnership", etc.
    utm_source: Optional[str] = None
    utm_medium: Optional[str] = None
    utm_campaign: Optional[str] = None
```

**Likely Channels (Based on Repo):**
- **Organic:** GitHub, documentation, SEO
- **Partnership:** McGraw Hill Education
- **Developer Community:** Open-source adoption
- **Content Marketing:** Blog posts, tutorials
- **Paid:** (Not yet, but planned)

---

### Conversion Funnel

**YC Will Ask:** "What's your conversion funnel? Where do users drop off?"

**Current State:**
- ✅ **Partially Instrumented:** Has funnel tracking
- **Location:** `agent_factory/telemetry/analytics.py` - `get_conversion_funnel()`
- **Current Funnel:**
  - Notebooks Converted → Agents Created → Blueprints Installed → Projects Created

**Gap:**
- ⚠️ **Wrong Funnel:** Current funnel is product-focused, not user-focused
- ⚠️ **Missing Stages:** Need user-focused funnel

**Action Items:**
- [ ] Define user-focused funnel:
  - Visitor → Signup → Activated → Retained → Paying
- [ ] Track each stage
- [ ] Compute conversion rates
- [ ] Identify drop-off points

**Suggested Funnel:**
```
1. Visitor (website visitor)
2. Signup (creates account)
3. Activated (first agent run)
4. Retained (active in last 7 days)
5. Paying (upgraded to paid plan)
```

**Current Implementation:**
```python
# In agent_factory/telemetry/analytics.py
def get_conversion_funnel(...) -> Dict[str, Any]:
    # Current: notebook → agent → blueprint → project
    # Need: visitor → signup → activated → retained → paying
```

---

### Growth Rate

**YC Will Ask:** "What's your month-over-month growth rate?"

**Current State:**
- ⚠️ **Can Compute:** Have data, but no growth rate analysis
- **Location:** `agent_factory/telemetry/analytics.py` (has user/tenant counts)

**Gap:**
- ⚠️ **No Growth Rate Calculation:** Need to compute MoM growth
- ⚠️ **No Growth Trends:** Can't see growth over time

**Action Items:**
- [ ] Add growth rate calculation
- [ ] Track MoM growth for:
  - Users
  - Tenants
  - Revenue
  - Agent runs
- [ ] Create growth dashboard

**Suggested Implementation:**
```python
# In agent_factory/telemetry/analytics.py
def get_growth_rate(
    self,
    metric: str,  # "users", "tenants", "revenue"
    period: str = "month"  # "week", "month"
) -> Dict[str, float]:
    """Compute growth rate for a metric."""
    # Get current period value
    # Get previous period value
    # Compute growth rate: (current - previous) / previous
```

---

## C. REVENUE & UNIT ECONOMICS

### Revenue Metrics

**YC Will Ask:** "What's your revenue? MRR? ARR? How is it growing?"

**Current State:**
- ✅ **Infrastructure Exists:** Billing system in place
- **Location:** 
  - `agent_factory/billing/` - Billing models and plans
  - `agent_factory/payments/` - Stripe integration
  - `MONETIZATION.md` - Pricing strategy

**Available:**
- Pricing tiers: Free, Pro ($99/month), Business ($499/month), Enterprise (custom)
- Stripe integration for payments
- Usage tracking for billing

**Gap:**
- ⚠️ **No Revenue Tracking:** Can't see actual revenue from telemetry
- ⚠️ **No MRR/ARR Calculation:** Need to compute from subscriptions
- ⚠️ **No Revenue Dashboard:** Can't view revenue metrics

**Action Items:**
- [ ] Add revenue tracking to telemetry
- [ ] Compute MRR (Monthly Recurring Revenue)
- [ ] Compute ARR (Annual Recurring Revenue)
- [ ] Track revenue growth
- [ ] Create revenue dashboard

**Suggested Implementation:**
```python
# In agent_factory/telemetry/model.py
class RevenueEvent(TelemetryEvent):
    """Event for revenue tracking."""
    tenant_id: str
    amount: float
    currency: str = "USD"
    revenue_type: str  # "subscription", "marketplace", "services"
    plan_id: Optional[str] = None
```

**Revenue Streams (from MONETIZATION.md):**
1. **Hosted Platform (SaaS):** $99-$499/month subscriptions
2. **Blueprint Marketplace:** 30% revenue share
3. **Professional Services:** Consulting, support
4. **Enterprise Licensing:** Custom pricing

---

### Unit Economics

**YC Will Ask:** "What are your unit economics? CAC? LTV? Payback period?"

**Current State:**
- ❌ **Not Tracked:** No unit economics analysis
- **Location:** None

**Gap:**
- ❌ **No CAC Tracking:** Can't compute Customer Acquisition Cost
- ❌ **No LTV Calculation:** Can't compute Lifetime Value
- ❌ **No Payback Period:** Can't compute payback period

**Action Items:**
- [ ] Track marketing spend by channel
- [ ] Compute CAC: Marketing Spend / New Customers
- [ ] Compute LTV: Average Revenue Per User × Average Customer Lifetime
- [ ] Compute Payback Period: CAC / (MRR × Gross Margin)
- [ ] Track unit economics over time

**Suggested Metrics:**
- **CAC (Customer Acquisition Cost):** Marketing Spend / New Customers
- **LTV (Lifetime Value):** ARPU × Average Customer Lifetime
- **LTV:CAC Ratio:** Should be > 3:1
- **Payback Period:** CAC / (MRR × Gross Margin) - Should be < 12 months
- **Gross Margin:** Revenue - Cost of Goods Sold (infrastructure costs)

**Cost Drivers (from repo):**
- LLM API costs (OpenAI, Anthropic)
- Infrastructure costs (Supabase, Redis, hosting)
- Support costs
- Marketplace revenue share (70% to creators)

---

### ARPU (Average Revenue Per User)

**YC Will Ask:** "What's your average revenue per user?"

**Current State:**
- ⚠️ **Can Compute:** Have pricing tiers, but no ARPU calculation
- **Location:** `agent_factory/billing/plans.py` (pricing tiers)

**Gap:**
- ⚠️ **No ARPU Calculation:** Need to compute from actual revenue data
- ⚠️ **No ARPU Trends:** Can't see ARPU over time

**Action Items:**
- [ ] Compute ARPU: Total Revenue / Total Paying Users
- [ ] Track ARPU by plan tier
- [ ] Track ARPU trends over time
- [ ] Compare ARPU across segments

**Current Pricing (from MONETIZATION.md):**
- Free: $0/month
- Pro: $99/month
- Business: $499/month
- Enterprise: Custom (likely $10K+/month)

**Expected ARPU:** $150-$300/month (weighted average)

---

## D. PRODUCT METRICS

### Agent Runs

**YC Will Ask:** "How many agent runs do you have? How is it growing?"

**Current State:**
- ✅ **Tracked:** Yes
- **Location:** `agent_factory/telemetry/analytics.py`
- **Metrics:**
  - `total_agent_runs` - Total agent runs
  - `agent_runs_by_agent` - Runs per agent

**Gap:**
- ⚠️ **Need Real Data:** Infrastructure exists, but need actual usage data
- ⚠️ **No Growth Trends:** Can't see growth over time

**Action Items:**
- [ ] Deploy telemetry in production
- [ ] Start collecting real agent run data
- [ ] Track growth trends
- [ ] Create agent runs dashboard

---

### Blueprint Marketplace Activity

**YC Will Ask:** "How active is your marketplace? How many blueprints? Installs?"

**Current State:**
- ✅ **Partially Tracked:** Tracks blueprint installs
- **Location:** `agent_factory/telemetry/analytics.py`
- **Metrics:**
  - `total_blueprint_installs` - Total installs
  - `blueprint_installs_by_type` - Installs per blueprint

**Gap:**
- ⚠️ **No Marketplace Revenue:** Can't see marketplace revenue
- ⚠️ **No Creator Metrics:** Can't see creator activity
- ⚠️ **No Blueprint Quality Metrics:** Can't see blueprint ratings/reviews

**Action Items:**
- [ ] Track marketplace revenue (30% platform share)
- [ ] Track creator activity (blueprints created, revenue earned)
- [ ] Add blueprint ratings/reviews
- [ ] Create marketplace dashboard

---

## E. OPERATIONAL METRICS

### Error Rate

**YC Will Ask:** "What's your error rate? How reliable is the platform?"

**Current State:**
- ✅ **Tracked:** Yes
- **Location:** `agent_factory/telemetry/analytics.py`
- **Metrics:**
  - `total_errors` - Total errors
  - `error_rate` - Error rate (errors / total events)

**Gap:**
- ⚠️ **Need Real Data:** Infrastructure exists, but need actual error data
- ⚠️ **No Error Categorization:** Can't see error types

**Action Items:**
- [ ] Deploy error tracking in production
- [ ] Categorize errors (API errors, agent errors, infrastructure errors)
- [ ] Track error trends
- [ ] Set up error alerting

---

### Infrastructure Costs

**YC Will Ask:** "What are your infrastructure costs? How do they scale?"

**Current State:**
- ⚠️ **Partially Tracked:** Tracks token usage and cost estimates
- **Location:** `agent_factory/telemetry/analytics.py`
- **Metrics:**
  - `total_tokens_used` - Total tokens
  - `total_cost_estimate` - Estimated LLM costs

**Gap:**
- ⚠️ **No Infrastructure Cost Tracking:** Can't see Supabase, Redis, hosting costs
- ⚠️ **No Cost Per Unit:** Can't see cost per agent run, per user

**Action Items:**
- [ ] Track infrastructure costs (Supabase, Redis, hosting)
- [ ] Compute cost per agent run
- [ ] Compute cost per user
- [ ] Track cost trends
- [ ] Optimize costs

---

## F. DASHBOARD REQUIREMENTS

### Metrics Dashboard

**YC Will Ask:** "Show me your metrics dashboard."

**Current State:**
- ⚠️ **CLI Only:** Has CLI commands for metrics, but no dashboard
- **Location:** `agent_factory/cli/commands/metrics.py`

**Available CLI Commands:**
- `agent-factory metrics summary` - Growth summary
- `agent-factory metrics tenant <tenant_id>` - Tenant metrics
- `agent-factory metrics funnel` - Conversion funnel

**Gap:**
- ❌ **No Web Dashboard:** Need visual dashboard
- ❌ **No Real-Time Updates:** Need real-time metrics
- ❌ **No Export:** Can't export metrics

**Action Items:**
- [ ] Create web dashboard (React/Vue + FastAPI)
- [ ] Show key metrics:
  - DAU/WAU/MAU
  - Revenue (MRR, ARR)
  - Growth rate
  - Conversion funnel
  - Unit economics
- [ ] Real-time updates
- [ ] Export to CSV/PDF

**Suggested Dashboard:**
- **Overview:** Key metrics at a glance
- **Users:** DAU/WAU/MAU, growth, retention
- **Revenue:** MRR, ARR, growth, by plan
- **Product:** Agent runs, blueprints, engagement
- **Funnel:** Conversion funnel with drop-off points
- **Unit Economics:** CAC, LTV, payback period

---

## TODO: Founders to Supply Real Data

**Missing Information:**
- [ ] Actual user metrics (DAU/WAU/MAU)
- [ ] Actual revenue data (MRR, ARR)
- [ ] Actual conversion funnel data
- [ ] Actual unit economics (CAC, LTV)
- [ ] Actual growth rates
- [ ] Actual error rates
- [ ] Actual infrastructure costs

**Action Items:**
- [ ] Deploy telemetry in production
- [ ] Start collecting real user data
- [ ] Set up metrics dashboard
- [ ] Track all metrics listed above
- [ ] Create metrics report for YC interview

---

**Next:** See `/yc/YC_METRICS_DASHBOARD_SKETCH.md` for dashboard design.
