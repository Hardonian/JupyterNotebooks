# OAuth 2.0 SSO Integration Guide

**Last Updated:** 2024-01-XX  
**Purpose:** Complete guide for integrating Agent Factory with OAuth 2.0-based Single Sign-On (SSO)

---

## Overview

**OAuth 2.0** is an authorization framework that enables applications to obtain limited access to user accounts. This guide explains how to configure OAuth 2.0 SSO for Agent Factory with popular providers like Google, Microsoft, GitHub, and custom OAuth providers.

---

## Integration Architecture

### Components

**1. OAuth Provider**
- OAuth 2.0 compliant
- Examples: Google, Microsoft, GitHub, Okta, Auth0

**2. Agent Factory (OAuth Client)**
- OAuth 2.0 support
- SSO configuration
- User provisioning

**3. Integration Flow**
- Authorization request
- Authorization code exchange
- Token refresh
- User information retrieval

---

## Prerequisites

### OAuth Provider Requirements

**Provider Configuration:**
- OAuth 2.0 support
- Client ID and Secret
- Redirect URI
- Scopes/permissions

**User Information:**
- Email (required)
- Profile information
- Groups/roles (optional)

---

### Agent Factory Requirements

**Account:**
- Pro or Enterprise plan (OAuth SSO available)
- Admin access
- SSO configuration access

**Configuration:**
- Client ID
- Client Secret
- Redirect URI
- Scopes

---

## Step 1: Configure OAuth Provider

### Google OAuth Configuration

**1. Create OAuth Application:**
- Navigate to Google Cloud Console
- Go to APIs & Services → Credentials
- Click "Create Credentials" → "OAuth client ID"

**2. Configure OAuth Consent Screen:**
- Application name: "Agent Factory"
- User support email: your email
- Authorized domains: agentfactory.com

**3. Create OAuth Client:**
- Application type: Web application
- Name: "Agent Factory SSO"
- Authorized redirect URIs: `https://agentfactory.com/oauth/google/callback`

**4. Save and Note:**
- Client ID
- Client Secret

---

### Microsoft Azure AD OAuth Configuration

**1. Register Application:**
- Navigate to Azure Portal → Azure AD → App registrations
- Click "New registration"
- Name: "Agent Factory"

**2. Configure Authentication:**
- Platform: Web
- Redirect URI: `https://agentfactory.com/oauth/microsoft/callback`

**3. Configure API Permissions:**
- Microsoft Graph → User.Read
- Microsoft Graph → email
- Microsoft Graph → profile

**4. Create Client Secret:**
- Go to Certificates & secrets
- Click "New client secret"
- Save secret value

**5. Note:**
- Application (client) ID
- Directory (tenant) ID
- Client secret

---

### GitHub OAuth Configuration

**1. Create OAuth App:**
- Navigate to GitHub Settings → Developer settings → OAuth Apps
- Click "New OAuth App"

**2. Configure Application:**
- Application name: "Agent Factory"
- Homepage URL: `https://agentfactory.com`
- Authorization callback URL: `https://agentfactory.com/oauth/github/callback`

**3. Save and Note:**
- Client ID
- Client Secret

---

## Step 2: Configure Agent Factory

### OAuth SSO Configuration

**1. Navigate to SSO Settings:**
- Go to Settings → Security → SSO
- Click "Configure OAuth SSO"

**2. Select Provider:**
- Choose provider (Google, Microsoft, GitHub, Custom)

**3. Enter Provider Information:**

**For Google:**
- Client ID: From Google Cloud Console
- Client Secret: From Google Cloud Console
- Scopes: `openid email profile`

**For Microsoft:**
- Client ID: Application ID from Azure AD
- Client Secret: Client secret from Azure AD
- Tenant ID: Directory ID from Azure AD
- Scopes: `openid email profile`

**For GitHub:**
- Client ID: From GitHub OAuth App
- Client Secret: From GitHub OAuth App
- Scopes: `user:email`

**4. Configure Redirect URI:**
- Provider-specific callback URL
- Example: `https://agentfactory.com/oauth/{provider}/callback`

**5. Configure Attribute Mapping:**
- Email: `email`
- First Name: `given_name` or `first_name`
- Last Name: `family_name` or `last_name`
- Avatar: `picture` or `avatar_url`

**6. Test Connection:**
- Click "Test OAuth"
- Complete OAuth flow
- Verify successful authentication

---

## Step 3: User Provisioning

### Automatic User Provisioning

**1. Enable Just-In-Time (JIT) Provisioning:**
- Automatically create users on first OAuth login
- Map attributes to user fields
- Assign default roles

**2. Configure User Mapping:**
- Email → User email
- First Name → User first name
- Last Name → User last name
- Avatar → User avatar

**3. Configure Default Roles:**
- Default role for new users
- Role assignment logic
- Admin role assignment

---

## Step 4: Testing

### Test OAuth Flow

**1. Initiate OAuth:**
- Navigate to `https://agentfactory.com/sso`
- Click provider button (Google, Microsoft, GitHub)

**2. Authenticate:**
- Complete authentication with provider
- Authorize Agent Factory access
- Should redirect back to Agent Factory

**3. Verify:**
- User logged in
- User attributes correct
- User roles assigned

---

## Custom OAuth Provider

### Configuration Steps

**1. Configure Provider:**
- Provider name
- Authorization URL
- Token URL
- User info URL
- Client ID and Secret

**2. Configure Scopes:**
- Required scopes
- Optional scopes
- Scope format

**3. Configure Attribute Mapping:**
- Map provider attributes to Agent Factory fields
- Handle different attribute names
- Handle nested attributes

---

## Security Considerations

### Token Security

**Best Practices:**
- Store tokens securely
- Use HTTPS for all OAuth flows
- Implement token refresh
- Monitor token usage

---

### Redirect URI Security

**Best Practices:**
- Use exact redirect URIs
- Validate redirect URIs
- Prevent open redirects
- Use state parameter

---

### Scope Management

**Best Practices:**
- Request minimum required scopes
- Review scope permissions
- Monitor scope usage
- Update scopes as needed

---

## Troubleshooting

### Common Issues

**Issue: OAuth redirect fails**
- **Solution:** Verify redirect URI, check provider configuration

**Issue: Invalid client error**
- **Solution:** Verify client ID and secret

**Issue: Scope errors**
- **Solution:** Check requested scopes, verify provider permissions

**Issue: User not created**
- **Solution:** Enable JIT provisioning, check user mapping

---

## Advanced Configuration

### Multiple OAuth Providers

**1. Configure Multiple Providers:**
- Support multiple OAuth providers
- Allow users to choose provider
- Handle provider-specific logic

**2. Provider Selection:**
- Implement provider selection page
- Remember provider choice
- Handle provider switching

---

### Role-Based Access Control

**1. Map Provider Attributes to Roles:**
- Assign roles based on provider attributes
- Update roles on OAuth login
- Handle role changes

**2. Group/Role Mapping:**
- Map provider groups to roles
- Sync roles automatically
- Remove roles on group removal

---

## Support

### Resources

**Documentation:**
- OAuth 2.0 Specification: https://oauth.net/2/
- Agent Factory SSO docs: https://docs.agentfactory.com/sso

**Provider Documentation:**
- Google: https://developers.google.com/identity/protocols/oauth2
- Microsoft: https://docs.microsoft.com/en-us/azure/active-directory/develop/
- GitHub: https://docs.github.com/en/apps/oauth-apps

**Support:**
- Email: support@agentfactory.com
- Enterprise Support: enterprise@agentfactory.com

---

**Remember:** OAuth 2.0 SSO provides a seamless user experience. Test thoroughly with your specific provider and ensure proper error handling for production deployment.
