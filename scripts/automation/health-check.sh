#!/bin/bash
# Agent Factory Health Check Automation Script
# Monitors system health and sends alerts

set -euo pipefail

# Configuration
API_URL="${API_URL:-https://api.agentfactory.com}"
HEALTH_ENDPOINT="${API_URL}/health"
ALERT_WEBHOOK="${ALERT_WEBHOOK:-}"
LOG_FILE="${LOG_FILE:-/var/log/agentfactory/health-check.log}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Check health endpoint
check_health() {
    local response
    local status_code
    
    response=$(curl -s -w "\n%{http_code}" "$HEALTH_ENDPOINT" || echo -e "\n000")
    status_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | sed '$d')
    
    if [ "$status_code" = "200" ]; then
        echo "$body"
        return 0
    else
        log "ERROR: Health check failed with status code $status_code"
        return 1
    fi
}

# Send alert
send_alert() {
    local message="$1"
    local severity="${2:-error}"
    
    log "ALERT [$severity]: $message"
    
    if [ -n "$ALERT_WEBHOOK" ]; then
        curl -X POST "$ALERT_WEBHOOK" \
            -H "Content-Type: application/json" \
            -d "{
                \"severity\": \"$severity\",
                \"message\": \"$message\",
                \"timestamp\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"
            }" || log "WARNING: Failed to send alert to webhook"
    fi
}

# Check database connectivity
check_database() {
    if command -v psql &> /dev/null; then
        if psql -h "${DB_HOST:-localhost}" -U "${DB_USER:-postgres}" -d "${DB_NAME:-agentfactory}" -c "SELECT 1;" &> /dev/null; then
            log "INFO: Database connectivity OK"
            return 0
        else
            send_alert "Database connectivity check failed" "critical"
            return 1
        fi
    else
        log "WARNING: psql not available, skipping database check"
        return 0
    fi
}

# Check Redis connectivity
check_redis() {
    if command -v redis-cli &> /dev/null; then
        if redis-cli -h "${REDIS_HOST:-localhost}" ping &> /dev/null; then
            log "INFO: Redis connectivity OK"
            return 0
        else
            send_alert "Redis connectivity check failed" "warning"
            return 1
        fi
    else
        log "WARNING: redis-cli not available, skipping Redis check"
        return 0
    fi
}

# Check disk space
check_disk_space() {
    local threshold=80
    local usage
    
    usage=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
    
    if [ "$usage" -gt "$threshold" ]; then
        send_alert "Disk usage is ${usage}% (threshold: ${threshold}%)" "warning"
        return 1
    else
        log "INFO: Disk usage OK (${usage}%)"
        return 0
    fi
}

# Check memory usage
check_memory() {
    local threshold=85
    local usage
    
    if [ -f /proc/meminfo ]; then
        local total_mem=$(grep MemTotal /proc/meminfo | awk '{print $2}')
        local available_mem=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
        usage=$((100 - (available_mem * 100 / total_mem)))
        
        if [ "$usage" -gt "$threshold" ]; then
            send_alert "Memory usage is ${usage}% (threshold: ${threshold}%)" "warning"
            return 1
        else
            log "INFO: Memory usage OK (${usage}%)"
            return 0
        fi
    else
        log "WARNING: /proc/meminfo not available, skipping memory check"
        return 0
    fi
}

# Main health check
main() {
    log "Starting health check..."
    
    local failed_checks=0
    
    # Check API health
    if ! check_health > /dev/null; then
        send_alert "API health check failed" "critical"
        ((failed_checks++))
    else
        log "INFO: API health check OK"
    fi
    
    # Check database
    if ! check_database; then
        ((failed_checks++))
    fi
    
    # Check Redis
    if ! check_redis; then
        ((failed_checks++))
    fi
    
    # Check disk space
    if ! check_disk_space; then
        ((failed_checks++))
    fi
    
    # Check memory
    if ! check_memory; then
        ((failed_checks++))
    fi
    
    # Summary
    if [ $failed_checks -eq 0 ]; then
        log "SUCCESS: All health checks passed"
        exit 0
    else
        log "WARNING: $failed_checks health check(s) failed"
        exit 1
    fi
}

# Run main function
main "$@"
