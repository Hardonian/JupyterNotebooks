# Monitoring & Alerting Runbook

**Last Updated:** 2024-01-XX  
**Purpose:** Comprehensive guide to monitoring and alerting for Agent Factory platform

---

## Overview

This runbook documents monitoring strategies, alert configurations, and response procedures for the Agent Factory platform.

**Monitoring Stack:**
- **Application Errors:** Sentry
- **Application Metrics:** Prometheus (via `/metrics` endpoint)
- **Logs:** Structured JSON logs (Vercel/Supabase)
- **Uptime:** Health endpoint monitoring
- **Database:** Supabase dashboard

---

## Key Metrics

### Application Metrics

**Error Rate:**
- **Target:** < 0.1%
- **Alert Threshold:** > 0.5% (P1), > 1% (P0)
- **Measurement:** Errors per total requests

**Response Time:**
- **Target:** p95 < 500ms, p99 < 1s
- **Alert Threshold:** p95 > 1s (P1), p95 > 2s (P0)
- **Measurement:** API endpoint response times

**Uptime:**
- **Target:** 99.9%
- **Alert Threshold:** < 99% (P0)
- **Measurement:** Health endpoint availability

**Request Rate:**
- **Monitor:** Requests per minute/hour
- **Alert Threshold:** Unusual spikes (> 2x baseline)
- **Measurement:** Total API requests

### Database Metrics

**Connection Pool Usage:**
- **Target:** < 80%
- **Alert Threshold:** > 85% (P1), > 95% (P0)
- **Measurement:** Active connections / max connections

**Query Performance:**
- **Target:** p95 < 100ms
- **Alert Threshold:** p95 > 500ms (P1), p95 > 1s (P0)
- **Measurement:** Database query execution time

**Database Size:**
- **Monitor:** Growth rate
- **Alert Threshold:** > 80% of quota
- **Measurement:** Total database size

### External Service Metrics

**OpenAI API:**
- **Monitor:** Success rate, latency
- **Alert Threshold:** Success rate < 95%
- **Measurement:** API call success/failure

**Anthropic API:**
- **Monitor:** Success rate, latency
- **Alert Threshold:** Success rate < 95%
- **Measurement:** API call success/failure

**Vercel:**
- **Monitor:** Deployment success rate
- **Alert Threshold:** Deployment failures
- **Measurement:** Build/deployment status

---

## Monitoring Setup

### Sentry Error Tracking

**Configuration:**
- DSN configured via `SENTRY_DSN`
- Environment: `production`/`preview`
- Sample rates: Traces 10%, Profiles 10%

**Key Alerts:**
- Error rate spike (> 10 errors/minute)
- New error types
- Critical errors (5xx)
- Authentication failures

**Dashboard:**
- Error frequency over time
- Error breakdown by type
- Affected users
- Error trends

### Prometheus Metrics

**Endpoint:** `/metrics`

**Key Metrics:**
- `http_requests_total` - Total HTTP requests
- `http_request_duration_seconds` - Request duration
- `http_errors_total` - Total errors
- `agent_executions_total` - Agent executions
- `workflow_executions_total` - Workflow executions

**Scraping:**
```yaml
# Prometheus scrape config
scrape_configs:
  - job_name: 'agent-factory'
    static_configs:
      - targets: ['api.agentfactory.io:9090']
```

### Health Endpoint Monitoring

**Endpoint:** `/api/v1/health`

**Response:**
```json
{
  "status": "healthy",
  "database": "connected",
  "cache": "connected",
  "version": "0.1.0"
}
```

**Monitoring:**
- Uptime monitoring (every 1 minute)
- Response time monitoring
- Status code monitoring (expect 200)

**Alert:** If health check fails or returns non-200

### Log Monitoring

**Log Format:** Structured JSON

**Key Log Fields:**
- `timestamp`
- `level` (DEBUG, INFO, WARNING, ERROR)
- `message`
- `request_id`
- `user_id` (if applicable)
- `tenant_id` (if applicable)

**Log Aggregation:**
- Vercel function logs
- Supabase logs
- Application logs

**Key Patterns to Monitor:**
- ERROR level logs
- Authentication failures
- Database errors
- External API failures

---

## Alert Configuration

### Alert Severity Levels

**P0 (Critical):**
- Service completely down
- Data loss risk
- Security breach
- Response time: Immediate

**P1 (High):**
- Major feature broken
- Significant performance degradation
- High error rate
- Response time: < 30 minutes

**P2 (Medium):**
- Minor feature broken
- Moderate performance issues
- Response time: < 2 hours

**P3 (Low):**
- Cosmetic issues
- Minor bugs
- Response time: < 24 hours

### Alert Channels

**Slack:**
- Channel: `#alerts`
- Format: Structured messages with severity
- Escalation: @channel for P0, @here for P1

**Email:**
- Recipients: On-call engineer, Engineering Lead
- Format: Detailed alert information
- Escalation: CTO for P0

**SMS/Phone:**
- Recipients: On-call engineer (P0 only)
- Format: Brief alert summary
- Escalation: CTO if no response in 15 minutes

### Alert Rules

**Error Rate Alert:**
```yaml
Alert: HighErrorRate
Condition: error_rate > 0.5% for 5 minutes
Severity: P1
Channel: Slack #alerts
```

**Response Time Alert:**
```yaml
Alert: SlowResponseTime
Condition: p95_response_time > 1s for 5 minutes
Severity: P1
Channel: Slack #alerts
```

**Uptime Alert:**
```yaml
Alert: ServiceDown
Condition: health_check_fails for 2 minutes
Severity: P0
Channel: Slack #alerts, SMS
```

**Database Connection Alert:**
```yaml
Alert: DatabaseConnectionPoolHigh
Condition: connection_pool_usage > 85% for 5 minutes
Severity: P1
Channel: Slack #alerts
```

---

## Dashboards

### Application Dashboard

**Metrics:**
- Request rate (requests/minute)
- Error rate (%)
- Response time (p50, p95, p99)
- Uptime (%)
- Active users

**Visualizations:**
- Time series graphs
- Error breakdown pie chart
- Response time distribution
- Uptime trend

### Database Dashboard

**Metrics:**
- Connection pool usage
- Query performance (p95, p99)
- Database size
- Slow queries
- Transaction rate

**Visualizations:**
- Connection pool usage over time
- Query performance trends
- Database size growth
- Top slow queries

### Business Metrics Dashboard

**Metrics:**
- Active agents
- Workflow executions
- API usage
- User signups
- Revenue (if applicable)

**Visualizations:**
- Growth trends
- Usage patterns
- User activity
- Revenue trends

---

## Response Procedures

### Alert Received

**Step 1: Acknowledge (0-2 minutes)**
- Acknowledge alert in Slack
- Assess severity
- Check if already being handled

**Step 2: Investigate (2-10 minutes)**
- Check monitoring dashboards
- Review error logs
- Check recent changes
- Identify root cause

**Step 3: Respond (10-30 minutes)**
- Implement fix or mitigation
- Deploy fix if needed
- Verify resolution
- Update alert status

**Step 4: Document (Within 24 hours)**
- Document incident
- Update runbooks if needed
- Create follow-up issues

### False Positive Handling

**If Alert is False Positive:**
1. Acknowledge alert
2. Mark as false positive
3. Review alert configuration
4. Adjust thresholds if needed
5. Document reason

---

## Monitoring Tools

### Sentry

**Access:** https://sentry.io/orgs/[org]/projects/

**Key Features:**
- Error tracking
- Performance monitoring
- Release tracking
- User impact analysis

**Usage:**
- Review error trends
- Investigate specific errors
- Track error resolution
- Monitor performance

### Vercel Dashboard

**Access:** https://vercel.com/dashboard

**Key Features:**
- Deployment history
- Function logs
- Analytics
- Performance metrics

**Usage:**
- Check deployment status
- Review function logs
- Monitor performance
- Analyze traffic

### Supabase Dashboard

**Access:** https://supabase.com/dashboard/project/[project]

**Key Features:**
- Database metrics
- Connection pool monitoring
- Query performance
- Storage usage

**Usage:**
- Monitor database health
- Review slow queries
- Check connection pool
- Monitor storage

### GitHub Actions

**Access:** https://github.com/[org]/[repo]/actions

**Key Features:**
- Workflow runs
- Build logs
- Test results
- Deployment status

**Usage:**
- Check CI/CD status
- Review build logs
- Monitor test results
- Track deployments

---

## Best Practices

### Monitoring

1. **Monitor Key Metrics:**
   - Focus on metrics that indicate user impact
   - Set appropriate thresholds
   - Review and adjust regularly

2. **Use Multiple Data Sources:**
   - Don't rely on single monitoring tool
   - Cross-reference metrics
   - Validate alerts

3. **Set Up Dashboards:**
   - Create dashboards for key metrics
   - Make dashboards accessible
   - Review dashboards regularly

### Alerting

1. **Avoid Alert Fatigue:**
   - Set appropriate thresholds
   - Use severity levels
   - Group related alerts

2. **Make Alerts Actionable:**
   - Include context in alerts
   - Provide links to dashboards
   - Include remediation steps

3. **Review and Tune:**
   - Review alert effectiveness
   - Adjust thresholds based on data
   - Remove unnecessary alerts

### Response

1. **Respond Quickly:**
   - Acknowledge alerts promptly
   - Escalate if needed
   - Communicate status

2. **Document Everything:**
   - Document incidents
   - Update runbooks
   - Share learnings

3. **Learn and Improve:**
   - Review incidents
   - Identify improvements
   - Implement changes

---

## Review & Updates

**Review Frequency:** Monthly  
**Last Reviewed:** [Date]  
**Next Review:** [Date]

**Update Triggers:**
- When metrics change
- When new services are added
- After incidents
- Monthly review cycle

---

## Appendix: Quick Reference

### Key Metrics Targets

| Metric | Target | P1 Alert | P0 Alert |
|--------|--------|----------|----------|
| Error Rate | < 0.1% | > 0.5% | > 1% |
| Response Time (p95) | < 500ms | > 1s | > 2s |
| Uptime | 99.9% | < 99% | < 95% |
| DB Connection Pool | < 80% | > 85% | > 95% |
| Query Performance (p95) | < 100ms | > 500ms | > 1s |

### Alert Channels

- **P0:** Slack #alerts @channel, SMS, Email
- **P1:** Slack #alerts @here, Email
- **P2:** Slack #alerts, Email
- **P3:** Slack #alerts

### Key Dashboards

- Sentry: Error tracking
- Vercel: Deployment & performance
- Supabase: Database health
- Prometheus: Application metrics

---

**Remember:** Monitor proactively, alert appropriately, and respond quickly.
