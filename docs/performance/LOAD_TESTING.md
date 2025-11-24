# Load Testing & Performance Benchmarks

**Last Updated:** 2024-01-XX  
**Purpose:** Load testing framework, benchmarks, and capacity planning

---

## Overview

This document defines load testing procedures, performance benchmarks, and capacity planning for the Agent Factory platform.

**Testing Tools:**
- Locust (Python-based load testing)
- k6 (JavaScript-based load testing)
- Apache Bench (simple HTTP testing)

---

## Performance Targets

### Response Time Targets

| Endpoint | p50 Target | p95 Target | p99 Target |
|----------|------------|------------|------------|
| Health Check | < 50ms | < 100ms | < 200ms |
| Agent List | < 200ms | < 500ms | < 1s |
| Agent Create | < 300ms | < 1s | < 2s |
| Agent Run | < 1s | < 5s | < 10s |
| Workflow Run | < 2s | < 10s | < 30s |

### Throughput Targets

| Scenario | Target RPS | Target Concurrent Users |
|----------|------------|------------------------|
| Health Checks | 1000 RPS | 1000 |
| Agent Operations | 100 RPS | 100 |
| Agent Executions | 50 RPS | 50 |
| Workflow Executions | 10 RPS | 10 |

---

## Load Testing Framework

### Test Scenarios

**Scenario 1: Health Check Load**
- Endpoint: `GET /api/v1/health`
- Target: 1000 RPS
- Duration: 5 minutes
- Expected: All requests succeed, p95 < 100ms

**Scenario 2: Agent Operations**
- Endpoints: Create, List, Get, Delete
- Target: 100 RPS per endpoint
- Duration: 10 minutes
- Expected: All requests succeed, p95 < 500ms

**Scenario 3: Agent Executions**
- Endpoint: `POST /api/v1/agents/{id}/run`
- Target: 50 RPS
- Duration: 15 minutes
- Expected: p95 < 5s (includes LLM call time)

**Scenario 4: Mixed Workload**
- Combination of all scenarios
- Realistic user behavior
- Target: 200 RPS total
- Duration: 30 minutes

---

## Load Testing Scripts

### Locust Script

**File:** `tests/load/locustfile.py`

```python
from locust import HttpUser, task, between

class AgentFactoryUser(HttpUser):
    wait_time = between(1, 3)
    
    @task(3)
    def health_check(self):
        self.client.get("/api/v1/health")
    
    @task(2)
    def list_agents(self):
        self.client.get("/api/v1/agents/")
    
    @task(1)
    def create_agent(self):
        self.client.post("/api/v1/agents/", json={
            "id": f"agent-{self.user_id}",
            "name": "Test Agent",
            "instructions": "You are helpful."
        })
    
    @task(1)
    def run_agent(self):
        self.client.post("/api/v1/agents/test-agent/run", json={
            "input_text": "Hello"
        })
```

### Running Load Tests

```bash
# Install Locust
pip install locust

# Run load test
locust -f tests/load/locustfile.py --host=https://api.agentfactory.io

# Run with specific users and spawn rate
locust -f tests/load/locustfile.py \
  --host=https://api.agentfactory.io \
  --users 100 \
  --spawn-rate 10
```

---

## Performance Benchmarks

### Baseline Benchmarks

**Environment:** Production-like (staging)  
**Date:** [Date]  
**Version:** v1.0.0

| Endpoint | p50 | p95 | p99 | RPS |
|----------|-----|-----|-----|-----|
| Health Check | 45ms | 89ms | 150ms | 1000 |
| Agent List | 180ms | 420ms | 800ms | 100 |
| Agent Create | 280ms | 850ms | 1.5s | 50 |
| Agent Run | 1.2s | 4.5s | 8s | 30 |

### Benchmark Updates

**Frequency:** After major releases  
**Tracking:** Performance regression detection  
**Alerting:** Alert if performance degrades > 20%

---

## Capacity Planning

### Current Capacity

**Database:**
- Connection pool: 20 connections
- Max concurrent queries: 50
- Database size: 500 MB (Supabase Free tier)

**API:**
- Vercel function limits: 10s timeout
- Concurrent executions: Limited by database
- Rate limits: 60/min, 1000/hour

**External Services:**
- OpenAI: Rate limits per API key
- Anthropic: Rate limits per API key

### Scaling Triggers

**Scale Up When:**
- Response time p95 > target for 5 minutes
- Error rate > 1% for 5 minutes
- Database connection pool > 80%
- CPU usage > 80%

**Scale Down When:**
- Response time p95 < 50% of target for 1 hour
- CPU usage < 30% for 1 hour
- Connection pool usage < 50% for 1 hour

### Capacity Projections

**10x Growth:**
- Database: Upgrade to Supabase Pro (8 GB)
- API: Scale Vercel functions
- External APIs: Upgrade API tiers

**100x Growth:**
-
- Database: Supabase Team tier or self-hosted
- API: Multiple regions, CDN
- External APIs: Enterprise tiers
- Caching: Redis cluster

---

## Performance Monitoring

### Key Metrics

**Application Metrics:**
- Request rate (RPS)
- Response time (p50, p95, p99)
- Error rate
- Throughput

**Infrastructure Metrics:**
- CPU usage
- Memory usage
- Database connections
- Network I/O

**External Service Metrics:**
- OpenAI API latency
- Anthropic API latency
- External API error rates

### Monitoring Tools

**Prometheus:** Application metrics  
**Grafana:** Dashboards  
**Sentry:** Error tracking  
**Vercel Analytics:** Performance monitoring

---

## Performance Optimization

### Identified Optimizations

**Database:**
- Add missing indexes
- Optimize slow queries
- Connection pooling
- Query caching

**API:**
- Response caching
- Request batching
- Async processing
- CDN for static assets

**External APIs:**
- Request batching
- Caching responses
- Rate limit optimization
- Fallback strategies

---

## Load Testing Schedule

### Regular Testing

**Frequency:** Weekly  
**Scenarios:** Health check, agent operations  
**Duration:** 10 minutes  
**Automation:** CI/CD integration

### Pre-Release Testing

**Frequency:** Before each release  
**Scenarios:** All scenarios  
**Duration:** 30 minutes  
**Requirement:** All tests must pass

### Capacity Testing

**Frequency:** Monthly  
**Scenarios:** Stress testing to find limits  
**Duration:** 1 hour  
**Goal:** Identify breaking points

---

## Stress Testing

### Stress Test Scenarios

**Scenario 1: Database Stress**
- Target: Exhaust connection pool
- Goal: Identify connection limits
- Expected: Graceful degradation

**Scenario 2: API Stress**
- Target: 10x normal load
- Goal: Identify API limits
- Expected: Rate limiting kicks in

**Scenario 3: External API Stress**
- Target: High LLM API usage
- Goal: Identify external API limits
- Expected: Queuing and retries

---

## Performance Regression Detection

### Automated Detection

**CI/CD Integration:**
- Run performance tests on each PR
- Compare against baseline
- Alert if performance degrades > 20%

**Monitoring:**
- Track performance metrics over time
- Alert on performance degradation
- Generate performance reports

---

## Review & Updates

**Review Frequency:** Monthly  
**Last Reviewed:** [Date]  
**Next Review:** [Date]

**Update Triggers:**
- When performance targets change
- When infrastructure changes
- When new features added
- Monthly review cycle

---

## Appendix: Quick Reference

### Load Testing Commands

```bash
# Locust
locust -f tests/load/locustfile.py --host=https://api.agentfactory.io

# k6
k6 run tests/load/k6_script.js

# Apache Bench
ab -n 10000 -c 100 https://api.agentfactory.io/api/v1/health
```

### Performance Targets Summary

- Health: p95 < 100ms
- Agent Ops: p95 < 500ms
- Agent Run: p95 < 5s
- Throughput: 200 RPS total

---

**Remember:** Performance is a feature. Monitor continuously, test regularly, and optimize proactively.
