# Webhooks Integration Guide

**Last Updated:** 2024-01-XX  
**Purpose:** Complete guide for integrating Agent Factory webhooks with external systems

---

## Overview

**Webhooks** allow Agent Factory to send real-time notifications to your applications when events occur. This guide explains how to configure, receive, and process webhooks from Agent Factory.

---

## Webhook Architecture

### Components

**1. Agent Factory**
- Event generation
- Webhook delivery
- Retry logic
- Signature verification

**2. Your Application**
- Webhook endpoint
- Event processing
- Signature validation
- Response handling

**3. Integration Flow**
- Event occurs in Agent Factory
- Webhook sent to your endpoint
- Your application processes event
- Response sent back to Agent Factory

---

## Webhook Events

### Available Events

**Agent Events:**
- `agent.created` - Agent created
- `agent.updated` - Agent updated
- `agent.deleted` - Agent deleted
- `agent.deployed` - Agent deployed
- `agent.undeployed` - Agent undeployed

**Conversation Events:**
- `conversation.started` - Conversation started
- `conversation.message` - New message received
- `conversation.ended` - Conversation ended

**Usage Events:**
- `usage.threshold` - Usage threshold reached
- `usage.limit` - Usage limit reached

**Error Events:**
- `error.occurred` - Error occurred
- `error.resolved` - Error resolved

---

## Step 1: Configure Webhook Endpoint

### Create Webhook Endpoint

**1. Navigate to Webhooks:**
- Go to Settings → Integrations → Webhooks
- Click "Create Webhook"

**2. Configure Webhook:**
- **Name:** Descriptive name
- **URL:** Your webhook endpoint URL
- **Events:** Select events to subscribe to
- **Secret:** Webhook secret (for signature verification)
- **Active:** Enable webhook

**3. Save Webhook:**
- Webhook created
- Note webhook ID and secret

---

## Step 2: Implement Webhook Endpoint

### Python Example

```python
from flask import Flask, request, jsonify
import hmac
import hashlib
import json

app = Flask(__name__)

WEBHOOK_SECRET = "your_webhook_secret"

def verify_signature(payload, signature, secret):
    """Verify webhook signature"""
    expected_signature = hmac.new(
        secret.encode('utf-8'),
        payload.encode('utf-8'),
        hashlib.sha256
    ).hexdigest()
    return hmac.compare_digest(expected_signature, signature)

@app.route('/webhooks/agentfactory', methods=['POST'])
def webhook_handler():
    # Get signature from headers
    signature = request.headers.get('X-AgentFactory-Signature')
    
    # Get raw payload
    payload = request.get_data(as_text=True)
    
    # Verify signature
    if not verify_signature(payload, signature, WEBHOOK_SECRET):
        return jsonify({'error': 'Invalid signature'}), 401
    
    # Parse payload
    data = json.loads(payload)
    
    # Process event
    event_type = data['event']
    event_data = data['data']
    
    if event_type == 'agent.created':
        handle_agent_created(event_data)
    elif event_type == 'conversation.message':
        handle_conversation_message(event_data)
    # ... handle other events
    
    # Return success
    return jsonify({'status': 'success'}), 200

def handle_agent_created(data):
    """Handle agent created event"""
    agent_id = data['agent_id']
    agent_name = data['agent_name']
    # Process agent creation
    print(f"Agent created: {agent_name} ({agent_id})")

def handle_conversation_message(data):
    """Handle conversation message event"""
    conversation_id = data['conversation_id']
    message = data['message']
    # Process message
    print(f"New message in conversation {conversation_id}: {message}")

if __name__ == '__main__':
    app.run(port=5000)
```

---

### JavaScript/Node.js Example

```javascript
const express = require('express');
const crypto = require('crypto');
const app = express();

const WEBHOOK_SECRET = 'your_webhook_secret';

function verifySignature(payload, signature, secret) {
  const expectedSignature = crypto
    .createHmac('sha256', secret)
    .update(payload)
    .digest('hex');
  return crypto.timingSafeEqual(
    Buffer.from(expectedSignature),
    Buffer.from(signature)
  );
}

app.post('/webhooks/agentfactory', express.raw({ type: 'application/json' }), (req, res) => {
  const signature = req.headers['x-agentfactory-signature'];
  const payload = req.body.toString();
  
  // Verify signature
  if (!verifySignature(payload, signature, WEBHOOK_SECRET)) {
    return res.status(401).json({ error: 'Invalid signature' });
  }
  
  // Parse payload
  const data = JSON.parse(payload);
  const eventType = data.event;
  const eventData = data.data;
  
  // Process event
  switch (eventType) {
    case 'agent.created':
      handleAgentCreated(eventData);
      break;
    case 'conversation.message':
      handleConversationMessage(eventData);
      break;
    // ... handle other events
  }
  
  // Return success
  res.status(200).json({ status: 'success' });
});

function handleAgentCreated(data) {
  const { agent_id, agent_name } = data;
  console.log(`Agent created: ${agent_name} (${agent_id})`);
}

function handleConversationMessage(data) {
  const { conversation_id, message } = data;
  console.log(`New message in conversation ${conversation_id}: ${message}`);
}

app.listen(5000, () => {
  console.log('Webhook server listening on port 5000');
});
```

---

## Step 3: Webhook Security

### Signature Verification

**How It Works:**
1. Agent Factory signs webhook payload with secret
2. Signature sent in `X-AgentFactory-Signature` header
3. Your endpoint verifies signature
4. Process webhook if signature valid

**Signature Format:**
```
X-AgentFactory-Signature: sha256=<signature>
```

**Verification:**
- Use HMAC-SHA256
- Compare signatures securely (timing-safe)
- Reject if signature invalid

---

### HTTPS Requirement

**Best Practices:**
- Use HTTPS for webhook endpoints
- Validate SSL certificates
- Use TLS 1.2+
- Monitor certificate expiration

---

## Step 4: Webhook Processing

### Event Processing

**1. Receive Webhook:**
- Receive POST request
- Verify signature
- Parse payload

**2. Process Event:**
- Identify event type
- Extract event data
- Process according to event type

**3. Respond:**
- Return 200 status for success
- Return 4xx/5xx for errors
- Respond within 5 seconds

---

### Error Handling

**Retry Logic:**
- Agent Factory retries failed webhooks
- Exponential backoff
- Max 3 retries
- 24-hour retry window

**Best Practices:**
- Handle errors gracefully
- Log errors for debugging
- Return appropriate status codes
- Implement idempotency

---

## Step 5: Testing

### Test Webhook Locally

**1. Use ngrok or similar:**
```bash
ngrok http 5000
```

**2. Configure Webhook:**
- Use ngrok URL as webhook endpoint
- Test webhook delivery
- Verify event processing

**3. Test Events:**
- Trigger test events
- Verify webhook received
- Check event processing

---

### Webhook Testing Tool

**Agent Factory Webhook Tester:**
- Test webhook endpoint
- Send test events
- Verify signature
- Debug issues

---

## Webhook Payload Examples

### Agent Created Event

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

### Conversation Message Event

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

## Best Practices

### Idempotency

**Implement Idempotency:**
- Use event ID for deduplication
- Store processed event IDs
- Skip duplicate events
- Handle retries gracefully

---

### Performance

**Optimize Processing:**
- Process events asynchronously
- Use queues for high volume
- Batch process when possible
- Monitor processing time

---

### Monitoring

**Monitor Webhooks:**
- Track webhook delivery
- Monitor error rates
- Alert on failures
- Log all events

---

## Troubleshooting

### Common Issues

**Issue: Webhook not received**
- **Solution:** Check endpoint URL, verify firewall rules, check logs

**Issue: Invalid signature**
- **Solution:** Verify secret, check signature calculation, ensure raw payload

**Issue: Timeout errors**
- **Solution:** Process asynchronously, respond quickly, optimize processing

---

## Support

### Resources

**Documentation:**
- Agent Factory Webhooks: https://docs.agentfactory.com/webhooks
- Webhook Best Practices: https://docs.agentfactory.com/webhooks/best-practices

**Support:**
- Email: support@agentfactory.com
- Community: community.agentfactory.com

---

**Remember:** Webhooks enable real-time integration. Implement proper security, error handling, and monitoring for production use.
