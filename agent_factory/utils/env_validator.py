"""
Environment variable validation for Agent Factory.

Validates required and optional environment variables on startup.
"""

import os
from typing import Dict, List, Optional, Tuple
from dataclasses import dataclass


@dataclass
class EnvVar:
    """Environment variable definition."""
    name: str
    required: bool = False
    default: Optional[str] = None
    description: str = ""
    validator: Optional[callable] = None


class EnvironmentValidationError(Exception):
    """Raised when environment validation fails."""
    pass


def validate_agent_factory_env() -> Dict[str, any]:
    """
    Validate Agent Factory environment variables.
    
    Returns:
        Dictionary of validated environment variables
        
    Raises:
        EnvironmentValidationError: If validation fails
    """
    errors = []
    warnings = []
    validated = {}
    
    # Required environment variables
    required_vars = [
        EnvVar(
            name="DATABASE_URL",
            required=True,
            description="Database connection URL (PostgreSQL or SQLite)"
        ),
    ]
    
    # Optional but recommended environment variables
    optional_vars = [
        EnvVar(
            name="OPENAI_API_KEY",
            required=False,
            description="OpenAI API key for LLM access"
        ),
        EnvVar(
            name="ANTHROPIC_API_KEY",
            required=False,
            description="Anthropic API key for LLM access"
        ),
        EnvVar(
            name="JWT_SECRET_KEY",
            required=False,
            default="change-me-in-production",
            description="Secret key for JWT token signing"
        ),
        EnvVar(
            name="REDIS_URL",
            required=False,
            description="Redis connection URL for caching"
        ),
        EnvVar(
            name="API_HOST",
            required=False,
            default="0.0.0.0",
            description="API server host"
        ),
        EnvVar(
            name="API_PORT",
            required=False,
            default="8000",
            description="API server port"
        ),
        EnvVar(
            name="LOG_LEVEL",
            required=False,
            default="INFO",
            description="Logging level (DEBUG, INFO, WARNING, ERROR)"
        ),
    ]
    
    # Validate required variables
    for var in required_vars:
        value = os.getenv(var.name)
        if not value:
            errors.append(f"Required environment variable {var.name} is not set: {var.description}")
        else:
            validated[var.name] = value
            # Run validator if provided
            if var.validator:
                try:
                    var.validator(value)
                except Exception as e:
                    errors.append(f"Invalid value for {var.name}: {str(e)}")
    
    # Validate optional variables
    for var in optional_vars:
        value = os.getenv(var.name, var.default)
        if value:
            validated[var.name] = value
            # Run validator if provided
            if var.validator:
                try:
                    var.validator(value)
                except Exception as e:
                    warnings.append(f"Invalid value for {var.name}: {str(e)}")
        elif var.required:
            errors.append(f"Required environment variable {var.name} is not set: {var.description}")
    
    # Validate LLM providers (at least one should be configured)
    has_openai = bool(os.getenv("OPENAI_API_KEY"))
    has_anthropic = bool(os.getenv("ANTHROPIC_API_KEY"))
    
    if not has_openai and not has_anthropic:
        warnings.append(
            "No LLM provider configured (OPENAI_API_KEY or ANTHROPIC_API_KEY). "
            "Agent functionality will be limited."
        )
    
    # Validate database URL format
    database_url = validated.get("DATABASE_URL")
    if database_url:
        if not (database_url.startswith("postgresql://") or 
                database_url.startswith("sqlite:///")):
            errors.append(
                "DATABASE_URL must start with 'postgresql://' or 'sqlite:///'"
            )
    
    # Validate JWT secret in production
    jwt_secret = validated.get("JWT_SECRET_KEY", os.getenv("JWT_SECRET_KEY"))
    debug_mode = os.getenv("DEBUG", "false").lower() == "true"
    
    if not debug_mode and jwt_secret in ["change-me-in-production", "your-secret-key-change-in-production"]:
        warnings.append(
            "JWT_SECRET_KEY is using default value. Change it in production!"
        )
    
    # Validate Redis URL format if provided
    redis_url = validated.get("REDIS_URL") or os.getenv("REDIS_URL")
    if redis_url:
        if not redis_url.startswith("redis://"):
            warnings.append(
                "REDIS_URL should start with 'redis://'. "
                "Cache functionality may not work correctly."
            )
    
    # Validate log level
    log_level = validated.get("LOG_LEVEL", "INFO").upper()
    valid_log_levels = ["DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"]
    if log_level not in valid_log_levels:
        warnings.append(
            f"Invalid LOG_LEVEL '{log_level}'. "
            f"Valid values: {', '.join(valid_log_levels)}. Using INFO."
        )
        validated["LOG_LEVEL"] = "INFO"
    
    # Raise error if critical issues found
    if errors:
        error_message = "Environment validation failed:\n" + "\n".join(f"  - {e}" for e in errors)
        if warnings:
            error_message += "\n\nWarnings:\n" + "\n".join(f"  - {w}" for w in warnings)
        raise EnvironmentValidationError(error_message)
    
    # Log warnings if any
    if warnings:
        import logging
        logger = logging.getLogger(__name__)
        for warning in warnings:
            logger.warning(f"Environment validation warning: {warning}")
    
    return validated


def validate_database_url(url: str) -> None:
    """Validate database URL format."""
    if not url:
        raise ValueError("Database URL cannot be empty")
    
    if not (url.startswith("postgresql://") or url.startswith("sqlite:///")):
        raise ValueError("Database URL must start with 'postgresql://' or 'sqlite:///'")


def validate_redis_url(url: str) -> None:
    """Validate Redis URL format."""
    if not url:
        raise ValueError("Redis URL cannot be empty")
    
    if not url.startswith("redis://"):
        raise ValueError("Redis URL must start with 'redis://'")


def validate_jwt_secret(secret: str) -> None:
    """Validate JWT secret key."""
    if not secret:
        raise ValueError("JWT secret cannot be empty")
    
    if len(secret) < 32:
        raise ValueError("JWT secret should be at least 32 characters long")


def get_validated_env() -> Dict[str, str]:
    """
    Get validated environment variables.
    
    Returns:
        Dictionary of validated environment variables
        
    Raises:
        EnvironmentValidationError: If validation fails
    """
    return validate_agent_factory_env()
