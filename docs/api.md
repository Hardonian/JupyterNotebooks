# API Documentation

**Last Updated:** 2024-01-XX  
**Purpose:** Complete API endpoint documentation with parameters, responses, and examples

---

## Base URL

**Development:** `http://localhost:8000/api/v1`  
**Production:** `https://api.agentfactory.io/api/v1`

---

## Authentication

### API Key Authentication (Recommended)

```http
Authorization: Bearer your-api-key
```

Or:

```http
X-API-Key: your-api-key
```

### JWT Authentication

```http
Authorization: Bearer jwt-token
```

**Getting an API Key:**

```bash
# Via CLI
agent-factory auth create-api-key --name "Production Key"

# Via API (requires authentication)
POST /api/v1/auth/api-keys
```

---

## Endpoints

### Agents

#### Create Agent

```http
POST /api/v1/agents/
Content-Type: application/json

{
  "id": "my-agent",
  "name": "My Agent",
  "instructions": "You are a helpful assistant.",
  "model": "gpt-4o"
}
```

**Response:**
```json
{
  "id": "my-agent",
  "status": "created"
}
```

**Status Codes:**
- `201` - Created
- `400` - Bad request
- `409` - Conflict (agent ID already exists)

---

#### List Agents

```http
GET /api/v1/agents/
```

**Response:**
```json
[
  {
    "id": "my-agent",
    "name": "My Agent",
    "instructions": "You are a helpful assistant.",
    "model": "gpt-4o",
    "created_at": "2024-01-01T00:00:00Z"
  }
]
```

**Query Parameters:**
- `tenant_id` (optional) - Filter by tenant
- `limit` (optional) - Limit results (default: 100)
- `offset` (optional) - Pagination offset

---

#### Get Agent

```http
GET /api/v1/agents/{agent_id}
```

**Response:**
```json
{
  "id": "my-agent",
  "name": "My Agent",
  "instructions": "You are a helpful assistant.",
  "model": "gpt-4o",
  "created_at": "2024-01-01T00:00:00Z",
  "updated_at": "2024-01-01T00:00:00Z"
}
```

**Status Codes:**
- `200` - OK
- `404` - Not found

---

#### Run Agent

```http
POST /api/v1/agents/{agent_id}/run
Content-Type: application/json

{
  "input_text": "Hello!",
  "session_id": "optional-session-id",
  "context": {
    "user_id": "user-123",
    "metadata": {}
  }
}
```

**Response:**
```json
{
  "output": "Hello! How can I help you?",
  "session_id": "session-123",
  "execution_id": "exec-123",
  "status": "completed",
  "execution_time": 1.23
}
```

**Status Codes:**
- `200` - OK
- `404` - Agent not found
- `500` - Execution error

---

#### Delete Agent

```http
DELETE /api/v1/agents/{agent_id}
```

**Response:**
```json
{
  "id": "my-agent",
  "status": "deleted"
}
```

**Status Codes:**
- `200` - OK
- `404` - Not found

---

### Tools

#### Create Tool

```http
POST /api/v1/tools/
Content-Type: application/json

{
  "id": "calculator",
  "name": "Calculator",
  "description": "Perform mathematical calculations",
  "schema": {
    "type": "function",
    "function": {
      "name": "calculate",
      "description": "Calculate mathematical expressions",
      "parameters": {
        "type": "object",
        "properties": {
          "expression": {
            "type": "string",
            "description": "Mathematical expression"
          }
        },
        "required": ["expression"]
      }
    }
  }
}
```

**Response:**
```json
{
  "id": "calculator",
  "status": "created"
}
```

---

#### List Tools

```http
GET /api/v1/tools/
```

**Response:**
```json
["calculator", "web_search", "file_io"]
```

---

#### Get Tool

```http
GET /api/v1/tools/{tool_id}
```

**Response:**
```json
{
  "id": "calculator",
  "name": "Calculator",
  "description": "Perform mathematical calculations",
  "schema": {...}
}
```

---

#### Test Tool

```http
POST /api/v1/tools/{tool_id}/test
Content-Type: application/json

{
  "arguments": {
    "expression": "2 + 2"
  }
}
```

**Response:**
```json
{
  "result": 4,
  "success": true,
  "execution_time": 0.01
}
```

---

### Workflows

#### Create Workflow

```http
POST /api/v1/workflows/
Content-Type: application/json

{
  "id": "my-workflow",
  "name": "My Workflow",
  "definition": {
    "steps": [
      {
        "type": "agent",
        "agent_id": "my-agent",
        "input": "{{input}}"
      }
    ]
  }
}
```

**Response:**
```json
{
  "id": "my-workflow",
  "status": "created"
}
```

---

#### Run Workflow

```http
POST /api/v1/workflows/{workflow_id}/run
Content-Type: application/json

{
  "input": {
    "text": "Hello!"
  }
}
```

**Response:**
```json
{
  "execution_id": "exec-123",
  "status": "running",
  "output": null
}
```

---

### Blueprints

#### List Blueprints

```http
GET /api/v1/blueprints/
```

**Response:**
```json
["research-assistant", "student-support", "learning-path"]
```

---

#### Install Blueprint

```http
POST /api/v1/blueprints/{blueprint_id}/install
Content-Type: application/json

{
  "tenant_id": "tenant-123"
}
```

**Response:**
```json
{
  "blueprint_id": "research-assistant",
  "status": "installed",
  "agents_created": ["agent-1", "agent-2"]
}
```

---

### Executions

#### List Executions

```http
GET /api/v1/executions/
```

**Query Parameters:**
- `execution_type` (optional) - Filter by type (agent, workflow)
- `status` (optional) - Filter by status (pending, running, completed, failed)
- `tenant_id` (optional) - Filter by tenant
- `limit` (optional) - Limit results (default: 100)
- `offset` (optional) - Pagination offset

**Response:**
```json
[
  {
    "id": "exec-123",
    "execution_type": "agent",
    "resource_id": "my-agent",
    "status": "completed",
    "created_at": "2024-01-01T00:00:00Z",
    "completed_at": "2024-01-01T00:00:01Z"
  }
]
```

---

#### Get Execution

```http
GET /api/v1/executions/{execution_id}
```

**Response:**
```json
{
  "id": "exec-123",
  "execution_type": "agent",
  "resource_id": "my-agent",
  "status": "completed",
  "input_data": {"input_text": "Hello!"},
  "output_data": {"output": "Hello! How can I help?"},
  "execution_time": 1.23,
  "created_at": "2024-01-01T00:00:00Z",
  "completed_at": "2024-01-01T00:00:01Z"
}
```

---

### Health

#### Health Check

```http
GET /api/v1/health
```

**Response:**
```json
{
  "status": "healthy",
  "database": "connected",
  "cache": "connected",
  "version": "0.1.0"
}
```

**Status Codes:**
- `200` - Healthy
- `503` - Unhealthy (service degraded)

---

### Telemetry

#### Get Metrics

```http
GET /api/v1/telemetry/metrics
```

**Response:** Prometheus metrics format

---

### Payments

#### Create Checkout Session

```http
POST /api/v1/payments/checkout
Content-Type: application/json

{
  "plan_id": "pro",
  "tenant_id": "tenant-123",
  "success_url": "https://example.com/success",
  "cancel_url": "https://example.com/cancel"
}
```

**Response:**
```json
{
  "checkout_url": "https://checkout.stripe.com/...",
  "session_id": "session-123"
}
```

---

## Error Responses

All errors follow this format:

```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "Human-readable error message",
    "details": {}
  }
}
```

**Common Error Codes:**
- `VALIDATION_ERROR` - Request validation failed
- `NOT_FOUND` - Resource not found
- `UNAUTHORIZED` - Authentication required
- `FORBIDDEN` - Insufficient permissions
- `RATE_LIMIT_EXCEEDED` - Rate limit exceeded
- `INTERNAL_ERROR` - Server error

---

## Rate Limiting

**Default Limits:**
- 60 requests per minute
- 1000 requests per hour

**Headers:**
```
X-RateLimit-Limit: 60
X-RateLimit-Remaining: 59
X-RateLimit-Reset: 1640995200
```

**Status Code:** `429 Too Many Requests`

---

## Pagination

List endpoints support pagination:

**Query Parameters:**
- `limit` - Number of results (default: 100, max: 1000)
- `offset` - Offset for pagination (default: 0)

**Response Headers:**
```
X-Total-Count: 1000
X-Page-Limit: 100
X-Page-Offset: 0
```

---

## Webhooks

### Stripe Webhooks

```http
POST /api/v1/payments/webhook
Content-Type: application/json
X-Stripe-Signature: signature

{
  "type": "checkout.session.completed",
  "data": {...}
}
```

**Authentication:** Verified via `STRIPE_WEBHOOK_SECRET`

---

## OpenAPI Specification

FastAPI automatically generates OpenAPI documentation:

**Swagger UI:** `http://localhost:8000/docs`  
**ReDoc:** `http://localhost:8000/redoc`  
**OpenAPI JSON:** `http://localhost:8000/openapi.json`

---

## SDK & CLI

### Python SDK

```python
from agent_factory.sdk import AgentFactoryClient

client = AgentFactoryClient(
    api_key="your-api-key",
    base_url="https://api.agentfactory.io"
)

# Create agent
agent = client.agents.create(
    id="my-agent",
    name="My Agent",
    instructions="You are helpful."
)

# Run agent
result = client.agents.run("my-agent", input_text="Hello!")
```

### CLI

```bash
# Create agent
agent-factory agent create my-agent \
  --name "My Agent" \
  --instructions "You are helpful."

# Run agent
agent-factory agent run my-agent --input "Hello!"
```

---

## Examples

See `examples/` directory for complete examples:
- `basic_agent.py` - Basic agent usage
- `customer_support_bot.py` - Customer support bot
- `multi_agent_system.py` - Multi-agent system

---

## Support

**Documentation:** https://docs.agentfactory.io  
**Issues:** https://github.com/agentfactory/platform/issues  
**Email:** support@agentfactory.io
