# Deployment Reliability Plan

**Last Updated:** 2024-01-XX  
**Status:** Active  
**Purpose:** Comprehensive plan to ensure reliable Vercel Preview and Production deployments

---

## Executive Summary

**Goal:** Ensure 100% reliable Vercel Preview (PR) and Production (main) deployments via GitHub Actions.

**Status:** ✅ Workflows created, ⚠️ Secrets configuration required

**Next Steps:**
1. Configure GitHub Secrets (VERCEL_TOKEN, VERCEL_ORG_ID, VERCEL_PROJECT_ID)
2. Configure Vercel Environment Variables
3. Test Preview deployment with a PR
4. Test Production deployment with push to main

---

## 1. Root Causes Found

### Critical Issues (Fixed)

1. ✅ **Missing Vercel Deployment Workflows**
   - **Status:** Fixed
   - **Fix:** Created `.github/workflows/deploy-vercel-preview.yml` and `deploy-vercel-production.yml`
   - **Impact:** Deployments can now trigger

2. ✅ **No Deployment Strategy Documentation**
   - **Status:** Fixed
   - **Fix:** Created `docs/deploy-strategy.md`
   - **Impact:** Clear deployment process documented

### High Priority Issues (Requires Configuration)

3. ⚠️ **Missing GitHub Secrets**
   - **Status:** Requires manual configuration
   - **Required:** VERCEL_TOKEN, VERCEL_ORG_ID, VERCEL_PROJECT_ID
   - **Impact:** Deployments will fail without these
   - **Action:** See section 3 below

4. ⚠️ **Missing Vercel Environment Variables**
   - **Status:** Requires manual configuration
   - **Required:** DATABASE_URL, API keys, etc. (app-specific)
   - **Impact:** App will fail at runtime without these
   - **Action:** See section 4 below

### Medium Priority Issues (May Need Attention)

5. ⚠️ **vercel.json Location**
   - **Status:** Currently in `deployment/vercel.json`
   - **Risk:** Vercel may not find it if project root not configured
   - **Action:** Move to root OR configure Vercel project root = `deployment/`

6. ⚠️ **Vercel Git Integration Conflict**
   - **Status:** Unknown (check Vercel dashboard)
   - **Risk:** Double deployments if both enabled
   - **Action:** Disable Vercel Git Integration if using GitHub Actions

---

## 2. Fixes Applied

### 2.1 Workflow Files Created

**Files Created:**
- `.github/workflows/deploy-vercel-preview.yml` - Preview deployments for PRs
- `.github/workflows/deploy-vercel-production.yml` - Production deployments for main

**Features:**
- ✅ Proper triggers (PRs for preview, main push for production)
- ✅ Pre-deployment checks (tests, lint, security)
- ✅ Vercel CLI installation and authentication
- ✅ Build and deploy steps
- ✅ PR comments with preview URLs
- ✅ Smoke tests (post-deployment)
- ✅ Error handling and clear error messages

### 2.2 Documentation Created

**Files Created:**
- `docs/deploy-strategy.md` - Canonical deployment strategy
- `docs/deploy-failure-postmortem-initial.md` - Initial failure analysis
- `docs/vercel-troubleshooting.md` - Troubleshooting guide
- `docs/deploy-reliability-plan.md` - This document

**Files Updated:**
- `docs/env-and-secrets.md` - Added Vercel secrets section
- `docs/ci-overview.md` - Updated with Vercel workflows (to be updated)

### 2.3 Diagnostic Tools Created

**Files Created:**
- `scripts/deploy-doctor.sh` - Diagnostic script for deployment configuration

**Features:**
- Checks workflow files exist
- Checks vercel.json location
- Checks Python dependencies
- Checks environment variable documentation
- Provides GitHub Secrets checklist
- Provides Vercel Dashboard checklist

---

## 3. Required Configuration Steps

### 3.1 GitHub Secrets (Required)

**Location:** Repository → Settings → Secrets and variables → Actions

**Required Secrets:**

1. **VERCEL_TOKEN**
   - **How to get:** https://vercel.com/account/tokens
   - **Steps:**
     1. Go to Vercel account tokens page
     2. Click "Create Token"
     3. Name it (e.g., "GitHub Actions")
     4. Copy token (only shown once!)
     5. Add to GitHub Secrets

2. **VERCEL_ORG_ID**
   - **How to get:** Vercel Dashboard → Team Settings → General
   - **Steps:**
     1. Go to Vercel Dashboard
     2. Team Settings → General
     3. Find "Team ID" (or personal account ID)
     4. Copy ID
     5. Add to GitHub Secrets

3. **VERCEL_PROJECT_ID**
   - **How to get:** Vercel Dashboard → Project → Settings → General
   - **Steps:**
     1. Go to Vercel Dashboard
     2. Your Project → Settings → General
     3. Find "Project ID"
     4. Copy ID
     5. Add to GitHub Secrets

4. **VERCEL_PRODUCTION_URL** (Optional)
   - **Purpose:** For notifications and smoke tests
   - **Format:** `https://[project-name].vercel.app`
   - **Optional:** Can be extracted from deployment, but setting it helps

**Verification:**
```bash
# Run deploy-doctor to check (won't verify secrets, but provides checklist)
./scripts/deploy-doctor.sh
```

### 3.2 Vercel Environment Variables (Required)

**Location:** Vercel Dashboard → Project → Settings → Environment Variables

**Important:** These are separate from GitHub Secrets!

**Preview Environment Variables:**
- `DATABASE_URL` (if using database)
- `OPENAI_API_KEY` or `ANTHROPIC_API_KEY`
- `JWT_SECRET_KEY` (if using auth)
- Any app-specific variables

**Production Environment Variables:**
- Same as Preview, but with production values
- `DEBUG=false`
- `LOG_LEVEL=INFO`
- Production database URLs
- Production API keys

**Steps:**
1. Go to Vercel Dashboard → Your Project
2. Settings → Environment Variables
3. Add variables for Preview environment
4. Add variables for Production environment
5. Set appropriate values for each

**Verification:**
- Check Vercel Dashboard → Project → Settings → Environment Variables
- Ensure both Preview and Production environments have required vars

### 3.3 Vercel Project Configuration

**Check These Settings:**

1. **Project Root Directory:**
   - If `vercel.json` is in root: Root = `/`
   - If `vercel.json` is in `deployment/`: Root = `deployment/`
   - **Recommendation:** Move `vercel.json` to root for simplicity

2. **Git Integration:**
   - **If using GitHub Actions:** Disable Vercel Git Integration auto-deploy
   - **If using Vercel Git Integration:** Remove GitHub Actions workflows
   - **Recommendation:** Use GitHub Actions (more control)

3. **Project Linking:**
   - Ensure project is linked to correct GitHub repository
   - Check Vercel Dashboard → Project → Settings → Git

**Steps:**
1. Go to Vercel Dashboard → Your Project
2. Settings → General
3. Check "Root Directory" setting
4. Settings → Git
5. Check repository link
6. Disable "Auto-deploy" if using GitHub Actions

---

## 4. Verification Steps

### 4.1 Verify Preview Deployment

**Test with a PR:**

1. **Create a test PR:**
   ```bash
   git checkout -b test-preview-deploy
   # Make a small change
   git commit -m "Test preview deployment"
   git push origin test-preview-deploy
   # Create PR to main
   ```

2. **Check GitHub Actions:**
   - Go to repository → Actions
   - Look for "Deploy Vercel Preview" workflow
   - Should trigger automatically

3. **Check workflow run:**
   - Click on workflow run
   - Check all jobs pass
   - Check "deploy-preview" job succeeds
   - Check PR comment appears with preview URL

4. **Verify preview URL:**
   - Click preview URL in PR comment
   - Should load deployed app
   - Test `/health` endpoint

**Success Criteria:**
- ✅ Workflow triggers automatically
- ✅ All jobs pass
- ✅ Preview URL appears in PR comment
- ✅ Preview URL is accessible
- ✅ App works correctly

### 4.2 Verify Production Deployment

**Test with push to main:**

1. **Merge test PR or push to main:**
   ```bash
   git checkout main
   git merge test-preview-deploy
   git push origin main
   ```

2. **Check GitHub Actions:**
   - Go to repository → Actions
   - Look for "Deploy Vercel Production" workflow
   - Should trigger automatically

3. **Check workflow run:**
   - Click on workflow run
   - Check pre-deployment checks pass
   - Check "deploy-production" job succeeds
   - Check smoke tests pass

4. **Verify production URL:**
   - Check workflow summary for production URL
   - Visit production URL
   - Test `/health` endpoint
   - Verify app works correctly

**Success Criteria:**
- ✅ Workflow triggers automatically
- ✅ Pre-deployment checks pass
- ✅ Production deployment succeeds
- ✅ Smoke tests pass
- ✅ Production URL is accessible
- ✅ App works correctly

---

## 5. If Deploy Breaks Again

### 5.1 Immediate Steps

1. **Run deploy-doctor:**
   ```bash
   ./scripts/deploy-doctor.sh
   ```
   Fix any errors it reports.

2. **Check workflow logs:**
   - GitHub → Actions → Failed run → Logs
   - Identify specific error
   - Check error message

3. **Check Vercel dashboard:**
   - Vercel Dashboard → Project → Deployments
   - Check latest deployment logs
   - Check for build/runtime errors

4. **Review troubleshooting guide:**
   - `docs/vercel-troubleshooting.md`
   - Find matching issue
   - Follow solution steps

### 5.2 Common Failure Points

**Workflow Not Triggering:**
- Check branch filters
- Check path filters
- Check workflow file exists
- Check workflow is enabled

**Deployment Failing:**
- Check GitHub Secrets are set
- Check Vercel Environment Variables are set
- Check vercel.json location
- Check build logs

**App Failing at Runtime:**
- Check Vercel Environment Variables (not GitHub Secrets!)
- Check environment-specific vars (Preview vs Production)
- Check app logs in Vercel dashboard

### 5.3 Diagnostic Checklist

Run through this checklist:

- [ ] Run `./scripts/deploy-doctor.sh`
- [ ] Check GitHub Secrets are set (VERCEL_TOKEN, VERCEL_ORG_ID, VERCEL_PROJECT_ID)
- [ ] Check Vercel Environment Variables are set (Preview and Production)
- [ ] Check vercel.json location (root or deployment/)
- [ ] Check Vercel project root directory setting
- [ ] Check Vercel Git Integration is disabled (if using Actions)
- [ ] Check workflow files exist and are correct
- [ ] Check workflow triggers are correct
- [ ] Check recent workflow runs
- [ ] Check Vercel deployment logs

---

## 6. Monitoring and Maintenance

### 6.1 Regular Checks

**Weekly:**
- Review deployment success rate
- Check for failed deployments
- Review error logs

**Monthly:**
- Review and update documentation
- Check for Vercel/CLI updates
- Review and rotate secrets (if needed)

### 6.2 Success Metrics

**Track:**
- Preview deployment success rate (target: >95%)
- Production deployment success rate (target: >99%)
- Average deployment time
- Time to detect failures

**Monitor:**
- GitHub Actions workflow runs
- Vercel deployment history
- Error rates and types

### 6.3 Continuous Improvement

**Improvements to Consider:**
- Add deployment notifications (Slack, email)
- Add deployment status badges
- Improve smoke test coverage
- Add performance monitoring
- Add canary deployments
- Add automated rollback

---

## 7. Documentation References

**Key Documents:**
- `docs/deploy-strategy.md` - Deployment strategy
- `docs/vercel-troubleshooting.md` - Troubleshooting guide
- `docs/env-and-secrets.md` - Secrets and environment variables
- `docs/ci-overview.md` - CI/CD overview
- `docs/deploy-failure-postmortem-initial.md` - Initial failure analysis

**Scripts:**
- `scripts/deploy-doctor.sh` - Diagnostic script

**Workflows:**
- `.github/workflows/deploy-vercel-preview.yml` - Preview deployment
- `.github/workflows/deploy-vercel-production.yml` - Production deployment

---

## 8. Next Steps

### Immediate (Before First Deployment)

1. ✅ **Configure GitHub Secrets:**
   - VERCEL_TOKEN
   - VERCEL_ORG_ID
   - VERCEL_PROJECT_ID

2. ✅ **Configure Vercel Environment Variables:**
   - Preview environment
   - Production environment

3. ✅ **Verify Vercel Project Settings:**
   - Root directory
   - Git integration (disable if using Actions)

4. ✅ **Test Preview Deployment:**
   - Create test PR
   - Verify workflow triggers
   - Verify preview URL works

5. ✅ **Test Production Deployment:**
   - Push to main
   - Verify workflow triggers
   - Verify production URL works

### Short-Term (First Week)

6. ✅ **Monitor Deployments:**
   - Track success rate
   - Fix any issues
   - Update documentation

7. ✅ **Improve Diagnostics:**
   - Enhance deploy-doctor script
   - Add more checks
   - Improve error messages

### Medium-Term (First Month)

8. ✅ **Add Monitoring:**
   - Deployment notifications
   - Status badges
   - Success metrics

9. ✅ **Optimize:**
   - Reduce deployment time
   - Improve smoke tests
   - Add performance monitoring

---

## Conclusion

**Current Status:**
- ✅ Workflows created and configured
- ✅ Documentation complete
- ✅ Diagnostic tools available
- ⚠️ Secrets configuration required (manual step)

**Confidence Level:** High

**Deployment Readiness:** Ready after secrets configuration

**Next Action:** Configure GitHub Secrets and Vercel Environment Variables, then test with a PR.

---

## Quick Reference

**Deploy Doctor:**
```bash
./scripts/deploy-doctor.sh
```

**Troubleshooting:**
- See `docs/vercel-troubleshooting.md`

**Secrets Setup:**
- See `docs/env-and-secrets.md` section 2.2

**Vercel Environment Variables:**
- See `docs/env-and-secrets.md` section 2.3

**Deployment Strategy:**
- See `docs/deploy-strategy.md`
