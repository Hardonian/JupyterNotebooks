# Backend & Database Strategy

**Last Updated:** 2024-01-XX  
**Status:** Canonical backend strategy for Agent Factory platform

---

## Executive Summary

**Canonical Backend:** PostgreSQL via **Supabase** (recommended) or self-hosted Postgres

**Rationale:**
- Platform requires relational database (multi-tenant, complex relationships)
- Supabase provides managed Postgres + Auth + Storage + RLS
- Cost-effective for startups (free tier, then usage-based)
- Production-ready with connection pooling, backups, monitoring

**Alternative:** Self-hosted PostgreSQL (for full control, higher ops overhead)

---

## 1. Database Choice: Supabase (Recommended)

### Why Supabase?

**1. Managed PostgreSQL**
- Fully managed Postgres 15+
- Automatic backups and point-in-time recovery
- Built-in connection pooling (pgBouncer)
- SSL/TLS encryption

**2. Additional Services**
- **Auth:** User authentication (JWT, OAuth, magic links)
- **Storage:** File storage (for blueprints, knowledge packs)
- **RLS:** Row-Level Security (multi-tenant isolation)
- **Realtime:** WebSocket subscriptions (future use)

**3. Cost-Effective**
- **Free Tier:**
  - 500 MB database
  - 1 GB file storage
  - 50,000 monthly active users
  - 2 GB bandwidth
- **Pro Tier:** $25/month (scales from there)
- **Usage-Based:** Pay for what you use beyond free tier

**4. Developer Experience**
- Web dashboard for database management
- SQL editor with query history
- Migration management
- API auto-generation

**5. Production Features**
- Connection pooling (port 6543)
- Read replicas (Pro+)
- Database branching (for testing)
- Monitoring and alerts

### Configuration

**Environment Variables:**
```bash
# Supabase Configuration
SUPABASE_URL=https://[PROJECT-REF].supabase.co
SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key

# Database URL (use pooled connection for production)
DATABASE_URL=postgresql://postgres.[PROJECT-REF]:[PASSWORD]@aws-0-[REGION].pooler.supabase.com:6543/postgres
SUPABASE_USE_POOLER=true
```

**Connection Strategy:**
- **Production:** Use connection pooler (port 6543) - handles 1000s of connections
- **Migrations/Admin:** Use direct connection (port 5432) - full Postgres features
- **Development:** Either pooler or direct (pooler recommended for consistency)

**RLS Policies:**
- Pre-configured policies in `supabase/rls_policies.sql`
- Enforces multi-tenant isolation at database level
- Service role key bypasses RLS (backend operations)
- Anon key respects RLS (client operations)

---

## 2. Alternative: Self-Hosted PostgreSQL

### When to Use

- **Full Control:** Need complete control over database configuration
- **Compliance:** Specific compliance requirements (HIPAA, SOC2, etc.)
- **Cost:** Very high scale where managed services become expensive
- **Custom Extensions:** Need Postgres extensions not available in Supabase

### Options

**1. Managed Postgres Providers**
- **Neon:** Serverless Postgres (good for serverless backends)
- **Render:** Managed Postgres (simple, integrated with Render hosting)
- **AWS RDS:** Enterprise-grade, high cost
- **DigitalOcean:** Simple, affordable managed Postgres

**2. Self-Hosted**
- Docker Compose (development)
- Kubernetes (production)
- VM-based (traditional)

### Configuration

**Environment Variables:**
```bash
# Standard PostgreSQL
DATABASE_URL=postgresql://user:password@host:5432/dbname

# Or individual variables
POSTGRES_USER=agent_factory
POSTGRES_PASSWORD=secure-password
POSTGRES_HOST=db.example.com
POSTGRES_PORT=5432
POSTGRES_DB=agent_factory
```

**Connection Pooling:**
- Use PgBouncer or PgPool-II
- Configure in application (`agent_factory/database/session.py`)
- Recommended pool size: 10-20 connections

---

## 3. Database Schema & Migrations

### Current Schema

**Location:** `agent_factory/database/models.py`

**Core Tables:**
- `users` - User accounts
- `tenants` - Multi-tenant organizations
- `agents` - AI agent definitions
- `workflows` - Workflow definitions
- `blueprints` - Blueprint marketplace
- `executions` - Execution history
- `audit_logs` - Audit trail
- `api_keys` - API authentication
- `projects` - Project organization
- `plans` - Billing plans
- `subscriptions` - Tenant subscriptions
- `usage_records` - Usage tracking

### Migration Tool: Alembic

**Location:** `alembic/versions/`

**Current Migrations:**
- `001_initial_migration.py` - Initial schema
- `002_master_schema.py` - Consolidated master schema

**Migration Commands:**
```bash
# Local development
./scripts/db-migrate-local.sh upgrade

# Production
./scripts/db-migrate-prod.sh upgrade

# Create new migration
alembic revision --autogenerate -m "description"
```

**CI Integration:**
- See `.github/workflows/db-migrate.yml` (to be created)
- Migrations run automatically on main branch
- Migration validation in PRs

---

## 4. Connection Management

### SQLAlchemy Configuration

**File:** `agent_factory/database/session.py`

**Supabase Optimizations:**
- Connection pooling: 5-10 connections (Supabase handles scaling)
- SSL required: `sslmode=require`
- Connection recycling: 1 hour
- Pre-ping: Enabled (detects dead connections)

**Standard Postgres:**
- Connection pooling: 10-20 connections
- No SSL requirement (unless configured)
- Standard connection management

**Session Management:**
- `get_db()` - Dependency injection for FastAPI routes
- Automatic session cleanup
- Context managers for manual sessions

---

## 5. Multi-Tenancy Strategy

### Row-Level Security (RLS)

**Supabase RLS:**
- Policies defined in `supabase/rls_policies.sql`
- Enforced at database level
- Users can only access their tenant's data
- Service role bypasses RLS (backend operations)

**Application-Level:**
- `tenant_id` column on all tenant-scoped tables
- Filtering in application code (backup if RLS not available)
- Middleware to inject tenant context

### Tenant Isolation

**Strategy:**
1. **Database Level:** RLS policies (Supabase)
2. **Application Level:** Query filtering by `tenant_id`
3. **API Level:** Tenant context from authentication

**Implementation:**
- JWT tokens include `tenant_id`
- API middleware extracts tenant
- All queries filtered by tenant
- Audit logs track tenant access

---

## 6. Caching & Performance

### Redis Cache

**Purpose:**
- Agent definitions caching
- Workflow definitions caching
- Rate limiting
- Job queue

**Configuration:**
```bash
REDIS_URL=redis://localhost:6379/0
```

**Usage:**
- `agent_factory/cache/` - Cache utilities
- TTL-based expiration
- Cache invalidation on updates

### Database Performance

**Indexes:**
- Email indexes on `users`
- Slug indexes on `tenants`
- Foreign key indexes (automatic)
- Created_at indexes on audit logs

**Query Optimization:**
- Use connection pooling
- Avoid N+1 queries (eager loading)
- Use select_related/joinedload for relationships

---

## 7. Backup & Recovery

### Supabase Backups

**Automatic:**
- Daily backups (retained 7 days)
- Point-in-time recovery (Pro tier)
- Manual backup snapshots

**Export:**
- pg_dump via Supabase dashboard
- SQL export for migrations

### Self-Hosted Backups

**Strategy:**
- Daily pg_dump to S3/object storage
- WAL archiving for point-in-time recovery
- Test restore procedures regularly

**Scripts:**
- `scripts/db-backup.sh` (to be created)
- Automated via cron or CI

---

## 8. Scaling Considerations

### Current Capacity (Supabase Free Tier)

- **Database:** 500 MB
- **Connections:** 60 direct, unlimited via pooler
- **Storage:** 1 GB
- **Bandwidth:** 2 GB/month

### Scaling Path

**1. Supabase Pro ($25/month)**
- 8 GB database
- 100 GB storage
- 50 GB bandwidth
- Read replicas

**2. Supabase Team ($599/month)**
- 32 GB database
- 200 GB storage
- 250 GB bandwidth
- Daily backups, PITR

**3. Self-Hosted**
- Vertical scaling (larger instance)
- Horizontal scaling (read replicas)
- Sharding (complex, future)

### Application Scaling

**Stateless API:**
- FastAPI is stateless
- Scale horizontally (multiple instances)
- Load balancer distributes traffic
- Shared database and Redis

**Connection Pooling:**
- Critical for scaling
- Use Supabase pooler (port 6543)
- Limit connections per instance

---

## 9. Migration Path

### From SQLite to Postgres

**Current State:**
- SQLite supported for development only
- Production requires Postgres

**Migration:**
1. Export SQLite data
2. Import to Postgres
3. Run Alembic migrations
4. Update `DATABASE_URL`

### From Self-Hosted to Supabase

**Migration:**
1. Create Supabase project
2. Run migrations on Supabase
3. Export data from self-hosted
4. Import to Supabase
5. Update connection strings
6. Test thoroughly
7. Switch DNS/config

### From Supabase to Self-Hosted

**Migration:**
1. Export Supabase database (pg_dump)
2. Set up self-hosted Postgres
3. Import data
4. Update connection strings
5. Migrate RLS policies to application-level
6. Test thoroughly

---

## 10. Cost Analysis

### Supabase Costs

**Free Tier:**
- Suitable for: Development, small demos, < 1000 users
- Cost: $0/month

**Pro Tier:**
- Suitable for: Small SaaS, < 10,000 users
- Cost: $25/month base + usage

**Team Tier:**
- Suitable for: Growing SaaS, enterprise
- Cost: $599/month base + usage

### Self-Hosted Costs

**DigitalOcean Managed Postgres:**
- Basic: $15/month (1 GB RAM, 10 GB storage)
- Standard: $60/month (2 GB RAM, 25 GB storage)

**AWS RDS:**
- db.t3.micro: ~$15/month
- db.t3.small: ~$30/month
- Plus storage and backups

**Comparison:**
- Supabase: Better for startups (free tier, integrated services)
- Self-hosted: Better for high scale (predictable costs)

---

## 11. Security Considerations

### Database Security

**Supabase:**
- SSL/TLS encryption (required)
- Network isolation (VPC)
- Automatic security updates
- RLS for data isolation

**Self-Hosted:**
- SSL/TLS configuration required
- Firewall rules
- Regular security updates
- VPN/private network

### Access Control

**Supabase:**
- Anon key: Client-side (respects RLS)
- Service role key: Backend (bypasses RLS)
- Row-Level Security: Database-level isolation

**Self-Hosted:**
- Application-level access control
- Database users and roles
- Connection string security

---

## 12. Monitoring & Observability

### Supabase Monitoring

**Dashboard:**
- Database size and growth
- Query performance
- Connection counts
- Storage usage

**Alerts:**
- Database size limits
- Connection limits
- Error rates

### Application Monitoring

**Metrics:**
- Query performance (SQLAlchemy logging)
- Connection pool usage
- Cache hit rates
- Error rates

**Tools:**
- Prometheus metrics (`agent_factory/monitoring/metrics.py`)
- Structured logging
- Health checks (`/health` endpoint)

---

## 13. Recommendations

### Immediate Actions

1. **✅ Use Supabase for Production**
   - Best fit for current needs
   - Free tier for development
   - Scales with growth

2. **✅ Configure Connection Pooling**
   - Use Supabase pooler (port 6543)
   - Set `SUPABASE_USE_POOLER=true`

3. **✅ Enable RLS Policies**
   - Apply `supabase/rls_policies.sql`
   - Test multi-tenant isolation

4. **✅ Set Up Backups**
   - Verify Supabase automatic backups
   - Document manual backup process

### Short-Term Improvements

5. Add database monitoring dashboards
6. Implement query performance monitoring
7. Add database health checks to `/health` endpoint
8. Document rollback procedures

### Long-Term Considerations

9. Evaluate read replicas (when needed)
10. Consider database branching for testing
11. Plan for sharding (if scale requires)

---

## Conclusion

**Canonical Backend:** **Supabase** (PostgreSQL)

**Why:**
- Managed Postgres with minimal ops overhead
- Integrated Auth, Storage, RLS
- Cost-effective (free tier → $25/month)
- Production-ready with connection pooling
- Scales from prototype to production

**When to Consider Alternatives:**
- Very high scale (> 100K users)
- Specific compliance requirements
- Need for custom Postgres extensions
- Cost optimization at scale

**Next Steps:**
1. Set up Supabase project (if not done)
2. Apply migrations
3. Configure RLS policies
4. Set up CI migration workflow
5. Document backup/restore procedures
