# Quick Reference Guide - Agent Factory Platform

**Last Updated:** 2024-01-XX  
**Purpose:** Quick reference for common tasks and information

---

## 🚀 Quick Start

### Installation
```bash
pip install agent-factory
```

### First Agent (30 seconds)
```python
from agent_factory import Agent

agent = Agent(
    id="calculator",
    name="Calculator Agent",
    instructions="You are a helpful calculator assistant.",
)

result = agent.run("What's 15% tip on $87.50?")
print(result.output)
```

### Start API Server
```bash
uvicorn agent_factory.api.main:app --reload
```

---

## 📁 Key Files & Directories

### Configuration
- `.env.example` - Environment variables template
- `pyproject.toml` - Python dependencies
- `alembic.ini` - Database migration config

### Documentation
- `README.md` - Project overview
- `docs/GETTING_STARTED.md` - Getting started guide
- `docs/API_REFERENCE.md` - API documentation
- `docs/stack-discovery.md` - Architecture overview

### Scripts
- `scripts/db-validate-schema.py` - Validate database schema
- `scripts/env-doctor.py` - Check environment variables
- `scripts/doc-sync.py` - Sync documentation

### Database
- `agent_factory/database/models.py` - Database models
- `alembic/versions/` - Migration files

---

## 🔧 Common Commands

### Development
```bash
# Install dependencies
make install
# or
pip install -e ".[dev]"

# Run tests
make test
# or
pytest tests/

# Run linting
make lint
# or
ruff check agent_factory/ tests/
black --check agent_factory/ tests/

# Format code
make format
# or
black agent_factory/ tests/
ruff check --fix agent_factory/ tests/

# Type checking
make type-check
# or
mypy agent_factory/
```

### Database
```bash
# Run migrations
alembic upgrade head

# Create new migration
alembic revision --autogenerate -m "description"

# Validate schema
python scripts/db-validate-schema.py
```

### CI/CD
```bash
# Run all CI checks
make ci

# Run specific checks
make lint
make type-check
make test-unit
```

---

## 🌐 API Endpoints

### Base URL
- **Development:** `http://localhost:8000/api/v1`
- **Production:** `https://api.agentfactory.io/api/v1`

### Key Endpoints
- `GET /health` - Health check
- `GET /api/v1/agents` - List agents
- `POST /api/v1/agents` - Create agent
- `POST /api/v1/agents/{id}/run` - Run agent
- `GET /docs` - Interactive API docs (Swagger UI)
- `GET /openapi.json` - OpenAPI specification

### Authentication
```http
Authorization: Bearer your-api-key
```
or
```http
X-API-Key: your-api-key
```

---

## 🔐 Environment Variables

### Required (Production)
```bash
DATABASE_URL=postgresql://...
OPENAI_API_KEY=sk-...
# or
ANTHROPIC_API_KEY=sk-ant-...
```

### Supabase (Recommended)
```bash
SUPABASE_URL=https://[PROJECT-REF].supabase.co
SUPABASE_ANON_KEY=...
SUPABASE_SERVICE_ROLE_KEY=...
DATABASE_URL=postgresql://...:6543/postgres
SUPABASE_USE_POOLER=true
```

### Optional
```bash
REDIS_URL=redis://localhost:6379/0
JWT_SECRET_KEY=...
STRIPE_SECRET_KEY=...
LOG_LEVEL=INFO
```

**Full list:** See `.env.example` or `docs/env-and-secrets.md`

---

## 🗄️ Database

### Models
- `User` - User accounts
- `Tenant` - Multi-tenant organizations
- `Agent` - AI agents
- `Workflow` - Workflow definitions
- `Blueprint` - Blueprint templates
- `Execution` - Execution records
- `AuditLog` - Audit trail
- `APIKey` - API keys
- `Project` - Projects/apps
- `Plan` - Billing plans
- `Subscription` - Subscriptions
- `UsageRecord` - Usage tracking

### Migrations
```bash
# Check current revision
alembic current

# Upgrade to latest
alembic upgrade head

# Downgrade one revision
alembic downgrade -1

# Create new migration
alembic revision --autogenerate -m "add new table"
```

---

## 🧪 Testing

### Run Tests
```bash
# All tests
pytest tests/

# Unit tests only
pytest tests/ -m "not integration and not slow"

# Integration tests
pytest tests/ -m integration

# With coverage
pytest tests/ --cov=agent_factory --cov-report=html
```

### Test Markers
- `@pytest.mark.unit` - Fast unit tests
- `@pytest.mark.integration` - Integration tests
- `@pytest.mark.slow` - Slow tests
- `@pytest.mark.e2e` - End-to-end tests

---

## 🚢 Deployment

### Docker
```bash
# Build image
docker build -f docker/Dockerfile -t agent-factory .

# Run with docker-compose
docker-compose -f docker/docker-compose.yml up
```

### Render
- Config: `deployment/render.yaml`
- See: `docs/deploy-strategy.md`

### Kubernetes
- Manifests: `k8s/`
- See: `docs/deploy-strategy.md`

---

## 🔍 Troubleshooting

### Database Connection Issues
```bash
# Check connection
python scripts/db-validate-schema.py

# Check environment
python scripts/env-doctor.py
```

### API Not Starting
```bash
# Check logs
# Verify DATABASE_URL is set
# Check port 8000 is available
```

### Migration Issues
```bash
# Check current revision
alembic current

# Validate schema
python scripts/db-validate-schema.py

# See migration history
alembic history
```

---

## 📚 Documentation Links

### Getting Started
- [Getting Started Guide](GETTING_STARTED.md)
- [Local Development](local-dev.md)
- [Quick Start](QUICK_START.md)

### Architecture
- [Stack Discovery](stack-discovery.md)
- [Backend Strategy](backend-strategy.md)
- [Architecture Details](ARCHITECTURE_DETAILED.md)

### API
- [API Reference](API_REFERENCE.md)
- [API Documentation](api.md)

### Operations
- [CI/CD Overview](ci-overview.md)
- [Deployment Strategy](deploy-strategy.md)
- [Observability](observability.md)
- [Security](SECURITY.md)

### Database
- [Data Model Overview](data-model-overview.md)
- [Migrations Workflow](migrations-workflow.md)
- [Supabase Setup](supabase-setup.md)

---

## 🆘 Getting Help

### Documentation
- Check `docs/` directory
- See `README.md` for overview

### Issues
- GitHub Issues: https://github.com/agentfactory/platform/issues
- Check existing issues before creating new ones

### Support
- Email: support@agentfactory.io
- Documentation: https://docs.agentfactory.io

---

## ✅ Pre-Launch Checklist

- [ ] Environment variables configured
- [ ] Database migrations run
- [ ] Schema validated (`scripts/db-validate-schema.py`)
- [ ] Tests passing (`make test`)
- [ ] Linting passing (`make lint`)
- [ ] Type checking passing (`make type-check`)
- [ ] Health check passing (`curl http://localhost:8000/health`)
- [ ] API documentation accessible (`http://localhost:8000/docs`)
- [ ] Monitoring configured
- [ ] Backup strategy in place

---

**Last Updated:** 2024-01-XX  
**Maintained By:** Unified Background Agent v3.0
