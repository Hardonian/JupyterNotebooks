# Activation Flow - Agent Factory

**For:** Product-Led Growth, User Onboarding, Activation Optimization  
**Last Updated:** 2024-01-XX

---

## Overview

This document defines the activation flow for Agent Factory. Activation is the moment when users realize value and become engaged users. Optimizing activation is critical for product-led growth.

---

## Activation Definition

### Activation Moment
**"User deploys first agent to production and runs 10+ successful executions"**

### Activation Criteria
1. **Deploy first agent to production** (core action)
2. **Run 10+ successful executions** (proves value)
3. **Use agent in real scenario** (not just testing)

### Why This Definition
- **Deployment:** Core job is "deploy to production"
- **10+ Executions:** Proves agent works reliably
- **Real Scenario:** Proves real value, not just testing

---

## Activation Funnel

### Step 1: Signup
**Action:** User creates account
**Conversion Target:** 100% (baseline)

**Optimization:**
- Reduce friction (email only, no credit card)
- Clear value proposition
- Social proof (testimonials, case studies)

---

### Step 2: Install CLI
**Action:** User installs Agent Factory CLI
**Conversion Target:** >80% (from signup)

**Optimization:**
- Clear installation instructions
- One-command install (`pip install agent-factory`)
- Installation verification

---

### Step 3: Create First Agent
**Action:** User creates first agent (or converts notebook)
**Conversion Target:** >70% (from CLI install)

**Optimization:**
- Quick start guide
- Examples and templates
- Notebook converter (low friction)
- Progress indicators

---

### Step 4: Deploy to Production
**Action:** User deploys agent to production
**Conversion Target:** >60% (from agent creation)

**Optimization:**
- One-command deployment (`agent-factory deploy`)
- Clear deployment instructions
- Deployment verification
- Success celebration

---

### Step 5: Run 10+ Executions
**Action:** User runs agent 10+ times successfully
**Conversion Target:** >50% (from deployment)

**Optimization:**
- Clear usage instructions
- Examples of how to use agent
- Progress tracking (show progress to 10)
- Celebration at 10 executions

---

## Activation Metrics

### Overall Activation Rate
**Metric:** % of signups who activate
**Target:** >40%
**Current:** N/A (no users yet)

**Calculation:**
- Activation Rate = (Activated Users / Total Signups) × 100
- Target: >40%

---

### Time to Activation
**Metric:** Average time from signup to activation
**Target:** <7 days
**Current:** N/A (no users yet)

**Calculation:**
- Time to Activation = Average (Activation Timestamp - Signup Timestamp)
- Target: <7 days

---

### Funnel Conversion Rates

| Step | Conversion Target | Current | Status |
|------|------------------|---------|--------|
| Signup → CLI Install | >80% | N/A | 🔴 |
| CLI Install → Agent Creation | >70% | N/A | 🔴 |
| Agent Creation → Deployment | >60% | N/A | 🔴 |
| Deployment → 10+ Executions | >50% | N/A | 🔴 |
| **Overall Activation** | **>40%** | **N/A** | **🔴** |

**Legend:** 🔴 Not Started | ⚠️ In Progress | ✅ On Track | 🎯 Exceeded

---

## Activation Optimization

### High-Impact Optimizations

**1. Reduce Time to First Agent**
- **Current:** [TBD] hours
- **Target:** <1 hour
- **Tactics:**
  - Improve quick start guide
  - Add more examples
  - Simplify notebook converter
  - Add progress indicators

**2. Reduce Time to Deployment**
- **Current:** [TBD] days
- **Target:** <1 day
- **Tactics:**
  - Simplify deployment process
  - Improve deployment docs
  - Add deployment wizard
  - One-command deployment

**3. Increase Activation Rate**
- **Current:** [TBD]%
- **Target:** >40%
- **Tactics:**
  - Improve onboarding flow
  - Add progress indicators
  - Celebrate milestones
  - Provide support

---

### Medium-Impact Optimizations

**4. Improve Onboarding Flow**
- **Tactics:**
  - Step-by-step guide
  - Progress indicators
  - Clear next steps
  - Help and support

**5. Add Progress Tracking**
- **Tactics:**
  - Show progress to activation
  - Celebrate milestones
  - Show value delivered
  - Gamification (optional)

**6. Provide Support**
- **Tactics:**
  - Documentation
  - Examples
  - Community (Discord, GitHub)
  - Support (email, chat)

---

## Activation Flow Design

### Onboarding Steps

**Step 1: Welcome**
- Welcome email
- Dashboard overview
- Next steps guide

**Step 2: Quick Start**
- Install CLI
- Create first agent
- Test agent locally

**Step 3: Deploy**
- Deploy to production
- Get production URL
- Test production agent

**Step 4: Activate**
- Run 10+ executions
- See value delivered
- Celebrate activation

---

## Activation Triggers

### Trigger 1: After Signup
**Action:** Show welcome and quick start guide
**Goal:** Get user to install CLI

### Trigger 2: After CLI Install
**Action:** Show agent creation guide
**Goal:** Get user to create first agent

### Trigger 3: After Agent Creation
**Action:** Show deployment guide
**Goal:** Get user to deploy to production

### Trigger 4: After Deployment
**Action:** Show usage guide, track executions
**Goal:** Get user to 10+ executions

### Trigger 5: At 10 Executions
**Action:** Celebrate activation, show next steps
**Goal:** Activate user, show value

---

## Activation Messaging

### Welcome Message
"Welcome to Agent Factory! Let's get your first agent deployed to production in minutes."

### Progress Messages
- "Great! You've installed the CLI. Next: Create your first agent."
- "Awesome! You've created an agent. Next: Deploy to production."
- "Excellent! You've deployed to production. Next: Run 10 executions to activate."

### Activation Message
"🎉 Congratulations! You're activated. Your agent is live and working. What's next?"

---

## Activation Analytics

### Metrics to Track
- **Signup → CLI Install:** Conversion rate, time
- **CLI Install → Agent Creation:** Conversion rate, time
- **Agent Creation → Deployment:** Conversion rate, time
- **Deployment → Activation:** Conversion rate, time
- **Overall Activation:** Rate, time

### Drop-Off Analysis
- **Where do users drop off?**
- **Why do they drop off?**
- **How can we reduce drop-off?**

### Cohort Analysis
- **Activation rate by signup week**
- **Time to activation by cohort**
- **Activation rate by source**

---

## Next Steps

### This Month
1. [ ] Define activation flow
2. [ ] Implement activation tracking
3. [ ] Create onboarding flow

### Next Quarter
1. [ ] Measure activation metrics
2. [ ] Optimize activation flow
3. [ ] Improve activation rate

---

**Last Updated:** 2024-01-XX  
**Next Review:** [Date]

---

**Next:** See `/yc/UPGRADE_PROMPTS.md` for upgrade flow and `/yc/ONBOARDING_ANALYTICS.md` for analytics.