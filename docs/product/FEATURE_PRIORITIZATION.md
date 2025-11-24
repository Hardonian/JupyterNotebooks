# Feature Prioritization Framework

**Last Updated:** 2024-01-XX  
**Purpose:** Standardized framework for prioritizing product features

---

## Prioritization Methods

### RICE Framework (Primary)

**RICE Components:**
- **Reach:** How many users will this affect? (per quarter)
- **Impact:** How much will this impact each user? (0.25, 0.5, 1, 2, 3)
- **Confidence:** How confident are we? (50%, 80%, 100%)
- **Effort:** How much effort required? (person-months)

**Formula:**
```
RICE Score = (Reach × Impact × Confidence) / Effort
```

---

### Impact Scoring

**3 = Massive Impact**
- Game-changing feature
- Solves critical problem
- High user value

**2 = High Impact**
- Significant improvement
- Solves important problem
- Good user value

**1 = Medium Impact**
- Moderate improvement
- Solves moderate problem
- Some user value

**0.5 = Low Impact**
- Small improvement
- Solves minor problem
- Limited user value

**0.25 = Minimal Impact**
- Very small improvement
- Solves trivial problem
- Negligible user value

---

### Confidence Scoring

**100% = High Confidence**
- Strong data
- Clear requirements
- Proven approach

**80% = Medium Confidence**
- Some data
- Mostly clear requirements
- Reasonable approach

**50% = Low Confidence**
- Limited data
- Unclear requirements
- Uncertain approach

---

## Feature Evaluation Process

### Step 1: Feature Submission

**Submit:**
- Feature description
- Problem statement
- Proposed solution
- Success criteria

---

### Step 2: RICE Scoring

**Evaluate:**
- Reach: How many users?
- Impact: How much impact?
- Confidence: How confident?
- Effort: How much effort?

**Calculate:**
- RICE Score = (Reach × Impact × Confidence) / Effort

---

### Step 3: Strategic Alignment

**Consider:**
- Strategic goals
- Customer requests
- Competitive pressure
- Market trends
- Technical debt

---

### Step 4: Prioritization

**Rank:**
- High priority: RICE > 100
- Medium priority: RICE 50-100
- Low priority: RICE < 50

---

## Feature Examples

### Example 1: Multi-Agent Orchestration

**Reach:** 500 users/quarter  
**Impact:** 3 (Massive)  
**Confidence:** 80%  
**Effort:** 2 person-months

**RICE Score:** (500 × 3 × 0.8) / 2 = 600

**Priority:** High

---

### Example 2: Dark Mode

**Reach:** 1,000 users/quarter  
**Impact:** 0.5 (Low)  
**Confidence:** 100%  
**Effort:** 0.5 person-months

**RICE Score:** (1,000 × 0.5 × 1.0) / 0.5 = 1,000

**Priority:** High (but low impact)

---

### Example 3: Advanced Analytics

**Reach:** 200 users/quarter  
**Impact:** 2 (High)  
**Confidence:** 80%  
**Effort:** 3 person-months

**RICE Score:** (200 × 2 × 0.8) / 3 = 107

**Priority:** High

---

## Alternative Frameworks

### Value vs. Effort Matrix

**High Value, Low Effort:** Quick Wins (Do First)  
**High Value, High Effort:** Strategic Projects (Plan)  
**Low Value, Low Effort:** Fill-ins (Consider)  
**Low Value, High Effort:** Time Sinks (Avoid)

---

### Kano Model

**Basic Features:** Must-haves  
**Performance Features:** More is better  
**Delight Features:** Unexpected value

---

### MoSCoW Method

**Must Have:** Critical  
**Should Have:** Important  
**Could Have:** Nice to have  
**Won't Have:** Not now

---

## Review & Updates

### Review Schedule

**Weekly:** Feature review  
**Monthly:** Prioritization review  
**Quarterly:** Framework review

### Update Process

1. **Gather Data**
   - Usage metrics
   - Customer feedback
   - Market research
   - Competitive analysis

2. **Re-evaluate**
   - Update RICE scores
   - Adjust priorities
   - Consider new information

3. **Communicate**
   - Share priorities
   - Explain decisions
   - Set expectations

---

## Success Criteria

### Prioritization Success

**Must Achieve:**
- Clear priorities
- Data-driven decisions
- Stakeholder alignment
- Transparent process

**Nice to Have:**
- Automated scoring
- Real-time updates
- Predictive analytics
- AI-assisted prioritization

---

**Remember:** Prioritization is about making trade-offs. Focus on value, consider constraints, and stay flexible.
