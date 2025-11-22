"""
CLI commands for configuration management.
"""

import typer
import json
import os
from pathlib import Path
from typing import Optional

app = typer.Typer(name="config", help="Configuration management")


@app.command()
def check(
    config_file: Optional[str] = typer.Option(None, "--file", "-f", help="Config file path"),
):
    """Check configuration validity."""
    from agent_factory.utils.config import Config
    
    typer.echo("🔍 Checking configuration...\n")
    
    try:
        config = Config(config_file)
        
        # Check registry path
        registry_path = Path(config.registry_path).expanduser()
        typer.echo(f"📁 Registry Path: {registry_path}")
        if registry_path.exists():
            typer.echo("   ✅ Directory exists")
        else:
            typer.echo("   ⚠️  Directory does not exist (will be created)")
        
        # Check API keys
        typer.echo(f"\n🔐 API Keys:")
        openai_key = config.openai_api_key
        anthropic_key = config.anthropic_api_key
        
        if openai_key:
            masked = openai_key[:4] + "..." + openai_key[-4:] if len(openai_key) > 8 else "***"
            typer.echo(f"   ✅ OpenAI API Key: {masked}")
        else:
            typer.echo(f"   ⚠️  OpenAI API Key: Not set")
        
        if anthropic_key:
            masked = anthropic_key[:4] + "..." + anthropic_key[-4:] if len(anthropic_key) > 8 else "***"
            typer.echo(f"   ✅ Anthropic API Key: {masked}")
        else:
            typer.echo(f"   ⚠️  Anthropic API Key: Not set")
        
        # Check environment
        typer.echo(f"\n🌍 Environment: {config.environment}")
        
        # Check API base URL
        typer.echo(f"🌐 API Base URL: {config.api_base_url}")
        
        typer.echo("\n✅ Configuration check complete")
        
    except Exception as e:
        typer.echo(f"❌ Configuration check failed: {e}")
        raise typer.Exit(1)


@app.command()
def show(
    format: str = typer.Option("text", "--format", "-f", help="Output format (text, json)"),
):
    """Show current configuration."""
    from agent_factory.utils.config import Config
    
    config = Config()
    
    config_dict = {
        "registry_path": config.registry_path,
        "environment": config.environment,
        "api_base_url": config.api_base_url,
        "openai_api_key_set": bool(config.openai_api_key),
        "anthropic_api_key_set": bool(config.anthropic_api_key),
    }
    
    if format == "json":
        typer.echo(json.dumps(config_dict, indent=2))
    else:
        typer.echo("📋 Current Configuration:\n")
        for key, value in config_dict.items():
            if "key" in key.lower():
                value = "***" if value else "Not set"
            typer.echo(f"  {key}: {value}")


@app.command()
def validate(
    config_file: Optional[str] = typer.Option(None, "--file", "-f", help="Config file path"),
):
    """Validate configuration file."""
    from agent_factory.utils.config import Config
    
    if not config_file:
        # Check common locations
        config_files = [".env", "~/.agent_factory/.env"]
        config_file = next(
            (f for f in config_files if Path(f).expanduser().exists()),
            None
        )
        
        if not config_file:
            typer.echo("❌ No configuration file found")
            typer.echo("💡 Create a .env file or specify with --file")
            raise typer.Exit(1)
    
    config_path = Path(config_file).expanduser()
    
    if not config_path.exists():
        typer.echo(f"❌ Configuration file not found: {config_path}")
        raise typer.Exit(1)
    
    typer.echo(f"🔍 Validating: {config_path}\n")
    
    try:
        config = Config(str(config_path))
        
        # Validate required settings
        issues = []
        
        if not config.openai_api_key and not config.anthropic_api_key:
            issues.append("At least one API key (OpenAI or Anthropic) should be set")
        
        registry_path = Path(config.registry_path).expanduser()
        try:
            registry_path.mkdir(parents=True, exist_ok=True)
        except Exception as e:
            issues.append(f"Cannot create registry directory: {e}")
        
        if issues:
            typer.echo("⚠️  Validation issues found:")
            for issue in issues:
                typer.echo(f"   - {issue}")
            raise typer.Exit(1)
        else:
            typer.echo("✅ Configuration is valid")
            
    except Exception as e:
        typer.echo(f"❌ Validation failed: {e}")
        raise typer.Exit(1)
