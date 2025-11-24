#!/bin/bash
# Smoke tests for Agent Factory API
# Validates that core endpoints are working after deployment

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Configuration
API_URL="${API_BASE_URL:-http://localhost:8000}"
TIMEOUT=10

echo -e "${GREEN}=== Agent Factory Smoke Tests ===${NC}"
echo "API URL: $API_URL"
echo ""

# Test counter
TESTS_PASSED=0
TESTS_FAILED=0

# Function to test endpoint
test_endpoint() {
    local method=$1
    local endpoint=$2
    local expected_status=${3:-200}
    local description=$4
    
    echo -n "Testing $description... "
    
    if [ "$method" == "GET" ]; then
        status=$(curl -s -o /dev/null -w "%{http_code}" --max-time $TIMEOUT "$API_URL$endpoint" || echo "000")
    else
        status=$(curl -s -o /dev/null -w "%{http_code}" --max-time $TIMEOUT -X "$method" "$API_URL$endpoint" || echo "000")
    fi
    
    if [ "$status" == "$expected_status" ]; then
        echo -e "${GREEN}✓${NC} (HTTP $status)"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    else
        echo -e "${RED}✗${NC} (HTTP $status, expected $expected_status)"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return 1
    fi
}

# Test root endpoint
test_endpoint "GET" "/" "200" "Root endpoint"

# Test health endpoint
test_endpoint "GET" "/health" "200" "Health check"

# Test readiness endpoint
test_endpoint "GET" "/ready" "200" "Readiness probe"

# Test liveness endpoint
test_endpoint "GET" "/live" "200" "Liveness probe"

# Test API docs
test_endpoint "GET" "/docs" "200" "API documentation"

# Test OpenAPI schema
test_endpoint "GET" "/openapi.json" "200" "OpenAPI schema"

# Test agents endpoint (may require auth, so 401/403 is OK)
test_endpoint "GET" "/api/v1/agents" "200|401|403" "Agents endpoint"

# Test workflows endpoint
test_endpoint "GET" "/api/v1/workflows" "200|401|403" "Workflows endpoint"

# Test blueprints endpoint
test_endpoint "GET" "/api/v1/blueprints" "200|401|403" "Blueprints endpoint"

# Test health endpoint with detailed check
echo ""
echo -e "${YELLOW}Checking health endpoint details...${NC}"
health_response=$(curl -s --max-time $TIMEOUT "$API_URL/health" || echo "{}")

if echo "$health_response" | grep -q '"status"'; then
    echo -e "${GREEN}✓ Health endpoint returns valid JSON${NC}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}✗ Health endpoint response invalid${NC}"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi

# Summary
echo ""
echo "=========================================="
echo -e "${GREEN}Tests passed: $TESTS_PASSED${NC}"
if [ $TESTS_FAILED -gt 0 ]; then
    echo -e "${RED}Tests failed: $TESTS_FAILED${NC}"
    echo ""
    echo -e "${RED}✗ Smoke tests failed!${NC}"
    exit 1
else
    echo -e "${GREEN}✓ All smoke tests passed!${NC}"
    exit 0
fi
