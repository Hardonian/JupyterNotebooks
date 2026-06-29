# Agent Factory

CLI toolkit and framework for building, testing, and running AI agent configurations.

**Status:** Active development (local). Functional CLI with 18 commands, blueprint system, knowledge packs, and Docker deployment for a research assistant app.

## What It Is

Agent Factory is a Python-based agent framework with:
- **CLI** — agent creation, management, blueprints, knowledge packs, execution, metrics, evaluation
- **Blueprint system** — pre-defined agent configurations (support bot, research assistant, learning path generator, etc.)
- **Knowledge packs** — shareable domain knowledge bundles for agents
- **Apps** — deployable reference apps (research assistant with Docker)
- **Runtime** — execution engine with telemetry, security validation, evaluation

## Quick Start

```bash
# Install locally
pip install -e ".[dev]"

# Run tests
pytest tests/

# CLI entry point
agent-factory --help
```

### CLI Commands

```bash
agent-factory agent create calculator --name "Calculator" --instructions "You help with math"
agent-factory agent run calculator --input "Calculate 20% of 100"
```

## Tech Stack

- **Python** — primary language (CLI, SDK, API)
- **Click** — CLI framework
- **FastAPI / Uvicorn** — REST API
- **SQLAlchemy / Supabase** — data layer
- **Pydantic** — validation
- **Docker** — app deployment
- **GitHub Actions** — CI

## Project Structure

```
agent_factory/
├── cli/commands/        # 18 CLI commands
├── core/                # Core primitives (Agent, Tool, Workflow)
├── blueprints/          # 6 pre-built agent blueprints
├── knowledge_packs/     # Domain knowledge bundles
├── runtime/             # Execution engine
├── api/                 # REST API (FastAPI)
├── security/            # Auth, RBAC, sanitization
├── telemetry/           # Analytics and metrics
├── apps/                # Deployable reference apps
└── tests/               # Test suite
```

## Blueprints

| Blueprint | Domain |
|-----------|--------|
| support_bot | Customer support automation |
| research_assistant | Academic research help |
| learning_path_generator | Education content |
| assessment_assistant | Quiz and assessment generation |
| student_support_assistant | Student help desk |
| minimal_example | Reference implementation |

## Development

```bash
# Install dev dependencies
pip install -e ".[dev]"

# Lint
ruff check agent_factory/ tests/
ruff format --check agent_factory/ tests/

# Type check
mypy agent_factory/

# Run tests
pytest tests/
```

## Deployment

The [research_assistant_app](apps/research_assistant_app/) includes a Dockerfile and docker-compose.yml for containerized deployment.

See `apps/research_assistant_app/README.md` for details.

## Documentation

See `docs/` directory for local documentation:

- [Getting Started](docs/GETTING_STARTED.md)
- [Stack Discovery](docs/stack-discovery.md)
- [Local Development](docs/local-dev.md)
- [CI/CD Overview](docs/ci-overview.md)
- [Backend Strategy](docs/backend-strategy.md)

## License

GPL-3.0
