-- Supabase Row-Level Security (RLS) Policies for Agent Factory
-- 
-- These policies enforce multi-tenant data isolation at the database level.
-- Apply these policies after running migrations.
--
-- Usage:
--   1. Connect to your Supabase database
--   2. Run these SQL commands in the SQL Editor
--   3. Policies will be automatically enforced for all queries

-- Enable RLS on all tables
ALTER TABLE tenants ENABLE ROW LEVEL SECURITY;
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE agents ENABLE ROW LEVEL SECURITY;
ALTER TABLE workflows ENABLE ROW LEVEL SECURITY;
ALTER TABLE blueprints ENABLE ROW LEVEL SECURITY;
ALTER TABLE executions ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE api_keys ENABLE ROW LEVEL SECURITY;
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE usage_records ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- TENANTS TABLE
-- ============================================================================

-- Policy: Users can view their own tenant
CREATE POLICY "Users can view own tenant"
    ON tenants FOR SELECT
    USING (id IN (
        SELECT tenant_id FROM users WHERE id = auth.uid()::text
    ));

-- Policy: Service role can manage all tenants (for admin operations)
CREATE POLICY "Service role can manage tenants"
    ON tenants FOR ALL
    USING (auth.role() = 'service_role');

-- ============================================================================
-- USERS TABLE
-- ============================================================================

-- Policy: Users can view users in their tenant
CREATE POLICY "Users can view tenant users"
    ON users FOR SELECT
    USING (
        tenant_id IN (
            SELECT tenant_id FROM users WHERE id = auth.uid()::text
        )
    );

-- Policy: Users can update their own record
CREATE POLICY "Users can update own record"
    ON users FOR UPDATE
    USING (id = auth.uid()::text);

-- Policy: Service role can manage all users
CREATE POLICY "Service role can manage users"
    ON users FOR ALL
    USING (auth.role() = 'service_role');

-- ============================================================================
-- AGENTS TABLE
-- ============================================================================

-- Policy: Users can view agents in their tenant
CREATE POLICY "Users can view tenant agents"
    ON agents FOR SELECT
    USING (
        tenant_id IN (
            SELECT tenant_id FROM users WHERE id = auth.uid()::text
        )
    );

-- Policy: Users can create agents in their tenant
CREATE POLICY "Users can create tenant agents"
    ON agents FOR INSERT
    WITH CHECK (
        tenant_id IN (
            SELECT tenant_id FROM users WHERE id = auth.uid()::text
        )
    );

-- Policy: Users can update agents they created or in their tenant
CREATE POLICY "Users can update tenant agents"
    ON agents FOR UPDATE
    USING (
        tenant_id IN (
            SELECT tenant_id FROM users WHERE id = auth.uid()::text
        )
    );

-- Policy: Users can delete agents they created
CREATE POLICY "Users can delete own agents"
    ON agents FOR DELETE
    USING (
        created_by = auth.uid()::text AND
        tenant_id IN (
            SELECT tenant_id FROM users WHERE id = auth.uid()::text
        )
    );

-- ============================================================================
-- WORKFLOWS TABLE
-- ============================================================================

-- Policy: Users can view workflows in their tenant
CREATE POLICY "Users can view tenant workflows"
    ON workflows FOR SELECT
    USING (
        tenant_id IN (
            SELECT tenant_id FROM users WHERE id = auth.uid()::text
        )
    );

-- Policy: Users can create workflows in their tenant
CREATE POLICY "Users can create tenant workflows"
    ON workflows FOR INSERT
    WITH CHECK (
        tenant_id IN (
            SELECT tenant_id FROM users WHERE id = auth.uid()::text
        )
    );

-- Policy: Users can update workflows they created or in their tenant
CREATE POLICY "Users can update tenant workflows"
    ON workflows FOR UPDATE
    USING (
        tenant_id IN (
            SELECT tenant_id FROM users WHERE id = auth.uid()::text
        )
    );

-- Policy: Users can delete workflows they created
CREATE POLICY "Users can delete own workflows"
    ON workflows FOR DELETE
    USING (
        created_by = auth.uid()::text AND
        tenant_id IN (
            SELECT tenant_id FROM users WHERE id = auth.uid()::text
        )
    );

-- ============================================================================
-- BLUEPRINTS TABLE
-- ============================================================================

-- Policy: Public blueprints are visible to all authenticated users
CREATE POLICY "Users can view public blueprints"
    ON blueprints FOR SELECT
    USING (is_public = true);

-- Policy: Users can view their own blueprints
CREATE POLICY "Users can view own blueprints"
    ON blueprints FOR SELECT
    USING (publisher_id = auth.uid()::text);

-- Policy: Users can create blueprints
CREATE POLICY "Users can create blueprints"
    ON blueprints FOR INSERT
    WITH CHECK (publisher_id = auth.uid()::text);

-- Policy: Users can update their own blueprints
CREATE POLICY "Users can update own blueprints"
    ON blueprints FOR UPDATE
    USING (publisher_id = auth.uid()::text);

-- Policy: Users can delete their own blueprints
CREATE POLICY "Users can delete own blueprints"
    ON blueprints FOR DELETE
    USING (publisher_id = auth.uid()::text);

-- ============================================================================
-- EXECUTIONS TABLE
-- ============================================================================

-- Policy: Users can view executions in their tenant
CREATE POLICY "Users can view tenant executions"
    ON executions FOR SELECT
    USING (
        tenant_id IN (
            SELECT tenant_id FROM users WHERE id = auth.uid()::text
        )
    );

-- Policy: Users can create executions in their tenant
CREATE POLICY "Users can create tenant executions"
    ON executions FOR INSERT
    WITH CHECK (
        tenant_id IN (
            SELECT tenant_id FROM users WHERE id = auth.uid()::text
        )
    );

-- Policy: Users can update executions in their tenant
CREATE POLICY "Users can update tenant executions"
    ON executions FOR UPDATE
    USING (
        tenant_id IN (
            SELECT tenant_id FROM users WHERE id = auth.uid()::text
        )
    );

-- ============================================================================
-- API KEYS TABLE
-- ============================================================================

-- Policy: Users can view their own API keys
CREATE POLICY "Users can view own API keys"
    ON api_keys FOR SELECT
    USING (user_id = auth.uid()::text);

-- Policy: Users can create API keys for themselves
CREATE POLICY "Users can create own API keys"
    ON api_keys FOR INSERT
    WITH CHECK (user_id = auth.uid()::text);

-- Policy: Users can update their own API keys
CREATE POLICY "Users can update own API keys"
    ON api_keys FOR UPDATE
    USING (user_id = auth.uid()::text);

-- Policy: Users can delete their own API keys
CREATE POLICY "Users can delete own API keys"
    ON api_keys FOR DELETE
    USING (user_id = auth.uid()::text);

-- ============================================================================
-- PROJECTS TABLE
-- ============================================================================

-- Policy: Users can view projects in their tenant
CREATE POLICY "Users can view tenant projects"
    ON projects FOR SELECT
    USING (
        tenant_id IN (
            SELECT tenant_id FROM users WHERE id = auth.uid()::text
        )
    );

-- Policy: Users can create projects in their tenant
CREATE POLICY "Users can create tenant projects"
    ON projects FOR INSERT
    WITH CHECK (
        tenant_id IN (
            SELECT tenant_id FROM users WHERE id = auth.uid()::text
        )
    );

-- Policy: Users can update projects in their tenant
CREATE POLICY "Users can update tenant projects"
    ON projects FOR UPDATE
    USING (
        tenant_id IN (
            SELECT tenant_id FROM users WHERE id = auth.uid()::text
        )
    );

-- ============================================================================
-- PLANS TABLE
-- ============================================================================

-- Policy: All authenticated users can view plans (public pricing)
CREATE POLICY "Users can view plans"
    ON plans FOR SELECT
    USING (is_active = true);

-- Policy: Service role can manage plans
CREATE POLICY "Service role can manage plans"
    ON plans FOR ALL
    USING (auth.role() = 'service_role');

-- ============================================================================
-- SUBSCRIPTIONS TABLE
-- ============================================================================

-- Policy: Users can view subscriptions for their tenant
CREATE POLICY "Users can view tenant subscriptions"
    ON subscriptions FOR SELECT
    USING (
        tenant_id IN (
            SELECT tenant_id FROM users WHERE id = auth.uid()::text
        )
    );

-- Policy: Service role can manage subscriptions
CREATE POLICY "Service role can manage subscriptions"
    ON subscriptions FOR ALL
    USING (auth.role() = 'service_role');

-- ============================================================================
-- USAGE RECORDS TABLE
-- ============================================================================

-- Policy: Users can view usage records for their tenant
CREATE POLICY "Users can view tenant usage records"
    ON usage_records FOR SELECT
    USING (
        tenant_id IN (
            SELECT tenant_id FROM users WHERE id = auth.uid()::text
        )
    );

-- Policy: Service role can manage usage records
CREATE POLICY "Service role can manage usage records"
    ON usage_records FOR ALL
    USING (auth.role() = 'service_role');

-- ============================================================================
-- AUDIT LOGS TABLE
-- ============================================================================

-- Policy: Users can view audit logs for their tenant
CREATE POLICY "Users can view tenant audit logs"
    ON audit_logs FOR SELECT
    USING (
        user_id = auth.uid()::text OR
        EXISTS (
            SELECT 1 FROM users
            WHERE users.id = auth.uid()::text
            AND users.tenant_id = audit_logs.tenant_id
        )
    );

-- Policy: Service role can manage all audit logs
CREATE POLICY "Service role can manage audit logs"
    ON audit_logs FOR ALL
    USING (auth.role() = 'service_role');

-- ============================================================================
-- NOTES
-- ============================================================================

-- These policies assume:
-- 1. Supabase Auth is being used (auth.uid() function)
-- 2. User IDs in the users table match Supabase auth user IDs
-- 3. Service role key is used for admin/backend operations
--
-- To use these policies:
-- 1. Ensure user.id matches auth.uid() when users are created
-- 2. Use service_role key for backend operations that need to bypass RLS
-- 3. Use anon key for client-side operations that should respect RLS
--
-- For more information, see:
-- https://supabase.com/docs/guides/auth/row-level-security
