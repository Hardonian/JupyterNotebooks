# Usage-Based Expansion Strategy - Agent Factory

**For:** Product-Led Growth, Revenue Expansion, Growth  
**Last Updated:** 2024-01-XX

---

## Overview

This document defines the strategy for usage-based expansion—automatically prompting users to upgrade when they consistently hit usage limits. Usage-based expansion drives revenue growth through product usage.

---

## Expansion Triggers

### Trigger 1: Consistent High Usage (80%+ of Tier Limit)

**When:** User consistently uses 80%+ of tier limit for 3+ consecutive days

**Action:** Show upgrade prompt (in-product banner + email)

**Message:**
- **Headline:** "You're growing fast!"
- **Body:** "You're consistently hitting your tier limits. Upgrade to [Next Tier] for 10x more capacity."
- **CTA:** "Upgrade Now" / "See Plans"

**Timing:** After 3+ consecutive days of high usage

**Frequency:** Once per week

**Conversion Target:** >12% upgrade rate

---

### Trigger 2: Usage Spike (Sudden Increase)

**When:** User usage increases 50%+ in one day

**Action:** Show upgrade prompt (in-product banner)

**Message:**
- **Headline:** "Your usage is growing!"
- **Body:** "You're using more than usual. Upgrade to [Next Tier] to avoid hitting limits."
- **CTA:** "Upgrade Now" / "See Plans"

**Timing:** Immediately after usage spike detected

**Frequency:** Once per spike

**Conversion Target:** >10% upgrade rate

---

### Trigger 3: Projected Limit Hit (Based on Usage Trend)

**When:** Based on usage trend, user will hit limit within 7 days

**Action:** Show upgrade prompt (email + in-product banner)

**Message:**
- **Headline:** "You're on track to hit your limit"
- **Body:** "Based on your current usage, you'll hit your limit in [X] days. Upgrade to [Next Tier] to avoid interruption."
- **CTA:** "Upgrade Now" / "See Plans"

**Timing:** When projection shows limit hit within 7 days

**Frequency:** Once per projection

**Conversion Target:** >15% upgrade rate

---

### Trigger 4: Limit Hit (At 100%)

**When:** User hits 100% of tier limit

**Action:** Show upgrade prompt (modal + email)

**Message:**
- **Headline:** "You've hit your limit"
- **Body:** "You've used all your [Tier] requests. Upgrade to [Next Tier] to continue using Agent Factory."
- **CTA:** "Upgrade Now" / "See Plans"

**Timing:** Immediately when limit hit

**Frequency:** Once per limit hit

**Conversion Target:** >20% upgrade rate

---

## Expansion Flow

### Step 1: Usage Monitoring
- Monitor user usage in real-time
- Track usage trends and patterns
- Identify expansion opportunities

### Step 2: Trigger Detection
- Detect expansion triggers (high usage, spikes, projections)
- Calculate expansion probability
- Prioritize expansion opportunities

### Step 3: Expansion Prompt
- Show expansion prompt (banner, modal, email)
- Display value proposition
- Show usage vs. limit
- Clear upgrade CTA

### Step 4: Upgrade Completion
- User clicks upgrade CTA
- Redirect to upgrade flow
- Complete upgrade
- Confirm upgrade and new limits

### Step 5: Post-Upgrade
- Welcome email with new limits
- Usage reset (new tier limits)
- Success celebration
- Support offer

---

## Expansion Messaging

### By Tier

**Free → Starter ($49/month)**
- **Value:** "10x more capacity (1K → 10K requests/month)"
- **Message:** "Perfect for scaling your AI agent operations"
- **Target:** Users hitting free tier limits

**Starter → Pro ($199/month)**
- **Value:** "10x more capacity (10K → 100K requests/month)"
- **Message:** "Scale to handle high-volume usage"
- **Target:** Users hitting Starter tier limits

**Pro → Business**
- **Value:** "Unlimited requests, custom SLAs"
- **Message:** "Enterprise-grade capacity and support"
- **Target:** Users hitting Pro tier limits, enterprise needs

---

## Expansion Analytics

### Metrics to Track
- **Expansion Opportunities:** Number of users hitting limits
- **Expansion Prompts Shown:** Number of expansion prompts displayed
- **Expansion Conversion Rate:** % of prompts → upgrades
- **Expansion Revenue:** Revenue from usage-based upgrades
- **Time to Expansion:** Average time from signup to expansion

### A/B Testing
- **Test Messaging:** Different value propositions
- **Test Timing:** When to show prompts
- **Test Design:** Banner vs. modal vs. email
- **Test Frequency:** How often to show prompts

---

## Expansion Optimization

### High-Impact Optimizations
1. **Right Timing:** Show prompts at right moment (not too early, not too late)
2. **Clear Value:** Make value proposition clear and compelling
3. **Easy Upgrade:** Reduce friction in upgrade flow
4. **Usage Visibility:** Show usage vs. limit clearly

### Medium-Impact Optimizations
5. **Personalization:** Personalize prompts based on usage patterns
6. **Urgency:** Create urgency (limit approaching, etc.)
7. **Comparison:** Show tier comparison clearly
8. **Social Proof:** Show testimonials, case studies

---

## Next Steps

### This Month
1. [ ] Design expansion prompts
2. [ ] Implement expansion triggers
3. [ ] Create expansion flow

### Next Quarter
1. [ ] Launch expansion prompts
2. [ ] Measure expansion conversion
3. [ ] Optimize based on data

---

**Last Updated:** 2024-01-XX  
**Next Review:** [Date]

---

**Next:** See `/yc/UPGRADE_PROMPTS.md` for upgrade prompts and `/yc/ACTIVATION_FLOW.md` for activation.