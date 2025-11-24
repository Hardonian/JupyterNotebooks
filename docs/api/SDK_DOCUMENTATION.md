# SDK Documentation

**Last Updated:** 2024-01-XX  
**Purpose:** Complete SDK documentation for Agent Factory Platform

---

## Overview

**Agent Factory SDKs** provide easy-to-use libraries for integrating Agent Factory into your applications. SDKs are available for Python, JavaScript/Node.js, and Go.

---

## Python SDK

### Installation

```bash
pip install agentfactory
```

---

### Quick Start

```python
from agentfactory import AgentFactory

# Initialize client
client = AgentFactory(api_key="your_api_key")

# Get agent
agent = client.agents.get("agent_id")

# Chat with agent
response = agent.chat("Hello, how can I help you?")
print(response.text)
```

---

### Authentication

```python
from agentfactory import AgentFactory

# Using API key
client = AgentFactory(api_key="your_api_key")

# Using environment variable
import os
client = AgentFactory(api_key=os.getenv("AGENTFACTORY_API_KEY"))
```

---

### Agents

**List Agents:**
```python
agents = client.agents.list()
for agent in agents:
    print(agent.name)
```

**Get Agent:**
```python
agent = client.agents.get("agent_id")
```

**Create Agent:**
```python
agent = client.agents.create(
    name="My Agent",
    blueprint_id="blueprint_123",
    knowledge_base_id="kb_456"
)
```

**Update Agent:**
```python
agent = client.agents.update(
    agent_id="agent_id",
    name="Updated Name"
)
```

**Delete Agent:**
```python
client.agents.delete("agent_id")
```

---

### Conversations

**Start Conversation:**
```python
conversation = agent.conversations.create()
```

**Send Message:**
```python
response = conversation.send_message("Hello")
print(response.text)
```

**Get Conversation:**
```python
conversation = agent.conversations.get("conversation_id")
```

**List Conversations:**
```python
conversations = agent.conversations.list()
```

---

### Knowledge Bases

**Create Knowledge Base:**
```python
kb = client.knowledge_bases.create(
    name="My Knowledge Base",
    description="Knowledge base description"
)
```

**Add Documents:**
```python
kb.documents.add(
    content="Document content",
    metadata={"title": "Document Title"}
)
```

**Query Knowledge Base:**
```python
results = kb.query("search query")
```

---

### Webhooks

**Create Webhook:**
```python
webhook = client.webhooks.create(
    name="My Webhook",
    url="https://example.com/webhook",
    events=["agent.created", "conversation.message"]
)
```

**List Webhooks:**
```python
webhooks = client.webhooks.list()
```

---

### Error Handling

```python
from agentfactory import AgentFactory, APIError

try:
    agent = client.agents.get("invalid_id")
except APIError as e:
    print(f"Error: {e.message}")
    print(f"Status: {e.status_code}")
```

---

## JavaScript/Node.js SDK

### Installation

```bash
npm install @agentfactory/sdk
```

---

### Quick Start

```javascript
const AgentFactory = require('@agentfactory/sdk');

// Initialize client
const client = new AgentFactory({ apiKey: 'your_api_key' });

// Get agent
const agent = await client.agents.get('agent_id');

// Chat with agent
const response = await agent.chat('Hello, how can I help you?');
console.log(response.text);
```

---

### Authentication

```javascript
const AgentFactory = require('@agentfactory/sdk');

// Using API key
const client = new AgentFactory({ apiKey: 'your_api_key' });

// Using environment variable
const client = new AgentFactory({ 
  apiKey: process.env.AGENTFACTORY_API_KEY 
});
```

---

### Agents

**List Agents:**
```javascript
const agents = await client.agents.list();
agents.forEach(agent => console.log(agent.name));
```

**Get Agent:**
```javascript
const agent = await client.agents.get('agent_id');
```

**Create Agent:**
```javascript
const agent = await client.agents.create({
  name: 'My Agent',
  blueprintId: 'blueprint_123',
  knowledgeBaseId: 'kb_456'
});
```

**Update Agent:**
```javascript
const agent = await client.agents.update('agent_id', {
  name: 'Updated Name'
});
```

**Delete Agent:**
```javascript
await client.agents.delete('agent_id');
```

---

### Conversations

**Start Conversation:**
```javascript
const conversation = await agent.conversations.create();
```

**Send Message:**
```javascript
const response = await conversation.sendMessage('Hello');
console.log(response.text);
```

**Get Conversation:**
```javascript
const conversation = await agent.conversations.get('conversation_id');
```

**List Conversations:**
```javascript
const conversations = await agent.conversations.list();
```

---

### Error Handling

```javascript
const AgentFactory = require('@agentfactory/sdk');

try {
  const agent = await client.agents.get('invalid_id');
} catch (error) {
  if (error instanceof AgentFactory.APIError) {
    console.error(`Error: ${error.message}`);
    console.error(`Status: ${error.statusCode}`);
  }
}
```

---

## Go SDK

### Installation

```bash
go get github.com/agentfactory/go-sdk
```

---

### Quick Start

```go
package main

import (
    "fmt"
    "github.com/agentfactory/go-sdk"
)

func main() {
    // Initialize client
    client := agentfactory.NewClient("your_api_key")
    
    // Get agent
    agent, err := client.Agents.Get("agent_id")
    if err != nil {
        panic(err)
    }
    
    // Chat with agent
    response, err := agent.Chat("Hello, how can I help you?")
    if err != nil {
        panic(err)
    }
    
    fmt.Println(response.Text)
}
```

---

### Authentication

```go
import "github.com/agentfactory/go-sdk"

// Using API key
client := agentfactory.NewClient("your_api_key")

// Using environment variable
import "os"
client := agentfactory.NewClient(os.Getenv("AGENTFACTORY_API_KEY"))
```

---

### Agents

**List Agents:**
```go
agents, err := client.Agents.List()
if err != nil {
    panic(err)
}

for _, agent := range agents {
    fmt.Println(agent.Name)
}
```

**Get Agent:**
```go
agent, err := client.Agents.Get("agent_id")
```

**Create Agent:**
```go
agent, err := client.Agents.Create(&agentfactory.CreateAgentRequest{
    Name: "My Agent",
    BlueprintID: "blueprint_123",
    KnowledgeBaseID: "kb_456",
})
```

---

### Error Handling

```go
agent, err := client.Agents.Get("invalid_id")
if err != nil {
    if apiErr, ok := err.(*agentfactory.APIError); ok {
        fmt.Printf("Error: %s\n", apiErr.Message)
        fmt.Printf("Status: %d\n", apiErr.StatusCode)
    }
}
```

---

## Common Patterns

### Rate Limiting

**Python:**
```python
import time
from agentfactory import RateLimitError

def make_request_with_retry(func, *args, **kwargs):
    max_retries = 3
    for i in range(max_retries):
        try:
            return func(*args, **kwargs)
        except RateLimitError as e:
            if i == max_retries - 1:
                raise
            time.sleep(e.retry_after)
```

**JavaScript:**
```javascript
async function makeRequestWithRetry(fn, maxRetries = 3) {
  for (let i = 0; i < maxRetries; i++) {
    try {
      return await fn();
    } catch (error) {
      if (error instanceof AgentFactory.RateLimitError && i < maxRetries - 1) {
        await new Promise(resolve => 
          setTimeout(resolve, error.retryAfter * 1000)
        );
        continue;
      }
      throw error;
    }
  }
}
```

---

### Webhook Handling

**Python:**
```python
from flask import Flask, request
from agentfactory.webhooks import verify_signature

app = Flask(__name__)

@app.route('/webhook', methods=['POST'])
def webhook():
    signature = request.headers.get('X-AgentFactory-Signature')
    payload = request.get_data(as_text=True)
    
    if not verify_signature(payload, signature, 'your_secret'):
        return 'Invalid signature', 401
    
    data = request.json
    # Process webhook
    return 'OK', 200
```

**JavaScript:**
```javascript
const express = require('express');
const { verifySignature } = require('@agentfactory/sdk/webhooks');

const app = express();

app.post('/webhook', express.raw({ type: 'application/json' }), (req, res) => {
  const signature = req.headers['x-agentfactory-signature'];
  const payload = req.body.toString();
  
  if (!verifySignature(payload, signature, 'your_secret')) {
    return res.status(401).send('Invalid signature');
  }
  
  const data = JSON.parse(payload);
  // Process webhook
  res.status(200).send('OK');
});
```

---

## Support

### Resources

**Documentation:**
- Python SDK: https://docs.agentfactory.com/sdk/python
- JavaScript SDK: https://docs.agentfactory.com/sdk/javascript
- Go SDK: https://docs.agentfactory.com/sdk/go

**GitHub:**
- Python: https://github.com/agentfactory/python-sdk
- JavaScript: https://github.com/agentfactory/javascript-sdk
- Go: https://github.com/agentfactory/go-sdk

**Support:**
- Email: support@agentfactory.com
- Community: community.agentfactory.com

---

**Remember:** SDKs simplify integration. Use them to build faster and more reliably.
