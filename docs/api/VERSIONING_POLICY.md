# API Versioning Policy

**Last Updated:** 2024-01-XX  
**Status:** Draft  
**Purpose:** Define API versioning strategy, breaking change policy, and migration procedures

---

## Overview

Agent Factory uses **semantic versioning** for API versions with the format: `/api/v1/`, `/api/v2/`, etc.

**Current Version:** `v1`  
**Version Format:** Major.Minor.Patch (e.g., `v1.2.3`)

---

## Versioning Strategy

### Major Versions (v1 → v2)

**When to Increment:**
- Breaking changes to API contracts
- Removal of endpoints
- Changes to authentication
- Changes to data models that break compatibility

**Support Policy:**
- Previous major version supported for **12 months** after new version release
- Deprecation notice: **6 months** before removal
- Migration guides provided

### Minor Versions (v1.1 → v1.2)

**When to Increment:**
- New endpoints added
- New optional parameters
- New response fields (backward compatible)
- Performance improvements

**Support Policy:**
- Always backward compatible
- No deprecation needed
- Documented in changelog

### Patch Versions (v1.2.1 → v1.2.2)

**When to Increment:**
- Bug fixes
- Security patches
- Documentation updates
- Internal improvements

**Support Policy:**
- Always backward compatible
- No deprecation needed
- Documented in changelog

---

## Breaking Changes Definition

### What Constitutes a Breaking Change?

**Request Changes:**
- Removing required parameters
- Changing parameter types
- Removing endpoints
- Changing authentication requirements

**Response Changes:**
- Removing response fields
- Changing response field types
- Changing response structure
- Changing error response format

**Behavior Changes:**
- Changing default values
- Changing validation rules
- Changing rate limits
- Changing business logic

### What is NOT a Breaking Change?

- Adding new endpoints
- Adding optional parameters
- Adding new response fields
- Adding new error codes
- Performance improvements
- Bug fixes

---

## Deprecation Policy

### Deprecation Timeline

1. **Deprecation Notice:** 6 months before removal
2. **Support Period:** 12 months total (6 months deprecation + 6 months support)
3. **Removal:** After 12 months

### Deprecation Process

1. **Announce Deprecation:**
   - Add `Deprecated` header to responses
   - Update API documentation
   - Send email to affected customers
   - Post in changelog

2. **Provide Migration Guide:**
   - Step-by-step migration instructions
   - Code examples
   - Common issues and solutions

3. **Monitor Usage:**
   - Track usage of deprecated endpoints
   - Contact high-usage customers
   - Provide migration support

4. **Remove After Support Period:**
   - Remove deprecated endpoints
   - Update documentation
   - Notify customers

---

## Version Negotiation

### Header-Based Versioning

**Request Header:**
```
API-Version: v1
```

**Response Header:**
```
API-Version: v1.2.3
```

### URL-Based Versioning

**Current:** `/api/v1/agents/`  
**Future:** `/api/v2/agents/`

**Default:** If no version specified, use latest stable version

---

## Migration Guides

### v1 → v2 Migration (Example)

**Breaking Changes:**
- Agent creation endpoint changed
- Response format changed
- Authentication method changed

**Migration Steps:**
1. Update API version in requests
2. Update request format
3. Update response handling
4. Update authentication
5. Test thoroughly

**Code Example:**
```python
# v1
response = client.agents.create({
    "id": "my-agent",
    "name": "My Agent"
})

# v2
response = client.v2.agents.create({
    "agent_id": "my-agent",
    "agent_name": "My Agent"
})
```

---

## Version Support Matrix

| Version | Status | Released | Deprecated | End of Life |
|---------|--------|----------|------------|-------------|
| v1 | Current | 2024-01-01 | - | - |
| v2 | Planned | TBD | - | - |

---

## Communication

### Changelog

**Location:** `docs/api/CHANGELOG.md`

**Format:**
```markdown
## [v1.2.0] - 2024-01-XX

### Added
- New endpoint: POST /api/v1/agents/{id}/clone

### Changed
- Improved error messages

### Deprecated
- GET /api/v1/agents/{id}/legacy (use GET /api/v1/agents/{id} instead)

### Removed
- (none)
```

### Customer Notifications

**Email:** Sent to all customers 6 months before deprecation  
**In-App:** Banner notification in dashboard  
**Documentation:** Updated immediately

---

## Best Practices

### For API Consumers

1. **Pin to Specific Version:**
   ```python
   client = AgentFactoryClient(api_version="v1")
   ```

2. **Monitor Deprecation Headers:**
   ```python
   if response.headers.get("Deprecated"):
       # Plan migration
   ```

3. **Test New Versions Early:**
   - Test in staging
   - Migrate gradually
   - Monitor for issues

### For API Developers

1. **Avoid Breaking Changes:**
   - Add new endpoints instead of changing existing ones
   - Make changes backward compatible
   - Use feature flags for risky changes

2. **Document Everything:**
   - Document all changes
   - Provide migration guides
   - Include code examples

3. **Communicate Early:**
   - Announce changes early
   - Provide migration support
   - Gather feedback

---

## Examples

### Adding a New Endpoint (Minor Version)

**v1.1:** Add new endpoint
```python
POST /api/v1/agents/{id}/clone
```

**Backward Compatible:** Yes  
**Version:** v1.1.0

---

### Changing Response Format (Major Version)

**v1:** Response format
```json
{
  "id": "agent-1",
  "name": "Agent 1"
}
```

**v2:** New response format
```json
{
  "agent": {
    "id": "agent-1",
    "name": "Agent 1"
  },
  "metadata": {
    "created_at": "..."
  }
}
```

**Backward Compatible:** No  
**Version:** v2.0.0  
**Migration:** Required

---

## Review & Updates

**Review Frequency:** Quarterly  
**Last Reviewed:** [Date]  
**Next Review:** [Date]

**Update Triggers:**
- When API changes
- When breaking changes needed
- When deprecation policies change
- Quarterly review cycle

---

## Appendix: Quick Reference

### Version Increment Decision Tree

```
Is it a breaking change?
├─ Yes → Increment Major Version (v1 → v2)
│   └─ Deprecate old version
│   └─ Provide migration guide
│   └─ Support for 12 months
│
└─ No → Is it a new feature?
    ├─ Yes → Increment Minor Version (v1.1 → v1.2)
    │   └─ Backward compatible
    │   └─ Document in changelog
    │
    └─ No → Increment Patch Version (v1.2.1 → v1.2.2)
        └─ Bug fix or improvement
        └─ Document in changelog
```

---

**Remember:** Versioning is about trust. Be predictable, communicate clearly, and support migrations.
