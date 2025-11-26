# GitHub Actions Automation Guide

**Founder, CEO & Operator:** Scott Hardie  
**Purpose:** Automated execution of readiness scripts on PR commits and nightly updates

---

## Overview

Two GitHub Actions workflows have been set up to automatically run readiness scripts:

1. **Automated Readiness & Documentation Updates** - Runs on PR commits
2. **Nightly Readiness Updates** - Runs daily at 3 AM UTC

---

## Workflow 1: Automated Readiness (PR-based)

**File:** `.github/workflows/automated-readiness.yml`

**Triggers:**
- Pull requests opened, synchronized, or reopened
- Pushes to `main` or `develop` branches

**What It Does:**
- Runs security audit
- Analyzes test coverage
- Analyzes data room placeholders
- Generates metrics snapshot template
- Generates unit economics template
- Generates YC application checklist
- Generates user acquisition checklist
- Updates weekly progress (on Mondays)
- Runs comprehensive readiness check

**Output:**
- Commits generated files back to PR branch
- Creates PR comment with summary of updates

**Permissions:**
- `contents: write` - To commit changes
- `pull-requests: write` - To create PR comments

---

## Workflow 2: Nightly Readiness Updates

**File:** `.github/workflows/nightly-readiness.yml`

**Triggers:**
- Daily at 3 AM UTC
- Manual trigger via `workflow_dispatch`

**What It Does:**
- Runs security audit
- Analyzes test coverage
- Analyzes data room placeholders
- Generates metrics snapshot template
- Generates unit economics template
- Updates weekly progress
- Runs comprehensive readiness check

**Output:**
- Creates new branch: `automated/nightly-readiness-updates-YYYYMMDD`
- Commits changes to branch
- Creates PR with updates

**Permissions:**
- `contents: write` - To commit changes
- `pull-requests: write` - To create PRs

---

## Scripts Updated for CI/CD

All scripts now support non-interactive mode via `SKIP_INTERACTIVE` environment variable:

### Updated Scripts:

1. **`scripts/security-audit.sh`**
   - Continues on errors in CI/CD mode
   - Uses `SKIP_INTERACTIVE` flag

2. **`scripts/collect-metrics.sh`**
   - Uses `PRODUCTION_URL` env var or argument
   - Skips interactive prompts in CI/CD mode

3. **`scripts/calculate-unit-economics.py`**
   - Uses environment variables for inputs:
     - `MARKETING_SPEND` (default: 0)
     - `NEW_CUSTOMERS` (default: 0)
     - `ARPU` (default: 49)
     - `CUSTOMER_LIFETIME` (default: 12)
     - `GROSS_MARGIN_PCT` (default: 80)
   - Skips interactive prompts in CI/CD mode

4. **`scripts/test-coverage-improvement.sh`**
   - Continues on errors in CI/CD mode

5. **`scripts/fill-dataroom-placeholders.py`**
   - Continues on errors in CI/CD mode

---

## Environment Variables

### Required (Optional):

- `PRODUCTION_URL` - Production URL for metrics collection
  - Default: `http://localhost:8000`
  - Can be set as GitHub secret: `PRODUCTION_URL`

### CI/CD Flags:

- `SKIP_INTERACTIVE` - Set to `true` to skip interactive prompts
  - Automatically set in workflows

---

## Generated Files

### Security Reports:
- `security-reports/bandit_*.txt` - Bandit security scan results
- `security-reports/bandit_*.json` - Bandit JSON results
- `security-reports/safety_*.txt` - Safety dependency check results
- `security-reports/safety_*.json` - Safety JSON results
- `security-reports/security_audit_summary_*.md` - Summary report

### Documentation:
- `docs/TEST_COVERAGE_IMPROVEMENT_PLAN.md` - Test coverage plan
- `docs/DATAROOM_FILL_GUIDE.md` - Data room placeholder guide
- `docs/WEEKLY_PROGRESS.md` - Weekly progress log
- `readiness-report.txt` - Readiness check report

### YC/Investor Docs:
- `yc/METRICS_SNAPSHOT.md` - Metrics snapshot template
- `yc/UNIT_ECONOMICS.md` - Unit economics template
- `yc/YC_APPLICATION_CHECKLIST.md` - YC application checklist
- `yc/EARLY_ADOPTERS.md` - User acquisition checklist

---

## How It Works

### On PR Commit:

1. Workflow triggers on PR event
2. Checks out code
3. Installs dependencies
4. Runs all scripts in non-interactive mode
5. Checks for changes
6. Commits changes back to PR branch
7. Creates PR comment with summary

### Nightly:

1. Workflow triggers at 3 AM UTC
2. Checks out code
3. Creates new branch
4. Runs all scripts in non-interactive mode
5. Checks for changes
6. Commits changes to branch
7. Creates PR with updates

---

## Manual Trigger

### Trigger Nightly Workflow:

```bash
# Via GitHub CLI
gh workflow run nightly-readiness.yml

# Via GitHub UI
# Go to Actions → Nightly Readiness Updates → Run workflow
```

---

## Troubleshooting

### Scripts Fail in CI/CD:

- Scripts use `continue-on-error: true` to prevent workflow failures
- Check workflow logs for specific errors
- Scripts generate placeholder templates even if data is missing

### Changes Not Committed:

- Check if `GITHUB_TOKEN` has write permissions
- Verify branch protection rules allow automated commits
- Check workflow logs for git errors

### PR Comments Not Created:

- Verify `pull-requests: write` permission
- Check if PR is from fork (may have permission issues)
- Review workflow logs for API errors

---

## Customization

### Add New Scripts:

1. Add script execution step to workflow
2. Add output check step
3. Add to commit message
4. Add to PR comment

### Change Schedule:

Edit `.github/workflows/nightly-readiness.yml`:

```yaml
schedule:
  - cron: '0 3 * * *'  # Change time here
```

### Add Environment Variables:

Add to workflow:

```yaml
env:
  CUSTOM_VAR: ${{ secrets.CUSTOM_VAR }}
```

---

## Best Practices

1. **Review Generated Files:**
   - Always review automated changes before merging
   - Fill in placeholders with real data
   - Verify security audit findings

2. **Monitor Workflows:**
   - Check workflow runs regularly
   - Review PR comments for updates
   - Address any recurring errors

3. **Keep Scripts Updated:**
   - Update scripts as needed
   - Test locally before pushing
   - Document changes in scripts

---

## Security Considerations

- **GitHub Token:** Uses `GITHUB_TOKEN` (automatically provided)
- **Secrets:** Use GitHub secrets for sensitive data
- **Permissions:** Minimal permissions required (contents:write, pull-requests:write)
- **Branch Protection:** Automated commits respect branch protection rules

---

## Summary

✅ **Automated:** Security audits, test coverage, metrics, unit economics  
✅ **Updated:** Scripts support non-interactive mode  
✅ **Committed:** Changes automatically committed to PR branches  
✅ **Documented:** PR comments summarize updates  

**Next Steps:**
- Review generated files
- Fill in placeholders with real data
- Monitor workflow runs
- Customize as needed

---

**Last Updated:** 2024-12-XX  
**Maintained by:** Founder
