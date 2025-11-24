#!/bin/bash
# Production database migration script
# Usage: ./scripts/db-migrate-prod.sh [upgrade|downgrade|current|history]
# 
# This script is designed for production deployments where:
# - DATABASE_URL is set via environment variables (not .env file)
# - Migrations should be run carefully with confirmation
# - Logging is important for audit trails

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if DATABASE_URL is set
if [ -z "$DATABASE_URL" ]; then
    echo -e "${RED}Error: DATABASE_URL not set.${NC}"
    echo "Please set DATABASE_URL as an environment variable."
    echo "Example: export DATABASE_URL=postgresql://user:password@host:5432/dbname"
    exit 1
fi

# Safety check: warn if DATABASE_URL looks like production
if [[ "$DATABASE_URL" == *"localhost"* ]] || [[ "$DATABASE_URL" == *"127.0.0.1"* ]]; then
    echo -e "${YELLOW}Warning: DATABASE_URL appears to be localhost.${NC}"
    echo "This script is intended for production. Are you sure?"
    read -p "Continue? (yes/no): " confirm
    if [ "$confirm" != "yes" ]; then
        echo "Aborted."
        exit 1
    fi
fi

# Check if alembic is installed
if ! command -v alembic &> /dev/null; then
    echo -e "${RED}Error: alembic not found.${NC}"
    echo "Please install dependencies: pip install alembic sqlalchemy psycopg2-binary"
    exit 1
fi

# Function to show current revision before migration
show_current_revision() {
    echo -e "${GREEN}Current database revision:${NC}"
    alembic current || echo "No migrations applied yet"
    echo ""
}

# Function to run migrations with confirmation
run_migration() {
    local command=$1
    local revision=${2:-"head"}
    
    # Show current state
    show_current_revision
    
    # Show what will happen
    echo -e "${YELLOW}=== Migration Plan ===${NC}"
    if [ "$command" == "upgrade" ]; then
        echo "Will upgrade to: $revision"
        echo "Migration history:"
        alembic history | head -10
    else
        echo "Will downgrade to: $revision"
    fi
    echo ""
    
    # Confirm
    echo -e "${RED}⚠️  WARNING: This will modify the production database!${NC}"
    read -p "Type 'yes' to continue: " confirm
    if [ "$confirm" != "yes" ]; then
        echo "Aborted."
        exit 1
    fi
    
    # Run migration
    echo -e "${GREEN}Running: alembic $command $revision${NC}"
    echo "Timestamp: $(date -u +"%Y-%m-%d %H:%M:%S UTC")"
    echo ""
    
    if alembic $command $revision; then
        echo ""
        echo -e "${GREEN}✓ Migration completed successfully${NC}"
        show_current_revision
    else
        echo ""
        echo -e "${RED}✗ Migration failed!${NC}"
        echo "Check the error messages above and fix any issues."
        exit 1
    fi
}

# Parse command
case "${1:-upgrade}" in
    upgrade)
        echo -e "${GREEN}=== Production Database Upgrade ===${NC}"
        run_migration "upgrade" "${2:-head}"
        ;;
    downgrade)
        if [ -z "$2" ]; then
            echo -e "${RED}Error: downgrade requires a revision.${NC}"
            echo "Usage: $0 downgrade <revision>"
            echo "Example: $0 downgrade -1  (downgrade one revision)"
            exit 1
        fi
        echo -e "${YELLOW}=== Production Database Downgrade ===${NC}"
        run_migration "downgrade" "$2"
        ;;
    current)
        echo -e "${GREEN}=== Current Migration Revision ===${NC}"
        show_current_revision
        ;;
    history)
        echo -e "${GREEN}=== Migration History ===${NC}"
        alembic history
        ;;
    *)
        echo "Usage: $0 [upgrade|downgrade|current|history]"
        echo ""
        echo "Commands:"
        echo "  upgrade [revision]  - Upgrade to revision (default: head)"
        echo "  downgrade <revision> - Downgrade to revision (requires confirmation)"
        echo "  current            - Show current revision"
        echo "  history             - Show migration history"
        echo ""
        echo "Examples:"
        echo "  $0 upgrade           # Upgrade to latest"
        echo "  $0 downgrade -1      # Downgrade one revision"
        echo "  $0 current           # Show current revision"
        exit 1
        ;;
esac
