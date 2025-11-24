# CI/CD Overview

**Last Updated:** 2024-01-XX  
**Purpose:** Complete guide to CI/CD workflows, required checks, and deployment processes

---

## Executive Summary

**Total Workflows:** 5  
**Required Checks:** Test, Lint, Security, Build  
**Deployment:** Manual (automation to be added)

**Status:**
- ✅ Code quality checks (test, lint, security)
- ✅ Migration workflow (new)
- ❌ Deployment automation (to be added)
- ❌ Preview deployments (to be added)

---

## 1. Workflow Inventory

### 1.1 CI Pipeline (`ci.yml`)

**Purpose:** Main continuous integration pipeline

**Triggers:**
- Push to `main`, `develop`
- Pull requests to `main`, `develop`

**Jobs:**
1. **test** - Run test suite (Python 3.8-3.12 matrix)
2. **lint** - Code quality (Ruff, Black, MyPy)
3. **security** - Security scans (Safety, Bandit, detect-secrets)
4. **build** - Build Python package

**Status:** ✅ Active

**Required for:** Main branch protection

---

### 1.2 Database Migrations (`db-migrate.yml`)

**Purpose:** Automated database migrations

**Triggers:**
- Push to `main` (when migrations change)
- Manual dispatch (`workflow_dispatch`)

**Jobs:**
1. **validate-migrations** - Validate migration syntax
2. **apply-migrations** - Apply migrations to production
3. **dry-run-migrations** - Preview migrations (manual)

**Status:** ✅ Active (newly created)

**Required for:** Database schema changes

**Secrets Required:**
- `DATABASE_URL` - Production database connection

---

### 1.3 Maintenance (`maintenance.yml`)

**Purpose:** Weekly maintenance tasks

**Triggers:**
- Weekly schedule (Monday 2 AM UTC)
- Manual dispatch

**Jobs:**
1. **dependency-check** - Check for outdated packages
2. **stale-issues** - Mark stale issues
3. **code-quality** - Extended quality checks

**Status:** ✅ Active

**Required for:** Maintenance

---

### 1.4 Nightly Tests (`nightly.yml`)

**Purpose:** Integration tests with services

**Triggers:**
- Daily schedule (2 AM UTC)
- Manual dispatch

**Jobs:**
1. **test-integration** - Integration tests (Postgres + Redis)
2. **security** - Security scans

**Status:** ✅ Active

**Required for:** Integration testing

---

### 1.5 Extended Nightly Tests (`nightly-tests.yml`)

**Purpose:** Extended test suite

**Triggers:**
- Daily schedule (3 AM UTC)
- Manual dispatch

**Jobs:**
1. **test** - Full test matrix (3.8-3.12)
2. **slow** - Slow tests

**Status:** ✅ Active (may be redundant with `nightly.yml`)

**Recommendation:** Consider consolidating with `nightly.yml`

---

## 2. Required Checks for Main Branch

### Branch Protection Rules

**Recommended Required Checks:**
- ✅ `test` (from `ci.yml`)
- ✅ `lint` (from `ci.yml`)
- ✅ `security` (from `ci.yml`)
- ✅ `build` (from `ci.yml`)
- ✅ `validate-migrations` (from `db-migrate.yml`)

**Optional Checks:**
- `test-integration` (from `nightly.yml`) - Can be non-blocking
- `dependency-check` (from `maintenance.yml`) - Non-blocking

**How to Configure:**
1. Go to Repository → Settings → Branches
2. Add rule for `main` branch
3. Require status checks
4. Select checks above

---

## 3. Workflow Details

### 3.1 Test Job

**Matrix:** Python 3.8, 3.9, 3.10, 3.11, 3.12

**Commands:**
```bash
pytest tests/ -v --cov=agent_factory --cov-report=xml
```

**Coverage:** Uploaded to Codecov

**Duration:** ~5-10 minutes

---

### 3.2 Lint Job

**Python:** 3.11

**Commands:**
```bash
ruff check agent_factory/ tests/
black --check agent_factory/ tests/
mypy agent_factory/
```

**Duration:** ~2-3 minutes

---

### 3.3 Security Job

**Python:** 3.11

**Commands:**
```bash
safety check
bandit -r agent_factory/ -f json -o bandit-report.json
detect-secrets scan --baseline .secrets.baseline
```

**Duration:** ~3-5 minutes

---

### 3.4 Build Job

**Dependencies:** test, lint, security

**Commands:**
```bash
python -m build
```

**Artifacts:** `dist/` directory

**Duration:** ~1-2 minutes

---

### 3.5 Migration Job

**Dependencies:** validate-migrations

**Commands:**
```bash
alembic upgrade head
python scripts/db-validate-schema.py
```

**Secrets:** `DATABASE_URL`

**Duration:** ~1-2 minutes

**Safety:**
- Only runs on `main` branch
- Validates before applying
- Shows migration plan

---

## 4. Deployment Workflows

### Current Status: ❌ Not Automated

**Manual Deployment Process:**
1. Merge PR to `main`
2. CI runs (test, lint, security, build)
3. Migrations run automatically (if `db-migrate.yml` configured)
4. Manual deployment to hosting platform

**To Be Added:**
- `.github/workflows/deploy-production.yml`
- `.github/workflows/deploy-preview.yml`

---

## 5. Workflow Optimization

### Redundant Workflows

**Issue:** `nightly.yml` and `nightly-tests.yml` overlap

**Recommendation:** Consolidate into single `nightly.yml`

**Proposed Structure:**
```yaml
jobs:
  test-integration:
    # Integration tests
  test-full-matrix:
    # Full test matrix
  test-slow:
    # Slow tests
  security:
    # Security scans
```

---

### Workflow Performance

**Current Durations:**
- CI Pipeline: ~10-15 minutes
- Migrations: ~2-3 minutes
- Nightly: ~15-20 minutes

**Optimization Opportunities:**
1. Parallelize test jobs
2. Cache dependencies
3. Use matrix strategies efficiently

---

## 6. Secrets Management

### Required Secrets

**GitHub Secrets:**
- `DATABASE_URL` - Production database (for migrations)
- `OPENAI_API_KEY` - Optional (for tests)
- `ANTHROPIC_API_KEY` - Optional (for tests)

**How to Add:**
1. Repository → Settings → Secrets and variables → Actions
2. Click "New repository secret"
3. Add name and value

**Usage:**
```yaml
env:
  DATABASE_URL: ${{ secrets.DATABASE_URL }}
```

---

## 7. Workflow Triggers

### Push Events

**Branches:**
- `main` - Triggers CI + migrations
- `develop` - Triggers CI only

**Paths:**
- Migrations trigger on `alembic/versions/**` changes
- CI triggers on all code changes

---

### Pull Request Events

**Branches:**
- PRs to `main`, `develop`

**Checks:**
- Test, lint, security, build
- Migration validation (dry-run)

**No Migrations Applied:** Migrations only run on `main` merge

---

### Scheduled Events

**Maintenance:**
- Weekly (Monday 2 AM UTC)

**Nightly:**
- Daily (2-3 AM UTC)

**Manual:**
- All workflows support `workflow_dispatch`

---

## 8. Failure Handling

### Test Failures

**Action:** Block merge, show error details

**Investigation:**
1. Check test logs
2. Reproduce locally
3. Fix and push

---

### Lint Failures

**Action:** Block merge, show violations

**Fix:**
```bash
ruff check --fix agent_factory/ tests/
black agent_factory/ tests/
```

---

### Security Failures

**Action:** Block merge, create issue (if critical)

**Investigation:**
1. Review security report
2. Update dependencies if needed
3. Address vulnerabilities

---

### Migration Failures

**Action:** Block deployment, alert team

**Investigation:**
1. Check migration SQL
2. Test locally
3. Fix migration
4. Re-run workflow

---

## 9. Monitoring & Alerts

### Workflow Status

**GitHub Actions:**
- Dashboard shows all workflow runs
- Status badges available
- Email notifications (if configured)

**Monitoring:**
- Track workflow success rates
- Monitor duration trends
- Alert on failures

---

## 10. Best Practices

### 1. Keep Workflows Fast

- Use caching
- Parallelize jobs
- Skip unnecessary checks

### 2. Fail Fast

- Run quick checks first
- Don't run expensive tests if lint fails

### 3. Clear Error Messages

- Use descriptive job names
- Provide actionable error messages
- Link to documentation

### 4. Security First

- Never expose secrets in logs
- Use GitHub Secrets
- Rotate secrets regularly

### 5. Test Locally First

- Run checks locally before pushing
- Use same Python version as CI
- Match CI environment

---

## 11. Future Improvements

### Short-Term

1. **Add Deployment Workflows**
   - Production deployment on `main`
   - Preview deployments on PRs

2. **Add Smoke Tests**
   - Post-deployment health checks
   - API endpoint validation

3. **Consolidate Nightly Workflows**
   - Merge `nightly.yml` and `nightly-tests.yml`

### Medium-Term

4. **Multi-Environment Pipeline**
   - Dev → Staging → Production

5. **Performance Testing**
   - Load tests in CI
   - Performance regression detection

6. **E2E Tests**
   - Full API integration tests
   - User flow validation

### Long-Term

7. **Advanced Observability**
   - CI metrics dashboard
   - Failure trend analysis

8. **Automated Rollback**
   - Detect deployment issues
   - Automatic rollback

---

## 12. Quick Reference

### Run Checks Locally

```bash
# Tests
pytest tests/ -v

# Lint
ruff check agent_factory/ tests/
black --check agent_factory/ tests/
mypy agent_factory/

# Security
safety check
bandit -r agent_factory/
```

### Trigger Workflows Manually

1. Go to Actions tab
2. Select workflow
3. Click "Run workflow"
4. Select branch
5. Run

### Check Workflow Status

```bash
# GitHub CLI
gh run list
gh run view [run-id]
```

---

## Conclusion

**Current State:**
- ✅ Comprehensive CI pipeline
- ✅ Migration automation
- ✅ Security scanning
- ❌ Deployment automation (to be added)

**Next Steps:**
1. Add deployment workflows
2. Add smoke tests
3. Consolidate redundant workflows
4. Set up branch protection rules

**Required Checks for Main:**
- test
- lint
- security
- build
- validate-migrations
