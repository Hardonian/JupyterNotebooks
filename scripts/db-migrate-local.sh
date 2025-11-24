#!/bin/bash
# Local database migration script
# Usage: ./scripts/db-migrate-local.sh [upgrade|downgrade|current|history]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if .env file exists
if [ ! -f .env ]; then
    echo -e "${YELLOW}Warning: .env file not found. Using defaults or environment variables.${NC}"
fi

# Load environment variables
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

# Check if DATABASE_URL is set
if [ -z "$DATABASE_URL" ]; then
    echo -e "${RED}Error: DATABASE_URL not set.${NC}"
    echo "Please set DATABASE_URL in your .env file or environment."
    echo "Example: DATABASE_URL=postgresql://user:password@localhost:5432/agentfactory"
    exit 1
fi

# Check if alembic is installed
if ! command -v alembic &> /dev/null; then
    echo -e "${RED}Error: alembic not found.${NC}"
    echo "Please install dependencies: pip install -e '.[dev]'"
    exit 1
fi

# Function to run migrations
run_migration() {
    local command=$1
    local revision=${2:-"head"}
    
    echo -e "${GREEN}Running: alembic $command $revision${NC}"
    echo -e "${YELLOW}Database: ${DATABASE_URL}${NC}"
    echo ""
    
    alembic $command $revision
}

# Parse command
case "${1:-upgrade}" in
    upgrade)
        echo -e "${GREEN}=== Upgrading Database ===${NC}"
        run_migration "upgrade" "${2:-head}"
        echo -e "${GREEN}✓ Migration complete${NC}"
        ;;
    downgrade)
        if [ -z "$2" ]; then
            echo -e "${RED}Error: downgrade requires a revision.${NC}"
            echo "Usage: $0 downgrade <revision>"
            echo "Example: $0 downgrade -1  (downgrade one revision)"
            exit 1
        fi
        echo -e "${YELLOW}=== Downgrading Database ===${NC}"
        run_migration "downgrade" "$2"
        echo -e "${YELLOW}✓ Downgrade complete${NC}"
        ;;
    current)
        echo -e "${GREEN}=== Current Migration Revision ===${NC}"
        alembic current
        ;;
    history)
        echo -e "${GREEN}=== Migration History ===${NC}"
        alembic history
        ;;
    create)
        if [ -z "$2" ]; then
            echo -e "${RED}Error: create requires a message.${NC}"
            echo "Usage: $0 create 'migration message'"
            exit 1
        fi
        echo -e "${GREEN}=== Creating New Migration ===${NC}"
        alembic revision --autogenerate -m "$2"
        ;;
    *)
        echo "Usage: $0 [upgrade|downgrade|current|history|create]"
        echo ""
        echo "Commands:"
        echo "  upgrade [revision]  - Upgrade to revision (default: head)"
        echo "  downgrade <revision> - Downgrade to revision"
        echo "  current            - Show current revision"
        echo "  history             - Show migration history"
        echo "  create <message>    - Create new migration"
        echo ""
        echo "Examples:"
        echo "  $0 upgrade           # Upgrade to latest"
        echo "  $0 downgrade -1      # Downgrade one revision"
        echo "  $0 current           # Show current revision"
        echo "  $0 create 'add users table'  # Create migration"
        exit 1
        ;;
esac
