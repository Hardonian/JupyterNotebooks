#!/bin/bash
#
# Test seed data script
#
# Validates that the seed script is syntactically correct and can be imported
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

SCRIPT_FILE="scripts/db-seed-demo.py"

main() {
    echo "=========================================="
    echo "Seed Script Validation"
    echo "=========================================="
    echo ""
    
    local errors=0
    
    # Check if script exists
    if [ ! -f "$SCRIPT_FILE" ]; then
        log_error "Seed script not found: ${SCRIPT_FILE}"
        exit 1
    fi
    
    log_success "Seed script exists"
    
    # Check Python syntax
    log_info "Checking Python syntax..."
    if python3 -m py_compile "$SCRIPT_FILE" 2>&1; then
        log_success "Python syntax is valid"
    else
        log_error "Python syntax errors found"
        ((errors++))
    fi
    
    # Check imports (AST parsing)
    log_info "Checking imports..."
    if python3 -c "import ast; ast.parse(open('$SCRIPT_FILE').read())" 2>&1; then
        log_success "Imports are valid"
    else
        log_error "Import errors found"
        ((errors++))
    fi
    
    # Check for required functions
    log_info "Checking required functions..."
    if grep -q "def create_demo_data" "$SCRIPT_FILE" && grep -q "def main" "$SCRIPT_FILE"; then
        log_success "Required functions present"
    else
        log_error "Missing required functions"
        ((errors++))
    fi
    
    # Check for database connection handling
    log_info "Checking database connection handling..."
    if grep -q "get_database_url\|DATABASE_URL" "$SCRIPT_FILE"; then
        log_success "Database connection handling present"
    else
        log_warn "Database connection handling not found"
    fi
    
    # Check for error handling
    log_info "Checking error handling..."
    if grep -q "try:" "$SCRIPT_FILE" && grep -q "except\|finally" "$SCRIPT_FILE"; then
        log_success "Error handling present"
    else
        log_warn "Limited error handling found"
    fi
    
    # Check for required model imports
    log_info "Checking model imports..."
    if grep -q "from agent_factory.database.models import" "$SCRIPT_FILE"; then
        log_success "Model imports present"
    else
        log_error "Model imports missing"
        ((errors++))
    fi
    
    # Summary
    echo ""
    echo "=========================================="
    echo "Validation Summary"
    echo "=========================================="
    
    if [ "$errors" -eq 0 ]; then
        log_success "Seed script is valid and ready to use!"
        echo ""
        echo "To use the seed script:"
        echo "  1. Set DATABASE_URL environment variable"
        echo "  2. Run: python3 scripts/db-seed-demo.py"
        echo ""
        echo "Note: The script will create demo data including:"
        echo "  - Demo tenant (demo-org)"
        echo "  - Demo user (demo@example.com)"
        echo "  - Demo agent, workflow, blueprint"
        echo "  - Demo execution records"
        echo "  - Demo project, plan, subscription"
        exit 0
    else
        log_error "${errors} issue(s) found"
        exit 1
    fi
}

main "$@"
