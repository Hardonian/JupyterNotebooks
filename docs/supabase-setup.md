# Supabase Setup Guide

**Last Updated:** 2024-01-01  
**Purpose:** Complete guide for setting up Agent Factory with Supabase

---

## Overview

This guide walks you through setting up Agent Factory with Supabase as the backend. Supabase provides PostgreSQL database, authentication, storage, and more in a single platform.

**Why Supabase?**
- ✅ Managed PostgreSQL database
- ✅ Built-in authentication (JWT, email verification)
- ✅ Row-Level Security (RLS) for multi-tenancy
- ✅ Storage for files (knowledge packs, blueprints)
- ✅ Real-time subscriptions
- ✅ Edge functions
- ✅ Beautiful admin dashboard

---

## Prerequisites

- Supabase account (free tier available)
- Python 3.8+ installed
- Basic familiarity with environment variables

---

## Step 1: Create Supabase Project

1. **Sign up / Log in:**
   - Go to https://supabase.com
   - Sign up or log in to your account

2. **Create New Project:**
   - Click "New Project"
   - Choose your organization
   - Fill in project details:
     - **Name:** `agent-factory` (or your preferred name)
     - **Database Password:** Choose a strong password (save this!)
     - **Region:** Choose closest to your users
     - **Pricing Plan:** Free tier is fine to start

3. **Wait for Provisioning:**
   - Supabase will provision your database (takes 1-2 minutes)
   - You'll see a loading screen, then the project dashboard

---

## Step 2: Get Connection Details

Once your project is ready:

1. **Go to Project Settings:**
   - Click the gear icon (⚙️) in the left sidebar
   - Select "Database"

2. **Get Database Connection String:**
   - Scroll to "Connection string"
   - Select "URI" format
   - Copy the connection string
   - Format: `postgresql://postgres.[PROJECT-REF]:[PASSWORD]@aws-0-[REGION].pooler.supabase.com:6543/postgres`
   - **Note:** Use the **pooled connection** (port 6543) for production

3. **Get API Keys:**
   - Go to "API Settings" (still in Project Settings)
   - Copy:
     - **Project URL:** `https://[PROJECT-REF].supabase.co`
     - **anon/public key:** Starts with `eyJ...`
     - **service_role key:** Starts with `eyJ...` (keep this secret!)

---

## Step 3: Configure Environment Variables

1. **Copy `.env.example` to `.env`:**
   ```bash
   cp .env.example .env
   ```

2. **Edit `.env` and add Supabase configuration:**
   ```bash
   # Database (use pooled connection for production)
   DATABASE_URL=postgresql://postgres.[PROJECT-REF]:[YOUR-PASSWORD]@aws-0-[REGION].pooler.supabase.com:6543/postgres
   
   # Supabase Configuration
   SUPABASE_URL=https://[PROJECT-REF].supabase.co
   SUPABASE_ANON_KEY=your-anon-key-here
   SUPABASE_SERVICE_ROLE_KEY=your-service-role-key-here
   
   # Use Supabase connection pooler (recommended)
   SUPABASE_USE_POOLER=true
   
   # Storage (use Supabase Storage)
   STORAGE_TYPE=supabase
   SUPABASE_STORAGE_BUCKET=agent-factory
   ```

3. **Replace placeholders:**
   - `[PROJECT-REF]` - Your project reference ID
   - `[YOUR-PASSWORD]` - Your database password
   - `[REGION]` - Your region (e.g., `us-east-1`)
   - `your-anon-key-here` - Your anon/public key
   - `your-service-role-key-here` - Your service role key

**Example:**
```bash
DATABASE_URL=postgresql://postgres.abcdefghijklmnop:MySecurePassword123@aws-0-us-east-1.pooler.supabase.com:6543/postgres
SUPABASE_URL=https://abcdefghijklmnop.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

---

## Step 4: Install Dependencies

```bash
# Install Agent Factory with dependencies
pip install -e .

# Or if you have a requirements.txt
pip install -r requirements.txt
```

**Verify Supabase package is installed:**
```bash
pip show supabase
```

---

## Step 5: Run Database Migrations

1. **Check current migration status:**
   ```bash
   ./scripts/db-migrate-local.sh current
   ```

2. **Run migrations:**
   ```bash
   ./scripts/db-migrate-local.sh upgrade
   ```

3. **Verify:**
   ```bash
   ./scripts/db-migrate-local.sh current
   # Should show: 002 (head)
   ```

**Alternative (using Alembic directly):**
```bash
alembic upgrade head
```

---

## Step 6: Set Up Storage Bucket

1. **Go to Storage in Supabase Dashboard:**
   - Click "Storage" in the left sidebar
   - Click "New bucket"

2. **Create Bucket:**
   - **Name:** `agent-factory`
   - **Public bucket:** ✅ Checked (for public file access)
   - Click "Create bucket"

3. **Configure Bucket Policies (Optional):**
   - Go to "Policies" tab
   - Add policies for file access (or use default public access)

**Note:** The bucket name should match `SUPABASE_STORAGE_BUCKET` in your `.env`.

---

## Step 7: Set Up Row-Level Security (RLS) Policies

RLS policies enforce multi-tenant data isolation at the database level.

1. **Open SQL Editor:**
   - Click "SQL Editor" in the left sidebar
   - Click "New query"

2. **Apply RLS Policies:**
   - Copy the contents of `supabase/rls_policies.sql`
   - Paste into SQL Editor
   - Click "Run" (or press Ctrl+Enter)

3. **Verify Policies:**
   - Go to "Authentication" → "Policies"
   - You should see policies for each table

**Important Notes:**
- These policies assume Supabase Auth is being used
- User IDs in your `users` table must match Supabase auth user IDs
- Use `service_role` key for backend operations that need to bypass RLS
- Use `anon` key for client-side operations that should respect RLS

---

## Step 8: Test Connection

1. **Test Database Connection:**
   ```bash
   python -c "from agent_factory.database.session import get_db; next(get_db()); print('✓ Database connected')"
   ```

2. **Test Supabase Client:**
   ```bash
   python -c "from agent_factory.database.supabase_client import is_supabase_configured; print('✓ Supabase configured' if is_supabase_configured() else '✗ Supabase not configured')"
   ```

3. **Test Storage:**
   ```bash
   python -c "from agent_factory.storage import get_storage_backend; storage = get_storage_backend('supabase'); print('✓ Storage configured')"
   ```

---

## Step 9: Verify Setup

1. **Check Tables Exist:**
   - Go to "Table Editor" in Supabase Dashboard
   - You should see all 12 tables:
     - tenants, users, agents, workflows, blueprints
     - executions, audit_logs, api_keys
     - projects, plans, subscriptions, usage_records

2. **Test API:**
   ```bash
   # Start the API server
   uvicorn agent_factory.api.main:app --reload
   
   # In another terminal, test health endpoint
   curl http://localhost:8000/health
   ```

---

## Configuration Options

### Connection Pooling

Supabase provides two connection options:

1. **Direct Connection (port 5432):**
   - Full PostgreSQL features
   - Use for migrations, admin operations
   - Format: `postgresql://...@db.[PROJECT-REF].supabase.co:5432/postgres`

2. **Pooled Connection (port 6543) - Recommended:**
   - Better for production (handles many connections)
   - Use for application connections
   - Format: `postgresql://...@aws-0-[REGION].pooler.supabase.com:6543/postgres`

**Agent Factory automatically uses pooled connections when `SUPABASE_USE_POOLER=true`.**

### Storage Configuration

**Use Supabase Storage:**
```bash
STORAGE_TYPE=supabase
SUPABASE_STORAGE_BUCKET=agent-factory
```

**Use Local Storage (development):**
```bash
STORAGE_TYPE=local
STORAGE_PATH=./storage
```

**Use S3 (alternative):**
```bash
STORAGE_TYPE=s3
AWS_S3_BUCKET=your-bucket-name
AWS_ACCESS_KEY_ID=your-key
AWS_SECRET_ACCESS_KEY=your-secret
```

---

## Troubleshooting

### Connection Errors

**Error:** `could not connect to server`

**Solutions:**
1. Check `DATABASE_URL` is correct
2. Verify password is correct (no special characters need URL encoding)
3. Check if you're using the right port (5432 for direct, 6543 for pooled)
4. Verify your IP is allowed (Supabase allows all IPs by default)

### SSL Errors

**Error:** `SSL connection required`

**Solution:** Supabase requires SSL. The connection string should include SSL parameters, or set `sslmode=require` in connection args (already handled in code).

### Migration Errors

**Error:** `relation already exists`

**Solution:** Tables might already exist. Check current migration status:
```bash
./scripts/db-migrate-local.sh current
```

If migration is partially applied, you may need to manually fix or reset.

### Storage Errors

**Error:** `Failed to get Supabase storage bucket`

**Solutions:**
1. Verify bucket exists in Supabase Dashboard
2. Check `SUPABASE_STORAGE_BUCKET` matches bucket name
3. Verify `SUPABASE_SERVICE_ROLE_KEY` is set (required for storage operations)

---

## Production Checklist

Before deploying to production:

- [ ] Use **pooled connection** (port 6543) for `DATABASE_URL`
- [ ] Set `SUPABASE_USE_POOLER=true`
- [ ] Use **service_role key** for backend operations
- [ ] Use **anon key** for client-side operations
- [ ] RLS policies are applied
- [ ] Storage bucket is created and configured
- [ ] Database password is strong and secure
- [ ] Environment variables are set securely (not in code)
- [ ] Backups are enabled (Supabase Pro+)
- [ ] Monitoring is set up

---

## Next Steps

1. **Set up Authentication:**
   - See `docs/` for auth integration guides
   - Configure Supabase Auth providers (email, OAuth, etc.)

2. **Configure RLS Policies:**
   - Review `supabase/rls_policies.sql`
   - Customize policies for your use case

3. **Set up Storage:**
   - Create additional buckets if needed
   - Configure CORS for web access

4. **Deploy:**
   - See `docs/DEPLOYMENT.md` for deployment guides
   - Set environment variables in your hosting platform

---

## Additional Resources

- **Supabase Documentation:** https://supabase.com/docs
- **Supabase Python Client:** https://github.com/supabase/supabase-py
- **Row-Level Security Guide:** https://supabase.com/docs/guides/auth/row-level-security
- **Storage Guide:** https://supabase.com/docs/guides/storage

---

## Support

If you encounter issues:

1. Check Supabase Dashboard logs
2. Review migration status
3. Verify environment variables
4. Check Supabase status page: https://status.supabase.com
5. Review `docs/migrations-workflow.md` for migration help

---

**You're all set!** Your Agent Factory platform is now configured with Supabase. 🎉
