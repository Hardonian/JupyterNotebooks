# Building Agent Factory

## Prerequisites

- Python 3.8 or higher
- pip 21.0 or higher
- build tools: `pip install build`

## Building from Source

### 1. Clone the Repository

```bash
git clone https://github.com/agentfactory/platform.git
cd platform
```

### 2. Install Build Dependencies

```bash
pip install build twine
```

### 3. Build the Package

```bash
# Build source distribution and wheel
python -m build

# Outputs will be in dist/:
# - agent_factory-0.1.0.tar.gz (source distribution)
# - agent_factory-0.1.0-py3-none-any.whl (wheel)
```

### 4. Install Locally (Development)

```bash
# Install in editable mode with dev dependencies
pip install -e ".[dev]"

# Or with demo dependencies
pip install -e ".[dev,demo]"
```

### 5. Install from Built Package

```bash
pip install dist/agent_factory-0.1.0-py3-none-any.whl
```

## Versioning

Agent Factory follows [Semantic Versioning](https://semver.org/):
- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes (backward compatible)

Current version: `0.1.0` (Beta)

To update version:
1. Update `version` in `pyproject.toml`
2. Update `__version__` in `agent_factory/__init__.py`
3. Commit changes
4. Tag release: `git tag v0.1.0`

## Publishing to PyPI

### Test PyPI (for testing)

```bash
# Upload to test PyPI
python -m twine upload --repository testpypi dist/*

# Test install
pip install --index-url https://test.pypi.org/simple/ agent-factory
```

### Production PyPI

```bash
# Upload to PyPI (requires credentials)
python -m twine upload dist/*

# Install from PyPI
pip install agent-factory
```

## Building Docker Image

```bash
# Build Docker image
docker build -t agent-factory:0.1.0 -f docker/Dockerfile .

# Run container
docker run -p 8000:8000 agent-factory:0.1.0
```

## CLI Entry Point

After installation, the `agent-factory` CLI command is available:

```bash
agent-factory --help
agent-factory version
agent-factory init my-project
```

## Development Setup

```bash
# Clone and setup
git clone https://github.com/agentfactory/platform.git
cd platform
pip install -e ".[dev]"

# Run tests
pytest

# Run linters
ruff check .
black --check .

# Run type checker
mypy agent_factory
```

## Package Structure

```
agent_factory/
├── __init__.py          # Package initialization and exports
├── agents/              # Agent implementations
├── api/                 # FastAPI REST API
├── cli/                 # CLI commands
├── core/                # Core primitives
├── integrations/        # LLM integrations
├── marketplace/         # Marketplace functionality
├── registry/            # Registry system
└── runtime/             # Execution engine
```

## Distribution Files

- `pyproject.toml`: Package metadata and build configuration
- `README.md`: Project documentation
- `LICENSE`: GPL-3.0 license
- `MANIFEST.in`: Additional files to include in distribution (if needed)

## Troubleshooting

### Build fails with "No module named 'build'"

```bash
pip install build
```

### Import errors after installation

Ensure you're using the correct Python environment:
```bash
which python
which pip
```

### CLI command not found

Ensure the package is installed:
```bash
pip install -e .
agent-factory --help
```
