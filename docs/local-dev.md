# Local Development Guide

**Last Updated:** 2024-01-XX  
**Purpose:** Complete guide for setting up Agent Factory locally

---

## Quick Start

```bash
# 1. Clone repository
git clone https://github.com/agentfactory/platform.git
cd platform

# 2. Install dependencies
pip install -e ".[dev]"

# 3. Set up environment
cp .env.example .env
# Edit .env with your values

# 4. Set up database
# Option A: Use Supabase (recommended)
# - Create Supabase project
# - Copy DATABASE_URL and SUPABASE_* vars to .env

# Option B: Use local Postgres
# - Install Postgres
# - Create database: createdb agent_factory
# - Set DATABASE_URL in .env

# 5. Run migrations
./scripts/db-migrate-local.sh upgrade

# 6. Start API server
uvicorn agent_factory.api.main:app --reload

# 7. Verify
curl http://localhost:8000/health
```

---

## Prerequisites

### Required

- **Python:** 3.8, 3.9, 3.10, 3.11, or 3.12
- **PostgreSQL:** 12+ (or Supabase account)
- **pip:** Latest version

### Optional

- **Redis:** For caching and job queue
- **Docker:** For containerized development

---

## Installation

### 1. Clone Repository

```bash
git clone https://github.com/agentfactory/platform.git
cd platform
```

### 2. Create Virtual Environment

```bash
# Using venv
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Or using conda
conda create -n agent-factory python=3.11
conda activate agent-factory
```

### 3. Install Dependencies

```bash
# Install package with dev dependencies
pip install -e ".[dev]"

# Or install from requirements (if available)
pip install -r requirements.txt
```

### 4. Verify Installation

```bash
# Check CLI
agent-factory --version

# Check Python import
python -c "import agent_factory; print(agent_factory.__version__)"
```

---

## Environment Setup

### 1. Copy Environment Template

```bash
cp .env.example .env
```

### 2. Configure Environment Variables

**Minimum Required:**
```bash
# Database
DATABASE_URL=postgresql://user:password@localhost:5432/agent_factory

# LLM Provider (at least one)
OPENAI_API_KEY=sk-...
# OR
ANTHROPIC_API_KEY=sk-ant-...

# JWT Secret
JWT_SECRET_KEY=$(openssl rand -hex 32)
```

**Full Configuration:** See `docs/env-and-secrets.md`

### 3. Database Setup

#### Option A: Supabase (Recommended)

1. Create account at https://supabase.com
2. Create new project
3. Get connection details from project settings
4. Add to `.env`:
   ```bash
   SUPABASE_URL=https://[PROJECT-REF].supabase.co
   SUPABASE_ANON_KEY=...
   SUPABASE_SERVICE_ROLE_KEY=...
   DATABASE_URL=postgresql://postgres.[PROJECT-REF]:[PASSWORD]@aws-0-[REGION].pooler.supabase.com:6543/postgres
   SUPABASE_USE_POOLER=true
   ```

#### Option B: Local PostgreSQL

1. Install PostgreSQL
2. Create database:
   ```bash
   createdb agent_factory
   ```
3. Set in `.env`:
   ```bash
   DATABASE_URL=postgresql://localhost:5432/agent_factory
   ```

### 4. Run Migrations

```bash
# Upgrade to latest
./scripts/db-migrate-local.sh upgrade

# Check current revision
./scripts/db-migrate-local.sh current

# View history
./scripts/db-migrate-local.sh history
```

### 5. Seed Demo Data (Optional)

```bash
python scripts/db-seed-demo.py
```

---

## Running the Application

### API Server

```bash
# Development mode (auto-reload)
uvicorn agent_factory.api.main:app --reload --host 0.0.0.0 --port 8000

# Production mode
uvicorn agent_factory.api.main:app --host 0.0.0.0 --port 8000
```

**Access:**
- API: http://localhost:8000
- Docs: http://localhost:8000/docs
- Health: http://localhost:8000/health

### CLI

```bash
# Create agent
agent-factory agent create my-agent \
  --name "My Agent" \
  --instructions "You are helpful"

# Run agent
agent-factory agent run my-agent --input "Hello!"

# List agents
agent-factory agent list
```

### Docker Compose

```bash
# Start services
docker-compose -f docker/docker-compose.yml up

# Or production config
docker-compose -f docker/docker-compose.prod.yml up
```

---

## Development Workflow

### 1. Make Changes

```bash
# Edit code
vim agent_factory/core/agent.py

# Code is auto-reloaded (if using --reload)
```

### 2. Run Tests

```bash
# All tests
pytest tests/

# Specific test
pytest tests/test_agent.py

# With coverage
pytest tests/ --cov=agent_factory --cov-report=html

# View coverage report
open htmlcov/index.html
```

### 3. Lint Code

```bash
# Check
ruff check agent_factory/ tests/
black --check agent_factory/ tests/
mypy agent_factory/

# Fix (auto-fixable issues)
ruff check --fix agent_factory/ tests/
black agent_factory/ tests/
```

### 4. Create Migration

```bash
# After changing models
alembic revision --autogenerate -m "description"

# Or use script
./scripts/db-migrate-local.sh create "description"
```

### 5. Test Migration

```bash
# Upgrade
./scripts/db-migrate-local.sh upgrade

# Verify schema
python scripts/db-validate-schema.py

# If needed, downgrade
./scripts/db-migrate-local.sh downgrade -1
```

---

## Common Tasks

### Reset Database

```bash
# Drop all tables (careful!)
alembic downgrade base

# Recreate
alembic upgrade head

# Seed demo data
python scripts/db-seed-demo.py
```

### Run Smoke Tests

```bash
# Start API server first
uvicorn agent_factory.api.main:app --reload &

# Run smoke tests
./scripts/smoke-tests.sh

# Or set custom URL
API_BASE_URL=http://localhost:8000 ./scripts/smoke-tests.sh
```

### Check Database Connection

```bash
python -c "
from agent_factory.database.session import get_db
db = next(get_db())
print('✓ Database connected')
"
```

### Validate Environment

```bash
python -c "
from agent_factory.utils.env_validator import validate_agent_factory_env
validated = validate_agent_factory_env()
print(f'✓ Validated {len(validated)} variables')
"
```

---

## Troubleshooting

### Database Connection Issues

**Error:** `could not connect to server`

**Solutions:**
1. Check PostgreSQL is running: `pg_isready`
2. Verify `DATABASE_URL` format
3. Check firewall/network settings
4. For Supabase: Verify SSL settings

---

### Migration Errors

**Error:** `Target database is not up to date`

**Solutions:**
1. Check current revision: `alembic current`
2. View history: `alembic history`
3. Upgrade: `alembic upgrade head`
4. If stuck: Check migration files for errors

---

### Import Errors

**Error:** `ModuleNotFoundError: No module named 'agent_factory'`

**Solutions:**
1. Install package: `pip install -e ".[dev]"`
2. Activate virtual environment
3. Check Python path: `python -c "import sys; print(sys.path)"`

---

### Port Already in Use

**Error:** `Address already in use`

**Solutions:**
1. Find process: `lsof -i :8000` (macOS/Linux)
2. Kill process: `kill -9 <PID>`
3. Or use different port: `--port 8001`

---

## Development Tools

### IDE Setup

**VS Code:**
- Python extension
- Pylance for type checking
- Black formatter extension

**PyCharm:**
- Configure Python interpreter
- Enable type checking
- Set up run configurations

### Pre-commit Hooks (Optional)

```bash
# Install pre-commit
pip install pre-commit

# Install hooks
pre-commit install

# Run manually
pre-commit run --all-files
```

---

## Project Structure

```
agent_factory/
├── api/              # REST API
├── cli/              # CLI commands
├── core/             # Core primitives
├── database/         # Database models and session
├── integrations/     # LLM providers
├── tools/            # Tool system
└── ...

tests/                # Test suite
alembic/              # Database migrations
scripts/               # Utility scripts
docs/                  # Documentation
```

---

## Useful Commands

```bash
# Run all checks
pytest tests/ && ruff check . && black --check . && mypy agent_factory/

# Quick test
./scripts/quick_test.sh

# Update dependencies
pip install --upgrade -e ".[dev]"

# Clean up
find . -type d -name __pycache__ -exec rm -r {} +
find . -type f -name "*.pyc" -delete
```

---

## Next Steps

1. **Read Documentation:**
   - `docs/GETTING_STARTED.md` - First steps
   - `docs/API_REFERENCE.md` - API documentation
   - `docs/ARCHITECTURE_DETAILED.md` - Architecture deep dive

2. **Try Examples:**
   - `examples/basic_agent.py`
   - `examples/customer_support_bot.py`

3. **Join Community:**
   - GitHub Discussions
   - Discord/Slack (if available)

---

## Getting Help

**Issues:**
- Check existing issues on GitHub
- Search documentation
- Ask in discussions

**Debugging:**
- Enable debug mode: `DEBUG=true`
- Check logs: Application logs to console
- Use health endpoint: `/health`

**Support:**
- GitHub Issues for bugs
- Discussions for questions
- Documentation for guides

---

## Conclusion

**You're Ready When:**
- ✅ API server runs without errors
- ✅ Database migrations applied
- ✅ Health check passes
- ✅ Tests pass
- ✅ Can create and run agents

**Happy Coding!** 🚀
