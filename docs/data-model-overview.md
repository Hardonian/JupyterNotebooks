# Data Model Overview

**Last Updated:** 2024-01-01  
**Database:** PostgreSQL (primary), SQLite (development)  
**ORM:** SQLAlchemy

---

## Schema Summary

The Agent Factory platform uses a **multi-tenant SaaS architecture** with the following core entities:

- **Identity & Access:** Users, Tenants, API Keys
- **Core Resources:** Agents, Workflows, Blueprints, Projects
- **Execution:** Executions (runs)
- **Billing:** Plans, Subscriptions, Usage Records
- **Audit:** Audit Logs

**Total Tables:** 12

---

## Table Descriptions

### 1. `tenants`

Multi-tenant organization container.

| Column | Type | Description |
|--------|------|-------------|
| `id` | String (PK) | Unique tenant identifier |
| `name` | String | Tenant/organization name |
| `slug` | String (unique) | URL-friendly identifier |
| `is_active` | Boolean | Active status |
| `plan` | String | Current plan (free, pro, enterprise) |
| `resource_quota` | JSON | Resource limits (e.g., `{"agents": 10}`) |
| `usage` | JSON | Current usage (e.g., `{"agents": 3}`) |
| `created_at` | DateTime | Creation timestamp |
| `updated_at` | DateTime | Last update timestamp |

**Relationships:**
- One-to-many: `users`, `agents`, `workflows`, `blueprints`, `executions`, `api_keys`, `projects`, `subscriptions`, `usage_records`

**Indexes:**
- `ix_tenants_slug` (unique)

---

### 2. `users`

User accounts within tenants.

| Column | Type | Description |
|--------|------|-------------|
| `id` | String (PK) | Unique user identifier |
| `email` | String (unique) | User email address |
| `hashed_password` | String | Bcrypt-hashed password |
| `is_active` | Boolean | Account active status |
| `is_superuser` | Boolean | Admin privileges |
| `tenant_id` | String (FK) | Associated tenant |
| `roles` | JSON | User roles array |
| `permissions` | JSON | User permissions array |
| `created_at` | DateTime | Creation timestamp |
| `updated_at` | DateTime | Last update timestamp |

**Relationships:**
- Many-to-one: `tenant` (Tenant)
- One-to-many: `agents` (via `created_by`), `workflows`, `blueprints`, `executions`, `api_keys`, `projects`, `audit_logs`

**Indexes:**
- `ix_users_email` (unique)

---

### 3. `agents`

AI agent definitions.

| Column | Type | Description |
|--------|------|-------------|
| `id` | String (PK) | Unique agent identifier |
| `name` | String | Agent display name |
| `instructions` | Text | Agent system instructions |
| `model` | String | LLM model (e.g., "gpt-4o") |
| `tenant_id` | String (FK) | Owner tenant |
| `created_by` | String (FK) | Creator user |
| `created_at` | DateTime | Creation timestamp |
| `updated_at` | DateTime | Last update timestamp |

**Relationships:**
- Many-to-one: `tenant` (Tenant), `creator` (User)
- One-to-many: `executions` (via `resource_id` where `execution_type='agent'`)

**Note:** Model uses `created_by`, but migration uses `user_id`. Migration should be updated.

---

### 4. `workflows`

Workflow/orchestration definitions.

| Column | Type | Description |
|--------|------|-------------|
| `id` | String (PK) | Unique workflow identifier |
| `name` | String | Workflow display name |
| `definition` | JSON | Workflow structure (nodes, edges, etc.) |
| `tenant_id` | String (FK) | Owner tenant |
| `created_by` | String (FK) | Creator user |
| `created_at` | DateTime | Creation timestamp |
| `updated_at` | DateTime | Last update timestamp |

**Relationships:**
- Many-to-one: `tenant` (Tenant), `creator` (User)
- One-to-many: `executions` (via `resource_id` where `execution_type='workflow'`)

**Note:** Migration includes `description` field, but model doesn't. Migration should be updated.

---

### 5. `blueprints`

Reusable agent/workflow templates (marketplace items).

| Column | Type | Description |
|--------|------|-------------|
| `id` | String (PK) | Unique blueprint identifier |
| `name` | String | Blueprint display name |
| `description` | Text | Blueprint description |
| `version` | String | Version string |
| `definition` | JSON | Blueprint configuration |
| `pricing_model` | String | free, one-time, subscription |
| `price` | Float | Price amount |
| `publisher_id` | String (FK) | Publisher user |
| `is_public` | Boolean | Public visibility |
| `downloads` | Integer | Download count |
| `rating` | Float | Average rating |
| `reviews_count` | Integer | Number of reviews |
| `created_at` | DateTime | Creation timestamp |
| `updated_at` | DateTime | Last update timestamp |

**Relationships:**
- Many-to-one: `publisher` (User)

**Note:** Migration is missing many fields (`pricing_model`, `price`, `publisher_id`, `is_public`, `downloads`, `rating`, `reviews_count`). Migration should be updated.

---

### 6. `executions`

Execution records for agents and workflows.

| Column | Type | Description |
|--------|------|-------------|
| `id` | String (PK) | Unique execution identifier |
| `execution_type` | String | "agent" or "workflow" |
| `resource_id` | String | ID of agent or workflow |
| `status` | String | pending, running, completed, failed |
| `input_data` | JSON | Input parameters |
| `output_data` | JSON | Output/result data |
| `error` | Text | Error message (if failed) |
| `execution_time` | Float | Duration in seconds |
| `tenant_id` | String (FK) | Owner tenant |
| `created_by` | String (FK) | Creator user |
| `created_at` | DateTime | Creation timestamp |
| `completed_at` | DateTime | Completion timestamp |

**Relationships:**
- Many-to-one: `tenant` (Tenant), `creator` (User)

**Note:** Migration uses `type` instead of `execution_type`, `entity_id` instead of `resource_id`, `result` instead of `output_data`. Migration should be updated.

---

### 7. `audit_logs`

Security and compliance audit trail.

| Column | Type | Description |
|--------|------|-------------|
| `id` | Integer (PK, auto) | Unique log identifier |
| `event_type` | String | Event type |
| `user_id` | String (FK) | User who triggered event |
| `resource_type` | String | Resource type (e.g., "agent") |
| `resource_id` | String | Resource identifier |
| `action` | String | Action performed |
| `success` | Boolean | Success status |
| `details` | JSON | Additional event data |
| `ip_address` | String | Client IP address |
| `created_at` | DateTime | Event timestamp |

**Relationships:**
- Many-to-one: `user` (User)

**Indexes:**
- `ix_audit_logs_created_at` (for time-based queries)

**Note:** Migration uses `String` for `id`, but model uses `Integer` with autoincrement. Migration uses `metadata` instead of `details`, and doesn't include `ip_address`. Migration should be updated.

---

### 8. `api_keys`

API authentication keys for programmatic access.

| Column | Type | Description |
|--------|------|-------------|
| `id` | String (PK) | Unique key identifier |
| `key_hash` | String (unique) | Hashed API key |
| `name` | String | Key display name |
| `tenant_id` | String (FK) | Owner tenant |
| `user_id` | String (FK) | Owner user |
| `permissions` | JSON | Permissions array |
| `last_used_at` | DateTime | Last usage timestamp |
| `expires_at` | DateTime | Expiration timestamp |
| `is_active` | Boolean | Active status |
| `created_at` | DateTime | Creation timestamp |
| `updated_at` | DateTime | Last update timestamp |

**Relationships:**
- Many-to-one: `tenant` (Tenant), `user` (User)

**Indexes:**
- `ix_api_keys_key_hash` (unique)

---

### 9. `projects`

Project/App containers for organizing resources.

| Column | Type | Description |
|--------|------|-------------|
| `id` | String (PK) | Unique project identifier |
| `name` | String | Project display name |
| `project_type` | String | saas_app, blueprint_deployment, etc. |
| `tenant_id` | String (FK) | Owner tenant |
| `created_by` | String (FK) | Creator user |
| `config` | JSON | Project configuration |
| `is_active` | Boolean | Active status |
| `created_at` | DateTime | Creation timestamp |
| `updated_at` | DateTime | Last update timestamp |

**Relationships:**
- Many-to-one: `tenant` (Tenant), `creator` (User)

**Status:** ❌ **NOT IN MIGRATION** - Must be added.

---

### 10. `plans`

Billing plan definitions.

| Column | Type | Description |
|--------|------|-------------|
| `id` | String (PK) | Unique plan identifier |
| `name` | String | Plan display name |
| `plan_type` | String | free, pro, enterprise |
| `price_monthly` | Float | Monthly price |
| `price_yearly` | Float | Yearly price |
| `currency` | String | Currency code (default: USD) |
| `features` | JSON | Feature flags |
| `limits` | JSON | Resource limits |
| `is_active` | Boolean | Active status |
| `created_at` | DateTime | Creation timestamp |
| `updated_at` | DateTime | Last update timestamp |

**Relationships:**
- One-to-many: `subscriptions`

**Status:** ❌ **NOT IN MIGRATION** - Must be added.

---

### 11. `subscriptions`

Tenant subscription records.

| Column | Type | Description |
|--------|------|-------------|
| `id` | String (PK) | Unique subscription identifier |
| `tenant_id` | String (FK) | Subscriber tenant |
| `plan_id` | String (FK) | Subscribed plan |
| `status` | String | active, cancelled, expired |
| `billing_cycle` | String | monthly, yearly |
| `current_period_start` | DateTime | Current billing period start |
| `current_period_end` | DateTime | Current billing period end |
| `stripe_subscription_id` | String | Stripe subscription ID |
| `stripe_customer_id` | String | Stripe customer ID |
| `created_at` | DateTime | Creation timestamp |
| `updated_at` | DateTime | Last update timestamp |

**Relationships:**
- Many-to-one: `tenant` (Tenant), `plan` (Plan)
- One-to-many: `usage_records`

**Status:** ❌ **NOT IN MIGRATION** - Must be added.

---

### 12. `usage_records`

Usage tracking for billing and analytics.

| Column | Type | Description |
|--------|------|-------------|
| `id` | String (PK) | Unique record identifier |
| `tenant_id` | String (FK) | Tenant |
| `subscription_id` | String (FK) | Associated subscription |
| `billing_unit` | String | agent_run, workflow_run, token, etc. |
| `quantity` | Float | Usage quantity |
| `unit_price` | Float | Price per unit |
| `total_cost` | Float | Total cost |
| `currency` | String | Currency code (default: USD) |
| `period_start` | DateTime | Billing period start |
| `period_end` | DateTime | Billing period end |
| `created_at` | DateTime | Creation timestamp |

**Relationships:**
- Many-to-one: `tenant` (Tenant), `subscription` (Subscription)

**Status:** ❌ **NOT IN MIGRATION** - Must be added.

---

## Entity Relationship Diagram (Text)

```
tenants (1) ──< (N) users
tenants (1) ──< (N) agents
tenants (1) ──< (N) workflows
tenants (1) ──< (N) executions
tenants (1) ──< (N) api_keys
tenants (1) ──< (N) projects
tenants (1) ──< (N) subscriptions

users (1) ──< (N) agents (via created_by)
users (1) ──< (N) workflows (via created_by)
users (1) ──< (N) blueprints (via publisher_id)
users (1) ──< (N) executions (via created_by)
users (1) ──< (N) api_keys
users (1) ──< (N) projects (via created_by)
users (1) ──< (N) audit_logs

plans (1) ──< (N) subscriptions
subscriptions (1) ──< (N) usage_records
```

---

## Key Design Patterns

### Multi-Tenancy

- **Tenant Isolation:** All resources are scoped to `tenant_id`
- **User-Tenant Relationship:** Users belong to a tenant (many-to-one)
- **Resource Ownership:** Agents, workflows, executions are tenant-scoped

### Soft Deletes

- **Status Flags:** `is_active` on tenants, users, projects, api_keys
- **No Hard Deletes:** Prefer deactivation over deletion for audit trail

### JSON Columns

- **Flexibility:** `config`, `definition`, `permissions`, `features`, `limits` use JSON
- **PostgreSQL:** Native JSONB support for efficient querying
- **SQLite:** JSON stored as text (acceptable for dev)

### Timestamps

- **Standard Fields:** `created_at`, `updated_at` on most tables
- **Event Timestamps:** `completed_at` on executions, `last_used_at` on api_keys

---

## Migration Status

### ✅ In Migration
- users
- tenants
- agents
- workflows
- blueprints (partial)
- executions (partial)
- audit_logs (partial)
- api_keys

### ❌ Missing from Migration
- projects
- plans
- subscriptions
- usage_records

### ⚠️ Schema Mismatches
- agents: `user_id` vs `created_by`
- executions: `type` vs `execution_type`, `entity_id` vs `resource_id`, `result` vs `output_data`
- blueprints: Missing marketplace fields
- audit_logs: `id` type mismatch, `metadata` vs `details`, missing `ip_address`

**Action Required:** See `docs/migrations-workflow.md` for consolidation plan.
