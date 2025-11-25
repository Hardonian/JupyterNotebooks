# Upgrade Prompts Strategy - Agent Factory

**For:** Product-Led Growth, Revenue Optimization, Conversion  
**Last Updated:** 2024-01-XX

---

## Overview

This document defines the strategy for upgrade prompts—when and how to prompt free users to upgrade to paid tiers. Effective upgrade prompts drive revenue without being pushy.

---

## Upgrade Triggers

### Trigger 1: Usage Limit Reached (80% of Free Tier)

**When:** User hits 80% of free tier limit (800/1000 requests)

**Prompt Type:** In-product banner + email

**Message:**
- **Headline:** "You're using 80% of your free tier"
- **Body:** "Upgrade to Pro for 10x more capacity (10K requests/month)"
- **CTA:** "Upgrade to Pro" / "See Plans"

**Timing:** Show immediately when limit reached

**Frequency:** Once per limit hit

**Conversion Target:** >10% upgrade rate

---

### Trigger 2: Feature Gated (Multi-Agent, Advanced Features)

**When:** User tries to use gated feature (e.g., create second agent, use advanced features)

**Prompt Type:** Modal or inline prompt

**Message:**
- **Headline:** "Unlock [Feature Name]"
- **Body:** "Upgrade to Pro to unlock [feature] and more"
- **CTA:** "Upgrade to Pro" / "Learn More"

**Timing:** Show when user tries to use gated feature

**Frequency:** Once per feature attempt

**Conversion Target:** >15% upgrade rate

---

### Trigger 3: After Activation

**When:** User activates (deploys first agent, runs 10+ executions)

**Prompt Type:** Celebration + upgrade prompt

**Message:**
- **Headline:** "🎉 Congratulations! You're activated!"
- **Body:** "You're ready for Pro features. Upgrade to unlock more agents, higher limits, and advanced features."
- **CTA:** "Upgrade to Pro" / "See What's Included"

**Timing:** Show immediately after activation

**Frequency:** Once after activation

**Conversion Target:** >20% upgrade rate

---

### Trigger 4: Consistent High Usage

**When:** User consistently uses 80%+ of free tier for 3+ days

**Prompt Type:** Email + in-product banner

**Message:**
- **Headline:** "You're growing fast!"
- **Body:** "You're consistently hitting your free tier limits. Upgrade to Pro for 10x more capacity."
- **CTA:** "Upgrade to Pro" / "See Plans"

**Timing:** After 3+ days of high usage

**Frequency:** Once per week

**Conversion Target:** >12% upgrade rate

---

### Trigger 5: Time-Based (30 Days on Free Tier)

**When:** User has been on free tier for 30+ days

**Prompt Type:** Email

**Message:**
- **Headline:** "You've been using Agent Factory for 30 days"
- **Body:** "Thanks for using Agent Factory! Upgrade to Pro to unlock more features and support the platform."
- **CTA:** "Upgrade to Pro" / "See Plans"

**Timing:** After 30 days on free tier

**Frequency:** Once per 30 days

**Conversion Target:** >5% upgrade rate

---

## Upgrade Prompt Design

### In-Product Banners

**Design:**
- Non-intrusive (doesn't block workflow)
- Clear value proposition
- Easy to dismiss (but can show again)
- Visual hierarchy (CTA stands out)

**Placement:**
- Dashboard (top or side)
- After actions (usage limit, feature gated)
- Settings page

**Examples:**
- "You're using 80% of your free tier. Upgrade to Pro for 10x more."
- "Unlock multi-agent support. Upgrade to Pro."
- "🎉 You're activated! Ready for Pro features?"

---

### Modals

**Design:**
- Used for feature gating (can't proceed without upgrade)
- Clear value proposition
- Easy to close (but feature remains gated)
- Visual appeal (celebrates, doesn't pressure)

**Placement:**
- When user tries to use gated feature
- After activation (celebration)

**Examples:**
- "Unlock [Feature Name]" modal
- "🎉 Activation Celebration" modal

---

### Emails

**Design:**
- Personalized (use user's name, usage data)
- Clear value proposition
- Visual appeal (not just text)
- Clear CTA

**Timing:**
- Usage limit reached
- Consistent high usage
- Time-based (30 days)
- After activation

**Examples:**
- "You're using 80% of your free tier" email
- "You're growing fast!" email
- "30 days with Agent Factory" email

---

## Upgrade Messaging

### Value Propositions by Tier

**Free → Starter ($49/month)**
- **Value:** "5 agents, 10K requests/month, basic blueprints"
- **Message:** "Perfect for solo founders getting started"
- **Target:** Solo founders, early stage

**Free → Pro ($199/month)**
- **Value:** "20 agents, 100K requests/month, premium blueprints, API access"
- **Message:** "For founders ready to scale"
- **Target:** Scaling founders, product teams

**Starter → Pro ($199/month)**
- **Value:** "4x more agents, 10x more requests, premium features"
- **Message:** "Scale your AI agent operations"
- **Target:** Users hitting Starter limits

**Pro → Business/Enterprise**
- **Value:** "Unlimited agents, custom SLAs, dedicated support"
- **Message:** "Enterprise-grade features for scaling teams"
- **Target:** Enterprise customers, high-volume users

---

## Upgrade Flow

### Step 1: Trigger
- User hits upgrade trigger (usage limit, feature gated, etc.)
- System detects trigger
- Show upgrade prompt

### Step 2: Prompt Display
- Show in-product banner, modal, or email
- Display value proposition
- Show pricing comparison
- Clear CTA

### Step 3: User Clicks CTA
- User clicks "Upgrade to Pro" or "See Plans"
- Redirect to pricing page or upgrade flow
- Show plan comparison
- Highlight recommended plan

### Step 4: Upgrade Completion
- User selects plan
- Enters payment information
- Completes upgrade
- Confirmation and onboarding

### Step 5: Post-Upgrade
- Welcome email
- Feature tour (new features unlocked)
- Success celebration
- Support offer

---

## Upgrade Analytics

### Metrics to Track
- **Upgrade Prompt Views:** How many users see prompts
- **Upgrade Prompt Clicks:** How many users click prompts
- **Upgrade Conversion Rate:** % of prompt views → upgrades
- **Upgrade by Trigger:** Which triggers drive most upgrades
- **Time to Upgrade:** Average time from signup to upgrade

### A/B Testing
- **Test Messaging:** Different value propositions
- **Test Timing:** When to show prompts
- **Test Design:** Banner vs. modal vs. email
- **Test Frequency:** How often to show prompts

---

## Upgrade Optimization

### High-Impact Optimizations
1. **Right Timing:** Show prompts at right moment (not too early, not too late)
2. **Clear Value:** Make value proposition clear and compelling
3. **Easy Upgrade:** Reduce friction in upgrade flow
4. **Right Trigger:** Use triggers that drive most upgrades

### Medium-Impact Optimizations
5. **Personalization:** Personalize prompts based on usage
6. **Social Proof:** Show testimonials, case studies
7. **Urgency:** Create urgency (limited time offers, etc.)
8. **Comparison:** Show plan comparison clearly

---

## Next Steps

### This Month
1. [ ] Design upgrade prompts (banners, modals, emails)
2. [ ] Implement upgrade triggers
3. [ ] Create upgrade flow

### Next Quarter
1. [ ] Launch upgrade prompts
2. [ ] Measure upgrade conversion
3. [ ] Optimize based on data

---

**Last Updated:** 2024-01-XX  
**Next Review:** [Date]

---

**Next:** See `/yc/USAGE_EXPANSION.md` for usage-based expansion and `/yc/PQL_CRITERIA.md` for PQL criteria.