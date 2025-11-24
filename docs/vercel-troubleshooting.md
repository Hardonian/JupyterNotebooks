# Vercel Troubleshooting Guide

**Last Updated:** 2024-01-XX  
**Purpose:** Troubleshoot Vercel Preview and Production deployment issues

---

## Quick Diagnosis

Run the deploy-doctor script first:

```bash
./scripts/deploy-doctor.sh
```

This will identify common configuration issues.

---

## Common Issues and Solutions

### Issue 1: Preview Deployment Not Triggering

**Symptoms:**
- PR created but no preview deployment appears
- No workflow run in GitHub Actions

**Diagnosis:**

1. **Check workflow trigger:**
   ```bash
   cat .github/workflows/deploy-vercel-preview.yml | grep -A 5 "on:"
   ```
   Should show `pull_request` with `branches: [main]`

2. **Check if workflow file exists:**
   ```bash
   ls -la .github/workflows/deploy-vercel-preview.yml
   ```

3. **Check GitHub Actions tab:**
   - Go to repository → Actions
   - Look for "Deploy Vercel Preview" workflow
   - Check if it ran for your PR

**Solutions:**

- ✅ **Workflow missing:** Create `.github/workflows/deploy-vercel-preview.yml` (already created)
- ✅ **Wrong branch filter:** Ensure PR targets `main` branch
- ✅ **Workflow disabled:** Check repository settings → Actions → Workflow permissions

---

### Issue 2: Production Deployment Not Triggering

**Symptoms:**
- Push to `main` but no production deployment
- No workflow run in GitHub Actions

**Diagnosis:**

1. **Check workflow trigger:**
   ```bash
   cat .github/workflows/deploy-vercel-production.yml | grep -A 5 "on:"
   ```
   Should show `push` with `branches: [main]`

2. **Check path filters:**
   ```bash
   cat .github/workflows/deploy-vercel-production.yml | grep -A 5 "paths-ignore"
   ```
   If you only changed `.md` files, deployment may be skipped

3. **Check if CI checks passed:**
   - Production deployment requires pre-deployment checks to pass
   - Check `pre-deployment-checks` job status

**Solutions:**

- ✅ **Path filter too restrictive:** Remove or adjust `paths-ignore` in workflow
- ✅ **CI checks failing:** Fix test/lint/security issues
- ✅ **Workflow missing:** Create `.github/workflows/deploy-vercel-production.yml` (already created)

---

### Issue 3: Deployment Fails with "VERCEL_TOKEN not set"

**Symptoms:**
- Workflow runs but fails immediately
- Error: "VERCEL_TOKEN secret not set"

**Diagnosis:**

```bash
# Check if secret is referenced in workflow
grep -r "VERCEL_TOKEN" .github/workflows/deploy-vercel-*.yml
```

**Solutions:**

1. **Get Vercel Token:**
   - Go to https://vercel.com/account/tokens
   - Click "Create Token"
   - Name it (e.g., "GitHub Actions")
   - Copy token (only shown once!)

2. **Add to GitHub Secrets:**
   - Go to Repository → Settings → Secrets and variables → Actions
   - Click "New repository secret"
   - Name: `VERCEL_TOKEN`
   - Value: Paste token
   - Click "Add secret"

3. **Also add:**
   - `VERCEL_ORG_ID` - From Vercel Dashboard → Team Settings → General
   - `VERCEL_PROJECT_ID` - From Vercel Dashboard → Project → Settings → General

---

### Issue 4: Deployment Fails with "Failed to pull Vercel config"

**Symptoms:**
- Workflow runs but fails at "Pull Vercel Environment Information"
- Error about VERCEL_ORG_ID or VERCEL_PROJECT_ID

**Diagnosis:**

Check workflow logs for specific error:
- "VERCEL_ORG_ID not set"
- "VERCEL_PROJECT_ID not set"
- "Failed to pull Vercel config"

**Solutions:**

1. **Get VERCEL_ORG_ID:**
   - Go to Vercel Dashboard
   - Team Settings → General
   - Find "Team ID" (or personal account ID)
   - Copy the ID

2. **Get VERCEL_PROJECT_ID:**
   - Go to Vercel Dashboard
   - Your Project → Settings → General
   - Find "Project ID"
   - Copy the ID

3. **Add to GitHub Secrets:**
   - Repository → Settings → Secrets → Actions
   - Add `VERCEL_ORG_ID`
   - Add `VERCEL_PROJECT_ID`

4. **Verify values:**
   - Make sure no extra spaces
   - Make sure correct project (not wrong project ID)

---

### Issue 5: Build Fails

**Symptoms:**
- Workflow runs, pulls config, but build fails
- Error in Vercel build logs

**Diagnosis:**

Check workflow logs for build errors:
- Python version mismatch
- Missing dependencies
- Import errors
- Configuration errors

**Solutions:**

1. **Check Python version:**
   ```bash
   cat vercel.json deployment/vercel.json 2>/dev/null | grep PYTHON_VERSION
   ```
   Should match workflow Python version (3.11)

2. **Check requirements.txt:**
   ```bash
   cat apps/research_assistant_app/requirements.txt
   ```
   Ensure all dependencies are listed

3. **Check vercel.json paths:**
   ```bash
   cat vercel.json deployment/vercel.json 2>/dev/null | grep -A 2 "src:"
   ```
   Paths should be relative to project root

4. **Check Vercel project root:**
   - If `vercel.json` is in `deployment/`, configure Vercel project root = `deployment/`
   - Or move `vercel.json` to repository root

---

### Issue 6: Preview URL Not Appearing in PR Comment

**Symptoms:**
- Deployment succeeds but no PR comment
- Comment appears but URL is wrong

**Diagnosis:**

1. **Check workflow logs:**
   - Look for "Comment PR with Preview URL" step
   - Check if it ran
   - Check for errors

2. **Check GitHub token permissions:**
   - Repository → Settings → Actions → General
   - Workflow permissions → Read and write permissions

**Solutions:**

- ✅ **GitHub token permissions:** Enable "Read and write permissions" for workflows
- ✅ **Workflow step failed:** Check logs for specific error
- ✅ **URL extraction failed:** Check Vercel deploy output format

---

### Issue 7: Environment Variables Not Available in Deployed App

**Symptoms:**
- Deployment succeeds but app fails at runtime
- Error: "Environment variable X not set"

**Diagnosis:**

**Important:** GitHub Secrets ≠ Vercel Environment Variables

- **GitHub Secrets:** Used by workflows (VERCEL_TOKEN, etc.)
- **Vercel Environment Variables:** Used by deployed app (DATABASE_URL, etc.)

**Solutions:**

1. **Set Vercel Environment Variables:**
   - Go to Vercel Dashboard → Your Project
   - Settings → Environment Variables
   - Add variables for Preview and Production environments

2. **Required variables:**
   - `DATABASE_URL` (if using database)
   - `OPENAI_API_KEY` or `ANTHROPIC_API_KEY`
   - `JWT_SECRET_KEY` (if using auth)
   - Any app-specific variables

3. **Set for each environment:**
   - Preview environment (for PRs)
   - Production environment (for main)

---

### Issue 8: Double Deployments (GitHub Actions + Vercel Git Integration)

**Symptoms:**
- Two deployments for same commit
- Confusion about which deployment is "real"

**Diagnosis:**

Check Vercel project settings:
- Vercel Dashboard → Project → Settings → Git
- Check if repository is connected
- Check if "Auto-deploy" is enabled

**Solutions:**

**Option 1: Use GitHub Actions Only (Recommended)**

1. **Disable Vercel Git Integration:**
   - Vercel Dashboard → Project → Settings → Git
   - Click "Disconnect" or disable "Auto-deploy"
   - Keep repository connected (for project linking)
   - But disable automatic deployments

2. **Deployments via GitHub Actions only:**
   - More control
   - Better CI integration
   - Can run tests before deploy

**Option 2: Use Vercel Git Integration Only**

1. **Remove GitHub Actions workflows:**
   ```bash
   rm .github/workflows/deploy-vercel-*.yml
   ```

2. **Enable Vercel Git Integration:**
   - Vercel Dashboard → Project → Settings → Git
   - Enable "Auto-deploy"
   - Configure branch mappings

**Recommendation:** Use GitHub Actions (more control, better CI integration).

---

### Issue 9: vercel.json Location Issues

**Symptoms:**
- Build fails with "vercel.json not found"
- Wrong paths in build

**Diagnosis:**

```bash
# Check where vercel.json is
find . -name "vercel.json" -type f

# Check vercel.json paths
cat vercel.json deployment/vercel.json 2>/dev/null | grep -A 2 "src:"
```

**Solutions:**

**Option 1: Move vercel.json to root (Recommended)**

```bash
mv deployment/vercel.json vercel.json
```

Update paths in vercel.json if needed (they're relative to vercel.json location).

**Option 2: Configure Vercel Project Root**

1. Vercel Dashboard → Project → Settings → General
2. Set "Root Directory" to `deployment/`
3. Keep vercel.json in `deployment/`

**Option 3: Update vercel.json Paths**

If vercel.json stays in `deployment/`, update paths:
- `apps/research_assistant_app/main.py` → `../apps/research_assistant_app/main.py`

---

### Issue 10: Smoke Tests Failing

**Symptoms:**
- Deployment succeeds but smoke tests fail
- Health check fails

**Diagnosis:**

1. **Check smoke test logs:**
   - Look for specific endpoint failures
   - Check if URL is correct

2. **Check deployment URL:**
   - Verify URL extraction worked
   - Check if URL is accessible

**Solutions:**

- ✅ **Wait longer:** Deployment may need more time (increase sleep)
- ✅ **Check health endpoint:** Verify `/health` endpoint exists and works
- ✅ **Check CORS:** If testing from different origin, check CORS settings
- ✅ **Non-blocking:** Smoke tests are non-blocking (warnings only)

---

## Step-by-Step Debugging

### 1. Check Workflow Status

```bash
# View recent workflow runs
gh run list --workflow=deploy-vercel-preview.yml
gh run list --workflow=deploy-vercel-production.yml

# View specific run
gh run view [RUN_ID]
```

### 2. Check Workflow Logs

1. Go to GitHub → Actions
2. Select workflow run
3. Click on failed job
4. Expand failed step
5. Read error message

### 3. Check Vercel Dashboard

1. Go to Vercel Dashboard
2. Select project
3. Check "Deployments" tab
4. View deployment logs
5. Check "Settings" → "Environment Variables"

### 4. Test Locally

```bash
# Install Vercel CLI
npm install -g vercel

# Login
vercel login

# Link project
vercel link

# Pull environment
vercel pull --environment=preview

# Build
vercel build

# Deploy preview
vercel deploy --prebuilt
```

---

## Prevention Checklist

Before merging PRs or pushing to main:

- [ ] Run `./scripts/deploy-doctor.sh`
- [ ] Verify GitHub Secrets are set
- [ ] Verify Vercel Environment Variables are set
- [ ] Test locally with Vercel CLI
- [ ] Check workflow files are correct
- [ ] Verify branch filters are correct

---

## Getting Help

If issues persist:

1. **Run deploy-doctor:**
   ```bash
   ./scripts/deploy-doctor.sh
   ```

2. **Check workflow logs:**
   - GitHub → Actions → Failed run → Logs

3. **Check Vercel logs:**
   - Vercel Dashboard → Project → Deployments → Logs

4. **Review documentation:**
   - `docs/deploy-strategy.md`
   - `docs/env-and-secrets.md`
   - `docs/deploy-reliability-plan.md`

5. **Common fixes:**
   - Verify secrets are set
   - Verify environment variables are set
   - Check vercel.json location
   - Disable Vercel Git Integration if using Actions

---

## Quick Reference

| Issue | Quick Fix |
|-------|-----------|
| Preview not triggering | Check PR targets `main`, workflow exists |
| Production not triggering | Check push to `main`, CI checks passed |
| VERCEL_TOKEN error | Add token to GitHub Secrets |
| Build fails | Check Python version, requirements.txt, vercel.json paths |
| Env vars missing | Set in Vercel Dashboard (not just GitHub Secrets) |
| Double deployments | Disable Vercel Git Integration |
| vercel.json not found | Move to root or configure project root |

---

## Conclusion

**Most Common Issues:**
1. Missing GitHub Secrets (VERCEL_TOKEN, VERCEL_ORG_ID, VERCEL_PROJECT_ID)
2. Missing Vercel Environment Variables (set in dashboard, not GitHub)
3. vercel.json in wrong location
4. Vercel Git Integration conflicting with GitHub Actions

**Quick Fix:**
1. Run `./scripts/deploy-doctor.sh`
2. Fix errors it reports
3. Set missing secrets/variables
4. Test with a PR or push to main
