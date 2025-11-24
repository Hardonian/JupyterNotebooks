# Incident Response Runbook

**Last Updated:** 2024-01-XX  
**Purpose:** Standardized procedures for responding to production incidents

---

## Overview

This runbook provides step-by-step procedures for responding to incidents affecting the Agent Factory platform.

**Severity Levels:**
- **P0 (Critical):** Service completely down, data loss, security breach
- **P1 (High):** Major feature broken, significant performance degradation
- **P2 (Medium):** Minor feature broken, moderate performance issues
- **P3 (Low):** Cosmetic issues, minor bugs

---

## Pre-Incident Preparation

### On-Call Rotation
- **Schedule:** Weekly rotation
- **Coverage:** 24/7 for P0/P1, business hours for P2/P3
- **Escalation:** Engineering Lead → CTO → CEO

### Access Requirements
- GitHub repository access
- Vercel dashboard access
- Supabase dashboard access
- Database access (read-only for most, write for emergencies)
- Monitoring dashboards (Sentry, logs)

### Communication Channels
- **Primary:** Slack #incidents channel
- **Secondary:** Email alerts
- **Escalation:** Phone/SMS for P0 incidents

---

## Incident Response Process

### Step 1: Acknowledge & Assess (0-5 minutes)

**Actions:**
1. Acknowledge incident in Slack #incidents
2. Assess severity level
3. Check monitoring dashboards:
   - Sentry for errors
   - Vercel for deployment status
   - Supabase for database health
   - API health endpoint: `/api/v1/health`

**Questions to Answer:**
- What is the impact? (users affected, features broken)
- What is the scope? (all users, specific region, specific feature)
- Is data at risk?
- Is security compromised?

**Document:**
```markdown
**Incident:** [Brief description]
**Severity:** P0/P1/P2/P3
**Detected:** [Time]
**Impact:** [Description]
**Status:** Investigating
```

---

### Step 2: Investigate (5-30 minutes)

**Check Monitoring:**
1. **Sentry Dashboard:**
   - Review error frequency
   - Check error patterns
   - Identify affected endpoints

2. **Vercel Dashboard:**
   - Check deployment status
   - Review build logs
   - Check function logs

3. **Database (Supabase):**
   - Check connection pool usage
   - Review slow queries
   - Check for locks/deadlocks

4. **Application Logs:**
   ```bash
   # Check recent errors
   vercel logs --follow
   
   # Or via Supabase logs
   # Check application logs in Supabase dashboard
   ```

**Common Issues & Checks:**

**Database Issues:**
- Check connection pool exhaustion
- Review migration status
- Check for schema issues
- Verify RLS policies

**API Issues:**
- Check rate limiting
- Review authentication failures
- Check external API dependencies (OpenAI, Anthropic)

**Deployment Issues:**
- Check recent deployments
- Review build failures
- Check environment variables

---

### Step 3: Mitigate (Immediate)

**Immediate Actions:**

**For P0 (Critical):**
1. **If service is down:**
   - Check if recent deployment caused issue
   - Consider rollback to previous deployment
   - Enable maintenance mode if needed

2. **If database is affected:**
   - Check database connection
   - Review recent migrations
   - Consider pausing migrations

3. **If security breach:**
   - Rotate all secrets immediately
   - Review access logs
   - Notify security team

**Rollback Procedure:**
```bash
# Vercel rollback
vercel rollback [deployment-url]

# Or via Vercel dashboard:
# 1. Go to Deployments
# 2. Find last working deployment
# 3. Click "Promote to Production"
```

**Maintenance Mode:**
```bash
# Set maintenance mode (if implemented)
# Update environment variable:
MAINTENANCE_MODE=true

# Or update health endpoint to return 503
```

---

### Step 4: Resolve (30 minutes - 2 hours)

**Resolution Steps:**

1. **Identify Root Cause:**
   - Review error logs
   - Check recent changes
   - Test in staging environment

2. **Fix Issue:**
   - Create hotfix branch
   - Implement fix
   - Test locally
   - Deploy to staging
   - Verify fix

3. **Deploy Fix:**
   ```bash
   # Create hotfix branch
   git checkout -b hotfix/incident-[id]
   
   # Make changes
   # Test locally
   
   # Deploy to production
   git push origin hotfix/incident-[id]
   # Merge to main via PR
   ```

4. **Verify Resolution:**
   - Check health endpoint
   - Run smoke tests
   - Monitor error rates
   - Verify user reports stop

---

### Step 5: Post-Incident (Within 24 hours)

**Actions:**

1. **Update Status:**
   ```markdown
   **Status:** Resolved
   **Resolution Time:** [Duration]
   **Root Cause:** [Description]
   **Fix Applied:** [Description]
   ```

2. **Post-Mortem:**
   - Schedule post-mortem meeting (within 48 hours)
   - Document:
     - Timeline of events
     - Root cause analysis
     - What went well
     - What could be improved
     - Action items

3. **Create Issues:**
   - Create GitHub issues for:
     - Root cause fix (if not already fixed)
     - Prevention measures
     - Monitoring improvements
     - Documentation updates

4. **Update Runbook:**
   - Add lessons learned
   - Update procedures if needed
   - Document new scenarios

---

## Common Incident Scenarios

### Scenario 1: Database Connection Pool Exhausted

**Symptoms:**
- 503 errors
- "Too many connections" errors
- Slow response times

**Investigation:**
```bash
# Check Supabase dashboard
# Review connection pool usage
# Check for connection leaks
```

**Resolution:**
1. Check for connection leaks in code
2. Increase connection pool size (if needed)
3. Restart application (releases connections)
4. Review connection management code

**Prevention:**
- Monitor connection pool usage
- Set up alerts for high usage
- Review connection management patterns

---

### Scenario 2: API Rate Limiting Issues

**Symptoms:**
- 429 errors
- External API failures (OpenAI, Anthropic)
- Slow responses

**Investigation:**
```bash
# Check rate limit headers
curl -I https://api.agentfactory.io/api/v1/agents/

# Review external API usage
# Check OpenAI/Anthropic dashboards
```

**Resolution:**
1. Check rate limit configuration
2. Review external API usage
3. Implement exponential backoff
4. Consider upgrading API tier

**Prevention:**
- Monitor API usage
- Set up rate limit alerts
- Implement caching

---

### Scenario 3: Deployment Failure

**Symptoms:**
- Build failures
- Deployment errors
- Service unavailable

**Investigation:**
```bash
# Check Vercel build logs
vercel logs [deployment-id]

# Review GitHub Actions logs
# Check for environment variable issues
```

**Resolution:**
1. Review build logs
2. Check environment variables
3. Fix build issues
4. Redeploy

**Prevention:**
- Test builds before merging
- Use preview deployments
- Monitor deployment success rate

---

### Scenario 4: Security Incident

**Symptoms:**
- Unauthorized access
- Suspicious activity
- Data exposure

**Investigation:**
1. Review access logs
2. Check audit logs
3. Review authentication failures
4. Check for exposed secrets

**Resolution:**
1. **Immediate:**
   - Rotate all secrets
   - Revoke compromised tokens
   - Block suspicious IPs
   - Enable additional security

2. **Short-term:**
   - Review security policies
   - Update access controls
   - Enhance monitoring

**Prevention:**
- Regular security audits
- Secret rotation schedule
- Access review process
- Security monitoring

---

## Escalation Procedures

### When to Escalate

**Escalate to Engineering Lead:**
- P0 incident not resolved in 30 minutes
- P1 incident not resolved in 2 hours
- Security incident
- Data loss risk

**Escalate to CTO:**
- P0 incident not resolved in 1 hour
- Security breach confirmed
- Customer data at risk
- Service unavailable > 1 hour

**Escalate to CEO:**
- Security breach with data exposure
- Service unavailable > 4 hours
- Customer data loss
- Legal/compliance issues

### Escalation Contact Information

**Engineering Lead:**
- Slack: @engineering-lead
- Email: engineering-lead@agentfactory.io
- Phone: [On-call phone]

**CTO:**
- Slack: @cto
- Email: cto@agentfactory.io
- Phone: [On-call phone]

**CEO:**
- Email: ceo@agentfactory.io
- Phone: [Emergency phone]

---

## Monitoring & Alerts

### Key Metrics to Monitor

**Application Health:**
- Error rate (target: < 0.1%)
- Response time (target: p95 < 500ms)
- Uptime (target: 99.9%)
- Health check status

**Database:**
- Connection pool usage (target: < 80%)
- Query performance (target: p95 < 100ms)
- Database size
- Replication lag

**External Services:**
- OpenAI API status
- Anthropic API status
- Vercel deployment status
- Supabase service status

### Alert Thresholds

**P0 Alerts:**
- Error rate > 1%
- Uptime < 99%
- Database connection pool > 95%
- Security incident detected

**P1 Alerts:**
- Error rate > 0.5%
- Response time p95 > 1s
- Database connection pool > 85%
- External API failures

**P2 Alerts:**
- Error rate > 0.1%
- Response time p95 > 500ms
- High API usage

---

## Communication Templates

### Initial Incident Report

```
🚨 INCIDENT: [Brief Description]

**Severity:** P0/P1/P2/P3
**Detected:** [Time]
**Impact:** [Description]
**Status:** Investigating

**Affected:**
- Service: [Service name]
- Users: [Estimated number]
- Features: [List features]

**Current Status:**
- [What we know]
- [What we're checking]
- [Next steps]

**Updates:** Will provide updates every [X] minutes
```

### Status Update

```
📊 INCIDENT UPDATE: [Incident ID]

**Status:** [Investigating/Mitigating/Resolved]
**Duration:** [Time since start]

**Progress:**
- [What we've done]
- [What we found]
- [What we're doing next]

**ETA:** [Estimated resolution time]
```

### Resolution

```
✅ INCIDENT RESOLVED: [Incident ID]

**Duration:** [Total duration]
**Root Cause:** [Brief description]
**Fix Applied:** [What was done]

**Post-Mortem:** Scheduled for [Date/Time]
**Action Items:** [List items]

**Thank you for your patience!**
```

---

## Tools & Resources

### Dashboards
- **Sentry:** https://sentry.io/orgs/[org]/projects/
- **Vercel:** https://vercel.com/dashboard
- **Supabase:** https://supabase.com/dashboard/project/[project]
- **GitHub Actions:** https://github.com/[org]/[repo]/actions

### Scripts
- `scripts/smoke-tests.sh` - Smoke test script
- `scripts/db-validate-schema.py` - Database validation
- `scripts/env-doctor.py` - Environment validation

### Documentation
- [Deployment Strategy](deploy-strategy.md)
- [Troubleshooting Guide](../TROUBLESHOOTING.md)
- [Monitoring Guide](../observability.md)

---

## Review & Updates

**Review Frequency:** Monthly  
**Last Reviewed:** [Date]  
**Next Review:** [Date]

**Update Triggers:**
- After major incidents
- When procedures change
- When new tools are added
- Monthly review cycle

---

## Appendix: Quick Reference

### Emergency Contacts
- Engineering Lead: [Contact]
- CTO: [Contact]
- CEO: [Contact]

### Quick Commands
```bash
# Check health
curl https://api.agentfactory.io/api/v1/health

# Run smoke tests
./scripts/smoke-tests.sh production https://api.agentfactory.io

# Check database
python3 scripts/db-validate-schema.py

# Rollback deployment
vercel rollback [deployment-url]
```

### Key URLs
- Production API: https://api.agentfactory.io
- Health Check: https://api.agentfactory.io/api/v1/health
- API Docs: https://api.agentfactory.io/docs
- Status Page: [If available]

---

**Remember:** Stay calm, communicate clearly, document everything, and learn from each incident.
