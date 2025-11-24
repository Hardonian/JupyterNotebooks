# Moodle Integration Guide

**Last Updated:** 2024-01-XX  
**Purpose:** Complete guide for integrating Agent Factory with Moodle LMS

---

## Overview

**Moodle** is an open-source learning management system widely used in education. This guide explains how to integrate Agent Factory agents with Moodle to provide AI-powered student support, course assistance, and administrative automation.

---

## Integration Architecture

### Components

**1. Moodle Web Services API**
- REST API for Moodle
- Token-based authentication
- Webhook support (via plugins)

**2. Agent Factory API**
- Agent API endpoints
- Webhook endpoints
- Authentication

**3. Integration Layer**
- Token authentication
- Data synchronization
- Event handling

---

## Prerequisites

### Moodle Requirements

**Moodle Instance:**
- Moodle 3.8+ (recommended)
- Web services enabled
- REST protocol enabled
- External service configured

**Permissions:**
- Web service token
- API access permissions
- Capabilities configured

---

### Agent Factory Requirements

**Account:**
- Agent Factory account
- API key
- Webhook endpoint configured

**Agent:**
- Agent created
- Knowledge base configured
- Moodle-specific tools enabled

---

## Step 1: Moodle Web Services Setup

### Enable Web Services

**1. Navigate to Moodle Admin:**
- Go to Site administration → Advanced features
- Enable "Enable web services"

**2. Enable REST Protocol:**
- Go to Site administration → Plugins → Web services → Manage protocols
- Enable "REST protocol"

**3. Create External Service:**
- Go to Site administration → Plugins → Web services → External services
- Click "Add"
- Name: "Agent Factory Integration"
- Enabled: Yes

---

### Configure Capabilities

**1. Add Functions:**
- `core_course_get_courses`
- `core_user_get_users_by_field`
- `core_course_get_course_contents`
- `mod_assign_get_assignments`
- `core_grades_get_grades`

**2. Create Token:**
- Go to Site administration → Plugins → Web services → Manage tokens
- Click "Create token"
- User: Select service account
- Service: Agent Factory Integration
- IP restriction: (optional)
- Save and note token

---

## Step 2: Agent Factory Configuration

### Configure Integration

**1. Navigate to Integrations:**
- Go to Settings → Integrations
- Click "Add Integration" → "Moodle"

**2. Enter Credentials:**
- Moodle Instance URL
- Web Service Token
- API Version

**3. Test Connection:**
- Click "Test Connection"
- Verify successful connection

---

## Step 3: Agent Configuration

### Create Moodle Agent

**1. Create Agent:**
- Go to Agents → Create
- Select "Moodle Integration" blueprint
- Name: "Moodle Student Support"

**2. Configure Knowledge Base:**
- Upload Moodle documentation
- Add course materials
- Configure FAQ database

**3. Enable Moodle Tools:**
- Course information tool
- Assignment tool
- Grade tool
- Forum tool

---

## Step 4: Webhook Configuration

### Moodle Webhooks (via Plugin)

**1. Install Webhook Plugin:**
- Install Moodle webhook plugin
- Configure webhook endpoint
- URL: `https://agentfactory.com/webhooks/moodle`

**2. Set Up Webhook Handler:**
```python
from agent_factory.webhooks import moodle_webhook_handler

@moodle_webhook_handler
def handle_moodle_event(event_type, data):
    if event_type == 'course_created':
        # Notify agent about new course
        agent.notify_course_created(data)
    elif event_type == 'assignment_submitted':
        # Process submission
        agent.process_submission(data)
```

---

## Step 5: Testing

### Test Integration

**1. Test Authentication:**
- Verify token works
- Test API calls
- Check permissions

**2. Test API Calls:**
- Fetch courses
- Fetch users
- Fetch assignments

**3. Test Webhooks:**
- Create test event
- Verify webhook received
- Check agent response

---

## Use Cases

### Use Case 1: Student Support Agent

**Scenario:** Students ask questions about courses, assignments, grades

**Implementation:**
1. Agent monitors Moodle messages
2. Responds to student questions
3. Fetches course information
4. Provides assignment details
5. Answers grade questions

**Benefits:**
- 24/7 student support
- Instant responses
- Reduced faculty workload

---

### Use Case 2: Forum Moderator

**Scenario:** Automate forum moderation and responses

**Implementation:**
1. Agent monitors forums
2. Answers common questions
3. Provides resources
4. Escalates complex issues

**Benefits:**
- Improved forum engagement
- Faster responses
- Reduced moderation workload

---

## API Examples

### Python Example

```python
import requests
from agent_factory import AgentFactory

# Initialize Agent Factory
af = AgentFactory(api_key="your_api_key")

# Get Moodle integration
moodle = af.integrations.moodle

# Fetch courses
courses = moodle.get_courses()

# Create agent response
agent = af.agents.get("moodle-support")
response = agent.chat("What assignments are due this week?")

# Send message to Moodle
moodle.send_message(
    user_id=student_id,
    message=response.text
)
```

---

### JavaScript Example

```javascript
const AgentFactory = require('@agentfactory/sdk');
const MoodleAPI = require('moodle-api');

// Initialize Agent Factory
const af = new AgentFactory({ apiKey: 'your_api_key' });

// Get Moodle integration
const moodle = af.integrations.moodle;

// Fetch courses
const courses = await moodle.getCourses();

// Create agent response
const agent = await af.agents.get('moodle-support');
const response = await agent.chat('What assignments are due this week?');

// Send message to Moodle
await moodle.sendMessage({
  userId: studentId,
  message: response.text
});
```

---

## Security Considerations

### Data Privacy

**FERPA Compliance:**
- Student data encryption
- Access controls
- Audit logging
- Data retention policies

**Best Practices:**
- Use HTTPS
- Encrypt sensitive data
- Implement access controls
- Regular security audits

---

### Authentication

**Token Security:**
- Secure token storage
- Token rotation
- IP restrictions
- Regular token review

---

## Troubleshooting

### Common Issues

**Issue: Web services not enabled**
- **Solution:** Enable web services in Moodle admin

**Issue: Token authentication fails**
- **Solution:** Verify token, check permissions

**Issue: API calls fail**
- **Solution:** Check capabilities, verify functions enabled

---

## Support

### Resources

**Documentation:**
- Moodle Web Services: https://docs.moodle.org/dev/Web_services
- Agent Factory API docs: https://docs.agentfactory.com/api

**Support:**
- Email: support@agentfactory.com
- Community: community.agentfactory.com

---

**Remember:** Moodle is open-source and highly customizable. Integration may vary based on Moodle version and plugins installed. Test thoroughly with your specific Moodle instance.
