# Frontend Hosting Strategy

**Last Updated:** 2024-01-XX  
**Status:** API-first platform with no dedicated frontend

---

## Executive Summary

**Frontend Status:** **No Dedicated Frontend Application**

Agent Factory is an **API-first platform** designed to be consumed via:
- Python SDK
- REST API
- CLI
- Third-party frontend applications built by users

**Hosting Strategy:** N/A (no frontend to host)

---

## 1. Platform Architecture

### API-First Design

Agent Factory provides:
- **Backend API:** FastAPI REST API (`agent_factory/api/main.py`)
- **SDK:** Python library (`agent_factory/sdk/`)
- **CLI:** Command-line interface (`agent_factory/cli/`)
- **UI Generator:** Basic HTML/React template generator (`agent_factory/ui/generator.py`)

### No Dedicated Frontend

**Rationale:**
- Platform is a **developer tool** and **backend service**
- Users build their own frontends using the API/SDK
- Similar to Stripe, Twilio, or AWS - API-first, no UI

**UI Components (Optional/Demo Only):**
- Simple HTML demo UI generator
- Demo app in `apps/research_assistant_app/` (FastAPI serving HTML)
- These are **examples**, not production frontends

---

## 2. API Hosting

### Primary Deployment: **Render** (Recommended)

**Configuration:** `deployment/render.yaml`

**Why Render:**
- Simple Python hosting
- Automatic HTTPS
- Health checks
- Environment variable management
- Free tier available

**Setup:**
1. Connect GitHub repository
2. Render auto-detects `render.yaml`
3. Set environment variables
4. Deploy

**Health Check:** `/health` endpoint

### Alternative: **Docker** (Self-Hosted)

**Configuration:** `docker/docker-compose.prod.yml`

**Use Cases:**
- Self-hosted deployments
- Kubernetes deployments
- On-premise installations

**Services:**
- API server (port 8000)
- Scheduler (background jobs)

### Alternative: **Kubernetes**

**Configuration:** `k8s/` directory

**Manifests:**
- `api-deployment.yaml` - API service
- `ingress.yaml` - Ingress controller
- `configmap.yaml` - Configuration
- `secret.yaml` - Secrets

**Use Cases:**
- Enterprise deployments
- Multi-region deployments
- High availability requirements

---

## 3. Demo Applications

### Research Assistant Demo

**Location:** `apps/research_assistant_app/main.py`

**Description:**
- Simple FastAPI app serving HTML
- Demonstrates API usage
- Not a production frontend

**Deployment:**
- Vercel: `deployment/vercel.json` configured
- HuggingFace Spaces: `deployment/huggingface/` configured
- Docker: Can be containerized

**Purpose:**
- Demo/showcase
- Developer onboarding
- API testing

---

## 4. UI Generator

### HTML/React Template Generator

**Location:** `agent_factory/ui/generator.py`

**Purpose:**
- Generate basic UI templates from agent schemas
- Help users bootstrap frontends
- Not a production-ready UI framework

**Templates:**
- `html` - Basic HTML form
- `react` - React components (basic)

**Usage:**
```bash
agent-factory ui generate my-agent --output ui/ --template react
```

**Output:**
- HTML files
- React components (basic)
- API integration code

**Note:** These are **starter templates**, not production UIs.

---

## 5. User-Built Frontends

### Expected Frontend Patterns

Users of Agent Factory will build their own frontends:

**1. Web Applications**
- React, Vue, Svelte, etc.
- Consume REST API
- Use Python SDK (via backend proxy)

**2. Mobile Applications**
- React Native, Flutter, native
- Consume REST API
- Use API keys for authentication

**3. CLI Tools**
- Built-in CLI (`agent-factory` command)
- Custom CLIs using SDK

**4. Integrations**
- Zapier, Make.com, etc.
- Webhook integrations
- API-based automations

---

## 6. API Documentation

### OpenAPI/Swagger

**Endpoint:** `/docs` (FastAPI auto-generated)

**Features:**
- Interactive API documentation
- Try-it-out functionality
- Schema definitions
- Authentication examples

### API Reference

**Location:** `docs/API_REFERENCE.md`

**Content:**
- Endpoint documentation
- Authentication guide
- Code examples
- SDK usage

---

## 7. CORS Configuration

### Current Setup

**Configuration:** `agent_factory/api/main.py`

```python
CORS_ORIGINS=http://localhost:3000,http://localhost:8080
```

**For Production:**
- Set `CORS_ORIGINS` to your frontend domain(s)
- Use environment variable: `CORS_ORIGINS=https://your-app.com`
- Support multiple origins (comma-separated)

**Security:**
- Credentials allowed: `CORS_CREDENTIALS=true`
- Specific origins (not `*` in production)
- HTTPS required in production

---

## 8. Static Assets (If Needed)

### Current: None

Platform has no static assets to serve.

### If Adding Static Assets

**Options:**
1. **CDN:** Cloudflare, CloudFront, etc.
2. **Object Storage:** Supabase Storage, S3
3. **API Route:** Serve via FastAPI static files

**Recommendation:** Use CDN or object storage for static assets.

---

## 9. Deployment Checklist

### API Deployment

**Required:**
- [ ] Set `DATABASE_URL`
- [ ] Set `REDIS_URL` (if using cache/queue)
- [ ] Set `OPENAI_API_KEY` or `ANTHROPIC_API_KEY`
- [ ] Set `JWT_SECRET_KEY`
- [ ] Set `CORS_ORIGINS` (if frontend exists)
- [ ] Configure health checks (`/health`)

**Optional:**
- [ ] Set `STRIPE_SECRET_KEY` (if using billing)
- [ ] Set `SUPABASE_*` variables (if using Supabase)
- [ ] Configure monitoring/observability

### Frontend Deployment (User-Built)

**Not Applicable:** Platform doesn't host user frontends.

**Users Should:**
- Deploy their own frontends
- Configure CORS on API
- Use API keys or JWT for authentication

---

## 10. Recommendations

### For Platform Maintainers

1. **✅ Keep API-First Design**
   - Don't build a frontend unless there's clear need
   - Focus on API quality and documentation
   - Provide good SDK and CLI tools

2. **✅ Improve API Documentation**
   - Keep OpenAPI docs up to date
   - Provide code examples
   - Create integration guides

3. **✅ Enhance UI Generator** (Optional)
   - Improve template quality
   - Add more template options
   - Better documentation

### For Users

1. **Build Your Own Frontend**
   - Use your preferred framework
   - Consume REST API or Python SDK
   - Follow API documentation

2. **Use Demo Apps as Reference**
   - Check `apps/research_assistant_app/` for examples
   - Adapt to your needs
   - Don't use demo code in production

---

## Conclusion

**Frontend Strategy:** **No Frontend** (API-first platform)

**Hosting:**
- **API:** Render, Docker, Kubernetes
- **Demo Apps:** Vercel, HuggingFace Spaces (optional)
- **User Frontends:** Users deploy their own

**Key Points:**
- Platform is backend-only
- Users build their own frontends
- API is the primary interface
- SDK and CLI provide developer experience

**Next Steps:**
1. Ensure API is well-documented
2. Provide good SDK examples
3. Keep demo apps updated
4. Consider UI generator improvements (optional)
