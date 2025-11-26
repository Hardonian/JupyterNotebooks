# Demo Path

**Purpose:** Exact steps to run a "happy path" demo from fresh user to "aha" moment  
**Time:** 5-10 minutes

---

## Prerequisites

**Before Demo:**
- [ ] API server running (local or production)
- [ ] Database migrations applied
- [ ] Environment variables configured
- [ ] (Optional) Demo data seeded

**Check:**
```bash
curl http://localhost:8000/health
# OR
curl https://api.agentfactory.io/health
```

---

## Happy Path Demo Flow

### Step 1: Health Check (30 seconds)

**Show:** Platform is running and healthy

```bash
curl http://localhost:8000/health
```

**Expected:**
```json
{
  "status": "healthy",
  "checks": {
    "database": {"status": "healthy"}
  }
}
```

**Talking Point:** "Platform is production-ready with health monitoring."

---

### Step 2: Create First Agent via CLI (2 minutes)

**Show:** Simple agent creation and execution

```bash
# Create agent
agent-factory agent create demo-assistant \
  --name "Demo Assistant" \
  --instructions "You are a helpful assistant that answers questions clearly and concisely."

# Run agent
agent-factory agent run demo-assistant --input "What is Agent Factory?"
```

**Expected:** Agent responds with explanation of Agent Factory.

**Talking Point:** "In 30 seconds, we've created and run a production-ready agent."

---

### Step 3: Create Agent via API (2 minutes)

**Show:** REST API integration

```bash
# Create agent
curl -X POST http://localhost:8000/api/v1/agents \
  -H "Content-Type: application/json" \
  -d '{
    "id": "api-demo",
    "name": "API Demo Agent",
    "instructions": "You help users with questions about AI agents."
  }'

# Run agent
curl -X POST http://localhost:8000/api/v1/agents/api-demo/run \
  -H "Content-Type: application/json" \
  -d '{"input": "How do I deploy an AI agent to production?"}'
```

**Expected:** Agent responds with deployment guidance.

**Talking Point:** "Works with any language via REST API. Easy integration."

---

### Step 4: Python SDK (2 minutes)

**Show:** Native Python SDK

```python
from agent_factory import Agent

# Create agent
agent = Agent(
    id="sdk-demo",
    name="SDK Demo Agent",
    instructions="You are a helpful assistant."
)

# Run agent
result = agent.run("Explain how Agent Factory works.")
print(result.output)
```

**Expected:** Agent responds via SDK.

**Talking Point:** "Native Python SDK with type safety and full feature support."

---

### Step 5: Install Blueprint (2 minutes)

**Show:** Marketplace and blueprint system

```bash
# List available blueprints
curl http://localhost:8000/api/v1/blueprints

# Install blueprint (e.g., research assistant)
curl -X POST http://localhost:8000/api/v1/blueprints/research-assistant/install \
  -H "Authorization: Bearer YOUR_API_KEY"

# Use installed blueprint
agent-factory agent run research-assistant --input "Research AI agent platforms"
```

**Expected:** Blueprint installs and agent runs.

**Talking Point:** "One-click installation of pre-built agents. Marketplace creates network effects."

---

## Aha Moment

**The "Aha Moment":**  
"From prototype to production in minutes, not months."

**Key Points:**
1. **Speed:** Created and deployed agent in <5 minutes
2. **Simplicity:** No infrastructure setup required
3. **Production-Ready:** Built-in observability, billing, multi-tenancy
4. **Multiple Interfaces:** CLI, API, SDK - use what you prefer

---

## Extended Demo (Optional, 10-15 minutes)

### Multi-Tenancy

```bash
# Create tenant
curl -X POST http://localhost:8000/api/v1/tenants \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -d '{"name": "Acme Corp", "slug": "acme-corp"}'

# Create agent in tenant
curl -X POST http://localhost:8000/api/v1/agents \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "X-Tenant-ID: acme-corp" \
  -d '{"name": "Acme Assistant", ...}'
```

**Talking Point:** "Complete tenant isolation. Launch SaaS products immediately."

---

### Workflows

```bash
# Create workflow
curl -X POST http://localhost:8000/api/v1/workflows \
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
```

**Talking Point:** "Chain agents into complex workflows. Orchestrate multi-agent systems."

---

### Observability

```bash
# Check metrics
curl http://localhost:8000/metrics

# View execution history
curl http://localhost:8000/api/v1/executions \
  -H "Authorization: Bearer YOUR_API_KEY"
```

**Talking Point:** "Built-in observability. Track every execution, monitor performance."

---

## Demo Checklist

**Before Demo:**
- [ ] API server running
- [ ] Health check passes
- [ ] Environment variables configured
- [ ] (Optional) Demo data seeded
- [ ] Test all demo steps beforehand

**During Demo:**
- [ ] Show health check
- [ ] Create agent via CLI
- [ ] Create agent via API
- [ ] Show Python SDK
- [ ] Install blueprint
- [ ] Highlight "aha moment"

**After Demo:**
- [ ] Answer questions
- [ ] Share documentation links
- [ ] Provide next steps

---

## Troubleshooting

**API Not Responding:**
- Check health endpoint
- Verify database connection
- Check logs

**Authentication Errors:**
- Verify API key
- Check authorization header format

**Agent Not Running:**
- Check LLM API key (OpenAI/Anthropic)
- Verify agent configuration
- Check logs for errors

**See:** `demo/DEMO_CHECKLIST.md` for detailed troubleshooting

---

## Next Steps for Viewer

1. **Try It Yourself:**
   - Sign up at [production URL]
   - Follow `docs/GETTING_STARTED.md`
   - Create your first agent

2. **Read Documentation:**
   - `docs/GETTING_STARTED.md` - First steps
   - `docs/API_REFERENCE.md` - API docs
   - `docs/ARCHITECTURE_DETAILED.md` - Architecture

3. **Join Community:**
   - GitHub Discussions
   - [Slack/Discord if available]

---

**See Also:**
- `demo/DEMO_SCRIPT.md` - Talking points for demo
- `demo/DEMO_CHECKLIST.md` - Pre-demo checklist
- `docs/demo-script.md` - Detailed demo script

---

**Last Updated:** 2024-01-XX  
**Maintained by:** Venture OS Supervisor
