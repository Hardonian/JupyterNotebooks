# SaaS Starter Guide: Building a Product with Agent Factory

This guide helps you turn Agent Factory into a complete SaaS product. You'll learn how to add authentication, billing, multi-tenancy, and everything else you need to launch.

---

## What You're Building

By the end of this guide, you'll have:
- ✅ User authentication and authorization
- ✅ Multi-tenant architecture
- ✅ Usage tracking and billing
- ✅ API keys and rate limiting
- ✅ Onboarding flows
- ✅ Admin dashboard basics
- ✅ Deployment setup

---

## Architecture Overview

```
┌─────────────────────────────────────────┐
│         Your SaaS Application           │
├─────────────────────────────────────────┤
│  Frontend (React/Vue/etc)              │
│  └─> REST API (Agent Factory API)      │
├─────────────────────────────────────────┤
│  Agent Factory Platform                 │
│  ├─ Authentication & Authorization     │
│  ├─ Multi-Tenancy                       │
│  ├─ Usage Tracking                      │
│  ├─ Billing Integration                 │
│  └─ Agent Execution                     │
├─────────────────────────────────────────┤
│  Infrastructure                         │
│  ├─ PostgreSQL (users, tenants)        │
│  ├─ Redis (caching, queues)            │
│  └─ Stripe (billing)                   │
└─────────────────────────────────────────┘
```

---

## Step 1: User Authentication

### Setup

Agent Factory includes authentication hooks. Here's how to use them:

```python
from agent_factory.auth import create_user, authenticate_user
from agent_factory.database import get_db

# Create a user
user = create_user(
    email="user@example.com",
    password="secure_password",
    db=next(get_db())
)

# Authenticate
token = authenticate_user(
    email="user@example.com",
    password="secure_password",
    db=next(get_db())
)
```

### API Integration

The API automatically handles authentication:

```python
# In your FastAPI routes
from agent_factory.auth import get_current_user
from fastapi import Depends

@app.get("/api/v1/agents/")
async def list_agents(current_user = Depends(get_current_user)):
    # Only show agents for this user
    return get_user_agents(current_user.id)
```

### Frontend Integration

```javascript
// Login
const response = await fetch('/api/v1/auth/login', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ email, password })
});
const { token } = await response.json();

// Use token in subsequent requests
fetch('/api/v1/agents/', {
  headers: { 'Authorization': `Bearer ${token}` }
});
```

---

## Step 2: Multi-Tenancy

### Tenant Model

Each user belongs to a tenant (organization):

```python
from agent_factory.database.models import Tenant, User

# Create tenant
tenant = Tenant(name="Acme Corp", plan="pro")
db.add(tenant)
db.commit()

# Add user to tenant
user.tenant_id = tenant.id
db.commit()
```

### Tenant Isolation

All resources are scoped to tenants:

```python
# Agents are tenant-scoped
agents = db.query(Agent).filter(Agent.tenant_id == current_user.tenant_id).all()

# Usage tracking is tenant-scoped
usage = get_tenant_usage(current_user.tenant_id)
```

### API Routes

```python
@app.get("/api/v1/agents/")
async def list_agents(current_user = Depends(get_current_user)):
    return db.query(Agent).filter(
        Agent.tenant_id == current_user.tenant_id
    ).all()
```

---

## Step 3: Usage Tracking & Billing

### Track Usage

Agent Factory tracks usage automatically:

```python
from agent_factory.billing import track_usage

# Usage is tracked automatically when agents run
# But you can also track custom events:
track_usage(
    tenant_id=tenant.id,
    event_type="custom_feature",
    quantity=1,
    metadata={"feature": "advanced_analytics"}
)
```

### Billing Integration

Connect to Stripe:

```python
from agent_factory.payments.stripe_client import StripeClient

stripe = StripeClient()

# Create subscription
subscription = stripe.create_subscription(
    customer_id=customer_id,
    plan_id="pro_monthly",
    tenant_id=tenant.id
)

# Track usage for billing
usage = get_tenant_usage(tenant.id)
stripe.record_usage(
    subscription_id=subscription.id,
    quantity=usage.total_requests
)
```

### Usage Limits

Enforce limits based on plan:

```python
from agent_factory.billing.plans import get_plan_limits

limits = get_plan_limits(tenant.plan)

if usage.total_requests >= limits.max_requests:
    raise HTTPException(403, "Usage limit exceeded")
```

---

## Step 4: API Keys

### Generate API Keys

```python
from agent_factory.auth.api_keys import create_api_key

api_key = create_api_key(
    tenant_id=tenant.id,
    name="Production Key",
    scopes=["agents:read", "agents:write"]
)
```

### Use API Keys

```python
from agent_factory.auth.api_keys import validate_api_key

@app.get("/api/v1/agents/")
async def list_agents(api_key: str = Header(None)):
    if api_key:
        tenant = validate_api_key(api_key)
        # Use tenant for scoping
    else:
        # Use user authentication
        tenant = current_user.tenant_id
```

---

## Step 5: Onboarding Flow

### Signup

```python
@app.post("/api/v1/auth/signup")
async def signup(user_data: UserSignup):
    # Create tenant
    tenant = Tenant(name=user_data.company_name, plan="free")
    db.add(tenant)
    db.commit()
    
    # Create user
    user = create_user(
        email=user_data.email,
        password=user_data.password,
        tenant_id=tenant.id,
        db=db
    )
    
    # Create first agent
    first_agent = create_onboarding_agent(tenant.id)
    
    return {
        "user": user,
        "tenant": tenant,
        "first_agent": first_agent
    }
```

### Onboarding Steps

```python
def create_onboarding_agent(tenant_id):
    """Create a starter agent for new users."""
    agent = Agent(
        id="welcome-agent",
        name="Welcome Agent",
        instructions="You are a helpful assistant.",
        tenant_id=tenant_id
    )
    return agent
```

---

## Step 6: Admin Dashboard

### Basic Stats

```python
@app.get("/api/v1/admin/stats")
async def admin_stats(current_user = Depends(get_admin_user)):
    return {
        "total_users": db.query(User).count(),
        "total_tenants": db.query(Tenant).count(),
        "total_agents": db.query(Agent).count(),
        "total_requests": get_total_requests(),
        "revenue": get_total_revenue()
    }
```

### User Management

```python
@app.get("/api/v1/admin/users")
async def list_users(current_user = Depends(get_admin_user)):
    return db.query(User).all()

@app.put("/api/v1/admin/users/{user_id}")
async def update_user(user_id: int, updates: UserUpdate):
    user = db.query(User).filter(User.id == user_id).first()
    # Update user
    return user
```

---

## Step 7: Deployment

### Environment Variables

```bash
# Database
DATABASE_URL=postgresql://user:pass@localhost/agentfactory

# Redis
REDIS_URL=redis://localhost:6379

# Stripe
STRIPE_SECRET_KEY=sk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...

# JWT
JWT_SECRET_KEY=your-secret-key

# API
API_BASE_URL=https://api.yoursaas.com
```

### Docker Compose

```yaml
version: '3.8'
services:
  api:
    build: .
    environment:
      DATABASE_URL: postgresql://postgres:password@db/agentfactory
      REDIS_URL: redis://redis:6379
    ports:
      - "8000:8000"
  
  db:
    image: postgres:15
    environment:
      POSTGRES_DB: agentfactory
      POSTGRES_PASSWORD: password
  
  redis:
    image: redis:7
```

### Production Checklist

- [ ] Set up PostgreSQL database
- [ ] Configure Redis for caching
- [ ] Set up Stripe account and webhooks
- [ ] Configure domain and SSL
- [ ] Set up monitoring (Sentry, etc.)
- [ ] Configure backups
- [ ] Set up CI/CD pipeline
- [ ] Load testing
- [ ] Security audit

---

## Step 8: Frontend Integration

### React Example

```jsx
// Auth context
const AuthContext = createContext();

function AuthProvider({ children }) {
  const [user, setUser] = useState(null);
  const [token, setToken] = useState(localStorage.getItem('token'));
  
  const login = async (email, password) => {
    const res = await fetch('/api/v1/auth/login', {
      method: 'POST',
      body: JSON.stringify({ email, password })
    });
    const { token, user } = await res.json();
    setToken(token);
    setUser(user);
    localStorage.setItem('token', token);
  };
  
  return (
    <AuthContext.Provider value={{ user, login }}>
      {children}
    </AuthContext.Provider>
  );
}

// Use in components
function AgentList() {
  const { user } = useContext(AuthContext);
  const [agents, setAgents] = useState([]);
  
  useEffect(() => {
    fetch('/api/v1/agents/', {
      headers: {
        'Authorization': `Bearer ${localStorage.getItem('token')}`
      }
    })
    .then(res => res.json())
    .then(setAgents);
  }, []);
  
  return <div>{agents.map(a => <AgentCard key={a.id} agent={a} />)}</div>;
}
```

---

## Templates & Examples

### Basic SaaS Template

See `templates/saas_basic/` for a complete starter template with:
- User authentication
- Multi-tenancy
- Basic billing
- Admin dashboard
- Frontend integration

### Advanced SaaS Template

See `templates/saas_advanced/` for:
- Advanced billing (usage-based)
- Team management
- Advanced analytics
- Webhook handling
- Custom domains

---

## Next Steps

1. **Customize:** Adapt templates to your needs
2. **Add Features:** Build your unique features
3. **Test:** Thoroughly test all flows
4. **Deploy:** Follow deployment checklist
5. **Launch:** Go live and iterate

---

## Resources

- [API Reference](docs/API_REFERENCE.md) — Complete API docs
- [Authentication Guide](docs/AUTHENTICATION.md) — Auth details
- [Billing Guide](docs/BILLING.md) — Billing integration
- [Deployment Guide](docs/DEPLOYMENT.md) — Production deployment

---

**Questions?** Open an issue or reach out at support@agentfactory.io
