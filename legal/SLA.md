# Service Level Agreement (SLA)

**Last Updated:** 2024-01-XX  
**Effective Date:** [Date]  
**Version:** 1.0

---

## Overview

This Service Level Agreement ("SLA") defines the service levels, availability guarantees, and support commitments for Agent Factory Platform services.

**Agreement Parties:**
- **Service Provider:** Agent Factory
- **Customer:** [Customer Name]

**Service Period:** [Start Date] to [End Date]

---

## Service Levels by Tier

### Free Tier

**Uptime:** Best effort (no guarantee)  
**Support:** Community support only  
**Response Time:** No guarantee

### Starter Tier ($49/month)

**Uptime:** 99.0% (7.2 hours downtime/month)  
**Support:** Email support, 48-hour response time  
**Response Time:** p95 < 1 second

### Pro Tier ($199/month)

**Uptime:** 99.5% (3.6 hours downtime/month)  
**Support:** Priority email support, 24-hour response time  
**Response Time:** p95 < 500ms

### Enterprise Tier ($999+/month)

**Uptime:** 99.9% (43 minutes downtime/month)  
**Support:** Dedicated support, 4-hour response time SLA  
**Response Time:** p95 < 200ms  
**Custom SLAs:** Available upon request

---

## Uptime Calculation

### Definition

**Uptime:** Percentage of time the API is available and responding correctly.

**Formula:**
```
Uptime = (Total Time - Downtime) / Total Time × 100%
```

### Downtime Definition

**Downtime:** Any period where:
- API returns 5xx errors for > 1% of requests
- Health endpoint returns non-200 status
- API is completely unreachable

**Excluded from Downtime:**
- Scheduled maintenance (with 7 days notice)
- Customer-caused issues
- Third-party service outages (OpenAI, Anthropic)
- Force majeure events

### Measurement

**Method:** Health endpoint monitoring every 1 minute  
**Location:** Multiple geographic regions  
**Calculation:** Monthly rolling average

---

## Support Response Times

### Response Time Definition

**Response Time:** Time from ticket creation to first human response.

### Response Time SLAs

| Tier | Response Time | Support Channel |
|------|---------------|-----------------|
| Free | No SLA | Community |
| Starter | 48 hours | Email |
| Pro | 24 hours | Email |
| Enterprise | 4 hours | Dedicated Slack |

### Support Hours

**Free/Starter/Pro:** Business hours (9 AM - 5 PM EST, Mon-Fri)  
**Enterprise:** 24/7 support

---

## Performance SLAs

### Response Time Targets

| Tier | p50 Target | p95 Target | p99 Target |
|------|------------|------------|------------|
| Free | < 500ms | < 1s | < 2s |
| Starter | < 300ms | < 1s | < 1.5s |
| Pro | < 200ms | < 500ms | < 1s |
| Enterprise | < 100ms | < 200ms | < 500ms |

### Measurement

**Method:** API response time monitoring  
**Frequency:** Continuous  
**Calculation:** Rolling 30-day average

---

## Service Credits

### Uptime Credits

**If Uptime < SLA:**
- **99.0% - 98.0%:** 10% service credit
- **98.0% - 97.0%:** 25% service credit
- **< 97.0%:** 50% service credit

**If Response Time > SLA:**
- **2x SLA:** 10% service credit
- **3x SLA:** 25% service credit
- **> 3x SLA:** 50% service credit

### Support Response Credits

**If Response Time > SLA:**
- **2x SLA:** 10% service credit
- **3x SLA:** 25% service credit
- **> 3x SLA:** 50% service credit

### Credit Calculation

**Service Credit:** Percentage of monthly subscription fee  
**Maximum Credit:** 50% of monthly fee  
**Credit Application:** Next billing cycle

### Credit Request Process

1. Customer submits credit request within 30 days of incident
2. Agent Factory verifies SLA violation
3. Credit applied to next billing cycle
4. Customer notified of credit application

---

## Maintenance Windows

### Scheduled Maintenance

**Frequency:** Monthly (if needed)  
**Duration:** Up to 4 hours  
**Notice:** 7 days advance notice  
**Time:** Off-peak hours (2 AM - 6 AM EST)

### Emergency Maintenance

**Notice:** As much as possible (minimum 2 hours)  
**Duration:** As short as possible  
**Communication:** Email, dashboard notification

### Maintenance Exclusion

Scheduled maintenance does not count toward downtime if:
- 7 days notice provided
- Performed during off-peak hours
- Duration < 4 hours

---

## Exclusions

### Not Covered by SLA

- Customer-caused issues
- Third-party service outages (OpenAI, Anthropic, etc.)
- Force majeure events
- DDoS attacks (mitigation provided but no SLA)
- Customer infrastructure issues
- API misuse or abuse

### Customer Responsibilities

- Maintain valid API keys
- Follow rate limits
- Use API according to documentation
- Report issues promptly
- Provide necessary information for support

---

## Monitoring & Reporting

### Uptime Monitoring

**Method:** Automated health checks  
**Frequency:** Every 1 minute  
**Locations:** Multiple geographic regions  
**Public Dashboard:** [Status Page URL]

### Performance Monitoring

**Method:** API response time tracking  
**Frequency:** Continuous  
**Metrics:** p50, p95, p99 response times  
**Dashboard:** Available in customer portal

### Monthly Reports

**Content:**
- Uptime percentage
- Response time statistics
- Incident summary
- SLA compliance status

**Delivery:** First week of each month  
**Format:** Email + PDF report

---

## Incident Communication

### Incident Notification

**Channels:**
- Status page
- Email (for Enterprise customers)
- Slack (for Enterprise customers)

**Timing:**
- Initial notification: Within 15 minutes
- Updates: Every 30 minutes during incident
- Resolution: Within 1 hour of resolution

### Status Page

**URL:** https://status.agentfactory.io  
**Updates:** Real-time during incidents  
**Historical:** 90-day incident history

---

## SLA Modifications

### Changes to SLA

**Notice:** 30 days advance notice  
**Method:** Email notification  
**Effective:** Next billing cycle

### Custom SLAs

**Enterprise Customers:** Custom SLAs available  
**Negotiation:** During contract negotiation  
**Documentation:** Included in Enterprise agreement

---

## Dispute Resolution

### SLA Disputes

1. Customer submits dispute with evidence
2. Agent Factory reviews within 5 business days
3. Resolution provided within 10 business days
4. Escalation available if unresolved

### Escalation

**Level 1:** Support Manager  
**Level 2:** Engineering Lead  
**Level 3:** CTO

---

## Definitions

**Uptime:** Percentage of time service is available  
**Downtime:** Period when service is unavailable  
**Response Time:** API response time (p50, p95, p99)  
**Support Response Time:** Time to first human response  
**Service Credit:** Percentage refund of monthly fee  
**Scheduled Maintenance:** Planned maintenance with notice  
**Emergency Maintenance:** Unplanned maintenance  
**Force Majeure:** Events beyond reasonable control

---

## Contact

**Agent Factory**  
**Founder, CEO & Operator:** Scott Hardie  
**Email:** scottrmhardie@gmail.com  
**SLA Questions:** sla@agentfactory.io  
**Support:** support@agentfactory.io  
**Enterprise:** enterprise@agentfactory.io

**Company Information:**
- **Founder, CEO & Operator:** Scott Hardie
- **Location:** Greater Toronto Area, Canada
- **GitHub:** github.com/shardie-github
- **LinkedIn:** linkedin.com/in/scottrmhardie

---

## Appendix: SLA Summary Table

| Metric | Free | Starter | Pro | Enterprise |
|--------|------|---------|-----|------------|
| **Uptime** | Best effort | 99.0% | 99.5% | 99.9% |
| **Response Time (p95)** | < 1s | < 1s | < 500ms | < 200ms |
| **Support Response** | Community | 48h | 24h | 4h |
| **Support Hours** | Community | Business | Business | 24/7 |
| **Service Credits** | No | Yes | Yes | Yes |
| **Status Page** | Yes | Yes | Yes | Yes |
| **Monthly Reports** | No | No | Yes | Yes |

---

**Note:** This SLA is a template. Customize with placeholder values. Customize with actual metrics, contact information, and legal review before publishing.
