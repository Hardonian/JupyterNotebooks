# Deployment Failure Postmortem - Initial Analysis

**Date:** 2024-01-XX  
**Status:** Investigation Complete  
**Purpose:** Identify root causes of Vercel Preview and Production deployment failures

---

## Executive Summary

**Critical Finding:** **No Vercel deployment workflows exist** despite:
- `vercel.json` configuration present in `deployment/vercel.json`
- User expectation of Preview (PR) and Production (main) deployments
- Multiple deployment workflows exist but target Render/Docker/K8s only

**Root Cause:** Missing GitHub Actions workflows for Vercel deployments.

---

## 1. Current Workflow Inventory

### 1.1 Existing Deployment Workflows

| Workflow | Trigger | Target | Status |
|----------|---------|--------|--------|
| `deploy-preview.yml` | PRs to main/develop | Render + Docker | ✅ Active (wrong target) |
| `deploy-production.yml` | Push to main | Render + Docker + K8s | ✅ Active (wrong target) |
| `deploy-multi-env.yml` | Push to develop/main | Render + Docker | ✅ Active (wrong target) |
| `ci.yml` | Push/PR to main/develop | Build/Test/Lint | ✅ Active |
| `db-migrate.yml` | Push to main (migrations) | Database | ✅ Active |

### 1.2 Missing Workflows

| Workflow | Expected Trigger | Expected Target | Status |
|----------|-----------------|-----------------|--------|
| **Vercel Preview** | PRs to main | Vercel Preview | ❌ **MISSING** |
| **Vercel Production** | Push to main | Vercel Production | ❌ **MISSING** |

---

## 2. Failure Mode Analysis

### Failure Mode 1: Workflow Not Triggering ❌

**Issue:** No Vercel deployment workflows exist.

**Evidence:**
- No workflow files matching `*vercel*` in `.github/workflows/`
- `deploy-preview.yml` and `deploy-production.yml` target Render, not Vercel
- `vercel.json` exists but is never invoked by workflows

**Impact:** 
- PRs never trigger Vercel Preview deployments
- Pushes to `main` never trigger Vercel Production deployments

**Root Cause:** Workflows were never created for Vercel.

---

### Failure Mode 2: Workflow Runs But Deploy Step Skipped ❌

**Issue:** N/A - workflows don't exist.

**If workflows existed, potential issues:**
- `if:` conditions might skip deploy jobs
- Missing job dependencies (`needs:`)
- Incorrect branch filters

---

### Failure Mode 3: Workflow Runs But Fails ❌

**Issue:** N/A - workflows don't exist.

**If workflows existed, potential issues:**

#### 3.1 Missing Secrets

**Required Vercel Secrets:**
- `VERCEL_TOKEN` - Vercel API token
- `VERCEL_ORG_ID` - Vercel organization ID
- `VERCEL_PROJECT_ID` - Vercel project ID

**Current State:** Unknown if secrets are configured (no workflows to test).

#### 3.2 Build Configuration

**Current `vercel.json`:**
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

**Potential Issues:**
- Python dependencies not specified (no `requirements.txt` in root)
- `apps/research_assistant_app/requirements.txt` exists but may not be detected
- Environment variables not configured in Vercel project settings

#### 3.3 Node/Package Manager Issues

**N/A** - This is a Python app, not Node.js.

---

### Failure Mode 4: Vercel Project Misconfiguration ❌

**Issue:** Cannot verify without workflows, but likely issues:

#### 4.1 Git Integration Conflict

**Risk:** If Vercel Git Integration is enabled:
- Vercel native deployments might conflict with GitHub Actions
- Both might try to deploy, causing confusion
- Need to choose one: Git Integration OR GitHub Actions (not both)

#### 4.2 Project Linking

**Risk:** 
- Vercel project might not be linked to this GitHub repo
- Wrong project ID referenced in secrets
- Wrong organization ID

#### 4.3 Environment Variables

**Risk:**
- Environment variables not set in Vercel dashboard
- Preview vs Production env vars not configured
- Missing required vars (DATABASE_URL, API keys, etc.)

---

## 3. Workflow Trigger Analysis

### 3.1 Preview Deployment (Expected)

**Expected Trigger:**
```yaml
on:
  pull_request:
    types: [opened, synchronize, reopened]
    branches: [main]
```

**Current State:** No workflow exists.

**Issues:**
- ❌ No workflow file
- ❌ No trigger configuration
- ❌ No deploy job

---

### 3.2 Production Deployment (Expected)

**Expected Trigger:**
```yaml
on:
  push:
    branches: [main]
```

**Current State:** `deploy-production.yml` exists but targets Render.

**Issues:**
- ❌ Targets Render, not Vercel
- ❌ Has `paths-ignore` that might skip deploys:
  ```yaml
  paths-ignore:
    - '**.md'
    - 'docs/**'
    - '.github/workflows/deploy-preview.yml'
  ```
- ❌ No Vercel CLI commands

---

## 4. Configuration Analysis

### 4.1 Vercel Configuration

**File:** `deployment/vercel.json`

**Status:** ✅ Exists and appears valid

**Issues:**
- Located in `deployment/` subdirectory (Vercel expects `vercel.json` in root or project root)
- May need to be moved to root or `apps/research_assistant_app/`

### 4.2 Python Dependencies

**File:** `apps/research_assistant_app/requirements.txt`

**Status:** ✅ Exists

**Potential Issue:** Vercel may not detect it if `vercel.json` is in wrong location.

### 4.3 Environment Variables

**File:** `.env.example`

**Status:** ✅ Exists with comprehensive list

**Issue:** No clear mapping to Vercel environment variables.

---

## 5. Immediate "Can't Possibly Deploy" Issues

### Critical Blockers

1. **❌ No Vercel deployment workflows exist**
   - Must create `deploy-vercel-preview.yml`
   - Must create `deploy-vercel-production.yml`

2. **❌ Vercel.json location may be incorrect**
   - Currently in `deployment/vercel.json`
   - May need to be in root or `apps/research_assistant_app/`

3. **❌ Missing Vercel secrets**
   - `VERCEL_TOKEN` - Required
   - `VERCEL_ORG_ID` - Required
   - `VERCEL_PROJECT_ID` - Required

4. **❌ No Vercel CLI installation in workflows**
   - Workflows must install `vercel` CLI
   - Must authenticate with `VERCEL_TOKEN`

5. **❌ Environment variables not configured**
   - Vercel project settings need env vars
   - Preview vs Production env vars need setup

---

## 6. Suspected Failure Modes Summary

### High Confidence

1. **Workflow Missing** - No workflows exist for Vercel (100% certain)
2. **Secrets Missing** - Vercel secrets likely not configured (high confidence)
3. **Config Location** - `vercel.json` in subdirectory may cause issues (medium confidence)

### Medium Confidence

4. **Git Integration Conflict** - May be enabled, causing double-deploys (unknown)
5. **Environment Variables** - Not configured in Vercel dashboard (likely)

### Low Confidence

6. **Build Failures** - Cannot assess without workflows running
7. **Dependency Issues** - Requirements.txt exists, likely fine

---

## 7. Action Plan

### Phase 1: Create Missing Workflows (Critical)

1. Create `.github/workflows/deploy-vercel-preview.yml`
   - Trigger on PRs to main
   - Install Vercel CLI
   - Deploy to Preview

2. Create `.github/workflows/deploy-vercel-production.yml`
   - Trigger on push to main
   - Install Vercel CLI
   - Deploy to Production

### Phase 2: Fix Configuration (High Priority)

3. Verify `vercel.json` location
   - Move to root if needed
   - Or configure Vercel to use subdirectory

4. Document required secrets
   - Update `docs/env-and-secrets.md`
   - Add Vercel-specific section

### Phase 3: Documentation (Medium Priority)

5. Create deployment strategy doc
6. Create troubleshooting guide
7. Create deploy-doctor script

---

## 8. Next Steps

1. ✅ **Create Vercel Preview workflow**
2. ✅ **Create Vercel Production workflow**
3. ✅ **Fix vercel.json location (if needed)**
4. ✅ **Document required secrets**
5. ✅ **Create troubleshooting docs**
6. ✅ **Add deploy-doctor script**

---

## Conclusion

**Primary Root Cause:** Missing GitHub Actions workflows for Vercel deployments.

**Secondary Issues:**
- Vercel configuration location may be incorrect
- Secrets likely not configured
- Environment variables likely not set in Vercel dashboard

**Fix Priority:**
1. **CRITICAL:** Create Vercel deployment workflows
2. **HIGH:** Verify and fix configuration
3. **MEDIUM:** Document and add diagnostics
