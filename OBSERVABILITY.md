# Observability Guide for Agent Factory

This guide covers monitoring, logging, tracing, and debugging for Agent Factory deployments.

---

## 📊 Overview

Observability in Agent Factory includes:
- **Metrics:** Performance and usage data
- **Logging:** Structured application logs
- **Tracing:** Request and execution traces
- **Alerting:** Proactive issue detection

---

## 📈 Metrics

### Key Metrics

**Performance Metrics:**
- Agent execution time
- API response time
- Database query time
- Cache hit rate

**Usage Metrics:**
- Active users
- Agent runs per day
- API requests per hour
- Feature usage

**Error Metrics:**
- Error rate
- Exception types
- Failed requests
- Retry rate

**Business Metrics:**
- Revenue
- User growth
- Churn rate
- Feature adoption

### Collecting Metrics

Agent Factory uses Prometheus for metrics:

```python
from agent_factory.telemetry.metrics import MetricsCollector

collector = MetricsCollector()

# Record a metric
collector.record_counter("agent_runs", labels={"agent_id": "calculator"})
collector.record_histogram("execution_time", duration, labels={"agent_id": "calculator"})
```

### Viewing Metrics

Metrics are exposed at `/metrics` endpoint:

```bash
curl http://localhost:8000/metrics
```

---

## 📝 Logging

### Structured Logging

Agent Factory uses structured JSON logging:

```python
from agent_factory.monitoring.logging import get_logger

logger = get_logger(__name__)

logger.info("Agent executed", extra={
    "agent_id": "calculator",
    "execution_time": 1.23,
    "tokens_used": 150
})
```

### Log Levels

- **DEBUG:** Detailed information for debugging
- **INFO:** General information about operations
- **WARNING:** Warning messages for potential issues
- **ERROR:** Error messages for failures
- **CRITICAL:** Critical errors requiring immediate attention

### Log Aggregation

Logs are collected and aggregated for:
- Search and filtering
- Alerting
- Analysis
- Compliance

---

## 🔍 Tracing

### Request Tracing

Every request gets a trace ID:

```python
from agent_factory.monitoring.tracing import trace_request

@trace_request
async def run_agent(agent_id: str, input: str):
    # Agent execution is automatically traced
    pass
```

### Execution Tracing

Agent executions are traced:

```python
from agent_factory.monitoring.tracing import trace_execution

with trace_execution("agent_run", agent_id="calculator"):
    result = agent.run(input)
```

### Viewing Traces

Traces are available in:
- Application logs
- Tracing backend (Jaeger, etc.)
- Debug endpoints

---

## 🚨 Alerting

### Alert Rules

Set up alerts for:
- High error rates
- Slow response times
- High resource usage
- Failed deployments

### Alert Channels

- Email
- Slack
- PagerDuty
- Webhooks

---

## 🐛 Debugging

### Debug Mode

Enable debug mode for detailed logging:

```bash
export LOG_LEVEL=DEBUG
uvicorn agent_factory.api.main:app --reload
```

### Debug Endpoints

Access debug information:

```bash
# Health check
curl http://localhost:8000/health

# Metrics
curl http://localhost:8000/metrics

# Debug info
curl http://localhost:8000/debug/info
```

### Log Analysis

Search and analyze logs:

```bash
# Search logs
grep "ERROR" logs/app.log

# Analyze with jq
cat logs/app.log | jq 'select(.level == "ERROR")'
```

---

## 📊 Dashboards

### Key Dashboards

**Performance Dashboard:**
- Response times
- Throughput
- Error rates
- Resource usage

**Business Dashboard:**
- User growth
- Revenue
- Feature usage
- Churn rate

**Operational Dashboard:**
- System health
- Service status
- Recent errors
- Active alerts

---

## 🔧 Configuration

### Environment Variables

```bash
# Logging
LOG_LEVEL=INFO
LOG_FORMAT=json

# Metrics
METRICS_ENABLED=true
METRICS_PORT=9090

# Tracing
TRACING_ENABLED=true
TRACING_BACKEND=jaeger
```

### Configuration File

```yaml
observability:
  logging:
    level: INFO
    format: json
    output: stdout
  
  metrics:
    enabled: true
    port: 9090
  
  tracing:
    enabled: true
    backend: jaeger
    endpoint: http://jaeger:14268/api/traces
```

---

## 🛠️ Tools & Integrations

### Recommended Tools

**Metrics:**
- Prometheus
- Grafana
- Datadog

**Logging:**
- ELK Stack
- Loki
- CloudWatch

**Tracing:**
- Jaeger
- Zipkin
- OpenTelemetry

**APM:**
- New Relic
- Datadog APM
- AppDynamics

---

## 📋 Best Practices

1. **Structured Logging:** Use structured logs for better analysis
2. **Meaningful Metrics:** Track metrics that matter
3. **Alert Wisely:** Don't alert on noise
4. **Monitor Trends:** Watch for trends, not just spikes
5. **Document Alerts:** Document what each alert means
6. **Review Regularly:** Review and tune alerts regularly

---

## 🚀 Getting Started

1. **Enable Observability:**
   ```bash
   export METRICS_ENABLED=true
   export TRACING_ENABLED=true
   ```

2. **Set Up Dashboards:**
   - Import Grafana dashboards
   - Configure alerts
   - Set up log aggregation

3. **Monitor:**
   - Watch key metrics
   - Review logs regularly
   - Respond to alerts

---

## 📚 Resources

- [Monitoring Setup](docs/MONITORING_SETUP.md)
- [Alert Configuration](docs/ALERTS.md)
- [Debugging Guide](docs/DEBUGGING.md)

---

**Questions?** Open an issue or check the documentation.
