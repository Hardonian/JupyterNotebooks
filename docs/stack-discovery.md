# Stack Discovery Report

**Generated:** 2024-01-XX  
**Purpose:** Complete inventory of the Agent Factory platform stack, infrastructure, and deployment patterns.

---

## Executive Summary

Agent Factory is a **Python-based AI agent platform** that provides:
- Backend API (FastAPI)
- CLI and SDK for developers
- Multi-tenant SaaS capabilities
- Blueprint marketplace
- No dedicated frontend (API-first architecture)

**Primary Stack:**
- **Backend:** Python 3.8+ / FastAPI
- **Database:** PostgreSQL (Supabase recommended)
- **Cache/Queue:** Redis
- **Migrations:** Alembic
- **Deployment:** Docker, Render, Vercel (for demo apps)

---

## 1. Frontend

### Status: **No Dedicated Frontend**

This is an **API-first platform** with no traditional frontend application.

**UI Components:**
- Simple HTML demo UI generator (`agent_factory/ui/generator.py`)
- Demo app in `apps/research_assistant_app/main.py` (FastAPI serving HTML)
- CLI-based interface (`agent_factory/cli/`)
- REST API for integrations

**Frontend Strategy:**
- Platform is designed to be consumed via:
  - Python SDK
  - REST API
  - CLI
- Frontend applications are expected to be built by users/consumers
- UI generator can create basic HTML/React templates for demos

**Build Tooling:** N/A (no frontend build process)

---

## 2. Backend

### Framework: **FastAPI**

**Location:** `agent_factory/api/main.py`

**Key Components:**
- FastAPI application with async support
- REST API endpoints:
  - `/api/v1/agents` - Agent management
  - `/api/v1/tools` - Tool management
  - `/api/v1/workflows` - Workflow orchestration
  - `/api/v1/blueprints` - Blueprint marketplace
  - `/api/v1/executions` - Execution tracking
  - `/api/v1/telemetry` - Metrics and observability
  - `/api/v1/health` - Health checks
  - `/api/v1/payments` - Stripe integration
  - `/api/v1/financial` - Billing and cost tracking

**Server:** Uvicorn (ASGI)

**Python Version:** 3.8+ (tested on 3.8-3.12)

**Dependencies:** See `pyproject.toml`
- FastAPI, Uvicorn
- SQLAlchemy (ORM)
- Alembic (migrations)
- Supabase client
- Redis client
- Stripe SDK
- OpenAI/Anthropic SDKs

---

## 3. Database & Persistence

### Primary Database: **PostgreSQL** (via Supabase)

**ORM:** SQLAlchemy 2.0+

**Migrations:** Alembic
- Location: `alembic/versions/`
- Current migrations:
  - `001_initial_migration.py` - Initial schema
  - `002_master_schema.py` - Consolidated master schema

**Database Models:** `agent_factory/database/models.py`
- Users, Tenants (multi-tenancy)
- Agents, Workflows, Blueprints
- Executions, Audit Logs
- API Keys, Projects
- Plans, Subscriptions, Usage Records

**Connection Management:**
- `agent_factory/database/session.py`
- Supports Supabase connection pooling (port 6543)
- SSL required for Supabase
- Connection pool: 5-10 connections (Supabase), 10-20 (standard Postgres)

**Supabase Integration:**
- RLS policies: `supabase/rls_policies.sql`
- Storage support: `agent_factory/database/supabase_client.py`
- Client utilities for Supabase Auth

**Alternative Options:**
- SQLite (development only, not production-ready)
- Standard PostgreSQL (self-hosted or managed)

### Cache/Queue: **Redis**

**Usage:**
- Caching layer (`agent_factory/cache/`)
- Job queue (`agent_factory/jobs/queue.py`)
- Rate limiting

**Configuration:** `REDIS_URL` environment variable

---

## 4. Infrastructure & Hosting

### Deployment Targets

**1. Docker (Primary)**
- `docker/Dockerfile` - Python 3.11-slim base
- `docker/docker-compose.yml` - Development setup
- `docker/docker-compose.prod.yml` - Production setup
- Services: API, Scheduler

**2. Render**
- `deployment/render.yaml` - Render.com configuration
- Web service with health checks
- Environment variables configured

**3. Vercel**
- `deployment/vercel.json` - Configured for demo app (`apps/research_assistant_app/`)
- Not configured for main API (FastAPI on Vercel requires serverless functions)

**4. Kubernetes**
- `k8s/` directory with manifests:
  - API deployment
  - Postgres deployment
  - Redis deployment
  - ConfigMaps, Secrets, Ingress

**5. HuggingFace Spaces**
- `deployment/huggingface/` - Demo deployment config

### Current Deployment Status

**Production:** Not clearly defined
- No production deployment workflow in CI
- Multiple deployment configs suggest experimentation phase

**Preview/Staging:** Not configured
- No PR-based preview deployments
- No staging environment workflow

---

## 5. CI/CD & Automation

### GitHub Actions Workflows

**Location:** `.github/workflows/`

**1. `ci.yml`** - Main CI Pipeline
- **Triggers:** Push/PR to `main`, `develop`
- **Jobs:**
  - `test` - Matrix test (Python 3.8-3.12)
  - `lint` - Ruff, Black, MyPy
  - `security` - Safety, Bandit, detect-secrets
  - `build` - Package build
- **Status:** ✅ Active and comprehensive

**2. `maintenance.yml`** - Weekly Maintenance
- **Triggers:** Weekly schedule, manual dispatch
- **Jobs:**
  - Dependency checks
  - Stale issue management
  - Code quality checks
- **Status:** ✅ Active

**3. `nightly.yml`** - Nightly Integration Tests
- **Triggers:** Daily schedule, manual dispatch
- **Jobs:**
  - Integration tests with Postgres + Redis services
  - Security scans
- **Status:** ✅ Active

**4. `nightly-tests.yml`** - Extended Test Suite
- **Triggers:** Daily schedule, manual dispatch
- **Jobs:**
  - Full test matrix (3.8-3.12)
  - Slow tests
- **Status:** ✅ Active (may be redundant with `nightly.yml`)

### Missing CI Workflows

**❌ Database Migrations**
- No automated migration workflow
- Migrations must be run manually
- No migration validation in CI

**❌ Deployment Workflows**
- No automated deployment to production
- No preview/staging deployments
- No deployment rollback mechanism

**❌ Smoke Tests**
- No post-deployment smoke tests
- Health checks exist but not automated in CI

---

## 6. Environment & Secrets

### Environment Variables

**Location:** `.env.example`

**Categories:**
1. **API Configuration**
   - `API_HOST`, `API_PORT`, `API_BASE_URL`, `DEBUG`

2. **Database**
   - `DATABASE_URL` (primary)
   - `SUPABASE_URL`, `SUPABASE_ANON_KEY`, `SUPABASE_SERVICE_ROLE_KEY`
   - `SUPABASE_USE_POOLER`
   - Alternative: `POSTGRES_*` variables

3. **Cache**
   - `REDIS_URL`

4. **LLM Providers**
   - `OPENAI_API_KEY`, `ANTHROPIC_API_KEY`

5. **Authentication**
   - `JWT_SECRET_KEY`, `JWT_ALGORITHM`, `JWT_EXPIRATION_HOURS`
   - `API_KEY_ENABLED`, `API_KEY_SECRET`

6. **Billing**
   - `STRIPE_SECRET_KEY`, `STRIPE_PUBLISHABLE_KEY`, `STRIPE_WEBHOOK_SECRET`

7. **Observability**
   - `TELEMETRY_ENABLED`, `METRICS_ENABLED`, `METRICS_PORT`
   - `LOG_LEVEL`, `LOG_FORMAT`
   - `TRACING_ENABLED`, `JAEGER_ENDPOINT`

8. **Storage**
   - `STORAGE_TYPE` (supabase/local/s3)
   - Supabase/S3 specific vars

9. **Feature Flags**
   - `FEATURE_BLUEPRINT_MARKETPLACE`, `FEATURE_BILLING`, `FEATURE_MULTI_TENANT`

### Secrets Management

**Current State:**
- `.env.example` documents all variables
- No centralized secrets management documented
- GitHub Secrets likely used but not documented
- No secrets rotation strategy

---

## 7. Testing & Quality

### Test Framework: **pytest**

**Configuration:** `pytest.ini`
- Markers: `unit`, `integration`, `slow`
- Test paths: `tests/`

**Test Coverage:**
- Unit tests: ✅ Comprehensive
- Integration tests: ✅ Present (`tests/integration/`)
- E2E tests: ❌ Not present

**CI Integration:**
- Tests run in CI (`ci.yml`)
- Coverage reporting (Codecov)
- Integration tests run nightly

**Test Scripts:**
- `scripts/quick_test.sh` - Quick local testing

---

## 8. Business Intent & User Flows

### Primary Use Cases

**1. AI Agent Development Platform**
- Developers build agents using Python SDK or CLI
- Agents can be deployed and run via API
- Multi-tenant SaaS model

**2. Blueprint Marketplace**
- Pre-built agent configurations
- Share and monetize blueprints
- Education-focused blueprints (learning paths, student support)

**3. Workflow Orchestration**
- Chain multiple agents together
- Complex automation workflows

**4. Enterprise Features**
- Multi-tenancy
- Billing and subscriptions (Stripe)
- Usage tracking
- Audit logging
- RBAC

### Target Users

- **Developers:** Building AI agents
- **Founders:** Launching SaaS products
- **Educators:** Creating educational tools
- **Teams:** Internal automation

---

## 9. Notable Gaps & Red Flags

### Critical Gaps

1. **❌ No CI Migration Workflow**
   - Migrations must be run manually
   - Risk of schema drift between environments
   - No migration validation in CI

2. **❌ No Deployment Automation**
   - No automated production deployments
   - No preview/staging environments
   - Manual deployment process

3. **❌ No Smoke Tests**
   - No automated health checks post-deployment
   - No validation that deployments succeeded

4. **❌ Secrets Management Not Documented**
   - No clear process for managing secrets
   - No rotation strategy

5. **❌ No Seed Data Scripts**
   - No documented way to seed demo data
   - No seed workflow in CI

### Medium Priority Gaps

6. **⚠️ Redundant CI Workflows**
   - `nightly.yml` and `nightly-tests.yml` overlap
   - Could be consolidated

7. **⚠️ No Frontend Hosting Strategy**
   - Platform is API-only, but no clear hosting docs
   - Demo apps exist but deployment unclear

8. **⚠️ No Rollback Strategy**
   - No documented rollback process
   - No database migration rollback workflow

### Low Priority / Future Improvements

9. **📋 No E2E Tests**
   - Would benefit from API E2E tests

10. **📋 No Multi-Environment Pipeline**
    - Single production environment
    - No staging/dev environment separation

---

## 10. Recommendations Summary

### Immediate Actions

1. **Create CI Migration Workflow**
   - Automated migrations on main branch
   - Migration validation in PRs

2. **Add Deployment Workflows**
   - Production deployment on main
   - Preview deployments on PRs

3. **Add Smoke Tests**
   - Post-deployment health checks
   - API endpoint validation

4. **Document Secrets Management**
   - GitHub Secrets mapping
   - Hosting platform secrets

5. **Create Seed Data Scripts**
   - Demo data for testing
   - CI seed workflow

### Short-Term Improvements

6. Consolidate redundant CI workflows
7. Add rollback procedures
8. Document deployment processes
9. Add E2E test suite

### Long-Term Enhancements

10. Multi-environment pipeline (dev/staging/prod)
11. Advanced observability (APM, error tracking)
12. Cost monitoring and alerts

---

## Conclusion

Agent Factory is a **well-structured Python platform** with:
- ✅ Solid backend architecture (FastAPI + SQLAlchemy)
- ✅ Comprehensive test coverage
- ✅ Good CI for code quality
- ✅ Multiple deployment options configured

**Main gaps are in:**
- ❌ CI/CD automation (migrations, deployments)
- ❌ Production readiness (smoke tests, rollback)
- ❌ Documentation (secrets, deployment processes)

**Next Steps:** See `docs/backend-strategy.md` and `docs/frontend-hosting-strategy.md` for detailed recommendations.
