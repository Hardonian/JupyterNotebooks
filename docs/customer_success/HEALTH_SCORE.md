# Customer Health Score Framework

**Last Updated:** 2024-01-XX  
**Purpose:** Customer health score calculation and monitoring framework

---

## Overview

**Purpose:** Identify at-risk customers early and drive expansion opportunities  
**Frequency:** Calculated weekly, reviewed monthly  
**Scale:** 0-100 (0-59: Critical, 60-79: At Risk, 80-100: Healthy)

---

## Health Score Components

### 1. Product Usage (40% Weight)

**Metrics:**
- Active agents count
- API calls per month
- Feature adoption rate
- Login frequency
- Session duration

**Scoring:**
- **High (80-100):** Active usage, multiple agents, high API calls
- **Medium (60-79):** Moderate usage, some agents, moderate API calls
- **Low (0-59):** Low usage, few/no agents, low API calls

**Calculation:**
```
Usage Score = (Active Agents × 20) + (API Calls Factor × 20) + 
              (Feature Adoption × 20) + (Login Frequency × 20) + 
              (Session Duration × 20)
```

---

### 2. Engagement (30% Weight)

**Metrics:**
- Support ticket volume (inverse)
- Training attendance
- Community participation
- Feedback provided
- Response to communications

**Scoring:**
- **High (80-100):** High engagement, positive interactions
- **Medium (60-79):** Moderate engagement, neutral interactions
- **Low (0-59):** Low engagement, negative interactions

**Calculation:**
```
Engagement Score = (Support Tickets Factor × 20) + 
                   (Training Attendance × 20) + 
                   (Community Participation × 20) + 
                   (Feedback Provided × 20) + 
                   (Response Rate × 20)
```

---

### 3. Business Outcomes (20% Weight)

**Metrics:**
- Goals achieved
- ROI realized
- Value demonstrated
- Success metrics met
- Referenceability

**Scoring:**
- **High (80-100):** Goals achieved, ROI positive, referenceable
- **Medium (60-79):** Some goals achieved, ROI neutral
- **Low (0-59):** Goals not achieved, ROI negative

**Calculation:**
```
Outcomes Score = (Goals Achieved × 20) + (ROI Factor × 20) + 
                 (Value Demonstrated × 20) + (Success Metrics × 20) + 
                 (Referenceability × 20)
```

---

### 4. Relationship (10% Weight)

**Metrics:**
- NPS score
- CSAT score
- Customer satisfaction
- Advocacy
- Relationship strength

**Scoring:**
- **High (80-100):** High satisfaction, strong relationship
- **Medium (60-79):** Moderate satisfaction, neutral relationship
- **Low (0-59):** Low satisfaction, weak relationship

**Calculation:**
```
Relationship Score = (NPS Factor × 20) + (CSAT Factor × 20) + 
                     (Satisfaction × 20) + (Advocacy × 20) + 
                     (Relationship Strength × 20)
```

---

## Health Score Calculation

### Formula

```
Health Score = (Usage Score × 0.4) + (Engagement Score × 0.3) + 
               (Outcomes Score × 0.2) + (Relationship Score × 0.1)
```

---

### Scoring Ranges

**Healthy (80-100):** Green
- Strong usage
- High engagement
- Positive outcomes
- Strong relationship
- **Action:** Focus on expansion

**At Risk (60-79):** Yellow
- Moderate usage
- Moderate engagement
- Neutral outcomes
- Neutral relationship
- **Action:** Re-engage, prevent churn

**Critical (<60):** Red
- Low usage
- Low engagement
- Negative outcomes
- Weak relationship
- **Action:** Immediate intervention

---

## Health Score Monitoring

### Weekly Monitoring

**Activities:**
- Calculate health scores
- Identify changes
- Flag at-risk customers
- Update dashboards

**Reports:**
- Health score distribution
- Changes from previous week
- At-risk customers list
- Critical customers list

---

### Monthly Review

**Activities:**
- Trend analysis
- Segment analysis
- Intervention effectiveness
- Process improvements

**Reports:**
- Health score trends
- Segment performance
- Intervention results
- Recommendations

---

## Health Score Actions

### Healthy Customers (80-100)

**Actions:**
- Identify expansion opportunities
- Build advocacy
- Share success stories
- Upsell/cross-sell
- Reference requests

**Frequency:** Monthly check-ins

---

### At-Risk Customers (60-79)

**Actions:**
- Identify issues
- Re-engage
- Provide support
- Value demonstration
- Prevent churn

**Frequency:** Bi-weekly check-ins

---

### Critical Customers (<60)

**Actions:**
- Immediate intervention
- Executive escalation
- Recovery plan
- Intensive support
- Retention offers

**Frequency:** Weekly check-ins

---

## Health Score Factors

### Positive Factors

**Increase Health Score:**
- Increased usage
- Feature adoption
- Positive feedback
- Goal achievement
- High engagement

---

### Negative Factors

**Decrease Health Score:**
- Decreased usage
- Support tickets increase
- Negative feedback
- Goals not met
- Low engagement

---

## Health Score Examples

### Example 1: Healthy Customer

**Usage:** 5 active agents, 10K API calls/month, 80% feature adoption  
**Engagement:** Low support tickets, high training attendance  
**Outcomes:** Goals achieved, positive ROI, referenceable  
**Relationship:** NPS 70, CSAT 4.8/5

**Health Score:** 85 (Healthy)

**Action:** Focus on expansion, build advocacy

---

### Example 2: At-Risk Customer

**Usage:** 1 active agent, 1K API calls/month, 30% feature adoption  
**Engagement:** Moderate support tickets, low training attendance  
**Outcomes:** Some goals achieved, neutral ROI  
**Relationship:** NPS 40, CSAT 3.5/5

**Health Score:** 65 (At Risk)

**Action:** Re-engage, provide support, prevent churn

---

### Example 3: Critical Customer

**Usage:** 0 active agents, 100 API calls/month, 10% feature adoption  
**Engagement:** High support tickets, no training attendance  
**Outcomes:** Goals not achieved, negative ROI  
**Relationship:** NPS 20, CSAT 2.5/5

**Health Score:** 45 (Critical)

**Action:** Immediate intervention, executive escalation, recovery plan

---

## Health Score Tools

### Tools Used

**Analytics:** Mixpanel/Amplitude  
**CRM:** HubSpot/Salesforce  
**Support:** Zendesk/Intercom  
**Dashboards:** Custom dashboards  
**Alerts:** Automated alerts

---

## Review & Optimization

### Review Schedule

**Weekly:** Health score calculation  
**Monthly:** Trend analysis  
**Quarterly:** Framework review

### Optimization Process

1. **Monitor Performance**
   - Track health scores
   - Identify trends
   - Spot issues

2. **Analyze Effectiveness**
   - Intervention success
   - Churn prevention
   - Expansion opportunities

3. **Optimize**
   - Adjust weights
   - Refine metrics
   - Improve processes
   - Update tools

---

## Success Criteria

### Year 1 Targets

**Health Score Distribution:**
- Healthy: 70%+
- At Risk: 20-25%
- Critical: <10%

**Intervention Success:**
- 50%+ at-risk customers recover
- 30%+ critical customers recover
- Churn rate <10%

---

**Remember:** Health scores are indicators, not absolutes. Use them to guide actions, not make decisions in isolation. Always consider context and customer feedback.
