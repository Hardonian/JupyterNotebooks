# Local Setup Guide

**Purpose:** Get Agent Factory running locally from a fresh clone.

**Time:** 15-30 minutes  
**Prerequisites:** Python 3.8+, PostgreSQL (or Supabase account)

---

## Quick Path: Fresh Clone → Running App

### 1. Clone & Install (5 min)

```bash
# Clone repository
git clone https://github.com/agentfactory/platform.git
cd platform

# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -e ".[dev]"

# Verify installation
agent-factory --version
```

### 2. Configure Environment (5 min)

```bash
# Copy environment template
cp .env.example .env

# Edit .env - Minimum required:
# - DATABASE_URL (or Supabase vars)
# - OPENAI_API_KEY (or ANTHROPIC_API_KEY)
# - JWT_SECRET_KEY (generate with: openssl rand -hex 32)
```

**Minimum .env setup:**
```bash
# Database (choose one):
# Option A: Supabase (recommended)
SUPABASE_URL=https://[PROJECT-REF].supabase.co
SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
DATABASE_URL=postgresql://postgres.[PROJECT-REF]:[PASSWORD]@aws-0-[REGION].pooler.supabase.com:6543/postgres

# Option B: Local PostgreSQL
DATABASE_URL=postgresql://localhost:5432/agent_factory

# LLM Provider (at least one required)
OPENAI_API_KEY=sk-your-key-here
# OR
ANTHROPIC_API_KEY=sk-ant-your-key-here

# Security
JWT_SECRET_KEY=$(openssl rand -hex 32)
```

**See:** `docs/env-and-secrets.md` for complete configuration.

### 3. Setup Database (5 min)

```bash
# Run migrations
make migrate
# OR
alembic upgrade head

# Verify schema
make validate-schema
# OR
python scripts/db-validate-schema.py

# (Optional) Seed demo data
make seed
# OR
python scripts/db-seed-demo.py
```

### 4. Start API Server (1 min)

```bash
# Development mode (auto-reload)
uvicorn agent_factory.api.main:app --reload --host 0.0.0.0 --port 8000

# Verify it's running
curl http://localhost:8000/health
```

**Expected response:**
```json
{
  "status": "healthy",
  "checks": {
    "database": {"status": "healthy"}
  }
}
```

### 5. Test It Works (2 min)

```bash
# Using CLI
agent-factory agent create test-agent \
  --name "Test Agent" \
  --instructions "You are helpful"

agent-factory agent run test-agent --input "Hello!"

# Using API
curl -X POST http://localhost:8000/api/v1/agents \
  -H "Content-Type: application/json" \
  -d '{
    "id": "api-test",
    "name": "API Test",
    "instructions": "You are helpful"
  }'

curl http://localhost:8000/api/v1/agents/api-test/run \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{"input": "Hello!"}'
```

**✅ You're done!** App is running locally.

---

## Common Commands Reference

### Development
```bash
make install          # Install dependencies
make test             # Run all tests
make test-unit        # Run unit tests only
make lint             # Check code style
make format           # Auto-format code
make type-check       # Run type checker
```

### Database
```bash
make migrate          # Run migrations
make migrate-current  # Show current migration
make seed             # Seed demo data
make validate-schema  # Validate database schema
```

### Server
```bash
# Start API
uvicorn agent_factory.api.main:app --reload

# Start with custom port
uvicorn agent_factory.api.main:app --port 8001

# Production mode
uvicorn agent_factory.api.main:app --host 0.0.0.0 --port 8000
```

### CLI
```bash
agent-factory agent create <id> --name "<name>" --instructions "<instructions>"
agent-factory agent run <id> --input "<input>"
agent-factory agent list
agent-factory --help
```

---

## Troubleshooting

### Database Connection Fails

**Error:** `could not connect to server`

**Solutions:**
1. Check PostgreSQL is running: `pg_isready` (local) or verify Supabase project is active
2. Verify `DATABASE_URL` format in `.env`
3. Check firewall/network settings
4. For Supabase: Ensure SSL is enabled (`sslmode=require`)

### Migration Errors

**Error:** `Target database is not up to date`

**Solutions:**
1. Check current revision: `alembic current`
2. View history: `alembic history`
3. Upgrade: `alembic upgrade head`
4. If stuck: Check migration files for errors

### Import Errors

**Error:** `ModuleNotFoundError: No module named 'agent_factory'`

**Solutions:**
1. Install package: `pip install -e ".[dev]"`
2. Activate virtual environment
3. Check Python path: `python -c "import sys; print(sys.path)"`

### Port Already in Use

**Error:** `Address already in use`

**Solutions:**
1. Find process: `lsof -i :8000` (macOS/Linux) or `netstat -ano | findstr :8000` (Windows)
2. Kill process or use different port: `--port 8001`

---

## Next Steps

1. **Read Documentation:**
   - `docs/GETTING_STARTED.md` - First steps with Agent Factory
   - `docs/local-dev.md` - Detailed development guide
   - `docs/API_REFERENCE.md` - API documentation

2. **Try Examples:**
   - `examples/basic_agent.py`
   - `examples/customer_support_bot.py`

3. **Explore Features:**
   - Create agents via CLI/API/SDK
   - Install blueprints from marketplace
   - Build workflows

---

## Production Deployment Path

**From Repo → Production:**

1. **Choose Hosting:**
   - Vercel (for demo app) - See `docs/deploy-strategy.md`
   - Render (for API backend) - See `deployment/render.yaml`
   - Docker/K8s - See `docker/` directory

2. **Set Environment Variables:**
   - Copy production values to hosting platform
   - See `docs/env-and-secrets.md` for required vars

3. **Run Migrations:**
   - Production migrations via CI/CD (see `.github/workflows/db-migrate.yml`)
   - Or manually: `alembic upgrade head`

4. **Deploy:**
   - Via GitHub Actions (automatic on merge to main)
   - Or manually via hosting platform CLI

**See:** `docs/deploy-strategy.md` for complete deployment guide.

---

## Getting Help

- **Documentation:** `docs/` directory
- **Issues:** GitHub Issues
- **Environment Check:** `make env-check` or `python scripts/env-doctor.py`

---

**Last Updated:** 2024-01-XX  
**Maintained by:** Venture OS Supervisor
