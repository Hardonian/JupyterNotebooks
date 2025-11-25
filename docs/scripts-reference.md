# Scripts Reference Guide

**Last Updated:** 2024-01-XX  
**Purpose:** Complete reference for all scripts in the Agent Factory repository

---

## Overview

All scripts are located in the `scripts/` directory and are designed to help with development, deployment, and maintenance tasks.

---

## Database Scripts

### `db-validate-schema.py`

**Purpose:** Validate database schema matches expected structure

**Usage:**
```bash
python scripts/db-validate-schema.py
```

**What it checks:**
- Core tables exist
- Required columns present
- Indexes created
- Foreign keys correct
- Migration revision

**Environment:**
- `DATABASE_URL` - Database connection string

**Exit codes:**
- `0` - Schema valid
- `1` - Schema invalid or connection failed

---

### `db-migrate-local.sh`

**Purpose:** Run database migrations for local development

**Usage:**
```bash
./scripts/db-migrate-local.sh
```

**What it does:**
- Checks DATABASE_URL is set
- Runs `alembic upgrade head`
- Validates schema after migration

---

### `db-migrate-prod.sh`

**Purpose:** Run database migrations for production

**Usage:**
```bash
./scripts/db-migrate-prod.sh
```

**What it does:**
- Validates environment
- Creates backup (if configured)
- Runs migrations
- Validates schema
- Reports status

**⚠️ Warning:** Use with caution in production

---

### `db-seed-demo.py`

**Purpose:** Seed database with demo data

**Usage:**
```bash
python scripts/db-seed-demo.py
```

**What it creates:**
- Demo tenants
- Demo users
- Demo agents
- Demo workflows
- Demo blueprints

**Options:**
- `--reset` - Drop existing data before seeding
- `--tenant-id` - Seed specific tenant only

---

### `db-validate-schema.py`

**Purpose:** Validate database schema

**Usage:**
```bash
python scripts/db-validate-schema.py
```

**See:** Database Scripts section above

---

## Environment Scripts

### `env-doctor.py`

**Purpose:** Check environment variable consistency

**Usage:**
```bash
python scripts/env-doctor.py
python scripts/env-doctor.py --check  # Only check, don't fix
```

**What it checks:**
- Variables in `.env.example` but not used
- Variables used but not in `.env.example`
- Naming inconsistencies
- CI workflow secrets

**Output:**
- Lists unused variables
- Lists missing variables
- Identifies naming issues

---

## Documentation Scripts

### `doc-sync.py`

**Purpose:** Check documentation synchronization

**Usage:**
```bash
python scripts/doc-sync.py --check
python scripts/doc-sync.py --fix  # Not yet implemented
```

**What it checks:**
- API documentation matches endpoints
- Environment variable documentation matches `.env.example`
- Schema documentation matches models
- CI/CD documentation matches workflows

---

## Deployment Scripts

### `deploy-automation.sh`

**Purpose:** Automated deployment script

**Usage:**
```bash
./scripts/deploy-automation.sh [environment]
```

**Environments:**
- `staging` - Deploy to staging
- `production` - Deploy to production

**What it does:**
- Runs tests
- Builds Docker image
- Deploys to target environment
- Runs smoke tests

---

### `health-check.sh`

**Purpose:** Check service health

**Usage:**
```bash
./scripts/health-check.sh [url]
```

**Default URL:** `http://localhost:8000`

**What it checks:**
- Health endpoint (`/health`)
- Readiness endpoint (`/ready`)
- Liveness endpoint (`/live`)

---

### `smoke-tests.sh`

**Purpose:** Run smoke tests after deployment

**Usage:**
```bash
./scripts/smoke-tests.sh [api_url]
```

**Default URL:** `http://localhost:8000`

**What it tests:**
- Health endpoints
- API endpoints
- Database connectivity
- Basic functionality

---

## Development Scripts

### `dev_setup.sh`

**Purpose:** Set up development environment

**Usage:**
```bash
./scripts/dev_setup.sh
```

**What it does:**
- Creates virtual environment
- Installs dependencies
- Sets up pre-commit hooks
- Creates `.env` from `.env.example`
- Runs initial migrations

---

### `onboard.sh`

**Purpose:** Onboarding script for new developers

**Usage:**
```bash
./scripts/onboard.sh
```

**What it does:**
- Checks prerequisites
- Sets up environment
- Runs tests
- Provides next steps

---

### `quick_test.sh`

**Purpose:** Quick test runner

**Usage:**
```bash
./scripts/quick_test.sh
```

**What it runs:**
- Unit tests (fast)
- Linting
- Type checking

---

## Monitoring Scripts

### `monitor-api.sh`

**Purpose:** Monitor API performance

**Usage:**
```bash
./scripts/monitor-api.sh [api_url]
```

**What it monitors:**
- Response times
- Error rates
- Health status

---

## Automation Scripts

### `backup-automation.sh`

**Purpose:** Automated backup script

**Usage:**
```bash
./scripts/backup-automation.sh
```

**What it does:**
- Creates database backup
- Uploads to storage (if configured)
- Cleans old backups

---

### `test-deployment-workflows.sh`

**Purpose:** Test deployment workflows

**Usage:**
```bash
./scripts/test-deployment-workflows.sh
```

**What it tests:**
- Docker builds
- Kubernetes manifests
- Deployment configs

---

## Utility Scripts

### `update_dependencies.sh`

**Purpose:** Update Python dependencies

**Usage:**
```bash
./scripts/update_dependencies.sh
```

**What it does:**
- Checks for outdated packages
- Updates `pyproject.toml`
- Tests after update

---

### `test-seed-script.sh`

**Purpose:** Test seed script

**Usage:**
```bash
./scripts/test-seed-script.sh
```

**What it does:**
- Tests seed script
- Validates seeded data
- Cleans up after test

---

## Script Execution

### Making Scripts Executable

```bash
chmod +x scripts/*.sh
```

### Running Python Scripts

```bash
# Direct execution
python scripts/script_name.py

# With arguments
python scripts/script_name.py --arg value

# As module
python -m scripts.script_name
```

---

## Script Development Guidelines

### Python Scripts

1. **Shebang:** `#!/usr/bin/env python3`
2. **Docstring:** Describe purpose and usage
3. **Error handling:** Use try/except, exit codes
4. **Logging:** Use logging module, not print
5. **Arguments:** Use argparse for CLI args

### Shell Scripts

1. **Shebang:** `#!/bin/bash`
2. **Error handling:** `set -e` for fail-fast
3. **Variables:** Quote variables
4. **Functions:** Use functions for reusability

---

## Common Patterns

### Environment Variable Check

```bash
if [ -z "$DATABASE_URL" ]; then
    echo "Error: DATABASE_URL not set"
    exit 1
fi
```

### Python Script Template

```python
#!/usr/bin/env python3
"""Script description."""

import sys
from pathlib import Path

# Add project root to path
project_root = Path(__file__).parent.parent
sys.path.insert(0, str(project_root))

def main():
    """Main function."""
    # Script logic
    pass

if __name__ == '__main__':
    sys.exit(main())
```

---

## Troubleshooting

### Script Not Found

- Check script exists: `ls scripts/script_name.sh`
- Check executable: `chmod +x scripts/script_name.sh`
- Use full path: `./scripts/script_name.sh`

### Permission Denied

```bash
chmod +x scripts/script_name.sh
```

### Python Import Errors

- Ensure project root is in PYTHONPATH
- Check virtual environment is activated
- Verify dependencies installed

---

**Last Updated:** 2024-01-XX  
**Maintained By:** Unified Background Agent v3.0
