# Environment Variables & Secrets Management

**Last Updated:** 2024-01-XX  
**Purpose:** Complete guide to environment variables, secrets, and configuration

---

## Executive Summary

**Total Variables:** ~40 environment variables  
**Categories:** API, Database, Auth, Billing, Observability, Storage, Features

**Secrets Management:**
- **Local:** `.env` file (gitignored)
- **CI:** GitHub Secrets
- **Production:** Hosting platform secrets (Render, Vercel, etc.)

---

## 1. Environment Variable Categories

### 1.1 API Configuration

**Purpose:** Core API server configuration

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `API_HOST` | No | `0.0.0.0` | API server host |
| `API_PORT` | No | `8000` | API server port |
| `API_BASE_URL` | No | `http://localhost:8000` | Base URL for API |
| `DEBUG` | No | `false` | Enable debug mode |

**Usage:**
```bash
API_HOST=0.0.0.0
API_PORT=8000
API_BASE_URL=https://api.example.com
DEBUG=false
```

**Notes:**
- `DEBUG=true` enables detailed error messages (dev only)
- `API_BASE_URL` used for generating absolute URLs

---

### 1.2 Database Configuration

**Purpose:** PostgreSQL database connection

#### Supabase (Recommended)

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `SUPABASE_URL` | Yes* | - | Supabase project URL |
| `SUPABASE_ANON_KEY` | Yes* | - | Supabase anonymous key |
| `SUPABASE_SERVICE_ROLE_KEY` | Yes* | - | Supabase service role key |
| `DATABASE_URL` | Yes* | - | PostgreSQL connection string |
| `SUPABASE_USE_POOLER` | No | `true` | Use connection pooler (port 6543) |

**Format:**
```bash
SUPABASE_URL=https://[PROJECT-REF].supabase.co
SUPABASE_ANON_KEY=eyJhbGc...
SUPABASE_SERVICE_ROLE_KEY=eyJhbGc...
DATABASE_URL=postgresql://postgres.[PROJECT-REF]:[PASSWORD]@aws-0-[REGION].pooler.supabase.com:6543/postgres
SUPABASE_USE_POOLER=true
```

#### Standard PostgreSQL

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `DATABASE_URL` | Yes* | - | PostgreSQL connection string |
| `POSTGRES_USER` | No | `agent_factory` | Database user |
| `POSTGRES_PASSWORD` | No | - | Database password |
| `POSTGRES_HOST` | No | `localhost` | Database host |
| `POSTGRES_PORT` | No | `5432` | Database port |
| `POSTGRES_DB` | No | `agent_factory` | Database name |

**Format:**
```bash
# Option 1: Connection string
DATABASE_URL=postgresql://user:password@host:5432/dbname

# Option 2: Individual variables
POSTGRES_USER=agent_factory
POSTGRES_PASSWORD=secure-password
POSTGRES_HOST=db.example.com
POSTGRES_PORT=5432
POSTGRES_DB=agent_factory
```

**Notes:**
- `DATABASE_URL` takes precedence over individual variables
- Supabase requires SSL (`sslmode=require`)
- Use connection pooler (port 6543) for Supabase production

---

### 1.3 Cache & Queue

**Purpose:** Redis for caching and job queue

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `REDIS_URL` | No | `redis://localhost:6379/0` | Redis connection string |

**Format:**
```bash
REDIS_URL=redis://localhost:6379/0
# Or with password
REDIS_URL=redis://:password@host:6379/0
# Or with SSL
REDIS_URL=rediss://host:6380/0
```

**Notes:**
- Optional but recommended for production
- Used for caching, rate limiting, job queue
- Falls back gracefully if not configured

---

### 1.4 LLM Providers

**Purpose:** AI model API keys

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `OPENAI_API_KEY` | Yes* | - | OpenAI API key |
| `ANTHROPIC_API_KEY` | No | - | Anthropic API key |

**Format:**
```bash
OPENAI_API_KEY=sk-...
ANTHROPIC_API_KEY=sk-ant-...
```

**Notes:**
- At least one LLM provider required
- Used by agents for AI capabilities
- Keep secure (never commit to git)

---

### 1.5 Authentication & Security

**Purpose:** JWT and API key authentication

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `JWT_SECRET_KEY` | Yes | - | Secret for JWT signing |
| `JWT_ALGORITHM` | No | `HS256` | JWT algorithm |
| `JWT_EXPIRATION_HOURS` | No | `24` | JWT expiration time |
| `API_KEY_ENABLED` | No | `false` | Enable API key auth |
| `API_KEY_SECRET` | No | - | Secret for API key hashing |

**Format:**
```bash
JWT_SECRET_KEY=your-secret-key-change-in-production
JWT_ALGORITHM=HS256
JWT_EXPIRATION_HOURS=24
API_KEY_ENABLED=true
API_KEY_SECRET=your-api-key-secret
```

**Notes:**
- `JWT_SECRET_KEY` must be strong (32+ characters)
- Generate with: `openssl rand -hex 32`
- Rotate regularly in production

---

### 1.6 Billing & Payments

**Purpose:** Stripe integration

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `STRIPE_SECRET_KEY` | No | - | Stripe secret key |
| `STRIPE_PUBLISHABLE_KEY` | No | - | Stripe publishable key |
| `STRIPE_WEBHOOK_SECRET` | No | - | Stripe webhook secret |

**Format:**
```bash
STRIPE_SECRET_KEY=sk_test_...  # Test mode
STRIPE_SECRET_KEY=sk_live_...  # Production
STRIPE_PUBLISHABLE_KEY=pk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...
```

**Notes:**
- Required only if billing features enabled
- Use test keys for development
- Webhook secret for webhook verification

---

### 1.7 Observability

**Purpose:** Logging, metrics, tracing

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `TELEMETRY_ENABLED` | No | `true` | Enable telemetry |
| `METRICS_ENABLED` | No | `true` | Enable metrics |
| `METRICS_PORT` | No | `9090` | Metrics server port |
| `LOG_LEVEL` | No | `INFO` | Log level (DEBUG, INFO, WARNING, ERROR) |
| `LOG_FORMAT` | No | `json` | Log format (json, text) |
| `TRACING_ENABLED` | No | `false` | Enable distributed tracing |
| `TRACING_BACKEND` | No | `jaeger` | Tracing backend |
| `JAEGER_ENDPOINT` | No | - | Jaeger endpoint |

**Format:**
```bash
TELEMETRY_ENABLED=true
METRICS_ENABLED=true
METRICS_PORT=9090
LOG_LEVEL=INFO
LOG_FORMAT=json
TRACING_ENABLED=false
JAEGER_ENDPOINT=http://localhost:14268/api/traces
```

**Notes:**
- JSON logs recommended for production (structured)
- Metrics exposed at `/metrics` endpoint
- Tracing optional (adds overhead)

---

### 1.8 Storage

**Purpose:** File storage configuration

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `STORAGE_TYPE` | No | `supabase` | Storage type (supabase, local, s3) |
| `SUPABASE_STORAGE_BUCKET` | No | `agent-factory` | Supabase bucket name |
| `STORAGE_PATH` | No | `./storage` | Local storage path |
| `AWS_ACCESS_KEY_ID` | No | - | AWS access key (S3) |
| `AWS_SECRET_ACCESS_KEY` | No | - | AWS secret key (S3) |
| `AWS_S3_BUCKET` | No | - | S3 bucket name |
| `AWS_REGION` | No | `us-east-1` | AWS region |

**Format:**
```bash
# Supabase Storage
STORAGE_TYPE=supabase
SUPABASE_STORAGE_BUCKET=agent-factory

# Local Storage (dev only)
STORAGE_TYPE=local
STORAGE_PATH=./storage

# S3 Storage
STORAGE_TYPE=s3
AWS_ACCESS_KEY_ID=AKIA...
AWS_SECRET_ACCESS_KEY=...
AWS_S3_BUCKET=my-bucket
AWS_REGION=us-east-1
```

---

### 1.9 Feature Flags

**Purpose:** Enable/disable features

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `FEATURE_BLUEPRINT_MARKETPLACE` | No | `true` | Enable blueprint marketplace |
| `FEATURE_BILLING` | No | `true` | Enable billing features |
| `FEATURE_MULTI_TENANT` | No | `true` | Enable multi-tenancy |

**Format:**
```bash
FEATURE_BLUEPRINT_MARKETPLACE=true
FEATURE_BILLING=true
FEATURE_MULTI_TENANT=true
```

---

### 1.10 Other

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `CORS_ORIGINS` | No | `*` | CORS allowed origins |
| `CORS_CREDENTIALS` | No | `true` | Allow CORS credentials |
| `RATE_LIMIT_ENABLED` | No | `true` | Enable rate limiting |
| `RATE_LIMIT_PER_MINUTE` | No | `60` | Requests per minute |
| `RATE_LIMIT_PER_HOUR` | No | `1000` | Requests per hour |
| `MARKETPLACE_URL` | No | - | Marketplace API URL |
| `MARKETPLACE_API_KEY` | No | - | Marketplace API key |

---

## 2. Secrets Management

### 2.1 Local Development

**File:** `.env` (gitignored)

**Setup:**
```bash
# Copy example
cp .env.example .env

# Edit with your values
nano .env
```

**Required for Local Dev:**
- `DATABASE_URL` (or Supabase vars)
- `OPENAI_API_KEY` (or `ANTHROPIC_API_KEY`)
- `JWT_SECRET_KEY`

**Optional:**
- `REDIS_URL` (if using cache/queue)
- `STRIPE_SECRET_KEY` (if testing billing)

---

### 2.2 CI/CD (GitHub Actions)

**Location:** GitHub Repository Secrets

**Required Secrets:**
- `DATABASE_URL` - Production database (for migrations)
- `OPENAI_API_KEY` - For tests (optional)
- `ANTHROPIC_API_KEY` - For tests (optional)

**How to Set:**
1. Go to Repository → Settings → Secrets and variables → Actions
2. Click "New repository secret"
3. Add each secret

**Usage in Workflows:**
```yaml
env:
  DATABASE_URL: ${{ secrets.DATABASE_URL }}
```

---

### 2.3 Production Hosting

#### Render

**Location:** Render Dashboard → Environment

**Required:**
- `DATABASE_URL`
- `OPENAI_API_KEY` or `ANTHROPIC_API_KEY`
- `JWT_SECRET_KEY`
- `SUPABASE_*` (if using Supabase)

**How to Set:**
1. Go to Render Dashboard
2. Select service
3. Go to Environment tab
4. Add variables

#### Vercel

**Location:** Vercel Dashboard → Project Settings → Environment Variables

**Required:** Same as Render

#### Docker/Kubernetes

**Location:** Environment variables or secrets

**Docker Compose:**
```yaml
environment:
  - DATABASE_URL=${DATABASE_URL}
  - OPENAI_API_KEY=${OPENAI_API_KEY}
```

**Kubernetes:**
- Use `Secret` resources
- Mount as environment variables

---

## 3. Environment-Specific Configuration

### Development

**File:** `.env`

**Typical Values:**
```bash
DEBUG=true
LOG_LEVEL=DEBUG
LOG_FORMAT=text
DATABASE_URL=postgresql://localhost:5432/agent_factory_dev
REDIS_URL=redis://localhost:6379/0
```

### Staging

**Typical Values:**
```bash
DEBUG=false
LOG_LEVEL=INFO
LOG_FORMAT=json
DATABASE_URL=postgresql://staging-db...
REDIS_URL=redis://staging-redis...
```

### Production

**Typical Values:**
```bash
DEBUG=false
LOG_LEVEL=INFO
LOG_FORMAT=json
DATABASE_URL=postgresql://prod-db...
REDIS_URL=redis://prod-redis...
TELEMETRY_ENABLED=true
METRICS_ENABLED=true
```

---

## 4. Security Best Practices

### 1. Never Commit Secrets

**✅ Good:**
- `.env` in `.gitignore`
- `.env.example` with placeholders
- Secrets in environment variables

**❌ Bad:**
- Secrets in code
- Secrets in git history
- Secrets in public repos

### 2. Rotate Secrets Regularly

**Schedule:**
- `JWT_SECRET_KEY`: Every 90 days
- API keys: When compromised
- Database passwords: Every 180 days

### 3. Use Strong Secrets

**Generate:**
```bash
# JWT Secret (32 bytes)
openssl rand -hex 32

# API Key Secret (32 bytes)
openssl rand -hex 32

# Database Password (16 bytes)
openssl rand -base64 16
```

### 4. Limit Secret Access

- Only grant access to necessary services
- Use different secrets per environment
- Rotate when team members leave

### 5. Monitor Secret Usage

- Log secret access (audit logs)
- Alert on unusual patterns
- Review access logs regularly

---

## 5. Validation

### Environment Validator

**Location:** `agent_factory/utils/env_validator.py`

**Usage:**
```python
from agent_factory.utils.env_validator import validate_agent_factory_env

validated = validate_agent_factory_env()
# Returns dict of validated variables
```

**Checks:**
- Required variables present
- Format validation (URLs, etc.)
- Value ranges (ports, etc.)

---

## 6. Troubleshooting

### Missing Variables

**Error:** `KeyError: 'DATABASE_URL'`

**Solution:**
1. Check `.env` file exists
2. Verify variable name (case-sensitive)
3. Restart application

### Invalid Format

**Error:** `Invalid database URL`

**Solution:**
1. Check URL format
2. Verify special characters are encoded
3. Test connection manually

### Secrets Not Loading

**Error:** Secrets not available in production

**Solution:**
1. Verify secrets set in hosting platform
2. Check secret names (case-sensitive)
3. Restart service after adding secrets

---

## 7. Quick Reference

### Minimum Required (Local Dev)

```bash
DATABASE_URL=postgresql://localhost:5432/agent_factory
OPENAI_API_KEY=sk-...
JWT_SECRET_KEY=...
```

### Production Minimum

```bash
DATABASE_URL=postgresql://...
OPENAI_API_KEY=sk-...
JWT_SECRET_KEY=...
SUPABASE_URL=...
SUPABASE_SERVICE_ROLE_KEY=...
```

### Full Production

See `.env.example` for complete list.

---

## Conclusion

**Key Points:**
- ~40 environment variables total
- Core required: Database, LLM key, JWT secret
- Use `.env` for local, platform secrets for production
- Never commit secrets to git
- Rotate secrets regularly

**Next Steps:**
1. Copy `.env.example` to `.env`
2. Fill in required variables
3. Set secrets in CI/hosting platform
4. Validate with `validate_agent_factory_env()`
