# Observability Guide

**Last Updated:** 2024-01-XX  
**Purpose:** Complete guide to monitoring, logging, metrics, and tracing

---

## Executive Summary

**Observability Stack:**
- **Logging:** Structured JSON logging
- **Metrics:** Prometheus metrics
- **Tracing:** Optional (Jaeger)
- **Health Checks:** Built-in endpoints

**Status:** ✅ Basic observability implemented, advanced features optional

---

## 1. Logging

### Structured Logging

**Format:** JSON (production) or text (development)

**Configuration:**
```bash
LOG_LEVEL=INFO          # DEBUG, INFO, WARNING, ERROR
LOG_FORMAT=json         # json or text
```

**Location:** `agent_factory/monitoring/logging.py`

**Features:**
- Structured JSON logs
- Request/response logging
- Error tracking
- Contextual information

---

### Log Levels

**DEBUG:**
- Detailed debugging information
- Request/response bodies
- Internal state

**INFO:**
- General information
- Request summaries
- Important events

**WARNING:**
- Non-critical issues
- Deprecation warnings
- Performance concerns

**ERROR:**
- Errors and exceptions
- Failed operations
- Critical issues

---

### Log Examples

**Structured JSON:**
```json
{
  "timestamp": "2024-01-01T12:00:00Z",
  "level": "INFO",
  "message": "Request completed",
  "method": "GET",
  "path": "/api/v1/agents",
  "status_code": 200,
  "duration_ms": 45.2
}
```

**Text Format:**
```
2024-01-01 12:00:00 INFO Request completed method=GET path=/api/v1/agents status_code=200
```

---

### Request Logging

**Middleware:** `agent_factory/api/main.py`

**Logs:**
- Request method and path
- Response status code
- Duration
- Client IP

**Example:**
```python
logger.info(
    "Request completed",
    method=request.method,
    path=request.url.path,
    status_code=response.status_code
)
```

---

## 2. Metrics

### Prometheus Metrics

**Endpoint:** `/metrics`

**Configuration:**
```bash
METRICS_ENABLED=true
METRICS_PORT=9090
```

**Location:** `agent_factory/monitoring/metrics.py`

**Metrics Exposed:**
- HTTP request counts
- HTTP request duration
- Error rates
- Active connections

---

### Available Metrics

**HTTP Metrics:**
- `http_requests_total` - Total requests
- `http_request_duration_seconds` - Request duration
- `http_requests_in_flight` - Active requests

**Custom Metrics:**
- Agent execution counts
- Workflow execution counts
- Error counts by type

---

### Prometheus Setup

**1. Scrape Configuration:**
```yaml
scrape_configs:
  - job_name: 'agent-factory'
    scrape_interval: 15s
    static_configs:
      - targets: ['localhost:9090']
```

**2. Query Examples:**
```promql
# Request rate
rate(http_requests_total[5m])

# Error rate
rate(http_requests_total{status=~"5.."}[5m])

# P95 latency
histogram_quantile(0.95, http_request_duration_seconds_bucket)
```

---

## 3. Health Checks

### Health Endpoint

**Endpoint:** `/health`

**Returns:**
- Overall status
- Database connectivity
- Cache connectivity
- LLM provider status

**Status Codes:**
- `200` - All healthy
- `503` - Degraded

**Example Response:**
```json
{
  "status": "healthy",
  "timestamp": "2024-01-01T12:00:00Z",
  "checks": {
    "database": {
      "status": "healthy",
      "response_time_ms": 2.5
    },
    "cache": {
      "status": "healthy",
      "response_time_ms": 1.2
    }
  }
}
```

---

### Readiness Probe

**Endpoint:** `/ready`

**Purpose:** Kubernetes readiness probe

**Returns:**
- `200` - Ready to serve traffic
- `503` - Not ready

**Checks:**
- Database connectivity
- Critical services

---

### Liveness Probe

**Endpoint:** `/live`

**Purpose:** Kubernetes liveness probe

**Returns:**
- `200` - Service is alive

**No Dependencies:** Always returns 200 if service is running

---

## 4. Distributed Tracing

### Jaeger Integration

**Configuration:**
```bash
TRACING_ENABLED=true
TRACING_BACKEND=jaeger
JAEGER_ENDPOINT=http://localhost:14268/api/traces
```

**Location:** `agent_factory/monitoring/tracing.py`

**Features:**
- Request tracing
- Span creation
- Trace context propagation

**Status:** Optional (disabled by default)

---

### Tracing Setup

**1. Install Jaeger:**
```bash
docker run -d -p 16686:16686 -p 14268:14268 jaegertracing/all-in-one:latest
```

**2. Enable Tracing:**
```bash
TRACING_ENABLED=true
JAEGER_ENDPOINT=http://localhost:14268/api/traces
```

**3. View Traces:**
- Open http://localhost:16686
- Search for traces
- View span details

---

## 5. Error Tracking

### Current Implementation

**Error Handling:**
- Global exception handler
- Structured error logging
- Error details in debug mode

**Location:** `agent_factory/api/main.py`

**Features:**
- Exception logging
- Error response formatting
- Stack traces (debug mode)

---

### Future: Sentry Integration

**Planned Features:**
- Error aggregation
- Error alerts
- Performance monitoring
- Release tracking

**Configuration (Future):**
```bash
SENTRY_DSN=https://...
SENTRY_ENVIRONMENT=production
SENTRY_RELEASE=1.0.0
```

---

## 6. Monitoring Setup

### Production Monitoring

**Recommended Stack:**
1. **Prometheus** - Metrics collection
2. **Grafana** - Visualization
3. **Alertmanager** - Alerts
4. **Jaeger** - Tracing (optional)

---

### Grafana Dashboards

**Recommended Dashboards:**
- Request rate and latency
- Error rates
- Database performance
- Cache performance
- LLM API usage

**Example Queries:**
```promql
# Request rate
sum(rate(http_requests_total[5m])) by (method, path)

# Error rate
sum(rate(http_requests_total{status=~"5.."}[5m])) / sum(rate(http_requests_total[5m]))

# P95 latency
histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))
```

---

## 7. Alerting

### Recommended Alerts

**High Priority:**
- Error rate > 1%
- P95 latency > 1s
- Database connection failures
- Health check failures

**Medium Priority:**
- Request rate spike
- Memory usage > 80%
- Disk usage > 80%

**Low Priority:**
- Slow queries
- Cache hit rate < 80%

---

### Alert Configuration

**Prometheus Alert Rules:**
```yaml
groups:
  - name: agent_factory
    rules:
      - alert: HighErrorRate
        expr: rate(http_requests_total{status=~"5.."}[5m]) > 0.01
        for: 5m
        annotations:
          summary: "High error rate detected"
```

---

## 8. Best Practices

### 1. Use Structured Logging

**✅ Good:**
```python
logger.info("User created", user_id=user_id, tenant_id=tenant_id)
```

**❌ Bad:**
```python
logger.info(f"User {user_id} created for tenant {tenant_id}")
```

---

### 2. Include Context

**✅ Good:**
```python
logger.error("Database error", error=str(e), query=query, params=params)
```

**❌ Bad:**
```python
logger.error("Database error")
```

---

### 3. Don't Log Secrets

**✅ Good:**
```python
logger.info("API key created", key_id=key_id, user_id=user_id)
```

**❌ Bad:**
```python
logger.info("API key created", key=api_key)  # Never log secrets!
```

---

### 4. Use Appropriate Log Levels

- **DEBUG:** Development debugging
- **INFO:** Normal operations
- **WARNING:** Issues that don't break functionality
- **ERROR:** Errors that need attention

---

## 9. Troubleshooting

### Logs Not Appearing

**Check:**
1. `LOG_LEVEL` setting
2. Log format configuration
3. Application logs location
4. Service logs (if containerized)

---

### Metrics Not Scraping

**Check:**
1. `METRICS_ENABLED=true`
2. Metrics endpoint accessible: `/metrics`
3. Prometheus configuration
4. Network/firewall rules

---

### Health Check Failing

**Check:**
1. Database connectivity
2. Cache connectivity
3. Environment variables
4. Service dependencies

---

## 10. Future Enhancements

### Planned Improvements

1. **APM Integration**
   - Application Performance Monitoring
   - Detailed performance insights
   - Transaction tracing

2. **Error Tracking**
   - Sentry integration
   - Error aggregation
   - Alerting

3. **Custom Dashboards**
   - Pre-built Grafana dashboards
   - Business metrics
   - User activity

4. **Log Aggregation**
   - Centralized logging (ELK, Loki)
   - Log search and analysis
   - Long-term retention

---

## Conclusion

**Current State:**
- ✅ Structured logging
- ✅ Prometheus metrics
- ✅ Health checks
- ✅ Basic error handling
- ⚠️ Tracing optional
- ⚠️ Error tracking planned

**Next Steps:**
1. Set up Prometheus/Grafana
2. Configure alerts
3. Enable tracing (if needed)
4. Integrate error tracking (Sentry)

**Resources:**
- Prometheus: https://prometheus.io
- Grafana: https://grafana.com
- Jaeger: https://www.jaegertracing.io
- Sentry: https://sentry.io
