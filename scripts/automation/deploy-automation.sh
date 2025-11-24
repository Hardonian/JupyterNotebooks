#!/bin/bash
# Agent Factory Deployment Automation Script
# Automated deployment with validation and rollback

set -euo pipefail

# Configuration
ENVIRONMENT="${ENVIRONMENT:-production}"
DEPLOY_BRANCH="${DEPLOY_BRANCH:-main}"
API_URL="${API_URL:-https://api.agentfactory.com}"
HEALTH_CHECK_URL="${API_URL}/health"
ROLLBACK_ON_FAILURE="${ROLLBACK_ON_FAILURE:-true}"
NOTIFICATION_WEBHOOK="${NOTIFICATION_WEBHOOK:-}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Logging function
log() {
    echo -e "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# Send notification
send_notification() {
    local message="$1"
    local status="${2:-info}"
    
    log "NOTIFICATION [$status]: $message"
    
    if [ -n "$NOTIFICATION_WEBHOOK" ]; then
        curl -X POST "$NOTIFICATION_WEBHOOK" \
            -H "Content-Type: application/json" \
            -d "{
                \"status\": \"$status\",
                \"message\": \"$message\",
                \"environment\": \"$ENVIRONMENT\",
                \"timestamp\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"
            }" || log "WARNING: Failed to send notification"
    fi
}

# Pre-deployment checks
pre_deployment_checks() {
    log "Running pre-deployment checks..."
    
    # Check if on correct branch
    local current_branch=$(git rev-parse --abbrev-ref HEAD)
    if [ "$current_branch" != "$DEPLOY_BRANCH" ]; then
        log "${RED}ERROR: Not on deployment branch ($DEPLOY_BRANCH)${NC}"
        return 1
    fi
    
    # Check for uncommitted changes
    if [ -n "$(git status --porcelain)" ]; then
        log "${YELLOW}WARNING: Uncommitted changes detected${NC}"
    fi
    
    # Check if tests pass
    if [ -f "pytest.ini" ]; then
        log "Running tests..."
        python3 -m pytest tests/ || {
            log "${RED}ERROR: Tests failed${NC}"
            return 1
        }
    fi
    
    log "${GREEN}SUCCESS: Pre-deployment checks passed${NC}"
    return 0
}

# Build application
build_application() {
    log "Building application..."
    
    # Install dependencies
    if [ -f "requirements.txt" ]; then
        pip3 install -r requirements.txt || {
            log "${RED}ERROR: Failed to install dependencies${NC}"
            return 1
        }
    fi
    
    # Run database migrations
    if [ -f "alembic.ini" ]; then
        log "Running database migrations..."
        alembic upgrade head || {
            log "${RED}ERROR: Database migrations failed${NC}"
            return 1
        }
    fi
    
    log "${GREEN}SUCCESS: Application built${NC}"
    return 0
}

# Deploy application
deploy_application() {
    log "Deploying application to $ENVIRONMENT..."
    
    # Save current version for rollback
    local current_version=$(git rev-parse HEAD)
    echo "$current_version" > /tmp/agentfactory_previous_version
    
    # Deployment steps (customize based on your deployment method)
    # Example: Docker deployment
    if [ -f "docker-compose.yml" ]; then
        docker-compose -f docker-compose.yml up -d --build || {
            log "${RED}ERROR: Deployment failed${NC}"
            return 1
        }
    fi
    
    log "${GREEN}SUCCESS: Application deployed${NC}"
    return 0
}

# Health check
health_check() {
    log "Running health check..."
    
    local max_attempts=10
    local attempt=0
    
    while [ $attempt -lt $max_attempts ]; do
        if curl -f -s "$HEALTH_CHECK_URL" > /dev/null; then
            log "${GREEN}SUCCESS: Health check passed${NC}"
            return 0
        fi
        
        ((attempt++))
        log "Health check attempt $attempt/$max_attempts failed, retrying..."
        sleep 5
    done
    
    log "${RED}ERROR: Health check failed after $max_attempts attempts${NC}"
    return 1
}

# Rollback deployment
rollback_deployment() {
    log "${YELLOW}Rolling back deployment...${NC}"
    
    local previous_version=$(cat /tmp/agentfactory_previous_version 2>/dev/null || echo "")
    
    if [ -z "$previous_version" ]; then
        log "${RED}ERROR: Previous version not found, cannot rollback${NC}"
        return 1
    fi
    
    # Checkout previous version
    git checkout "$previous_version" || {
        log "${RED}ERROR: Failed to checkout previous version${NC}"
        return 1
    }
    
    # Redeploy
    deploy_application || {
        log "${RED}ERROR: Rollback deployment failed${NC}"
        return 1
    }
    
    log "${GREEN}SUCCESS: Rollback completed${NC}"
    return 0
}

# Post-deployment validation
post_deployment_validation() {
    log "Running post-deployment validation..."
    
    # Run smoke tests
    if [ -f "scripts/smoke-tests.sh" ]; then
        bash scripts/smoke-tests.sh || {
            log "${RED}ERROR: Smoke tests failed${NC}"
            return 1
        }
    fi
    
    log "${GREEN}SUCCESS: Post-deployment validation passed${NC}"
    return 0
}

# Main deployment function
main() {
    log "${GREEN}Starting deployment to $ENVIRONMENT...${NC}"
    send_notification "Deployment started" "info"
    
    # Pre-deployment checks
    if ! pre_deployment_checks; then
        send_notification "Pre-deployment checks failed" "error"
        exit 1
    fi
    
    # Build application
    if ! build_application; then
        send_notification "Build failed" "error"
        exit 1
    fi
    
    # Deploy application
    if ! deploy_application; then
        send_notification "Deployment failed" "error"
        if [ "$ROLLBACK_ON_FAILURE" = "true" ]; then
            rollback_deployment
        fi
        exit 1
    fi
    
    # Health check
    if ! health_check; then
        send_notification "Health check failed" "error"
        if [ "$ROLLBACK_ON_FAILURE" = "true" ]; then
            rollback_deployment
        fi
        exit 1
    fi
    
    # Post-deployment validation
    if ! post_deployment_validation; then
        send_notification "Post-deployment validation failed" "error"
        if [ "$ROLLBACK_ON_FAILURE" = "true" ]; then
            rollback_deployment
        fi
        exit 1
    fi
    
    log "${GREEN}SUCCESS: Deployment completed successfully${NC}"
    send_notification "Deployment completed successfully" "success"
    exit 0
}

# Run main function
main "$@"
