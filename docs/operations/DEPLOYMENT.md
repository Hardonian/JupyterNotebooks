# Deployment Runbook

**Last Updated:** 2024-01-XX  
**Purpose:** Standardized procedures for deploying Agent Factory platform

---

## Overview

This runbook provides step-by-step procedures for deploying the Agent Factory platform to preview and production environments.

**Deployment Types:**
- **Preview:** Automatic on PRs (Vercel Preview)
- **Production:** Automatic on main branch (Vercel Production)
- **Manual:** Via workflow_dispatch

---

## Pre-Deployment Checklist

### Code Quality
- [ ] All tests passing (`pytest tests/`)
- [ ] Lint checks passing (`ruff check`, `black --check`, `mypy`)
- [ ] Security scans passing (`safety check`, `bandit`)
- [ ] No critical issues in code review

### Database
- [ ] Migrations reviewed and tested
- [ ] Migration script validated (`scripts/test-deployment-workflows.sh`)
- [ ] Schema validation script ready (`scripts/db-validate-schema.py`)
- [ ] Backup created (for production)

### Configuration
- [ ] Environment variables updated (if needed)
- [ ] Secrets configured in GitHub/Vercel
- [ ] Feature flags reviewed
- [ ] Rate limits reviewed

### Documentation
- [ ] Changelog updated
- [ ] API documentation updated (if API changes)
- [ ] Breaking changes documented

---

## Preview Deployment

### Automatic (PR-based)

**Trigger:** Pull request to `main` branch

**Process:**
1. PR created → Preview deployment workflow triggers
2. Build and test run (non-blocking)
3. Vercel preview deployment
4. Smoke tests run
5. Preview URL commented on PR

**Verification:**
```bash
# Check preview URL from PR comment
# Run smoke tests manually
./scripts/smoke-tests.sh preview https://[preview-url].vercel.app
```

**Rollback:**
- Close PR or revert commit
- Preview automatically cleaned up

---

### Manual Preview Deployment

**Via GitHub Actions:**
1. Go to Actions → Deploy Vercel Preview
2. Click "Run workflow"
3. Select branch
4. Run workflow

**Via Vercel CLI:**
```bash
# Install Vercel CLI
npm install -g vercel

# Login
vercel login

# Deploy preview
vercel --preview
```

---

## Production Deployment

### Automatic (Main Branch)

**Trigger:** Push to `main` branch

**Process:**
1. Push to main → Production deployment workflow triggers
2. Pre-deployment checks:
   - Tests run
   - Lint checks
   - Security scans
3. Database migrations run (if needed)
4. Vercel production deployment
5. Post-deployment smoke tests
6. Deployment summary posted

**Verification:**
```bash
# Check deployment status
# Run smoke tests
./scripts/smoke-tests.sh production https://api.agentfactory.io

# Check health endpoint
curl https://api.agentfactory.io/api/v1/health
```

---

### Manual Production Deployment

**Via GitHub Actions:**
1. Go to Actions → Deploy Vercel Production
2. Click "Run workflow"
3. Select `main` branch
4. Run workflow

**Via Vercel CLI:**
```bash
# Deploy to production
vercel --prod

# Or promote existing deployment
vercel promote [deployment-url]
```

---

## Database Migrations

### Pre-Migration

**Checklist:**
- [ ] Migration script reviewed
- [ ] Migration tested in staging
- [ ] Backup created
- [ ] Rollback plan prepared

**Create Backup:**
```bash
# Via Supabase dashboard or CLI
# Export database
pg_dump $DATABASE_URL > backup-$(date +%Y%m%d).sql
```

### Run Migrations

**Automatic (CI):**
- Migrations run automatically on main branch
- Validated before applying
- Schema validated after applying

**Manual:**
```bash
# Set database URL
export DATABASE_URL="postgresql://..."

# Check current revision
alembic current

# Show migration plan
alembic upgrade --sql head

# Apply migrations
alembic upgrade head

# Validate schema
python3 scripts/db-validate-schema.py
```

### Post-Migration

**Verification:**
- [ ] Schema validation passes
- [ ] Application starts successfully
- [ ] Key endpoints work
- [ ] No errors in logs

---

## Rollback Procedures

### Application Rollback

**Via Vercel Dashboard:**
1. Go to Vercel Dashboard → Deployments
2. Find last working deployment
3. Click "Promote to Production"

**Via Vercel CLI:**
```bash
# List deployments
vercel ls

# Rollback to specific deployment
vercel rollback [deployment-url]

# Or promote previous deployment
vercel promote [deployment-url]
```

**Via GitHub Actions:**
1. Revert commit on main branch
2. Push revert commit
3. Production deployment triggers automatically

### Database Rollback

**If Migration Failed:**
```bash
# Check current revision
alembic current

# Rollback to previous revision
alembic downgrade -1

# Or rollback to specific revision
alembic downgrade [revision-id]

# Restore from backup if needed
psql $DATABASE_URL < backup-YYYYMMDD.sql
```

**⚠️ Warning:** Database rollbacks can cause data loss. Always backup first.

---

## Smoke Tests

### Automated Smoke Tests

**Preview:**
- Runs automatically after preview deployment
- Tests health, root, docs endpoints
- Non-blocking (continue-on-error)

**Production:**
- Runs automatically after production deployment
- Comprehensive test suite
- Tracks pass/fail counts
- Non-blocking but reports results

### Manual Smoke Tests

**Run Script:**
```bash
# Preview
./scripts/smoke-tests.sh preview https://[preview-url].vercel.app

# Production
./scripts/smoke-tests.sh production https://api.agentfactory.io
```

**Manual Checks:**
```bash
# Health endpoint
curl https://api.agentfactory.io/api/v1/health

# Root endpoint
curl https://api.agentfactory.io/

# API docs
curl https://api.agentfactory.io/docs

# Agents endpoint
curl https://api.agentfactory.io/api/v1/agents/
```

---

## Post-Deployment

### Immediate (0-15 minutes)

**Actions:**
1. Verify smoke tests passed
2. Check health endpoint
3. Monitor error rates (Sentry)
4. Check deployment logs

**Monitoring:**
- Sentry dashboard for errors
- Vercel function logs
- Health endpoint status
- API response times

### Short-term (15 minutes - 1 hour)

**Actions:**
1. Monitor error rates
2. Check user reports
3. Review performance metrics
4. Verify key features work

**Metrics to Watch:**
- Error rate (should be < 0.1%)
- Response time (p95 should be < 500ms)
- Uptime (should be 100%)
- Database connection pool usage

### Long-term (1-24 hours)

**Actions:**
1. Review deployment metrics
2. Check for any issues
3. Update documentation if needed
4. Document lessons learned

---

## Troubleshooting

### Deployment Fails

**Check:**
1. Build logs in Vercel
2. GitHub Actions logs
3. Environment variables
4. Dependencies

**Common Issues:**
- Missing environment variables
- Build errors
- Dependency conflicts
- Configuration errors

**Resolution:**
1. Review error logs
2. Fix issues
3. Redeploy

### Smoke Tests Fail

**Check:**
1. Deployment URL correct
2. Service is up
3. Health endpoint accessible
4. Network connectivity

**Resolution:**
1. Wait for deployment to stabilize
2. Check service status
3. Review error messages
4. Re-run smoke tests

### Database Migration Fails

**Check:**
1. Migration script syntax
2. Database connection
3. Schema conflicts
4. Permissions

**Resolution:**
1. Review migration logs
2. Check database state
3. Fix migration script
4. Re-run migration (or rollback)

---

## Emergency Procedures

### Emergency Rollback

**If Production is Broken:**
1. **Immediate:** Rollback via Vercel dashboard
2. **Verify:** Check health endpoint
3. **Communicate:** Notify team in Slack
4. **Investigate:** Review what went wrong
5. **Fix:** Create hotfix
6. **Redeploy:** After fix is ready

### Emergency Deployment

**For Critical Fixes:**
1. Create hotfix branch
2. Implement fix
3. Test locally
4. Deploy to staging (if time permits)
5. Deploy to production
6. Monitor closely

---

## Best Practices

### Deployment Frequency
- **Preview:** As often as needed (every PR)
- **Production:** When ready (after review and testing)

### Deployment Windows
- **Preferred:** Business hours (easier to monitor)
- **Avoid:** Friday afternoons (unless critical)
- **Emergency:** Anytime if critical

### Communication
- Announce major deployments
- Update status during deployment
- Post deployment summary
- Document any issues

### Testing
- Always test in preview first
- Run smoke tests after deployment
- Monitor error rates
- Verify key features

---

## Tools & Resources

### Scripts
- `scripts/smoke-tests.sh` - Smoke test script
- `scripts/test-deployment-workflows.sh` - Workflow validation
- `scripts/db-validate-schema.py` - Schema validation
- `scripts/db-seed-demo.py` - Seed data (if needed)

### Documentation
- [Deployment Strategy](../deploy-strategy.md)
- [CI/CD Overview](../ci-overview.md)
- [Troubleshooting Guide](../TROUBLESHOOTING.md)

### Dashboards
- Vercel Dashboard
- GitHub Actions
- Sentry
- Supabase Dashboard

---

## Review & Updates

**Review Frequency:** Monthly  
**Last Reviewed:** [Date]  
**Next Review:** [Date]

**Update Triggers:**
- When deployment process changes
- When new tools are added
- After deployment issues
- Monthly review cycle

---

## Appendix: Quick Reference

### Deployment Commands
```bash
# Preview deployment
vercel --preview

# Production deployment
vercel --prod

# Rollback
vercel rollback [deployment-url]

# Promote deployment
vercel promote [deployment-url]
```

### Migration Commands
```bash
# Check current revision
alembic current

# Show migration plan
alembic upgrade --sql head

# Apply migrations
alembic upgrade head

# Rollback migration
alembic downgrade -1
```

### Verification Commands
```bash
# Health check
curl https://api.agentfactory.io/api/v1/health

# Smoke tests
./scripts/smoke-tests.sh production https://api.agentfactory.io

# Schema validation
python3 scripts/db-validate-schema.py
```

---

**Remember:** Test in preview first, monitor after deployment, and always have a rollback plan.
