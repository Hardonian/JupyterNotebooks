# Backend Discovery Report

**Generated:** 2024-01-01  
**Purpose:** Comprehensive audit of database migrations, schema, and backend infrastructure

---

## Executive Summary

This project uses **PostgreSQL** as the primary database (with SQLite support for development), managed through **Alembic** migrations and **SQLAlchemy** ORM. The current migration state is incomplete—the existing migration file is missing several tables defined in the models.

---

## Migration Framework

### Framework: Alembic

- **Location:** `alembic/`
- **Config:** `alembic.ini`
- **Environment:** `alembic/env.py`
- **Migrations:** `alembic/versions/001_initial_migration.py`

**Status:** ✅ Alembic is properly configured and wired to SQLAlchemy models.

---

## Database Type

### Primary: PostgreSQL

- **Evidence:**
  - Migration uses `postgresql` dialect imports
  - `DATABASE_URL` defaults to PostgreSQL connection string
  - Docker compose includes PostgreSQL service
  - Kubernetes manifests include PostgreSQL deployment

### Development Fallback: SQLite

- **Evidence:**
  - `.env.example` shows SQLite option for development
  - Code supports both `postgresql://` and `sqlite:///` URLs
  - Some components (prompt logging, telemetry) use SQLite for local dev

**Recommendation:** PostgreSQL for production, SQLite acceptable for local development only.

---

## Database Configuration

### Environment Variables

**Primary:**
- `DATABASE_URL` - Full connection string (preferred)
  - Format: `postgresql://user:password@host:port/dbname`
  - Or: `sqlite:///./agent_factory.db` (dev only)

**Fallback (if DATABASE_URL not set):**
- `POSTGRES_USER` - Database user (default: `agent_factory`)
- `POSTGRES_PASSWORD` - Database password
- `POSTGRES_HOST` - Database host (default: `localhost`)
- `POSTGRES_PORT` - Database port (default: `5432`)
- `POSTGRES_DB` - Database name (default: `agent_factory`)

**Location:** `agent_factory/database/session.py`

### Connection Management

- **Session Factory:** `SessionLocal` (SQLAlchemy)
- **Session Generator:** `get_db()` - FastAPI dependency pattern
- **Base:** `Base` (declarative_base) for all models

---

## Schema State Analysis

### Current Migration (`001_initial_migration.py`)

**Tables Created:**
1. ✅ `users` - User accounts
2. ✅ `tenants` - Multi-tenancy support
3. ✅ `agents` - AI agent definitions
4. ✅ `workflows` - Workflow definitions
5. ✅ `blueprints` - Blueprint templates
6. ✅ `executions` - Execution records
7. ✅ `audit_logs` - Audit trail
8. ✅ `api_keys` - API authentication keys

### Missing from Migration (but in models.py)

**Tables NOT in migration:**
1. ❌ `projects` - Project/App organization
2. ❌ `plans` - Billing plans
3. ❌ `subscriptions` - Tenant subscriptions
4. ❌ `usage_records` - Usage tracking for billing

**Schema Inconsistencies:**
- Migration uses `user_id` in some places, models use `created_by`
- Migration uses `type` in executions, models use `execution_type`
- Migration uses `result` in executions, models use `output_data`
- Migration uses `description` in workflows, models don't have it
- Migration uses `config` in agents, models don't have it
- Migration uses `definition` in blueprints, models have both `definition` and `config`
- Blueprint model has additional fields: `pricing_model`, `price`, `publisher_id`, `is_public`, `downloads`, `rating`, `reviews_count`
- AuditLog model uses `Integer` primary key with autoincrement, migration uses `String`
- AuditLog model has `details` (JSON), migration uses `metadata`
- AuditLog model has `ip_address`, migration doesn't

---

## Database Usage in Codebase

### API Routes Using Database

- `agent_factory/api/routes/agents.py` - (Indirect via registry)
- `agent_factory/api/routes/blueprints.py` - Uses Blueprint model
- `agent_factory/api/routes/executions.py` - Uses Execution model
- `agent_factory/api/routes/financial.py` - Uses billing models
- `agent_factory/api/routes/payments.py` - Uses payment models

### Core Services Using Database

- `agent_factory/auth/api_keys.py` - APIKey, User, Tenant
- `agent_factory/billing/usage_tracker.py` - UsageRecord, Tenant, Subscription, Plan
- `agent_factory/billing/plans.py` - Plan
- `agent_factory/marketplace/*` - Blueprint operations
- `agent_factory/payments/*` - Payment and revenue sharing
- `agent_factory/enterprise/compliance.py` - AuditLog, User, Execution
- `agent_factory/enterprise/multitenancy.py` - Tenant, User
- `agent_factory/security/auth.py` - User

---

## Docker & Deployment

### Docker Compose

**Location:** `docker/docker-compose.yml`, `deployment/docker/docker-compose.prod.yml`

**Services:**
- API service (no DB service in base compose)
- Production compose includes PostgreSQL service

### Kubernetes

**Location:** `k8s/`

**Resources:**
- `postgres-deployment.yaml` - PostgreSQL deployment
- `configmap.yaml` - Database config
- `secret.yaml` - Database credentials

---

## Migration Management

### Current Tools

- **CLI:** Alembic command-line (`alembic upgrade head`, etc.)
- **Python API:** `agent_factory/database/migrations.py` - `MigrationManager` class
- **Init Function:** `init_db()` in `agent_factory/database/session.py` (creates tables directly, bypasses migrations)

### Issues Identified

1. **Incomplete Migration:** Missing 4 tables (projects, plans, subscriptions, usage_records)
2. **Schema Drift:** Migration doesn't match models exactly
3. **No Migration Scripts:** No documented scripts for running migrations locally or in production
4. **Dual Initialization:** Both `init_db()` and migrations exist—could cause confusion

---

## Recommendations

1. ✅ **Consolidate migrations** - Create master migration with all tables
2. ✅ **Fix schema inconsistencies** - Align migration with models
3. ✅ **Add migration scripts** - Create easy-to-use scripts for dev and prod
4. ✅ **Document workflow** - Clear instructions for running migrations
5. ✅ **Standardize initialization** - Use migrations only, remove direct `init_db()` or make it migration-aware

---

## Next Steps

See:
- `docs/data-model-overview.md` - Complete schema documentation
- `docs/backend-options-and-costs.md` - Backend hosting recommendations
- `docs/migrations-workflow.md` - Migration execution guide
