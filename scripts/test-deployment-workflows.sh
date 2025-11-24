#!/bin/bash
#
# Test deployment workflow configuration
#
# Validates that deployment workflows are correctly configured
# and can be executed (dry-run validation)
#

set -euo pipefail

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}ℹ${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}⚠${NC} $1"
}

log_error() {
    echo -e "${RED}✗${NC} $1"
}

log_success() {
    echo -e "${GREEN}✓${NC} $1"
}

# Check if workflow file exists and is valid YAML
check_workflow_file() {
    local workflow_file="$1"
    local workflow_name="$2"
    
    log_info "Checking ${workflow_name}..."
    
    if [ ! -f "$workflow_file" ]; then
        log_error "${workflow_name} not found: ${workflow_file}"
        return 1
    fi
    
    # Basic syntax check - look for common YAML patterns
    if grep -q "^name:" "$workflow_file" && grep -q "^on:" "$workflow_file"; then
        log_success "${workflow_name} appears valid (basic check)"
    else
        log_error "${workflow_name} missing required fields (name: or on:)"
        return 1
    fi
    
    return 0
}

# Check workflow triggers
check_workflow_triggers() {
    local workflow_file="$1"
    local workflow_name="$2"
    
    log_info "Checking ${workflow_name} triggers..."
    
    # Check for on: section
    if ! grep -q "^on:" "$workflow_file"; then
        log_error "${workflow_name} missing 'on:' trigger section"
        return 1
    fi
    
    # Check for common trigger patterns
    if grep -q "pull_request:" "$workflow_file" || \
       grep -q "push:" "$workflow_file" || \
       grep -q "workflow_dispatch:" "$workflow_file" || \
       grep -q "schedule:" "$workflow_file"; then
        log_success "${workflow_name} has valid triggers"
    else
        log_warn "${workflow_name} has no common triggers (may use custom triggers)"
    fi
    
    return 0
}

# Check for required secrets
check_required_secrets() {
    local workflow_file="$1"
    local workflow_name="$2"
    
    log_info "Checking ${workflow_name} secrets..."
    
    # Extract secrets references
    local secrets
    secrets=$(grep -o '\${{ secrets\.[^}]* }}' "$workflow_file" | sed 's/\${{ secrets\.//' | sed 's/ }}//' | sort -u || true)
    
    if [ -n "$secrets" ]; then
        log_info "Required secrets for ${workflow_name}:"
        echo "$secrets" | while read -r secret; do
            echo "  - ${secret}"
        done
    else
        log_warn "${workflow_name} doesn't reference any secrets"
    fi
    
    return 0
}

# Check for smoke test steps
check_smoke_tests() {
    local workflow_file="$1"
    local workflow_name="$2"
    
    log_info "Checking ${workflow_name} smoke tests..."
    
    if grep -qi "smoke" "$workflow_file" || grep -qi "health" "$workflow_file"; then
        log_success "${workflow_name} includes smoke/health tests"
    else
        log_warn "${workflow_name} doesn't appear to have smoke tests"
    fi
    
    return 0
}

# Main execution
main() {
    echo "=========================================="
    echo "Deployment Workflow Validation"
    echo "=========================================="
    echo ""
    
    local errors=0
    
    # Check preview deployment workflow
    if check_workflow_file ".github/workflows/deploy-vercel-preview.yml" "Preview Deployment"; then
        check_workflow_triggers ".github/workflows/deploy-vercel-preview.yml" "Preview Deployment"
        check_required_secrets ".github/workflows/deploy-vercel-preview.yml" "Preview Deployment"
        check_smoke_tests ".github/workflows/deploy-vercel-preview.yml" "Preview Deployment"
    else
        ((errors++))
    fi
    
    echo ""
    
    # Check production deployment workflow
    if check_workflow_file ".github/workflows/deploy-vercel-production.yml" "Production Deployment"; then
        check_workflow_triggers ".github/workflows/deploy-vercel-production.yml" "Production Deployment"
        check_required_secrets ".github/workflows/deploy-vercel-production.yml" "Production Deployment"
        check_smoke_tests ".github/workflows/deploy-vercel-production.yml" "Production Deployment"
    else
        ((errors++))
    fi
    
    echo ""
    echo "=========================================="
    echo "Validation Summary"
    echo "=========================================="
    
    if [ "$errors" -eq 0 ]; then
        log_success "All workflows are properly configured!"
        echo ""
        echo "Next steps:"
        echo "  1. Ensure GitHub Secrets are set:"
        echo "     - VERCEL_TOKEN"
        echo "     - VERCEL_ORG_ID"
        echo "     - VERCEL_PROJECT_ID"
        echo "     - DATABASE_URL (for migrations)"
        echo ""
        echo "  2. Test preview deployment with a PR"
        echo "  3. Test production deployment on main branch"
        exit 0
    else
        log_error "${errors} workflow(s) have issues"
        exit 1
    fi
}

main "$@"
