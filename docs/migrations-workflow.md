# Database Migrations Workflow

**Last Updated:** 2024-01-01  
**Migration Framework:** Alembic  
**Database:** PostgreSQL (production), SQLite (development)

---

## Overview

Agent Factory uses **Alembic** for database schema migrations. Migrations are versioned, reversible, and can be applied to both local development and production databases.

**Key Principles:**
- ✅ Migrations are **idempotent** (safe to run multiple times)
- ✅ Migrations are **reversible** (can downgrade if needed)
- ✅ Migrations match **SQLAlchemy models** exactly
- ✅ Production migrations require **confirmation**

---

## Quick Start

### Local Development

```bash
# Upgrade to latest migration
./scripts/db-migrate-local.sh upgrade

# Check current revision
./scripts/db-migrate-local.sh current

# View migration history
./scripts/db-migrate-local.sh history
```

### Production

```bash
# Upgrade to latest (requires confirmation)
./scripts/db-migrate-prod.sh upgrade

# Check current revision
./scripts/db-migrate-prod.sh current
```

---

## Migration Structure

### Current Migrations

1. **`001_initial_migration.py`** - Base schema (users, tenants, agents, workflows, blueprints, executions, audit_logs, api_keys)
2. **`002_master_schema.py`** - Complete schema consolidation (adds projects, plans, subscriptions, usage_records, fixes inconsistencies)

### Migration Files Location

- **Directory:** `alembic/versions/`
- **Config:** `alembic.ini`
- **Environment:** `alembic/env.py`

---

## Common Tasks

### 1. Running Migrations Locally

**Prerequisites:**
- PostgreSQL running locally, OR
- SQLite database file (development only)

**Steps:**

1. **Set up environment:**
   ```bash
   # Copy .env.example to .env
   cp .env.example .env
   
   # Edit .env and set DATABASE_URL
   # For PostgreSQL:
   DATABASE_URL=postgresql://user:password@localhost:5432/agentfactory
   
   # For SQLite (dev only):
   DATABASE_URL=sqlite:///./agent_factory.db
   ```

2. **Run migrations:**
   ```bash
   # Upgrade to latest
   ./scripts/db-migrate-local.sh upgrade
   
   # Or use alembic directly
   alembic upgrade head
   ```

3. **Verify:**
   ```bash
   # Check current revision
   ./scripts/db-migrate-local.sh current
   
   # Should show: 002 (head)
   ```

---

### 2. Running Migrations in Production

**Prerequisites:**
- `DATABASE_URL` environment variable set
- Database credentials configured
- Backup taken (recommended)

**Steps:**

1. **Set environment variable:**
   ```bash
   export DATABASE_URL=postgresql://user:password@host:5432/dbname
   ```

2. **Check current state:**
   ```bash
   ./scripts/db-migrate-prod.sh current
   ```

3. **Run migration:**
   ```bash
   # This will show migration plan and require confirmation
   ./scripts/db-migrate-prod.sh upgrade
   ```

4. **Verify:**
   ```bash
   ./scripts/db-migrate-prod.sh current
   ```

**⚠️ Important:** Always backup your production database before running migrations!

---

### 3. Creating a New Migration

**When to create:**
- Adding a new table
- Modifying existing table structure
- Adding/removing columns
- Creating indexes
- Adding constraints

**Steps:**

1. **Modify SQLAlchemy models:**
   ```python
   # Edit agent_factory/database/models.py
   class NewTable(Base):
       __tablename__ = "new_table"
       # ... define columns
   ```

2. **Generate migration:**
   ```bash
   # Auto-generate migration from model changes
   ./scripts/db-migrate-local.sh create "add new_table"
   
   # Or manually:
   alembic revision --autogenerate -m "add new_table"
   ```

3. **Review generated migration:**
   ```bash
   # Check the new file in alembic/versions/
   # Edit if needed to customize behavior
   ```

4. **Test migration:**
   ```bash
   # Test upgrade
   ./scripts/db-migrate-local.sh upgrade
   
   # Test downgrade
   ./scripts/db-migrate-local.sh downgrade -1
   
   # Test upgrade again
   ./scripts/db-migrate-local.sh upgrade
   ```

5. **Commit:**
   ```bash
   git add alembic/versions/XXX_add_new_table.py
   git commit -m "Add migration: add new_table"
   ```

---

### 4. Rolling Back a Migration

**⚠️ Warning:** Rolling back production migrations can cause data loss. Always backup first!

**Steps:**

1. **Check current revision:**
   ```bash
   ./scripts/db-migrate-local.sh current
   ```

2. **Downgrade:**
   ```bash
   # Downgrade one revision
   ./scripts/db-migrate-local.sh downgrade -1
   
   # Downgrade to specific revision
   ./scripts/db-migrate-local.sh downgrade 001
   ```

3. **Verify:**
   ```bash
   ./scripts/db-migrate-local.sh current
   ```

---

## Migration Scripts

### `scripts/db-migrate-local.sh`

**Purpose:** Run migrations in local development environment

**Usage:**
```bash
./scripts/db-migrate-local.sh [command] [options]
```

**Commands:**
- `upgrade [revision]` - Upgrade to revision (default: head)
- `downgrade <revision>` - Downgrade to revision
- `current` - Show current revision
- `history` - Show migration history
- `create <message>` - Create new migration

**Examples:**
```bash
./scripts/db-migrate-local.sh upgrade
./scripts/db-migrate-local.sh downgrade -1
./scripts/db-migrate-local.sh current
./scripts/db-migrate-local.sh create "add users table"
```

---

### `scripts/db-migrate-prod.sh`

**Purpose:** Run migrations in production (with safety checks)

**Usage:**
```bash
./scripts/db-migrate-prod.sh [command] [options]
```

**Commands:**
- `upgrade [revision]` - Upgrade to revision (requires confirmation)
- `downgrade <revision>` - Downgrade to revision (requires confirmation)
- `current` - Show current revision
- `history` - Show migration history

**Safety Features:**
- ✅ Requires explicit confirmation before running
- ✅ Shows migration plan before execution
- ✅ Displays current revision before and after
- ✅ Warns if DATABASE_URL looks like localhost

**Examples:**
```bash
./scripts/db-migrate-prod.sh upgrade
./scripts/db-migrate-prod.sh current
```

---

## Manual Alembic Commands

If you prefer using Alembic directly:

```bash
# Upgrade to latest
alembic upgrade head

# Upgrade to specific revision
alembic upgrade 002

# Downgrade one revision
alembic downgrade -1

# Downgrade to specific revision
alembic downgrade 001

# Show current revision
alembic current

# Show migration history
alembic history

# Create new migration (auto-generate)
alembic revision --autogenerate -m "migration message"

# Create new migration (manual)
alembic revision -m "migration message"
```

---

## Database Setup

### Local Development (PostgreSQL)

1. **Install PostgreSQL:**
   ```bash
   # macOS
   brew install postgresql
   brew services start postgresql
   
   # Ubuntu/Debian
   sudo apt-get install postgresql postgresql-contrib
   sudo systemctl start postgresql
   ```

2. **Create database:**
   ```bash
   createdb agentfactory
   # Or via psql:
   psql -c "CREATE DATABASE agentfactory;"
   ```

3. **Set DATABASE_URL:**
   ```bash
   # In .env file:
   DATABASE_URL=postgresql://$(whoami)@localhost:5432/agentfactory
   ```

4. **Run migrations:**
   ```bash
   ./scripts/db-migrate-local.sh upgrade
   ```

---

### Local Development (SQLite)

1. **Set DATABASE_URL:**
   ```bash
   # In .env file:
   DATABASE_URL=sqlite:///./agent_factory.db
   ```

2. **Run migrations:**
   ```bash
   ./scripts/db-migrate-local.sh upgrade
   ```

**Note:** SQLite is for development only. Production should use PostgreSQL.

---

### Production (Supabase)

1. **Create Supabase project:**
   - Go to https://supabase.com
   - Create new project
   - Wait for database to be provisioned

2. **Get connection string:**
   - Go to Project Settings → Database
   - Copy "Connection string" (URI format)
   - Format: `postgresql://postgres:[PASSWORD]@db.[PROJECT-REF].supabase.co:5432/postgres`

3. **Set environment variables:**
   ```bash
   export DATABASE_URL=postgresql://postgres:[PASSWORD]@db.[PROJECT-REF].supabase.co:5432/postgres
   export SUPABASE_URL=https://[PROJECT-REF].supabase.co
   export SUPABASE_ANON_KEY=your-anon-key
   export SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
   ```

4. **Run migrations:**
   ```bash
   ./scripts/db-migrate-prod.sh upgrade
   ```

See `docs/backend-options-and-costs.md` for more Supabase setup details.

---

### Production (Managed PostgreSQL)

**Examples:** DigitalOcean, Railway, Neon, Render

1. **Create database instance:**
   - Follow provider's documentation
   - Note connection details

2. **Set DATABASE_URL:**
   ```bash
   export DATABASE_URL=postgresql://user:password@host:5432/dbname
   ```

3. **Run migrations:**
   ```bash
   ./scripts/db-migrate-prod.sh upgrade
   ```

---

## Troubleshooting

### Migration Fails

**Error:** `Target database is not up to date`

**Solution:**
```bash
# Check current revision
alembic current

# Upgrade to head
alembic upgrade head
```

---

### Migration Conflicts

**Error:** `Multiple heads detected`

**Solution:**
```bash
# Merge heads
alembic merge -m "merge heads" head1 head2

# Then upgrade
alembic upgrade head
```

---

### Database Connection Error

**Error:** `could not connect to server`

**Solution:**
1. Check `DATABASE_URL` is set correctly
2. Verify database server is running
3. Check firewall/network settings
4. Verify credentials

```bash
# Test connection
psql $DATABASE_URL -c "SELECT 1;"
```

---

### Column Already Exists

**Error:** `column already exists`

**Solution:**
Migration is trying to add a column that already exists. This can happen if:
- Migration was partially applied
- Manual schema changes were made

**Fix:**
1. Check current schema:
   ```bash
   psql $DATABASE_URL -c "\d table_name"
   ```

2. Edit migration to check if column exists before adding:
   ```python
   # In migration file:
   columns = [col['name'] for col in inspector.get_columns('table_name')]
   if 'column_name' not in columns:
       op.add_column('table_name', sa.Column('column_name', ...))
   ```

---

## Best Practices

### ✅ Do

- **Always backup** production database before migrations
- **Test migrations** locally before production
- **Review auto-generated migrations** before committing
- **Use descriptive migration messages**
- **Keep migrations small** and focused
- **Test both upgrade and downgrade** paths

### ❌ Don't

- **Don't edit applied migrations** (create new ones instead)
- **Don't run migrations directly** on production without testing
- **Don't skip migrations** (apply in order)
- **Don't mix manual schema changes** with migrations
- **Don't commit migrations** with hardcoded credentials

---

## Migration Checklist

Before deploying a migration to production:

- [ ] Migration tested locally
- [ ] Migration tested on staging (if available)
- [ ] Backup taken of production database
- [ ] Migration reviewed for data safety
- [ ] Rollback plan prepared
- [ ] Team notified of migration
- [ ] Monitoring set up for migration
- [ ] Migration applied during low-traffic period (if possible)

---

## Additional Resources

- **Alembic Documentation:** https://alembic.sqlalchemy.org/
- **SQLAlchemy Documentation:** https://docs.sqlalchemy.org/
- **Backend Options:** `docs/backend-options-and-costs.md`
- **Data Model:** `docs/data-model-overview.md`
- **Backend Discovery:** `docs/backend-discovery.md`

---

## Getting Help

If you encounter issues:

1. Check migration history: `alembic history`
2. Check current revision: `alembic current`
3. Review migration files in `alembic/versions/`
4. Check database schema: `psql $DATABASE_URL -c "\dt"`
5. Review logs for error messages

For production issues, always have a rollback plan ready!
