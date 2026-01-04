# Agentic AI Master Notebook

## Overview

Complete production-ready reference and bootstrap tool for building agentic AI systems. This comprehensive notebook covers:

- **OpenAI Agents SDK** - Building agents with custom tools, handoffs, guardrails, and memory
- **CrewAI Framework** - Multi-agent teams and orchestration
- **MCP Servers** - Model Context Protocol implementation
- **LangGraph** - Stateful workflow management
- **Production Deployment** - Docker, monitoring, and observability
- **Ready-to-use Templates** - Customer support bot and research assistant

## Quick Start

See [quickstart.md](quickstart.md) for copy/paste commands.

## Requirements

- Python 3.10+
- OpenAI API key (optional for learning, required for execution)
- See `pyproject.toml` for full dependency list

## Usage

1. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

2. Configure environment (optional):
   ```bash
   cp .env.example .env
   # Edit .env with your API keys
   ```

3. Run the notebook:
   ```bash
   jupyter notebook main.ipynb
   ```

## Inputs

- `.env` (optional) - API keys for OpenAI, Anthropic, etc.

## Outputs

- `outputs/project_structure.json` - Generated project structure metadata
- `outputs/agent_configs.json` - Agent factory configurations
- Generated project folders and files (if using project structure generator)

## License

See [LICENSE.txt](LICENSE.txt) for license information (GPL-3.0-only).

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history.
