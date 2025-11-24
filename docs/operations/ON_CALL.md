# On-Call Rotation & Procedures

**Last Updated:** 2024-01-XX  
**Purpose:** On-call rotation schedule, procedures, and escalation

---

## Overview

On-call engineers provide 24/7 coverage for production incidents. This document defines the rotation schedule, procedures, and escalation paths.

**Coverage:**
- **P0/P1 Incidents:** 24/7 coverage
- **P2/P3 Incidents:** Business hours (9 AM - 5 PM EST)

---

## On-Call Rotation

### Schedule

**Rotation:** Weekly (Monday 9 AM EST)  
**Duration:** 7 days  
**Handoff:** Monday 9 AM EST

### Current Rotation

| Week | Primary On-Call | Secondary On-Call | Escalation |
|------|----------------|-------------------|------------|
| Week 1 | [Name] | [Name] | Engineering Lead |
| Week 2 | [Name] | [Name] | Engineering Lead |
| Week 3 | [Name] | [Name] | Engineering Lead |
| Week 4 | [Name] | [Name] | Engineering Lead |

### Rotation Rules

- Rotate weekly
- No consecutive weeks (unless emergency)
- Minimum 2 engineers per rotation
- Escalation contact always available

---

## On-Call Responsibilities

### Primary On-Call

**Responsibilities:**
- Respond to P0/P1 incidents within 15 minutes
- Respond to P2/P3 incidents within 2 hours (business hours)
- Acknowledge alerts
- Investigate incidents
- Escalate if needed
- Document incidents

**Availability:**
- Must be reachable 24/7
- Must have internet access
- Must have access to systems

### Secondary On-Call

**Responsibilities:**
- Backup for primary on-call
- Respond if primary unavailable
- Assist with incidents
- Escalate if primary unavailable

---

## On-Call Tools

### Alerting

**Tool:** PagerDuty (or similar)  
**Integration:** Sentry, Vercel, Supabase  
**Notifications:** Phone, SMS, Email, Slack

### Access

**Required Access:**
- GitHub repository
- Vercel dashboard
- Supabase dashboard
- Sentry dashboard
- Monitoring dashboards
- Database access (read-only for most)

### Communication

**Channels:**
- Slack #incidents channel
- PagerDuty (alerts)
- Phone/SMS (escalation)

---

## On-Call Procedures

### Receiving Alert

1. **Acknowledge Alert** (within 5 minutes)
   - Acknowledge in PagerDuty
   - Post in Slack #incidents

2. **Assess Severity**
   - Determine severity level
   - Check if already being handled

3. **Investigate**
   - Check monitoring dashboards
   - Review error logs
   - Identify root cause

4. **Respond**
   - Implement fix or mitigation
   - Escalate if needed
   - Communicate status

### Escalation

**When to Escalate:**
- P0 incident not resolved in 30 minutes
- P1 incident not resolved in 2 hours
- Need additional expertise
- Security incident

**Escalation Path:**
1. Secondary on-call
2. Engineering Lead
3. CTO
4. CEO (for critical incidents)

---

## On-Call Compensation

### Compensation Policy

**Primary On-Call:**
- Base: $X per week
- Incident response: $Y per incident
- Weekend coverage: Additional $Z

**Secondary On-Call:**
- Base: $X/2 per week
- Active response: Same as primary

### Time Off

- Time off for on-call response
- Minimum 4 hours off after P0 incident
- Comp time for weekend coverage

---

## On-Call Best Practices

### Preparation

- Review runbooks before shift
- Test access to all systems
- Ensure tools are working
- Review recent incidents

### During Shift

- Stay reachable
- Monitor alerts actively
- Document everything
- Communicate clearly

### After Shift

- Complete incident documentation
- Hand off unresolved issues
- Update runbooks if needed
- Provide feedback

---

## Handoff Procedures

### Weekly Handoff

**When:** Monday 9 AM EST  
**Format:** Slack message or meeting

**Content:**
- Active incidents
- Recent incidents
- System status
- Known issues
- Upcoming maintenance

### Incident Handoff

**When:** Incident resolved or shift ends  
**Format:** Incident ticket or Slack thread

**Content:**
- Incident summary
- Current status
- Next steps
- Action items

---

## On-Call Schedule Management

### Schedule Changes

**Request Changes:**
- Submit request 2 weeks in advance
- Find coverage replacement
- Update schedule
- Notify team

### Emergency Coverage

**If On-Call Unavailable:**
- Contact secondary on-call
- Escalate to Engineering Lead
- Use backup rotation

---

## On-Call Metrics

### Tracking

**Metrics:**
- Response time
- Resolution time
- Escalation rate
- Incident count

### Review

**Frequency:** Monthly  
**Review:** On-call performance  
**Improvements:** Based on metrics

---

## On-Call Training

### Initial Training

**New On-Call Engineers:**
- Shadow experienced engineer
- Review runbooks
- Test access
- Practice incident response

### Ongoing Training

**Regular Updates:**
- New procedures
- New tools
- Lessons learned
- Best practices

---

## Contact Information

### On-Call Contacts

**Current Primary:** [Name] - [Phone] - [Email]  
**Current Secondary:** [Name] - [Phone] - [Email]  
**Engineering Lead:** [Name] - [Phone] - [Email]  
**CTO:** [Name] - [Phone] - [Email]

### Emergency Contacts

**After Hours:** [Phone]  
**Escalation:** [Phone]  
**Security:** security@agentfactory.io

---

## Review & Updates

**Review Frequency:** Monthly  
**Last Reviewed:** [Date]  
**Next Review:** [Date]

**Update Triggers:**
- When rotation changes
- When procedures change
- When tools change
- Monthly review cycle

---

## Appendix: Quick Reference

### On-Call Checklist

**Before Shift:**
- [ ] Review runbooks
- [ ] Test system access
- [ ] Check alerting tools
- [ ] Review recent incidents

**During Shift:**
- [ ] Monitor alerts
- [ ] Respond promptly
- [ ] Document incidents
- [ ] Communicate status

**After Shift:**
- [ ] Complete documentation
- [ ] Hand off issues
- [ ] Update runbooks
- [ ] Provide feedback

### Escalation Decision Tree

```
Incident Severity?
├─ P0 → Resolve in 30 min or escalate
├─ P1 → Resolve in 2 hours or escalate
├─ P2 → Resolve in business hours
└─ P3 → Document and schedule

Need Help?
├─ Yes → Escalate to secondary
└─ No → Continue investigation

Still Stuck?
├─ Yes → Escalate to Engineering Lead
└─ No → Continue resolution
```

---

**Remember:** On-call is about protecting the service and helping customers. Stay calm, follow procedures, and escalate when needed.
