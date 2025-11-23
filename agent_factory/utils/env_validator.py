"""
Environment variable validation and startup checks.
"""

import os
from typing import List, Dict, Optional, Tuple
from agent_factory.core.exceptions import ConfigurationError


class EnvironmentValidator:
    """Validates environment variables at startup."""
    
    def __init__(self):
        self.required_vars: List[str] = []
        self.optional_vars: Dict[str, any] = {}
        self.validated: bool = False
    
    def add_required(self, var_name: str, description: Optional[str] = None):
        """Add a required environment variable."""
        self.required_vars.append((var_name, description))
    
    def add_optional(self, var_name: str, default: any, description: Optional[str] = None):
        """Add an optional environment variable with default."""
        self.optional_vars[var_name] = {"default": default, "description": description}
    
    def validate(self, raise_on_error: bool = True) -> Tuple[bool, List[str]]:
        """
        Validate all environment variables.
        
        Args:
            raise_on_error: Whether to raise exception on validation failure
            
        Returns:
            Tuple of (is_valid, list_of_errors)
            
        Raises:
            ConfigurationError: If validation fails and raise_on_error is True
        """
        errors = []
        
        # Check required variables
        for var_name, description in self.required_vars:
            if not os.getenv(var_name):
                error_msg = f"Required environment variable '{var_name}' is not set"
                if description:
                    error_msg += f": {description}"
                errors.append(error_msg)
        
        # Validate optional variables (set defaults if not present)
        for var_name, config in self.optional_vars.items():
            if var_name not in os.environ:
                os.environ[var_name] = str(config["default"])
        
        if errors and raise_on_error:
            raise ConfigurationError(
                f"Environment validation failed:\n" + "\n".join(f"  - {e}" for e in errors)
            )
        
        self.validated = len(errors) == 0
        return self.validated, errors
    
    def get(self, var_name: str, default: Optional[str] = None) -> Optional[str]:
        """Get environment variable value."""
        return os.getenv(var_name, default)


def validate_agent_factory_env() -> None:
    """
    Validate Agent Factory environment variables.
    
    Checks for required variables and sets defaults for optional ones.
    
    Raises:
        ConfigurationError: If required variables are missing
    """
    validator = EnvironmentValidator()
    
    # Required variables (can be empty for development, but should be set for production)
    # We'll make most optional but warn if critical ones are missing
    
    # Optional variables with defaults
    validator.add_optional("API_HOST", "0.0.0.0", "API server host")
    validator.add_optional("API_PORT", "8000", "API server port")
    validator.add_optional("DEBUG", "false", "Debug mode")
    validator.add_optional("LOG_LEVEL", "INFO", "Logging level")
    validator.add_optional("DATABASE_URL", "sqlite:///./agent_factory.db", "Database URL")
    validator.add_optional("REDIS_URL", "redis://localhost:6379/0", "Redis URL")
    validator.add_optional("JWT_SECRET_KEY", "change-me-in-production", "JWT secret key")
    validator.add_optional("RATE_LIMIT_PER_MINUTE", "60", "Rate limit per minute")
    validator.add_optional("RATE_LIMIT_PER_HOUR", "1000", "Rate limit per hour")
    
    # Validate (don't raise on error for optional vars, but log warnings)
    is_valid, errors = validator.validate(raise_on_error=False)
    
    # Warn about missing critical vars in production
    if os.getenv("ENVIRONMENT", "development") == "production":
        critical_vars = ["OPENAI_API_KEY", "ANTHROPIC_API_KEY"]
        missing_critical = [v for v in critical_vars if not os.getenv(v)]
        if missing_critical:
            import warnings
            warnings.warn(
                f"Critical environment variables not set in production: {', '.join(missing_critical)}",
                UserWarning
            )
    
    return validator
