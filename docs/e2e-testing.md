# E2E Testing Guide

**Last Updated:** 2024-01-XX  
**Purpose:** Complete guide to end-to-end testing

---

## Overview

Agent Factory includes comprehensive E2E tests covering:
- API endpoints
- Agent creation and execution
- Workflow operations
- Performance testing

---

## 1. Test Structure

### Test Files

**Location:** `tests/e2e/`

**Files:**
- `conftest.py` - Test configuration and fixtures
- `test_api_e2e.py` - API E2E tests

**Markers:**
- `@pytest.mark.e2e` - E2E test marker

---

## 2. Running E2E Tests

### Local

```bash
# Install E2E dependencies
pip install -e ".[e2e]"

# Set API URL
export API_BASE_URL=http://localhost:8000

# Run all E2E tests
pytest tests/e2e/ -m e2e -v

# Run specific test suite
pytest tests/e2e/test_api_e2e.py::TestAPIE2E -m e2e -v
```

### CI/CD

**Workflow:** `.github/workflows/e2e-tests.yml`

**Triggers:**
- Push to main/develop
- Pull requests
- Manual dispatch

**Configuration:**
- Tests against staging/production
- Parallel test execution
- Test result artifacts

---

## 3. Test Suites

### API E2E Tests

**Class:** `TestAPIE2E`

**Tests:**
- Health check endpoint
- Readiness probe
- Liveness probe
- API documentation
- OpenAPI schema
- Core API endpoints

**Example:**
```python
def test_health_check(self, api_client: httpx.Client):
    response = api_client.get("/health")
    assert response.status_code == 200
    assert response.json()["status"] in ["healthy", "degraded"]
```

---

### Agent E2E Tests

**Class:** `TestAgentE2E`

**Tests:**
- Create agent
- Run agent
- Agent execution flow

**Requirements:**
- Authentication configured
- API key set

---

### Workflow E2E Tests

**Class:** `TestWorkflowE2E`

**Tests:**
- List workflows
- Create workflow
- Execute workflow

**Requirements:**
- Authentication configured

---

### Performance Tests

**Class:** `TestPerformanceE2E`

**Tests:**
- Response time
- Concurrent requests
- Load handling

**Metrics:**
- Response time < 2s
- Concurrent request handling
- Throughput

---

## 4. Configuration

### Environment Variables

**Required:**
- `API_BASE_URL` - API endpoint URL

**Optional:**
- `API_KEY` - API key for authenticated tests
- `E2E_TIMEOUT` - Test timeout (default: 30s)

---

### Fixtures

**`api_client`** - HTTP client for API
**`authenticated_client`** - Authenticated HTTP client
**`api_base_url`** - API base URL

**Usage:**
```python
def test_endpoint(self, api_client: httpx.Client):
    response = api_client.get("/health")
    assert response.status_code == 200
```

---

## 5. CI Integration

### Workflow Configuration

**Matrix Strategy:**
- Test suites: `api`, `performance`
- Parallel execution
- Fail-fast disabled

**Steps:**
1. Determine API URL (staging/production/local)
2. Start local API if needed
3. Wait for API readiness
4. Run E2E tests
5. Upload test results

---

## 6. Best Practices

### 1. Test Independence

- Each test should be independent
- No shared state between tests
- Clean up after tests

### 2. Use Fixtures

- Reuse HTTP clients
- Configure once, use many times
- Session-scoped fixtures for efficiency

### 3. Handle Failures Gracefully

- Skip tests if prerequisites not met
- Provide clear error messages
- Don't fail entire suite on one failure

### 4. Test Real Scenarios

- Test actual user flows
- Include edge cases
- Test error conditions

---

## 7. Adding New Tests

### Test Template

```python
@pytest.mark.e2e
class TestNewFeature:
    """E2E tests for new feature."""
    
    def test_feature_endpoint(self, api_client: httpx.Client):
        """Test new feature endpoint."""
        response = api_client.get("/api/v1/new-feature")
        assert response.status_code == 200
        # Add assertions
```

### Best Practices

1. Use descriptive test names
2. Add docstrings
3. Use appropriate markers
4. Handle authentication
5. Clean up resources

---

## 8. Troubleshooting

### Tests Failing

**Check:**
1. API URL correct
2. API accessible
3. Authentication configured
4. Test data available

**Debug:**
```bash
# Run with verbose output
pytest tests/e2e/ -m e2e -v -s

# Run single test
pytest tests/e2e/test_api_e2e.py::TestAPIE2E::test_health_check -v -s
```

---

### Timeout Issues

**Fix:**
- Increase timeout in fixtures
- Check API response time
- Optimize slow tests

---

## Conclusion

**E2E Testing Status:** ✅ Complete

**Coverage:**
- ✅ API endpoints
- ✅ Agent operations
- ✅ Workflow operations
- ✅ Performance testing

**Next Steps:**
1. Add more test scenarios
2. Increase coverage
3. Add visual regression tests (optional)
4. Integrate with monitoring
