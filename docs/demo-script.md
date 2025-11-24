# Demo Script

**Last Updated:** 2024-01-XX  
**Purpose:** Step-by-step guide for demonstrating Agent Factory platform

---

## Prerequisites

**Before Demo:**
1. ✅ API deployed and accessible
2. ✅ Database migrations applied
3. ✅ Demo data seeded (optional)
4. ✅ API keys configured

**Demo Environment:**
- Production: `https://api.agentfactory.io`
- Staging: `https://staging-api.agentfactory.io`
- Local: `http://localhost:8000`

---

## Quick Demo (5 minutes)

### 1. Health Check

**Show:** Platform is running and healthy

```bash
curl https://api.agentfactory.io/health
```

**Expected:**
```json
{
  "status": "healthy",
  "checks": {
    "database": {"status": "healthy"},
    "cache": {"status": "healthy"}
  }
}
```

**Talking Points:**
- Platform is production-ready
- Health checks monitor all dependencies
- Automatic failover and recovery

---

### 2. API Documentation

**Show:** Interactive API docs

**URL:** `https://api.agentfactory.io/docs`

**Talking Points:**
- OpenAPI/Swagger documentation
- Try-it-out functionality
- Complete API reference

---

### 3. Create an Agent (CLI)

**Show:** Creating an agent via CLI

```bash
# Install CLI
pip install agent-factory

# Create agent
agent-factory agent create demo-agent \
  --name "Demo Assistant" \
  --instructions "You are a helpful assistant"

# Run agent
agent-factory agent run demo-agent --input "Hello!"
```

**Talking Points:**
- Simple CLI interface
- Fast agent creation
- Immediate execution

---

### 4. Create an Agent (API)

**Show:** Creating an agent via REST API

```bash
# Create agent
curl -X POST https://api.agentfactory.io/api/v1/agents \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -d '{
    "id": "api-demo-agent",
    "name": "API Demo Agent",
    "instructions": "You help users with questions"
  }'

# Run agent
curl -X POST https://api.agentfactory.io/api/v1/agents/api-demo-agent/run \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -d '{"input": "What is Agent Factory?"}'
```

**Talking Points:**
- RESTful API design
- Easy integration
- Works with any language

---

### 5. Python SDK

**Show:** Using Python SDK

```python
from agent_factory import Agent

# Create agent
agent = Agent(
    id="sdk-demo",
    name="SDK Demo Agent",
    instructions="You are a helpful assistant"
)

# Run agent
result = agent.run("Hello, world!")
print(result.output)
```

**Talking Points:**
- Native Python SDK
- Type-safe
- Full feature support

---

## Extended Demo (15 minutes)

### 1. Multi-Tenancy

**Show:** Multi-tenant isolation

```bash
# Create tenant
curl -X POST https://api.agentfactory.io/api/v1/tenants \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -d '{
    "name": "Acme Corp",
    "slug": "acme-corp"
  }'

# Create agent in tenant
curl -X POST https://api.agentfactory.io/api/v1/agents \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "X-Tenant-ID: acme-corp" \
  -d '{"name": "Acme Assistant", ...}'
```

**Talking Points:**
- Complete tenant isolation
- Row-level security
- Per-tenant quotas

---

### 2. Workflows

**Show:** Chaining agents in workflows

```bash
# Create workflow
curl -X POST https://api.agentfactory.io/api/v1/workflows \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -d '{
    "name": "Customer Support Flow",
    "definition": {
      "steps": [
        {"agent": "greeting-agent", "action": "greet"},
        {"agent": "support-agent", "action": "help"}
      ]
    }
  }'

# Run workflow
curl -X POST https://api.agentfactory.io/api/v1/workflows/workflow-id/run \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -d '{"input": "I need help"}'
```

**Talking Points:**
- Complex automation
- Agent orchestration
- Workflow visualization

---

### 3. Blueprint Marketplace

**Show:** Installing blueprints

```bash
# List blueprints
curl https://api.agentfactory.io/api/v1/blueprints

# Install blueprint
curl -X POST https://api.agentfactory.io/api/v1/blueprints/research-assistant/install \
  -H "Authorization: Bearer YOUR_API_KEY"
```

**Talking Points:**
- Pre-built agents
- Marketplace ecosystem
- One-click installation

---

### 4. Observability

**Show:** Monitoring and metrics

```bash
# Health check with details
curl https://api.agentfactory.io/health

# Metrics endpoint
curl https://api.agentfactory.io/metrics

# Execution history
curl https://api.agentfactory.io/api/v1/executions \
  -H "Authorization: Bearer YOUR_API_KEY"
```

**Talking Points:**
- Built-in observability
- Execution tracking
- Performance metrics

---

## Demo Scenarios

### Scenario 1: Customer Support Bot

**Goal:** Show how to build a customer support agent

**Steps:**
1. Create support agent
2. Add knowledge base
3. Configure escalation rules
4. Test with sample questions

**Talking Points:**
- Real-world use case
- Easy customization
- Production-ready

---

### Scenario 2: Research Assistant

**Goal:** Show research capabilities

**Steps:**
1. Install research assistant blueprint
2. Configure research tools
3. Run research query
4. Show results

**Talking Points:**
- Pre-built solutions
- Tool integration
- Complex workflows

---

### Scenario 3: Educational Tool

**Goal:** Show education use case

**Steps:**
1. Create learning path generator
2. Configure curriculum
3. Generate personalized path
4. Show student progress

**Talking Points:**
- Education focus
- Personalization
- Progress tracking

---

## Troubleshooting

### API Not Responding

**Check:**
1. Health endpoint: `/health`
2. Database connection
3. Service logs

**Fix:**
- Restart service
- Check environment variables
- Verify database connectivity

---

### Authentication Errors

**Check:**
1. API key valid
2. Authorization header format
3. Key permissions

**Fix:**
- Regenerate API key
- Check key format: `Bearer YOUR_KEY`
- Verify key permissions

---

### Demo Data Missing

**Seed Demo Data:**
```bash
python scripts/db-seed-demo.py
```

**Verify:**
```bash
curl https://api.agentfactory.io/api/v1/agents \
  -H "Authorization: Bearer YOUR_API_KEY"
```

---

## Demo Checklist

**Before Demo:**
- [ ] API deployed and accessible
- [ ] Health check passes
- [ ] Demo data seeded (optional)
- [ ] API keys ready
- [ ] Documentation accessible
- [ ] Sample code prepared

**During Demo:**
- [ ] Show health check
- [ ] Demonstrate CLI
- [ ] Show API usage
- [ ] Show SDK usage
- [ ] Answer questions

**After Demo:**
- [ ] Share documentation links
- [ ] Provide API keys (if appropriate)
- [ ] Follow up with resources

---

## Resources

**Documentation:**
- API Reference: `/docs`
- Getting Started: `docs/GETTING_STARTED.md`
- Architecture: `docs/ARCHITECTURE_DETAILED.md`

**Code Examples:**
- `examples/` directory
- API documentation (try-it-out)
- SDK examples

**Support:**
- GitHub Issues
- Documentation
- Community forum

---

## Conclusion

**Key Takeaways:**
- ✅ Easy to get started (minutes, not hours)
- ✅ Multiple integration options (CLI, API, SDK)
- ✅ Production-ready features
- ✅ Comprehensive documentation

**Next Steps:**
1. Sign up for API key
2. Try the quick start guide
3. Build your first agent
4. Join the community
