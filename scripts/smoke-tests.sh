#!/bin/bash
#
# Comprehensive smoke test script for Agent Factory deployments
#
# Usage:
#   ./scripts/smoke-tests.sh [preview|production] [URL]
#
# Examples:
#   ./scripts/smoke-tests.sh preview https://project-abc123.vercel.app
#   ./scripts/smoke-tests.sh production https://api.agentfactory.io
#

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
ENVIRONMENT="${1:-preview}"
BASE_URL="${2:-}"
TIMEOUT="${TIMEOUT:-10}"
VERBOSE="${VERBOSE:-false}"

# Test results
TESTS_PASSED=0
TESTS_FAILED=0
TESTS_SKIPPED=0

# Functions
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

test_endpoint() {
    local method="$1"
    local endpoint="$2"
    local expected_status="${3:-200}"
    local description="${4:-$endpoint}"
    local data="${5:-}"
    
    local url="${BASE_URL}${endpoint}"
    local curl_cmd="curl -s -w '\n%{http_code}' -X ${method} --max-time ${TIMEOUT}"
    
    if [ -n "$data" ]; then
        curl_cmd="${curl_cmd} -H 'Content-Type: application/json' -d '${data}'"
    fi
    
    curl_cmd="${curl_cmd} '${url}'"
    
    if [ "$VERBOSE" = "true" ]; then
        echo "  Testing: ${method} ${endpoint}"
    fi
    
    local response
    response=$(eval "$curl_cmd" 2>&1) || {
        log_error "Failed to connect to ${endpoint}"
        ((TESTS_FAILED++))
        return 1
    }
    
    local status_code
    status_code=$(echo "$response" | tail -n1)
    local body
    body=$(echo "$response" | sed '$d')
    
    if [ "$status_code" = "$expected_status" ]; then
        log_success "${description} (${status_code})"
        ((TESTS_PASSED++))
        return 0
    else
        log_error "${description} - Expected ${expected_status}, got ${status_code}"
        if [ "$VERBOSE" = "true" ]; then
            echo "  Response: ${body}"
        fi
        ((TESTS_FAILED++))
        return 1
    fi
}

test_health_endpoint() {
    log_info "Testing health endpoint..."
    test_endpoint "GET" "/api/v1/health" "200" "Health check"
}

test_root_endpoint() {
    log_info "Testing root endpoint..."
    # Root might return 200, 404, or 307 redirect - all are acceptable
    local status_code
    status_code=$(curl -s -o /dev/null -w '%{http_code}' --max-time "$TIMEOUT" "${BASE_URL}/" || echo "000")
    
    if [ "$status_code" = "200" ] || [ "$status_code" = "404" ] || [ "$status_code" = "307" ] || [ "$status_code" = "301" ]; then
        log_success "Root endpoint accessible (${status_code})"
        ((TESTS_PASSED++))
    else
        log_error "Root endpoint failed (${status_code})"
        ((TESTS_FAILED++))
    fi
}

test_api_docs() {
    log_info "Testing API documentation endpoints..."
    
    # Test Swagger UI
    test_endpoint "GET" "/docs" "200" "Swagger UI" || ((TESTS_SKIPPED++))
    
    # Test ReDoc
    test_endpoint "GET" "/redoc" "200" "ReDoc" || ((TESTS_SKIPPED++))
    
    # Test OpenAPI JSON
    test_endpoint "GET" "/openapi.json" "200" "OpenAPI JSON" || ((TESTS_SKIPPED++))
}

test_agents_endpoint() {
    log_info "Testing agents endpoint..."
    # Should return 200 (empty list) or 401/403 (auth required)
    local status_code
    status_code=$(curl -s -o /dev/null -w '%{http_code}' --max-time "$TIMEOUT" "${BASE_URL}/api/v1/agents/" || echo "000")
    
    if [ "$status_code" = "200" ] || [ "$status_code" = "401" ] || [ "$status_code" = "403" ]; then
        log_success "Agents endpoint accessible (${status_code})"
        ((TESTS_PASSED++))
    else
        log_error "Agents endpoint failed (${status_code})"
        ((TESTS_FAILED++))
    fi
}

test_cors_headers() {
    log_info "Testing CORS headers..."
    local headers
    headers=$(curl -s -I --max-time "$TIMEOUT" "${BASE_URL}/api/v1/health" | grep -i "access-control" || echo "")
    
    if [ -n "$headers" ]; then
        log_success "CORS headers present"
        ((TESTS_PASSED++))
    else
        log_warn "CORS headers not found (may be configured elsewhere)"
        ((TESTS_SKIPPED++))
    fi
}

test_response_time() {
    log_info "Testing response time..."
    local start_time
    start_time=$(date +%s%N)
    
    curl -s -o /dev/null --max-time "$TIMEOUT" "${BASE_URL}/api/v1/health" > /dev/null || {
        log_error "Health endpoint timeout"
        ((TESTS_FAILED++))
        return 1
    }
    
    local end_time
    end_time=$(date +%s%N)
    local duration_ms
    duration_ms=$(( (end_time - start_time) / 1000000 ))
    
    if [ "$duration_ms" -lt 5000 ]; then
        log_success "Response time acceptable (${duration_ms}ms)"
        ((TESTS_PASSED++))
    else
        log_warn "Response time slow (${duration_ms}ms)"
        ((TESTS_SKIPPED++))
    fi
}

# Main execution
main() {
    echo "=========================================="
    echo "Agent Factory Smoke Tests"
    echo "=========================================="
    echo "Environment: ${ENVIRONMENT}"
    echo "Base URL: ${BASE_URL}"
    echo "Timeout: ${TIMEOUT}s"
    echo ""
    
    if [ -z "$BASE_URL" ]; then
        log_error "Base URL not provided"
        echo "Usage: $0 [preview|production] [URL]"
        exit 1
    fi
    
    # Remove trailing slash
    BASE_URL="${BASE_URL%/}"
    
    # Validate URL format
    if [[ ! "$BASE_URL" =~ ^https?:// ]]; then
        log_error "Invalid URL format: ${BASE_URL}"
        exit 1
    fi
    
    log_info "Starting smoke tests for ${ENVIRONMENT} environment..."
    echo ""
    
    # Run tests
    test_health_endpoint
    test_root_endpoint
    
    if [ "$ENVIRONMENT" = "production" ]; then
        test_api_docs
    fi
    
    test_agents_endpoint
    test_cors_headers
    test_response_time
    
    # Summary
    echo ""
    echo "=========================================="
    echo "Test Summary"
    echo "=========================================="
    echo "Passed:  ${TESTS_PASSED}"
    echo "Failed:  ${TESTS_FAILED}"
    echo "Skipped: ${TESTS_SKIPPED}"
    echo ""
    
    if [ "$TESTS_FAILED" -eq 0 ]; then
        log_success "All critical tests passed!"
        exit 0
    else
        log_error "${TESTS_FAILED} test(s) failed"
        exit 1
    fi
}

# Run main function
main "$@"
