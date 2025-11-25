# Staging Environment Guide

**Last Updated:** 2024-01-XX  
**Purpose:** Guide for setting up and managing the staging environment

---

## Overview

The staging environment is a pre-production environment used for:
- Testing new features before production
- Integration testing with external services
- User acceptance testing (UAT)
- Performance testing
- Demo environments

---

## Staging Environment Setup

### Render.com Staging

**Configuration:** `deployment/staging.yaml`

**Setup Steps:**

1. **Create Staging Service in Render**
   - Go to Render dashboard
   - Create new Web Service
   - Connect to repository
   - Use `deployment/staging.yaml` configuration

2. **Set Environment Variables**
   ```bash
   ENVIRONMENT=staging
   DEBUG=true
   LOG_LEVEL=DEBUG
   DATABASE_URL=postgresql://...  # Staging database
   REDIS_URL=redis://...  # Staging Redis
   OPENAI_API_KEY=sk-...  # Staging API key
   JWT_SECRET_KEY=...  # Staging secret
   ```

3. **Database Setup**
   ```bash
   # Run migrations
   alembic upgrade head
   
   # Seed test data (optional)
   python scripts/db-seed-demo.py
   ```

4. **Verify Deployment**
   ```bash
   # Health check
   curl https://staging-api.agentfactory.io/health
   
   # Smoke tests
   ./scripts/smoke-tests.sh
   ```

### Docker Staging

**Configuration:** `docker/docker-compose.staging.yml`

```bash
# Start staging environment
docker-compose -f docker/docker-compose.staging.yml up -d

# Run migrations
docker-compose -f docker/docker-compose.staging.yml exec api alembic upgrade head

# View logs
docker-compose -f docker/docker-compose.staging.yml logs -f
```

### Kubernetes Staging

**Namespace:** `agent-factory-staging`

```bash
# Apply staging manifests
kubectl apply -f k8s/staging/

# Check status
kubectl get pods -n agent-factory-staging

# View logs
kubectl logs -f deployment/agent-factory-api -n agent-factory-staging
```

---

## Staging vs Production Differences

| Aspect | Staging | Production |
|--------|---------|------------|
| **Debug Mode** | Enabled | Disabled |
| **Log Level** | DEBUG | INFO |
| **Rate Limits** | Higher (120/min) | Standard (60/min) |
| **Database** | Separate staging DB | Production DB |
| **Auto Deploy** | Manual | Automatic |
| **Monitoring** | Full | Full |
| **Backups** | Daily | Continuous |

---

## Staging Workflow

### 1. Deploy to Staging

```bash
# Trigger staging deployment
# Via Render dashboard or:
curl -X POST "https://api.render.com/v1/services/$STAGING_SERVICE_ID/deploys" \
  -H "Authorization: Bearer $RENDER_API_KEY"
```

### 2. Run Tests

```bash
# Integration tests
pytest tests/ -m integration

# E2E tests
pytest tests/e2e/ -m e2e

# Smoke tests
./scripts/smoke-tests.sh
```

### 3. Verify Functionality

- [ ] Health checks passing
- [ ] API endpoints responding
- [ ] Database migrations applied
- [ ] No errors in logs
- [ ] Performance acceptable

### 4. Promote to Production

Once staging is validated:
- Merge to `main` branch
- Production deployment triggers automatically
- Monitor production deployment

---

## Staging Database

### Setup

```bash
# Create staging database (Supabase)
# Use separate Supabase project or database

# Run migrations
DATABASE_URL=$STAGING_DATABASE_URL alembic upgrade head

# Validate schema
DATABASE_URL=$STAGING_DATABASE_URL python scripts/db-validate-schema.py
```

### Seed Data

```bash
# Seed demo data
DATABASE_URL=$STAGING_DATABASE_URL python scripts/db-seed-demo.py
```

### Reset Staging Database

```bash
# WARNING: This will delete all data
# Drop and recreate
DATABASE_URL=$STAGING_DATABASE_URL alembic downgrade base
DATABASE_URL=$STAGING_DATABASE_URL alembic upgrade head
DATABASE_URL=$STAGING_DATABASE_URL python scripts/db-seed-demo.py
```

---

## Staging URLs

**API:** `https://staging-api.agentfactory.io`  
**Docs:** `https://staging-api.agentfactory.io/docs`  
**Health:** `https://staging-api.agentfactory.io/health`

---

## Monitoring Staging

### Health Checks

```bash
# Health endpoint
curl https://staging-api.agentfactory.io/health

# Readiness
curl https://staging-api.agentfactory.io/ready

# Liveness
curl https://staging-api.agentfactory.io/live
```

### Logs

**Render:**
- View logs in Render dashboard
- Logs available for 7 days

**Docker:**
```bash
docker-compose -f docker/docker-compose.staging.yml logs -f api
```

**Kubernetes:**
```bash
kubectl logs -f deployment/agent-factory-api -n agent-factory-staging
```

### Metrics

**Prometheus:** `https://staging-api.agentfactory.io/metrics`

---

## Troubleshooting

### Staging Deployment Fails

1. Check logs for errors
2. Verify environment variables
3. Check database connectivity
4. Verify migrations ran successfully

### Database Issues

```bash
# Check connection
python scripts/db-validate-schema.py

# Check migrations
alembic current

# Run migrations
alembic upgrade head
```

### API Not Responding

1. Check health endpoint
2. Verify service is running
3. Check logs for errors
4. Verify port configuration

---

## Best Practices

1. **Always test in staging before production**
2. **Keep staging data separate from production**
3. **Reset staging regularly for clean testing**
4. **Monitor staging performance**
5. **Document staging-specific configurations**
6. **Use staging for demos and UAT**

---

## CI/CD Integration

Staging deployments can be triggered:
- Manually via Render dashboard
- Via GitHub Actions workflow
- Via API call

**GitHub Actions:**
```yaml
# .github/workflows/deploy-staging.yml
# Deploy to staging on push to develop branch
```

---

**Last Updated:** 2024-01-XX  
**Maintained By:** Unified Background Agent v3.0
