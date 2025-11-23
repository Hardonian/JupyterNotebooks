"""Role-based access control."""

from enum import Enum
from typing import List, Callable
from functools import wraps
from fastapi import HTTPException, status, Request


class Permission(str, Enum):
    """Permission types."""
    READ_AGENTS = "agents:read"
    WRITE_AGENTS = "agents:write"
    DELETE_AGENTS = "agents:delete"
    READ_WORKFLOWS = "workflows:read"
    WRITE_WORKFLOWS = "workflows:write"
    DELETE_WORKFLOWS = "workflows:delete"
    READ_BLUEPRINTS = "blueprints:read"
    PUBLISH_BLUEPRINTS = "blueprints:publish"
    ADMIN = "admin:*"


class Role(str, Enum):
    """Role types."""
    USER = "user"
    CREATOR = "creator"
    ADMIN = "admin"


# Role to permissions mapping
ROLE_PERMISSIONS = {
    Role.USER: [
        Permission.READ_AGENTS,
        Permission.WRITE_AGENTS,
        Permission.READ_WORKFLOWS,
        Permission.WRITE_WORKFLOWS,
        Permission.READ_BLUEPRINTS,
    ],
    Role.CREATOR: [
        Permission.READ_AGENTS,
        Permission.WRITE_AGENTS,
        Permission.READ_WORKFLOWS,
        Permission.WRITE_WORKFLOWS,
        Permission.READ_BLUEPRINTS,
        Permission.PUBLISH_BLUEPRINTS,
    ],
    Role.ADMIN: [
        Permission.READ_AGENTS,
        Permission.WRITE_AGENTS,
        Permission.DELETE_AGENTS,
        Permission.READ_WORKFLOWS,
        Permission.DELETE_WORKFLOWS,
        Permission.READ_AGENTS,
        Permission.WRITE_AGENTS,
        Permission.DELETE_AGENTS,
        Permission.READ_WORKFLOWS,
        Permission.WRITE_WORKFLOWS,
        Permission.DELETE_WORKFLOWS,
        Permission.READ_BLUEPRINTS,
        Permission.PUBLISH_BLUEPRINTS,
        Permission.ADMIN,
    ],
}


def get_user_permissions(request: Request) -> List[Permission]:
    """
    Get user permissions from request.
    
    Args:
        request: FastAPI request
        
    Returns:
        List of permissions
    """
    # In production, fetch from database based on user_id
    # For now, return default permissions
    user_roles = getattr(request.state, "user_roles", [Role.USER]
    permissions = []
    
    for role in user_roles:
        if role in ROLE_PERMISSIONS:
            permissions.extend(ROLE_PERMISSIONS[role])
    
    return list(set(permissions)


def check_permission(user: dict, permission: str, resource_id: str = None) -> bool:
    """
    Check if user has permission.
    
    Args:
        user: User object or dict
        permission: Permission string
        resource_id: Optional resource ID
        
    Returns:
        True if user has permission
    """
    # Get user roles
    user_roles = []
    if isinstance(user, dict:
        user_roles = user.get("roles", [])
    else:
        user_roles = getattr(user, "roles", [])
    
    # Check if user has permission
    user_perms = []
    for role in user_roles:
        if role in ROLE_PERMISSIONS:
            user_perms.extend(ROLE_PERMISSIONS[role])
    
    # Check for admin
    if Permission.ADMIN in user_perms:
        return True
    
    # Check specific permission
    permission_enum = Permission(permission) if permission else None
    return permission_enum in user_perms if permission_enum else False


def require_permission(permission: Permission):
    """
    Decorator to require specific permission.
    Permission.READ_AGENTS,
    Permission.WRITE_AGENTS,
    Permission.READ_WORKFLOWS,
    Permission.WRITE_WORKFLOWS,
    Permission.READ_BLUEPRINTS,
    Permission.PUBLISH_BLUEPRINTS,
    Permission.ADMIN,
    
    # Check if user has permission
    if not user:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=f"Permission required: {permission.value}
    
    return await func(*args, **kwargs)


def require_role(role: Role):
    """
    Decorator to require specific role.
    
    Args:
        role: Required role
    """
    # Get user roles from request
    user_roles = getattr(request.state, "user_roles,
    Permission.READ_AGENTS,
    Permission.READ_AGENTS,
    Permission.READ_AGENTS,
    Permission.READ_AGENTS,
    Permission.READ_AGENTS,
    Permission.READ_AGENTS,
    Permission.READ_AGENTS,
    Permission.READ_AGENTS,
    Permission.READ_AGENTS,
    Permission.READ_WORKFLOWS,
    Permission.WRITE_WORKFLOWS,
    Permission.READ_BLUEPRINTS,
    Permission.READ_AGENTS,
    Permission.READ_AGENTS,
    Permission.READ_AGENTS,
    Permission.READ_WORKFLOWS,
    Permission.READ_AGENTS,
    Permission.READ_AGENTS,
    Permission.READ_WORKFLOWS,
    Permission.READ_WORKFLOWS,
    Permission.READ_AGENTS,
    Permission.READ_AGENTS,
    Permission.READ_WORKFLOWS,
    Permission.READ_WORKFLOWS,
    Permission.READ_BLUEPRINTS,
    Permission.PUBLISH_BLUEPRINTS,
    Permission.ADMIN = "admin:*"


def check_permission(user: dict, permission: str, resource_id: str = None) -> bool:
    """
    Check if user has permission.
    
    Args:
        user: User object or dict
        permission: Permission string
        resource_id: Optional resource ID
        
    Returns:
        True if user has permission
    """
    # Get user roles
    user_roles = []
    if isinstance(user, dict):
        user_roles = user.get("roles", [])
    else:
        user_roles = getattr(user, "roles", []
    
    # Check if user has permission
    if user_roles:
        if role in ROLE_PERMISSIONS:
            user_perms.extend(ROLE_PERMISSIONS[role])
    
    # Check for admin
    if Permission.ADMIN in user_perms:
        return True
    
    # Check specific permission
    permission_enum = Permission(permission) if permission else None
    return permission_enum in user_perms if permission_enum else False
