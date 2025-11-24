# SAML SSO Integration Guide

**Last Updated:** 2024-01-XX  
**Purpose:** Complete guide for integrating Agent Factory with SAML-based Single Sign-On (SSO)

---

## Overview

**SAML (Security Assertion Markup Language)** is a standard for exchanging authentication and authorization data between identity providers (IdP) and service providers (SP). This guide explains how to configure SAML SSO for Agent Factory.

---

## Integration Architecture

### Components

**1. Identity Provider (IdP)**
- SAML 2.0 compliant
- Examples: Okta, Azure AD, OneLogin, Shibboleth

**2. Agent Factory (Service Provider)**
- SAML 2.0 support
- SSO configuration
- User provisioning

**3. Integration Flow**
- SAML authentication request
- SAML response processing
- User creation/update
- Session management

---

## Prerequisites

### Identity Provider Requirements

**IdP Configuration:**
- SAML 2.0 support
- SSO URL (SAML endpoint)
- Entity ID
- X.509 certificate
- Attribute mapping

**User Attributes:**
- Email (required)
- First name
- Last name
- Groups/roles (optional)

---

### Agent Factory Requirements

**Account:**
- Enterprise plan (SAML SSO available)
- Admin access
- SSO configuration access

**Configuration:**
- SAML certificate
- SSO URL
- Entity ID
- Attribute mapping

---

## Step 1: Configure Identity Provider

### Okta Configuration Example

**1. Create SAML Application:**
- Navigate to Applications → Create App Integration
- Select "SAML 2.0"
- Name: "Agent Factory"

**2. Configure SAML Settings:**
- **Single sign-on URL:** `https://agentfactory.com/saml/acs`
- **Audience URI (SP Entity ID):** `https://agentfactory.com/saml/metadata`
- **Default RelayState:** (optional)
- **Name ID format:** EmailAddress
- **Application username:** Email

**3. Configure Attribute Statements:**
- `email` → `user.email`
- `firstName` → `user.firstName`
- `lastName` → `user.lastName`
- `groups` → `user.groups` (optional)

**4. Save and Note:**
- SSO URL
- Entity ID
- X.509 certificate

---

### Azure AD Configuration Example

**1. Create Enterprise Application:**
- Navigate to Azure AD → Enterprise applications
- Click "New application" → "Create your own application"
- Name: "Agent Factory"

**2. Configure SAML:**
- Go to Single sign-on → SAML
- **Identifier (Entity ID):** `https://agentfactory.com/saml/metadata`
- **Reply URL (Assertion Consumer Service URL):** `https://agentfactory.com/saml/acs`
- **Sign-on URL:** `https://agentfactory.com/sso`

**3. Configure Attributes:**
- `email` → `user.mail`
- `firstName` → `user.givenname`
- `lastName` → `user.surname`
- `groups` → `user.groups` (optional)

**4. Download Certificate:**
- Download Base64 certificate
- Note certificate details

---

## Step 2: Configure Agent Factory

### SSO Configuration

**1. Navigate to SSO Settings:**
- Go to Settings → Security → SSO
- Click "Configure SAML SSO"

**2. Enter IdP Information:**
- **SSO URL (IdP SSO URL):** From IdP configuration
- **Entity ID (IdP Entity ID):** From IdP configuration
- **X.509 Certificate:** Paste certificate from IdP
- **Name ID Format:** EmailAddress (or as configured)

**3. Configure Attribute Mapping:**
- Email: `email` (or IdP attribute name)
- First Name: `firstName` (or IdP attribute name)
- Last Name: `lastName` (or IdP attribute name)
- Groups: `groups` (optional)

**4. Configure Agent Factory URLs:**
- **ACS URL (Assertion Consumer Service):** `https://agentfactory.com/saml/acs`
- **Entity ID (SP Entity ID):** `https://agentfactory.com/saml/metadata`
- **SSO URL:** `https://agentfactory.com/sso`

**5. Test Connection:**
- Click "Test SSO"
- Complete SSO flow
- Verify successful authentication

---

## Step 3: User Provisioning

### Automatic User Provisioning

**1. Enable Just-In-Time (JIT) Provisioning:**
- Automatically create users on first SSO login
- Map attributes to user fields
- Assign default roles

**2. Configure User Mapping:**
- Email → User email
- First Name → User first name
- Last Name → User last name
- Groups → User roles (optional)

**3. Configure Default Roles:**
- Default role for new users
- Role mapping from groups
- Admin role assignment

---

## Step 4: Testing

### Test SSO Flow

**1. Initiate SSO:**
- Navigate to `https://agentfactory.com/sso`
- Should redirect to IdP

**2. Authenticate:**
- Complete authentication in IdP
- Should redirect back to Agent Factory

**3. Verify:**
- User logged in
- User attributes correct
- User roles assigned

---

## Security Considerations

### Certificate Management

**Best Practices:**
- Use valid SSL certificates
- Rotate certificates regularly
- Monitor certificate expiration
- Use certificate pinning (if supported)

---

### Attribute Security

**Best Practices:**
- Encrypt sensitive attributes
- Validate attribute signatures
- Implement attribute filtering
- Monitor attribute changes

---

### Session Management

**Best Practices:**
- Implement session timeouts
- Use secure session cookies
- Enable session encryption
- Monitor session activity

---

## Troubleshooting

### Common Issues

**Issue: SSO redirect fails**
- **Solution:** Verify SSO URL, check firewall rules

**Issue: Certificate validation fails**
- **Solution:** Verify certificate, check certificate format

**Issue: Attributes not mapped**
- **Solution:** Check attribute mapping, verify IdP attributes

**Issue: User not created**
- **Solution:** Enable JIT provisioning, check user mapping

---

## Advanced Configuration

### Role-Based Access Control (RBAC)

**1. Map Groups to Roles:**
- Configure group-to-role mapping
- Assign roles based on IdP groups
- Update roles on SSO login

**2. Dynamic Role Assignment:**
- Assign roles based on attributes
- Update roles automatically
- Remove roles on group removal

---

### Multi-IdP Support

**1. Configure Multiple IdPs:**
- Support multiple identity providers
- Route users to correct IdP
- Handle IdP-specific configurations

**2. IdP Discovery:**
- Implement IdP discovery page
- Allow users to select IdP
- Remember IdP selection

---

## Support

### Resources

**Documentation:**
- SAML 2.0 Specification: http://docs.oasis-open.org/security/saml/2.0/
- Agent Factory SSO docs: https://docs.agentfactory.com/sso

**Support:**
- Email: support@agentfactory.com
- Enterprise Support: enterprise@agentfactory.com

---

**Remember:** SAML SSO requires careful configuration on both IdP and SP sides. Test thoroughly in a staging environment before production deployment.
