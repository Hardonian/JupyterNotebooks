# Deployment Automation Guide

**Last Updated:** 2024-01-XX  
**Purpose:** Complete guide to automated deployment workflows

---

## Overview

Agent Factory now includes comprehensive deployment automation:

1. **Production Deployments** - Automated deployments to production
2. **Preview Deployments** - PR-based preview environments
3. **Multi-Environment Pipeline** - Dev → Staging → Production

---

## 1. Production Deployment

### Workflow: `deploy-production.yml`

**Triggers:**
- Push to `main` branch
- Manual dispatch (`workflow_dispatch`)

**Process:**
1. Pre-deployment checks (tests, lint, security)
2. Deploy to Render (if configured)
3. Build and push Docker image
4. Deploy to Kubernetes (if configured)
5. Post-deployment smoke tests
6. Notification

### Configuration

**Required Secrets:**
- `DATABASE_URL` - Production database
- `RENDER_API_KEY` - Render API key (optional)
- `RENDER_SERVICE_ID` - Render service ID (optional)
- `DOCKER_REGISTRY` - Docker registry (optional, defaults to ghcr.io)
- `KUBECONFIG` - Kubernetes config (optional)
- `PRODUCTION_API_URL` - Production API URL for smoke tests

**Setup:**
1. Go to Repository → Settings → Secrets and variables → Actions
2. Add required secrets
3. Configure deployment targets (Render, Docker, K8s)

---

## 2. Preview Deployments

### Workflow: `deploy-preview.yml`

**Triggers:**
- Pull request opened/updated
- Manual dispatch

**Process:**
1. Build preview
2. Deploy to Render preview service
3. Build preview Docker image
4. Run smoke tests
5. Comment on PR with preview URL

### Configuration

**Required Secrets:**
- `RENDER_API_KEY` - Render API key
- `RENDER_PREVIEW_SERVICE_ID` - Render preview service ID

**Preview URLs:**
- Format: `https://agent-factory-pr-{PR_NUMBER}.onrender.com`
- Automatically commented on PR
- Cleaned up when PR is closed

---

## 3. Multi-Environment Pipeline

### Workflow: `deploy-multi-env.yml`

**Triggers:**
- Push to `develop` → Deploy to staging
- Push to `main` → Deploy to production
- Manual dispatch (choose environment)

**Process:**
1. Determine target environment
2. Run tests
3. Run database migrations
4. Deploy to environment
5. Run smoke tests
6. Notify

### Environment Configuration

**Staging:**
- Branch: `develop`
- Secrets: `STAGING_DATABASE_URL`, `STAGING_API_URL`, `RENDER_STAGING_SERVICE_ID`

**Production:**
- Branch: `main`
- Secrets: `PRODUCTION_DATABASE_URL`, `PRODUCTION_API_URL`, `RENDER_PRODUCTION_SERVICE_ID`

---

## 4. Deployment Targets

### Render

**Setup:**
1. Create Render account
2. Create web service
3. Get API key and service ID
4. Add to GitHub secrets

**Configuration:**
- Auto-deploy from GitHub
- Environment variables from Render dashboard
- Health checks configured

---

### Docker

**Registry Options:**
- GitHub Container Registry (ghcr.io) - Default
- Docker Hub
- AWS ECR
- Google Container Registry

**Setup:**
1. Configure registry in secrets
2. Images tagged with: `latest`, `{sha}`, `{environment}-latest`

---

### Kubernetes

**Setup:**
1. Get Kubernetes config
2. Add as secret: `KUBECONFIG`
3. Configure namespace and deployment name

**Deployment:**
- Updates image tag in deployment
- Rolling update strategy
- Health checks via readiness/liveness probes

---

## 5. Smoke Tests

### Post-Deployment Validation

**Tests:**
- Health check endpoint
- Readiness probe
- Liveness probe
- API documentation
- Core API endpoints

**Script:** `scripts/smoke-tests.sh`

**Configuration:**
- Set `API_BASE_URL` environment variable
- Tests run automatically after deployment
- Non-blocking (warnings only)

---

## 6. Rollback

### Manual Rollback

**Docker:**
```bash
# Rollback to previous image
kubectl set image deployment/agent-factory-api \
  agent-factory-api=ghcr.io/org/repo:previous-sha
```

**Render:**
- Use Render dashboard to rollback to previous deployment
- Or trigger deployment with specific commit

**Database:**
```bash
# Rollback migration
alembic downgrade -1
```

---

## 7. Best Practices

### 1. Always Test Before Deploy

- Run tests locally
- Check CI passes
- Review changes

### 2. Use Preview Deployments

- Test changes in preview environment
- Verify before merging
- Share preview URLs with team

### 3. Monitor Deployments

- Watch deployment logs
- Check smoke tests
- Monitor health endpoints

### 4. Gradual Rollout

- Deploy to staging first
- Test thoroughly
- Promote to production

### 5. Keep Secrets Secure

- Never commit secrets
- Use GitHub Secrets
- Rotate regularly

---

## 8. Troubleshooting

### Deployment Fails

**Check:**
1. CI tests passing
2. Secrets configured
3. Service accessible
4. Logs for errors

**Fix:**
- Review workflow logs
- Check service status
- Verify secrets

---

### Smoke Tests Fail

**Check:**
1. API URL correct
2. Service ready
3. Health checks passing

**Fix:**
- Wait for service to be ready
- Check health endpoint manually
- Review API logs

---

### Preview Not Deploying

**Check:**
1. PR opened/updated
2. Render preview service configured
3. Secrets set

**Fix:**
- Verify Render configuration
- Check workflow logs
- Manually trigger workflow

---

## 9. Advanced Configuration

### Custom Deployment Scripts

**Location:** `scripts/deploy-*.sh`

**Usage:**
- Custom deployment logic
- Environment-specific steps
- Integration with other tools

---

### Deployment Notifications

**Channels:**
- GitHub Actions summary
- Slack (via webhook)
- Email (via GitHub notifications)

**Configuration:**
- Add notification steps to workflows
- Configure webhooks
- Set up alerts

---

## Conclusion

**Deployment Automation Status:** ✅ Complete

**Features:**
- ✅ Production deployments
- ✅ Preview deployments
- ✅ Multi-environment pipeline
- ✅ Smoke tests
- ✅ Rollback procedures

**Next Steps:**
1. Configure secrets
2. Set up deployment targets
3. Test deployments
4. Monitor and optimize
