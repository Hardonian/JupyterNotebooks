# Webhooks API Documentation

**Last Updated:** 2024-01-XX  
**Purpose:** Complete API documentation for Agent Factory webhooks

---

## Overview

**Webhooks** allow you to receive real-time notifications when events occur in Agent Factory. This document covers webhook configuration, event types, payloads, and best practices.

---

## Webhook Configuration

### Create Webhook

**Endpoint:** `POST /api/v1/webhooks`

**Request:**
```json
{
  "name": "My Webhook",
  "url": "https://example.com/webhooks/agentfactory",
  "events": [
    "agent.created",
    "conversation.message",
    "usage.threshold"
  ],
  "secret": "your_webhook_secret",
  "active": true
}
```

**Response:**
```json
{
  "id": "webhook_123",
  "name": "My Webhook",
  "url": "https://example.com/webhooks/agentfactory",
  "events": [
    "agent.created",
    "conversation.message",
    "usage.threshold"
  ],
  "secret": "your_webhook_secret",
  "active": true,
  "created_at": "2024-01-15T10:30:00Z"
}
```

---

### List Webhooks

**Endpoint:** `GET /api/v1/webhooks`

**Response:**
```json
{
  "webhooks": [
    {
      "id": "webhook_123",
      "name": "My Webhook",
      "url": "https://example.com/webhooks/agentfactory",
      "events": ["agent.created"],
      "active": true,
      "created_at": "2024-01-15T10:30:00Z"
    }
  ]
}
```

---

### Get Webhook

**Endpoint:** `GET /api/v1/webhooks/{webhook_id}`

**Response:**
```json
{
  "id": "webhook_123",
  "name": "My Webhook",
  "url": "https://example.com/webhooks/agentfactory",
  "events": ["agent.created"],
  "active": true,
  "created_at": "2024-01-15T10:30:00Z"
}
```

---

### Update Webhook

**Endpoint:** `PATCH /api/v1/webhooks/{webhook_id}`

**Request:**
```json
{
  "name": "Updated Webhook",
  "events": ["agent.created", "agent.updated"]
}
```

**Response:**
```json
{
  "id": "webhook_123",
  "name": "Updated Webhook",
  "url": "https://example.com/webhooks/agentfactory",
  "events": ["agent.created", "agent.updated"],
  "active": true,
  "updated_at": "2024-01-15T11:00:00Z"
}
```

---

### Delete Webhook

**Endpoint:** `DELETE /api/v1/webhooks/{webhook_id}`

**Response:**
```json
{
  "id": "webhook_123",
  "deleted": true
}
```

---

## Webhook Events

### Agent Events

**`agent.created`**
- Triggered when agent is created
- Payload includes agent details

**`agent.updated`**
- Triggered when agent is updated
- Payload includes updated agent details

**`agent.deleted`**
- Triggered when agent is deleted
- Payload includes agent ID

**`agent.deployed`**
- Triggered when agent is deployed
- Payload includes deployment details

**`agent.undeployed`**
- Triggered when agent is undeployed
- Payload includes agent ID

---

### Conversation Events

**`conversation.started`**
- Triggered when conversation starts
- Payload includes conversation details

**`conversation.message`**
- Triggered when message is received
- Payload includes message details

**`conversation.ended`**
- Triggered when conversation ends
- Payload includes conversation summary

---

### Usage Events

**`usage.threshold`**
- Triggered when usage threshold reached
- Payload includes usage details

**`usage.limit`**
- Triggered when usage limit reached
- Payload includes usage details

---

### Error Events

**`error.occurred`**
- Triggered when error occurs
- Payload includes error details

**`error.resolved`**
- Triggered when error is resolved
- Payload includes error details

---

## Webhook Payloads

### Agent Created Payload

```json
{
  "event": "agent.created",
  "timestamp": "2024-01-15T10:30:00Z",
  "data": {
    "agent_id": "agent_123",
    "agent_name": "Customer Support Bot",
    "user_id": "user_456",
    "created_at": "2024-01-15T10:30:00Z"
  }
}
```

---

### Conversation Message Payload

```json
{
  "event": "conversation.message",
  "timestamp": "2024-01-15T10:35:00Z",
  "data": {
    "conversation_id": "conv_789",
    "agent_id": "agent_123",
    "message_id": "msg_101",
    "message": "Hello, how can I help you?",
    "user_id": "user_456",
    "timestamp": "2024-01-15T10:35:00Z"
  }
}
```

---

### Usage Threshold Payload

```json
{
  "event": "usage.threshold",
  "timestamp": "2024-01-15T10:40:00Z",
  "data": {
    "user_id": "user_456",
    "usage_type": "api_calls",
    "current_usage": 9000,
    "threshold": 10000,
    "percentage": 90
  }
}
```

---

## Webhook Security

### Signature Verification

**Header:** `X-AgentFactory-Signature`

**Format:** `sha256=<signature>`

**Verification:**
```python
import hmac
import hashlib

def verify_signature(payload, signature, secret):
    expected_signature = hmac.new(
        secret.encode('utf-8'),
        payload.encode('utf-8'),
        hashlib.sha256
    ).hexdigest()
    return hmac.compare_digest(expected_signature, signature)
```

---

### HTTPS Requirement

**Best Practices:**
- Use HTTPS for webhook endpoints
- Validate SSL certificates
- Use TLS 1.2+
- Monitor certificate expiration

---

## Webhook Delivery

### Delivery Process

**1. Event Occurs:**
- Event triggered in Agent Factory
- Webhook queued for delivery

**2. Delivery Attempt:**
- POST request sent to webhook URL
- Signature included in headers
- Payload sent as JSON

**3. Response Handling:**
- 200 OK: Success, webhook processed
- 4xx/5xx: Error, retry scheduled

---

### Retry Logic

**Retry Schedule:**
- Initial: Immediate
- Retry 1: 1 minute
- Retry 2: 5 minutes
- Retry 3: 30 minutes
- Max retries: 3
- Retry window: 24 hours

**Retry Conditions:**
- Non-200 status code
- Timeout
- Network error
- Connection refused

---

## Webhook Testing

### Test Webhook

**Endpoint:** `POST /api/v1/webhooks/{webhook_id}/test`

**Request:**
```json
{
  "event": "agent.created",
  "test_data": {
    "agent_id": "test_agent",
    "agent_name": "Test Agent"
  }
}
```

**Response:**
```json
{
  "status": "sent",
  "test_event_id": "test_123"
}
```

---

## Best Practices

### Do's

✅ **Verify webhook signatures**  
✅ **Use HTTPS endpoints**  
✅ **Process webhooks asynchronously**  
✅ **Implement idempotency**  
✅ **Return 200 quickly**  
✅ **Log all webhook events**  
✅ **Monitor webhook delivery**

---

### Don'ts

❌ **Don't ignore signatures**  
❌ **Don't use HTTP endpoints**  
❌ **Don't process synchronously**  
❌ **Don't retry on your side**  
❌ **Don't ignore errors**  
❌ **Don't store secrets in code**

---

## Support

### Resources

**Documentation:**
- Webhooks Guide: https://docs.agentfactory.com/webhooks
- API Reference: https://docs.agentfactory.com/api

**Support:**
- Email: support@agentfactory.com
- Community: community.agentfactory.com

---

**Remember:** Webhooks enable real-time integration. Implement proper security, error handling, and monitoring for production use.
