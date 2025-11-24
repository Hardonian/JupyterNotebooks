#!/bin/bash
# Agent Factory API Monitoring Script
# Monitors API endpoints and performance metrics

set -euo pipefail

# Configuration
API_URL="${API_URL:-https://api.agentfactory.com}"
ENDPOINTS=(
    "/health"
    "/api/v1/agents"
    "/api/v1/conversations"
)
ALERT_WEBHOOK="${ALERT_WEBHOOK:-}"
LOG_FILE="${LOG_FILE:-/var/log/agentfactory/api-monitor.log}"
MAX_RESPONSE_TIME=2000  # milliseconds
ERROR_THRESHOLD=5       # consecutive errors before alert

# Logging function
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Check endpoint
check_endpoint() {
    local endpoint="$1"
    local url="${API_URL}${endpoint}"
    local start_time
    local end_time
    local response_time
    local status_code
    local response
    
    start_time=$(date +%s%N)
    response=$(curl -s -w "\n%{http_code}\n%{time_total}" -H "Authorization: Bearer ${API_KEY:-}" "$url" || echo -e "\n000\n0")
    end_time=$(date +%s%N)
    
    status_code=$(echo "$response" | tail -n2 | head -n1)
    response_time=$(echo "$response" | tail -n1)
    body=$(echo "$response" | sed '$d' | sed '$d')
    
    # Convert response time to milliseconds
    response_time_ms=$(echo "$response_time * 1000" | bc | cut -d. -f1)
    
    if [ "$status_code" = "200" ] || [ "$status_code" = "201" ]; then
        log "INFO: $endpoint - Status: $status_code, Response Time: ${response_time_ms}ms"
        
        # Check response time
        if [ "$response_time_ms" -gt "$MAX_RESPONSE_TIME" ]; then
            log "WARNING: $endpoint - Response time ${response_time_ms}ms exceeds threshold ${MAX_RESPONSE_TIME}ms"
            return 2
        fi
        
        return 0
    else
        log "ERROR: $endpoint - Status: $status_code"
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

# Track consecutive errors
track_errors() {
    local endpoint="$1"
    local error_file="/tmp/agentfactory_errors_${endpoint//\//_}"
    local error_count=0
    
    if [ -f "$error_file" ]; then
        error_count=$(cat "$error_file")
    fi
    
    echo $((error_count + 1)) > "$error_file"
    
    if [ $((error_count + 1)) -ge "$ERROR_THRESHOLD" ]; then
        send_alert "Endpoint $endpoint has failed $((error_count + 1)) consecutive times" "critical"
        echo 0 > "$error_file"  # Reset counter
    fi
}

# Reset error counter on success
reset_errors() {
    local endpoint="$1"
    local error_file="/tmp/agentfactory_errors_${endpoint//\//_}"
    [ -f "$error_file" ] && echo 0 > "$error_file"
}

# Main monitoring function
main() {
    log "Starting API monitoring..."
    
    local total_checks=0
    local failed_checks=0
    local slow_checks=0
    
    for endpoint in "${ENDPOINTS[@]}"; do
        ((total_checks++))
        
        check_endpoint "$endpoint"
        local result=$?
        
        if [ $result -eq 1 ]; then
            ((failed_checks++))
            track_errors "$endpoint"
        elif [ $result -eq 2 ]; then
            ((slow_checks++))
        else
            reset_errors "$endpoint"
        fi
    done
    
    # Summary
    log "Monitoring summary: Total: $total_checks, Failed: $failed_checks, Slow: $slow_checks"
    
    if [ $failed_checks -gt 0 ] || [ $slow_checks -gt 0 ]; then
        exit 1
    else
        exit 0
    fi
}

# Run main function
main "$@"
