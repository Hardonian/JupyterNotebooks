#!/bin/bash
# User Acquisition Checklist Script
# Helps track user acquisition progress

echo "👥 Agent Factory User Acquisition Checklist"
echo "============================================"
echo ""
echo "Founder, CEO & Operator: Scott Hardie"
echo ""

CHECKLIST_FILE="yc/EARLY_ADOPTERS.md"

cat > "$CHECKLIST_FILE" << 'EOF'
# Early Adopters & User Acquisition

**Founder, CEO & Operator:** Scott Hardie  
**Last Updated:** [DATE]

---

## User Acquisition Checklist

### Week 1: Initial Outreach

- [ ] **Identify 10-15 potential users**
  - [ ] Friends/colleagues who build AI agents (3-5)
  - [ ] Education contacts via McGraw Hill network (3-5)
  - [ ] Developer communities (Hacker News, Reddit, Twitter) (3-5)
  - [ ] Personal network (2-3)

- [ ] **Reach out to potential users**
  - [ ] Send personalized emails
  - [ ] Share on social media
  - [ ] Post in developer communities
  - [ ] Leverage McGraw Hill network

- [ ] **Give access**
  - [ ] Create accounts for beta testers
  - [ ] Send access instructions
  - [ ] Provide demo/support

**Target:** 3-5 users by end of Week 1

---

### Week 2: Engagement & Feedback

- [ ] **Follow up with users**
  - [ ] Check if they've tried it
  - [ ] Offer help/support
  - [ ] Schedule interviews

- [ ] **Conduct interviews** (use template below)
  - [ ] Interview User 1
  - [ ] Interview User 2
  - [ ] Interview User 3
  - [ ] Interview User 4
  - [ ] Interview User 5

- [ ] **Get testimonials**
  - [ ] Ask for written testimonials
  - [ ] Get permission to use quotes
  - [ ] Document in yc/CUSTOMER_TESTIMONIALS.md

**Target:** 3-5 interviews completed, 2-3 testimonials

---

## User Interview Template

**Date:** [DATE]  
**User:** [NAME/COMPANY]  
**Role:** [ROLE]  
**How Found:** [CHANNEL]

### Questions

1. **What problem were you trying to solve?**
   - [Their answer]

2. **How did you find Agent Factory?**
   - [Their answer]

3. **What did you try?**
   - [Their answer]

4. **What worked well?**
   - [Their answer]

5. **What didn't work or was confusing?**
   - [Their answer]

6. **Would you pay for this? How much?**
   - [Their answer]

7. **Would you recommend it? Why/why not?**
   - [Their answer]

8. **What features are most important to you?**
   - [Their answer]

9. **What's missing?**
   - [Their answer]

10. **Any other feedback?**
    - [Their answer]

### Summary

**Key Insights:**
- [Insight 1]
- [Insight 2]
- [Insight 3]

**Willingness to Pay:** [YES/NO] - [AMOUNT]

**Testimonial Quote:** "[QUOTE]"

---

## Early Adopters List

### User 1: [NAME]

**Contact:** [EMAIL]  
**Company/Role:** [INFO]  
**Use Case:** [WHAT THEY'RE BUILDING]  
**Status:** [ACTIVE / TESTING / PAUSED]  
**Feedback:** [KEY FEEDBACK POINTS]  
**Testimonial:** [QUOTE IF AVAILABLE]  
**Interview Date:** [DATE]

---

### User 2: [NAME]

[Same template]

---

## Outreach Templates

### Email Template 1: Personal Network

**Subject:** Would love your feedback on Agent Factory

Hi [NAME],

I've been working on Agent Factory—a platform that helps developers turn AI agent prototypes into production-ready products. After 15+ years in EdTech, I've seen hundreds of great prototypes die because developers couldn't build the infrastructure.

I'd love your feedback. Could you try it and let me know what you think?

[PRODUCTION_URL]

Thanks!
Scott Hardie
Founder, CEO & Operator
Agent Factory

---

### Email Template 2: Developer Communities

**Subject:** Beta testing Agent Factory - AI agent platform

Hi [COMMUNITY],

I'm building Agent Factory—a platform that handles all the infrastructure so you can focus on your AI agents. Think Rails/Django for AI agents.

Looking for beta testers who build AI agents. If you've ever had a prototype stuck in a Jupyter notebook, this might help.

[PRODUCTION_URL]

Happy to answer questions!
Scott Hardie
Founder, CEO & Operator
Agent Factory

---

### Social Media Template

🚀 Excited to share Agent Factory—a platform that turns AI prototypes into production products.

After 15+ years in EdTech, I've seen hundreds of great prototypes die because developers couldn't build the infrastructure. Agent Factory fixes that.

Looking for beta testers! If you build AI agents, I'd love your feedback.

[PRODUCTION_URL]

#AI #Agents #DeveloperTools

---

## Testimonial Request Template

**Subject:** Quick favor - testimonial for Agent Factory

Hi [NAME],

Thanks for trying Agent Factory! I'm preparing for YC application and would love to include a brief testimonial.

Could you share 1-2 sentences about:
- What you tried
- What worked
- Why it was useful

Even something like: "Agent Factory helped me deploy my AI agent prototype in days instead of months."

Thanks!
Scott

---

## Progress Tracking

**Week 1:**
- Users contacted: [NUMBER]
- Users signed up: [NUMBER]
- Users activated: [NUMBER]

**Week 2:**
- Interviews completed: [NUMBER]
- Testimonials received: [NUMBER]
- Feedback documented: [YES/NO]

**Week 3:**
- Case studies created: [NUMBER]
- Testimonials published: [NUMBER]

---

## Next Steps

1. **This Week:**
   - [ ] Identify 10-15 potential users
   - [ ] Send outreach emails
   - [ ] Share on social media/communities

2. **Next Week:**
   - [ ] Follow up with users
   - [ ] Conduct 3-5 interviews
   - [ ] Get 2-3 testimonials

3. **Week 3:**
   - [ ] Create case studies
   - [ ] Update yc/CUSTOMER_TESTIMONIALS.md
   - [ ] Update dataroom/04_CUSTOMER_PROOF.md

---

**Last Updated:** [DATE]  
**Maintained by:** Founder

EOF

echo "✅ User acquisition checklist created: $CHECKLIST_FILE"
echo ""
echo "Next steps:"
echo "  1. Fill in user list as you acquire them"
echo "  2. Use interview template for each user"
echo "  3. Request testimonials using template"
echo "  4. Update progress weekly"
