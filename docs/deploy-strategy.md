# Deployment Strategy

**Last Updated:** 2024-01-XX  
**Status:** Active  
**Purpose:** Canonical deployment strategy for Preview and Production environments

---

## Executive Summary

**Primary Host:** **Vercel** (for demo app)  
**Secondary Hosts:** Render, Docker, Kubernetes (for API backend)

**Deployment Targets:**
- **Preview:** Vercel Preview deployments for PRs
- **Production:** Vercel Production deployments for main branch

**Deployment Method:** GitHub Actions workflows

---

## 1. Deployment Architecture

### 1.1 Application Structure

**Demo App:** `apps/research_assistant_app/main.py`
- FastAPI application
- Serves HTML UI + REST API
- Deployed to Vercel

**Backend API:** `agent_factory/api/main.py`
- Core API platform
- Deployed to Render/Docker/K8s (not Vercel)

**This Strategy:** Focuses on **Vercel deployments** for the demo app.

---

## 2. Preview Deployments

### 2.1 Trigger

**Workflow:** `.github/workflows/deploy-vercel-preview.yml`

**Triggers:**
- Pull requests to `main` branch
- Types: `opened`, `synchronize`, `reopened`
- Manual dispatch (`workflow_dispatch`)

**Branch Filters:**
- Target branch: `main` only
- Source branch: Any (all PRs)

### 2.2 Process

1. **Checkout code** (PR branch)
2. **Run build/test/lint** (optional, can be skipped for speed)
3. **Install Vercel CLI**
4. **Authenticate with Vercel** (`VERCEL_TOKEN`)
5. **Pull Vercel config** (`vercel pull --environment=preview`)
6. **Build** (`vercel build`)
7. **Deploy Preview** (`vercel deploy --prebuilt --preview`)
8. **Comment on PR** with preview URL

### 2.3 Environment

**Vercel Environment:** `preview`

**Environment Variables:**
- Pulled from Vercel project settings (Preview environment)
- Can be overridden in workflow if needed

**Secrets Required:**
- `VERCEL_TOKEN` - Vercel API token
- `VERCEL_ORG_ID` - Vercel organization ID
- `VERCEL_PROJECT_ID` - Vercel project ID

### 2.4 Output

**Preview URL Format:**
- `https://[project-name]-[hash].vercel.app`
- Or custom domain if configured

**PR Comment:**
- Automatically comments preview URL on PR
- Updates comment on subsequent pushes

---

## 3. Production Deployments

### 3.1 Trigger

**Workflow:** `.github/workflows/deploy-vercel-production.yml`

**Triggers:**
- Push to `main` branch
- Manual dispatch (`workflow_dispatch`)

**Path Filters:**
- Deploys on code changes
- Ignores: `**.md`, `docs/**` (unless code changes)

### 3.2 Process

1. **Checkout code** (`main` branch)
2. **Run pre-deployment checks:**
   - Tests
   - Lint
   - Security scans
   - Build validation
3. **Run database migrations** (if needed, via `db-migrate.yml`)
4. **Install Vercel CLI**
5. **Authenticate with Vercel** (`VERCEL_TOKEN`)
6. **Pull Vercel config** (`vercel pull --environment=production`)
7. **Build** (`vercel build`)
8. **Deploy Production** (`vercel deploy --prebuilt --prod`)
9. **Run smoke tests** (post-deployment health checks)
10. **Notify** (summary in workflow run)

### 3.3 Environment

**Vercel Environment:** `production`

**Environment Variables:**
- Pulled from Vercel project settings (Production environment)
- Must include all required app env vars

**Secrets Required:**
- `VERCEL_TOKEN` - Vercel API token
- `VERCEL_ORG_ID` - Vercel organization ID
- `VERCEL_PROJECT_ID` - Vercel project ID

### 3.4 Output

**Production URL:**
- `https://[project-name].vercel.app`
- Or custom domain if configured

**Deployment Summary:**
- Posted to workflow run summary
- Includes deployment status, URL, smoke test results

---

## 4. Workflow Dependencies

### 4.1 Preview Dependencies

**Optional:**
- Can run independently
- May skip tests for speed (deploy first, test in preview)

**Recommended:**
- Run basic lint check before deploy
- Run tests if time permits

### 4.2 Production Dependencies

**Required:**
- `ci.yml` - Tests, lint, security must pass
- `db-migrate.yml` - Migrations must succeed (if DB changes)

**Order:**
1. CI pipeline runs (test, lint, security)
2. Migrations run (if needed)
3. Vercel deployment runs
4. Smoke tests run

---

## 5. Vercel Configuration

### 5.1 Project Setup

**Project Type:** Python (FastAPI)

**Build Command:** Auto-detected by Vercel (`@vercel/python`)

**Output Directory:** N/A (serverless functions)

**Root Directory:** `apps/research_assistant_app/` (or root if `vercel.json` in root)

### 5.2 Vercel.json

**Location:** `deployment/vercel.json` (or root)

**Configuration:**
```json
{
  "version": 2,
  "builds": [
    {
      "src": "apps/research_assistant_app/main.py",
      "use": "@vercel/python"
    }
  ],
  "routes": [
    {
      "src": "/(.*)",
      "dest": "apps/research_assistant_app/main.py"
    }
  ],
  "env": {
    "PYTHON_VERSION": "3.11"
  }
}
```

**Note:** If `vercel.json` is in `deployment/`, Vercel project must be configured with root directory `deployment/`.

### 5.3 Git Integration

**Recommendation:** **Disable Vercel Git Integration** if using GitHub Actions.

**Reason:** Avoid double-deployments and conflicts.

**How to Disable:**
1. Vercel Dashboard → Project Settings
2. Git → Disconnect repository
3. Or keep connected but disable auto-deploy

**Alternative:** Use Vercel Git Integration exclusively (remove GitHub Actions workflows).

**Decision:** **Use GitHub Actions** (more control, better CI integration).

---

## 6. Environment Variables

### 6.1 Required Variables

**Vercel Project Settings → Environment Variables:**

**Preview Environment:**
- `DATABASE_URL` (if using database)
- `OPENAI_API_KEY` or `ANTHROPIC_API_KEY`
- `JWT_SECRET_KEY` (if using auth)
- Any app-specific vars

**Production Environment:**
- Same as Preview, but with production values
- `DEBUG=false`
- `LOG_LEVEL=INFO`
- Production database URLs
- Production API keys

### 6.2 Variable Sources

**GitHub Secrets:** Used by workflows (VERCEL_TOKEN, etc.)

**Vercel Environment Variables:** Used by deployed app

**Both Required:** Secrets for deployment, env vars for runtime.

---

## 7. Branch Strategy

### 7.1 Preview Branches

**Source:** Any branch (PR source)

**Target:** `main` branch (PR target)

**Deployment:** Preview environment

**Lifetime:** Until PR is closed/merged

### 7.2 Production Branch

**Branch:** `main` only

**Deployment:** Production environment

**Protection:**
- Require PR reviews
- Require CI checks to pass
- Require migrations to pass (if DB changes)

---

## 8. Rollback Strategy

### 8.1 Automatic Rollback

**Vercel:** Automatic rollback on deployment failure

**Health Checks:** Smoke tests detect failures

**Manual Rollback:**
1. Vercel Dashboard → Deployments
2. Select previous deployment
3. Click "Promote to Production"

### 8.2 Emergency Rollback

**Via GitHub Actions:**
- Re-run previous successful workflow
- Or manually deploy specific commit

**Via Vercel CLI:**
```bash
vercel --prod --force
```

---

## 9. Monitoring & Alerts

### 9.1 Deployment Monitoring

**GitHub Actions:**
- Workflow run status
- Deployment logs
- Failure notifications

**Vercel Dashboard:**
- Deployment history
- Build logs
- Function logs
- Analytics

### 9.2 Health Checks

**Endpoint:** `/health`

**Smoke Tests:**
- Run after production deployment
- Check health endpoint
- Verify API endpoints

**Failure Action:**
- Log warning (don't fail deployment)
- Alert team
- Investigate

---

## 10. Troubleshooting

### 10.1 Common Issues

**Deployment Not Triggering:**
- Check workflow triggers
- Check branch filters
- Check path filters

**Deployment Failing:**
- Check Vercel build logs
- Verify environment variables
- Check Python version compatibility
- Verify dependencies

**Preview Not Appearing:**
- Check PR comment
- Verify Vercel project settings
- Check Vercel dashboard for deployment

**Production Not Deploying:**
- Check CI checks passed
- Verify migrations succeeded
- Check workflow logs
- Verify secrets configured

### 10.2 Diagnostic Tools

**Deploy Doctor Script:** `scripts/deploy-doctor.sh`

**Checks:**
- Workflow configuration
- Secrets presence
- Vercel config validity
- Environment variables

---

## 11. Best Practices

### 11.1 Deployment Frequency

**Preview:** Every PR update (automatic)

**Production:** Every merge to main (automatic)

**Manual:** Use `workflow_dispatch` for emergency deployments

### 11.2 Pre-Deployment Checks

**Preview:** Optional (speed vs safety)

**Production:** Required (tests, lint, security, migrations)

### 11.3 Post-Deployment Validation

**Preview:** Manual testing by PR author

**Production:** Automated smoke tests

---

## 12. Future Improvements

### Short-Term

1. Add deployment status badges
2. Add deployment notifications (Slack, email)
3. Improve smoke test coverage

### Medium-Term

4. Add canary deployments
5. Add A/B testing support
6. Add performance monitoring

### Long-Term

7. Multi-region deployments
8. Blue-green deployments
9. Advanced rollback automation

---

## Conclusion

**Deployment Strategy:**
- **Preview:** Automatic on PRs (Vercel Preview)
- **Production:** Automatic on main (Vercel Production)
- **Method:** GitHub Actions workflows
- **Host:** Vercel (for demo app)

**Key Principles:**
- Automated deployments
- CI-first approach
- Fail fast, deploy safe
- Monitor and alert

**Next Steps:**
1. Implement workflows
2. Configure secrets
3. Set up environment variables
4. Test deployments
5. Monitor and iterate
