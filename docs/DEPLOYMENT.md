# Agent Factory Platform - Deployment Guide

## Overview

This guide covers deploying Agent Factory Platform to production environments, including Docker, Kubernetes, and cloud platforms.

---

## Prerequisites

- Python 3.8+ (if running directly)
- Docker & Docker Compose (for containerized deployment)
- PostgreSQL 12+ (or SQLite for development)
- Redis 6+ (optional, for caching)
- Environment variables configured

---

## Quick Start (Development)

### Using Docker Compose

```bash
# Clone repository
git clone https://github.com/agentfactory/platform.git
cd platform

# Copy environment file
cp .env.example .env

# Edit .env with your configuration
nano .env

# Start services
docker-compose up -d

# Check health
curl http://localhost:8000/health
```

### Direct Python Installation

```bash
# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install package
pip install -e ".[dev]"

# Set environment variables
export OPENAI_API_KEY=your-key
export DATABASE_URL=postgresql://user:pass@localhost/db

# Run API server
uvicorn agent_factory.api.main:app --host 0.0.0.0 --port 8000
```

---

## Production Deployment

### Docker Deployment

#### Build Image

```bash
docker build -t agent-factory:latest .
```

#### Run Container

```bash
docker run -d \
  --name agent-factory \
  -p 8000:8000 \
  -e OPENAI_API_KEY=your-key \
  -e DATABASE_URL=postgresql://user:pass@host/db \
  -e REDIS_URL=redis://host:6379/0 \
  agent-factory:latest
```

### Kubernetes Deployment

#### Prerequisites

- Kubernetes cluster
- kubectl configured
- Helm (optional)

#### Deploy

```bash
# Apply namespace
kubectl apply -f k8s/namespace.yaml

# Apply secrets (create secret.yaml first)
kubectl apply -f k8s/secret.yaml

# Apply configmap
kubectl apply -f k8s/configmap.yaml

# Deploy PostgreSQL
kubectl apply -f k8s/postgres-deployment.yaml

# Deploy Redis
kubectl apply -f k8s/redis-deployment.yaml

# Deploy API
kubectl apply -f k8s/api-deployment.yaml

# Apply ingress
kubectl apply -f k8s/ingress.yaml
```

#### Health Checks

Kubernetes uses the following endpoints:
- **Liveness**: `/live` - Returns 200 if process is alive
- **Readiness**: `/ready` - Returns 200 if ready to serve traffic
- **Health**: `/health` - Comprehensive health check

---

## Environment Configuration

### Required Variables

```bash
# LLM Providers (at least one required)
OPENAI_API_KEY=sk-...
ANTHROPIC_API_KEY=sk-ant-...

# Database
DATABASE_URL=postgresql://user:password@host:5432/dbname

# Security
JWT_SECRET_KEY=your-secret-key-change-in-production
```

### Optional Variables

```bash
# API Configuration
API_HOST=0.0.0.0
API_PORT=8000
DEBUG=false

# Cache
REDIS_URL=redis://localhost:6379/0

# Logging
LOG_LEVEL=INFO
LOG_FORMAT=json

# Rate Limiting
RATE_LIMIT_PER_MINUTE=60
RATE_LIMIT_PER_HOUR=1000

# CORS
CORS_ORIGINS=http://localhost:3000,https://yourdomain.com
```

### Production Checklist

- [ ] Set `DEBUG=false`
- [ ] Use strong `JWT_SECRET_KEY`
- [ ] Configure production database
- [ ] Set up Redis for caching
- [ ] Configure CORS origins
- [ ] Set up monitoring/alerting
- [ ] Enable HTTPS/TLS
- [ ] Configure backup strategy
- [ ] Set up log aggregation
- [ ] Configure rate limiting

---

## Database Setup

### PostgreSQL

```sql
-- Create database
CREATE DATABASE agentfactory;

-- Create user (optional)
CREATE USER agentfactory WITH PASSWORD 'secure-password';
GRANT ALL PRIVILEGES ON DATABASE agentfactory TO agentfactory;
```

The application will automatically create tables on first startup.

### SQLite (Development Only)

```bash
# SQLite is used automatically if DATABASE_URL starts with sqlite://
DATABASE_URL=sqlite:///./agent_factory.db
```

**Note**: SQLite is not recommended for production.

---

## Monitoring & Observability

### Health Endpoints

- **GET /health**: Comprehensive health check
- **GET /ready**: Readiness probe
- **GET /live**: Liveness probe

### Metrics

Prometheus metrics available at `/metrics` (if enabled).

### Logging

Structured JSON logs to stdout. Configure log aggregation (e.g., ELK, Loki) to collect logs.

---

## Scaling

### Horizontal Scaling

The API is stateless and can be scaled horizontally:

```bash
# Scale API replicas
kubectl scale deployment agent-factory-api --replicas=3
```

### Database Scaling

- Use connection pooling (configured in SQLAlchemy)
- Consider read replicas for read-heavy workloads
- Use database indexes for performance

### Cache Scaling

- Redis can be scaled using Redis Cluster
- Configure Redis persistence for durability

---

## Security Best Practices

1. **Secrets Management**
   - Use Kubernetes secrets or secret management service
   - Never commit secrets to git
   - Rotate secrets regularly

2. **Network Security**
   - Use HTTPS/TLS in production
   - Configure firewall rules
   - Use private networks where possible

3. **Authentication**
   - Use strong JWT secrets
   - Implement rate limiting
   - Use API keys for programmatic access

4. **Input Validation**
   - All inputs validated via Pydantic
   - Guardrails enabled by default
   - Path validation for file operations

---

## Backup & Recovery

### Database Backups

```bash
# PostgreSQL backup
pg_dump -h host -U user -d agentfactory > backup.sql

# Restore
psql -h host -U user -d agentfactory < backup.sql
```

### Automated Backups

Set up cron job or Kubernetes CronJob for regular backups.

---

## Troubleshooting

### Common Issues

1. **Database Connection Failed**
   - Check DATABASE_URL format
   - Verify database is accessible
   - Check firewall rules

2. **Redis Connection Failed**
   - Check REDIS_URL format
   - Verify Redis is running
   - Cache will degrade gracefully if Redis unavailable

3. **LLM API Errors**
   - Verify API keys are set
   - Check API rate limits
   - Verify network connectivity

### Debug Mode

Enable debug mode for detailed error messages:

```bash
DEBUG=true LOG_LEVEL=DEBUG
```

**Warning**: Never enable debug mode in production.

---

## Cloud Platform Guides

### AWS (ECS/EKS)

See `deployment/aws/` for AWS-specific configurations.

### Google Cloud (GKE)

See `deployment/gcp/` for GCP-specific configurations.

### Azure (AKS)

See `deployment/azure/` for Azure-specific configurations.

---

## CI/CD Integration

### GitHub Actions

Example workflow:

```yaml
name: Deploy
on:
  push:
    branches: [main]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Build and push
        # Build and push Docker image
      - name: Deploy
        # Deploy to production
```

---

## Performance Tuning

### Database

- Add indexes for frequently queried fields
- Use connection pooling
- Consider read replicas

### Cache

- Enable Redis caching
- Set appropriate TTLs
- Monitor cache hit rates

### API

- Use gunicorn with multiple workers
- Configure appropriate timeouts
- Enable request compression

---

**Last Updated**: 2024-01-XX  
**Version**: 0.1.0
