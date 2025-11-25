# Feature Flags Guide

**Last Updated:** 2024-01-XX  
**Purpose:** Guide for using feature flags in Agent Factory

---

## Overview

Feature flags allow you to enable or disable features without code changes. This is useful for:
- Gradual feature rollouts
- A/B testing
- Emergency feature disabling
- Environment-specific features

---

## Available Feature Flags

### Core Features

| Flag | Default | Description |
|------|---------|-------------|
| `blueprint_marketplace` | `true` | Enable blueprint marketplace functionality |
| `billing` | `true` | Enable billing and subscription features |
| `multi_tenant` | `true` | Enable multi-tenant features |
| `experiments` | `false` | Enable research experiments feature |
| `advanced_analytics` | `false` | Enable advanced analytics and reporting |
| `webhooks` | `true` | Enable webhook functionality |
| `sso` | `false` | Enable SSO authentication |

---

## Configuration

### Environment Variables

Set feature flags via environment variables:

```bash
# Enable a feature
FEATURE_BLUEPRINT_MARKETPLACE=true

# Disable a feature
FEATURE_BILLING=false

# Enable experiments
FEATURE_EXPERIMENTS=true
```

### .env File

```bash
# Feature Flags
FEATURE_BLUEPRINT_MARKETPLACE=true
FEATURE_BILLING=true
FEATURE_MULTI_TENANT=true
FEATURE_EXPERIMENTS=false
FEATURE_ADVANCED_ANALYTICS=false
FEATURE_WEBHOOKS=true
FEATURE_SSO=false
```

---

## Usage Examples

### Python Code

```python
from agent_factory.config.feature_flags import is_feature_enabled, blueprint_marketplace_enabled

# Check if feature is enabled
if is_feature_enabled("blueprint_marketplace"):
    # Marketplace code
    pass

# Using convenience functions
if blueprint_marketplace_enabled():
    # Marketplace code
    pass

# With default value
if is_feature_enabled("experiments", default=False):
    # Experiments code
    pass
```

### API Routes

```python
from fastapi import APIRouter
from agent_factory.config.feature_flags import is_feature_enabled

router = APIRouter()

@router.get("/marketplace")
async def get_marketplace():
    if not is_feature_enabled("blueprint_marketplace"):
        raise HTTPException(status_code=404, detail="Marketplace not available")
    
    # Marketplace logic
    return {"blueprints": [...]}
```

### Conditional Feature Loading

```python
from agent_factory.config.feature_flags import is_feature_enabled

# Conditionally import features
if is_feature_enabled("experiments"):
    from agent_factory.research.experiments import ExperimentRunner
    experiment_runner = ExperimentRunner()
```

### Feature Flag Checks

```python
from agent_factory.config.feature_flags import FeatureFlags

# Get all flags
all_flags = FeatureFlags.get_all_flags()
print(all_flags)
# {'blueprint_marketplace': True, 'billing': True, ...}

# Get flag info
info = FeatureFlags.get_flag_info("blueprint_marketplace")
print(info)
# {
#     'env_var': 'FEATURE_BLUEPRINT_MARKETPLACE',
#     'default': True,
#     'description': 'Enable blueprint marketplace functionality',
#     'enabled': True
# }
```

---

## Environment-Specific Configuration

### Development

```bash
# Enable all features for testing
FEATURE_BLUEPRINT_MARKETPLACE=true
FEATURE_BILLING=true
FEATURE_MULTI_TENANT=true
FEATURE_EXPERIMENTS=true
FEATURE_ADVANCED_ANALYTICS=true
FEATURE_WEBHOOKS=true
FEATURE_SSO=false
```

### Staging

```bash
# Enable features being tested
FEATURE_BLUEPRINT_MARKETPLACE=true
FEATURE_BILLING=true
FEATURE_MULTI_TENANT=true
FEATURE_EXPERIMENTS=true  # Testing experiments
FEATURE_ADVANCED_ANALYTICS=false
FEATURE_WEBHOOKS=true
FEATURE_SSO=false
```

### Production

```bash
# Only enable stable features
FEATURE_BLUEPRINT_MARKETPLACE=true
FEATURE_BILLING=true
FEATURE_MULTI_TENANT=true
FEATURE_EXPERIMENTS=false  # Not ready for production
FEATURE_ADVANCED_ANALYTICS=false  # Not ready
FEATURE_WEBHOOKS=true
FEATURE_SSO=false  # Not implemented yet
```

---

## Adding New Feature Flags

### 1. Define Flag in Code

Edit `agent_factory/config/feature_flags.py`:

```python
FLAGS = {
    # ... existing flags ...
    "new_feature": {
        "env_var": "FEATURE_NEW_FEATURE",
        "default": False,
        "description": "Enable new feature functionality"
    },
}
```

### 2. Add Convenience Function (Optional)

```python
def new_feature_enabled() -> bool:
    """Check if new feature is enabled."""
    return is_feature_enabled("new_feature")
```

### 3. Update Documentation

- Add flag to `.env.example`
- Update this documentation
- Document in feature-specific docs

### 4. Use in Code

```python
from agent_factory.config.feature_flags import is_feature_enabled

if is_feature_enabled("new_feature"):
    # New feature code
    pass
```

---

## Best Practices

1. **Always provide defaults** - Feature flags should have sensible defaults
2. **Document flags** - Add descriptions for each flag
3. **Use environment variables** - Don't hardcode flag values
4. **Test with flags disabled** - Ensure code works when flags are off
5. **Remove deprecated flags** - Clean up flags for removed features
6. **Monitor flag usage** - Track which flags are enabled in production

---

## Feature Flag Lifecycle

1. **Development** - Flag created, default `false`
2. **Testing** - Flag enabled in staging, tested
3. **Gradual Rollout** - Flag enabled for subset of users
4. **Full Rollout** - Flag enabled for all users
5. **Deprecation** - Flag default changed to `true`, code simplified
6. **Removal** - Flag removed, code always enabled

---

## Troubleshooting

### Feature Not Working

1. Check environment variable is set:
   ```bash
   echo $FEATURE_BLUEPRINT_MARKETPLACE
   ```

2. Verify flag is enabled:
   ```python
   from agent_factory.config.feature_flags import FeatureFlags
   print(FeatureFlags.get_flag_info("blueprint_marketplace"))
   ```

3. Check code is using flag correctly

### Flag Not Found

- Ensure flag is defined in `feature_flags.py`
- Check spelling of flag name
- Verify environment variable name matches

---

## API Endpoint (Future)

Future enhancement: Add API endpoint to check feature flags:

```http
GET /api/v1/feature-flags
GET /api/v1/feature-flags/{flag_name}
```

---

**Last Updated:** 2024-01-XX  
**Maintained By:** Unified Background Agent v3.0
