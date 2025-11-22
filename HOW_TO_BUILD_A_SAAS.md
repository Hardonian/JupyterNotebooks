# How to Build a SaaS with Agent Factory

This guide walks you through building a Software-as-a-Service (SaaS) application using Agent Factory Platform.

## 🎯 Overview

Agent Factory provides the foundation for building AI-powered SaaS applications. This guide covers:

1. Architecture patterns
2. Multi-tenancy setup
3. Authentication & authorization
4. Billing & subscriptions
5. Deployment strategies
6. Scaling considerations

## 🏗️ Architecture Patterns

### Pattern 1: Single-Tenant API

Each customer gets their own API instance.

**Pros**:
- Complete isolation
- Easy to customize
- Simple billing

**Cons**:
- Higher infrastructure costs
- More complex deployment

**Implementation**:
```python
# apps/saas_app/main.py
from fastapi import FastAPI, Depends
from agent_factory.agents.agent import Agent

app = FastAPI()

# Per-tenant agent storage
tenant_agents = {}

@app.post("/api/v1/agents/{agent_id}/run")
async def run_agent(agent_id: str, input: str, tenant: str = Depends(get_tenant)):
    agent = tenant_agents.get(f"{tenant}:{agent_id}")
    if not agent:
        raise HTTPException(404, "Agent not found")
    
    result = agent.run(input)
    return {"output": result.output}
```

### Pattern 2: Multi-Tenant Shared

All customers share the same infrastructure with tenant isolation.

**Pros**:
- Lower costs
- Easier to scale
- Centralized management

**Cons**:
- Requires careful isolation
- More complex security

**Implementation**:
```python
from agent_factory.enterprise.multitenancy import TenantManager

tenant_manager = TenantManager()

@app.post("/api/v1/agents/{agent_id}/run")
async def run_agent(agent_id: str, input: str, tenant: str = Depends(get_tenant)):
    # Get tenant-specific registry
    registry = tenant_manager.get_registry(tenant)
    agent = registry.get_agent(agent_id)
    
    result = agent.run(input)
    return {"output": result.output}
```

## 🔐 Authentication & Authorization

### Setup Authentication

```python
from fastapi import Depends, HTTPException
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from agent_factory.security.auth import verify_token

security = HTTPBearer()

async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security)
):
    token = credentials.credentials
    user = verify_token(token)
    if not user:
        raise HTTPException(401, "Invalid token")
    return user

async def get_tenant(user: dict = Depends(get_current_user)):
    return user.get("tenant_id")
```

### Role-Based Access Control

```python
from agent_factory.security.rbac import require_role

@app.post("/api/v1/admin/users")
@require_role("admin")
async def create_user(user_data: dict, user: dict = Depends(get_current_user)):
    # Admin-only endpoint
    pass
```

## 💳 Billing & Subscriptions

### Integration with Stripe

Agent Factory includes Stripe integration:

```python
from agent_factory.payments.stripe_client import StripeClient
from agent_factory.payments.subscriptions import SubscriptionManager

stripe = StripeClient()
subscriptions = SubscriptionManager()

@app.post("/api/v1/subscriptions")
async def create_subscription(
    plan_id: str,
    user: dict = Depends(get_current_user)
):
    # Create subscription
    subscription = subscriptions.create(
        user_id=user["id"],
        plan_id=plan_id,
        payment_method="stripe"
    )
    
    return {"subscription_id": subscription.id}
```

### Usage-Based Billing

```python
from agent_factory.monitoring.metrics import track_usage

@app.post("/api/v1/agents/{agent_id}/run")
async def run_agent(agent_id: str, input: str, user: dict = Depends(get_current_user)):
    # Check usage limits
    if not subscriptions.check_usage_limit(user["id"]):
        raise HTTPException(402, "Usage limit exceeded")
    
    # Run agent
    result = agent.run(input)
    
    # Track usage
    track_usage(
        user_id=user["id"],
        resource="agent",
        resource_id=agent_id,
        tokens_used=result.tokens_used if hasattr(result, 'tokens_used') else 0
    )
    
    return {"output": result.output}
```

## 🚀 Deployment Strategies

### Option 1: Docker Compose (Development)

```yaml
# docker-compose.saas.yml
version: '3.8'
services:
  api:
    build: .
    ports:
      - "8000:8000"
    environment:
      - DATABASE_URL=postgresql://...
      - REDIS_URL=redis://...
      - STRIPE_SECRET_KEY=sk_...
  
  db:
    image: postgres:15
  
  redis:
    image: redis:7
```

### Option 2: Kubernetes (Production)

```yaml
# k8s/saas-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: agent-factory-saas
spec:
  replicas: 3
  template:
    spec:
      containers:
      - name: api
        image: agent-factory:latest
        env:
        - name: DATABASE_URL
          valueFrom:
            secretKeyRef:
              name: saas-secrets
              key: database-url
```

### Option 3: Serverless (AWS Lambda)

```python
# lambda/handler.py
from agent_factory.agents.agent import Agent

def lambda_handler(event, context):
    agent_id = event["agent_id"]
    input_text = event["input"]
    
    agent = Agent.from_registry(agent_id)
    result = agent.run(input_text)
    
    return {
        "statusCode": 200,
        "body": {"output": result.output}
    }
```

## 📊 Monitoring & Observability

### Metrics Collection

```python
from agent_factory.monitoring.metrics import MetricsCollector

metrics = MetricsCollector()

@app.post("/api/v1/agents/{agent_id}/run")
async def run_agent(agent_id: str, input: str):
    start_time = time.time()
    
    try:
        result = agent.run(input)
        
        # Record success metrics
        metrics.record(
            metric="agent.execution.success",
            tags={"agent_id": agent_id},
            value=1
        )
        
        metrics.record(
            metric="agent.execution.latency",
            tags={"agent_id": agent_id},
            value=time.time() - start_time
        )
        
        return {"output": result.output}
    except Exception as e:
        # Record error metrics
        metrics.record(
            metric="agent.execution.error",
            tags={"agent_id": agent_id, "error": str(e)},
            value=1
        )
        raise
```

### Logging

```python
from agent_factory.monitoring.logging import get_logger

logger = get_logger(__name__)

@app.post("/api/v1/agents/{agent_id}/run")
async def run_agent(agent_id: str, input: str, user: dict = Depends(get_current_user)):
    logger.info(
        "Agent execution started",
        extra={
            "agent_id": agent_id,
            "user_id": user["id"],
            "tenant_id": user["tenant_id"]
        }
    )
    
    result = agent.run(input)
    
    logger.info(
        "Agent execution completed",
        extra={
            "agent_id": agent_id,
            "tokens_used": result.tokens_used
        }
    )
    
    return {"output": result.output}
```

## 🔒 Security Best Practices

### 1. API Rate Limiting

```python
from agent_factory.security.rate_limit import RateLimiter

rate_limiter = RateLimiter()

@app.post("/api/v1/agents/{agent_id}/run")
@rate_limiter.limit("10/minute")
async def run_agent(agent_id: str, input: str, user: dict = Depends(get_current_user)):
    # Rate limited endpoint
    pass
```

### 2. Input Sanitization

```python
from agent_factory.security.sanitization import sanitize_input

@app.post("/api/v1/agents/{agent_id}/run")
async def run_agent(agent_id: str, input: str):
    # Sanitize user input
    sanitized_input = sanitize_input(input)
    result = agent.run(sanitized_input)
    return {"output": result.output}
```

### 3. Audit Logging

```python
from agent_factory.security.audit import audit_log

@app.post("/api/v1/agents/{agent_id}/run")
async def run_agent(agent_id: str, input: str, user: dict = Depends(get_current_user)):
    audit_log(
        event_type="agent_execution",
        user_id=user["id"],
        resource_type="agent",
        resource_id=agent_id,
        action="run",
        success=True
    )
    
    result = agent.run(input)
    return {"output": result.output}
```

## 📈 Scaling Considerations

### Horizontal Scaling

- Use load balancer (nginx, AWS ALB)
- Stateless API design
- Shared database and cache
- Session storage in Redis

### Caching Strategy

```python
from agent_factory.cache.redis_cache import RedisCache

cache = RedisCache()

@app.post("/api/v1/agents/{agent_id}/run")
async def run_agent(agent_id: str, input: str):
    # Check cache
    cache_key = f"{agent_id}:{hash(input)}"
    cached = cache.get(cache_key)
    if cached:
        return {"output": cached, "cached": True}
    
    # Run agent
    result = agent.run(input)
    
    # Cache result
    cache.set(cache_key, result.output, ttl=3600)
    
    return {"output": result.output}
```

### Database Optimization

- Use connection pooling
- Index frequently queried fields
- Consider read replicas for analytics
- Use Redis for session storage

## 🎯 Complete SaaS Example

See `apps/research_assistant_app/` for a complete example SaaS application with:

- FastAPI backend
- Auto-generated UI
- Docker deployment
- Environment configuration
- Health checks

## 📚 Additional Resources

- **Enterprise Features**: `/docs/ARCHITECTURE_DETAILED.md`
- **API Reference**: `/docs/API_REFERENCE.md`
- **Deployment Guides**: `/deployment/README.md`
- **Security Guide**: `/docs/SECURITY.md` (if exists)

## 🚀 Next Steps

1. **Choose Architecture**: Single-tenant vs multi-tenant
2. **Setup Authentication**: Implement user management
3. **Add Billing**: Integrate payment processing
4. **Deploy**: Use deployment templates
5. **Monitor**: Set up metrics and logging
6. **Scale**: Plan for growth

---

**Ready to build your SaaS? Start with the example app and customize it for your needs!** 🎉
