# Contributing to Agent Factory

**Founder, CEO & Operator:** Scott Hardie

Thank you for your interest in contributing to Agent Factory! This guide will help you get started.

**Note from Founder:** Agent Factory exists because I've lived the problem of turning AI prototypes into production. After building multiple AI-driven systems and spending 15+ years in EdTech, I know how hard infrastructure can be. Your contributions help make AI agents accessible to everyone. Thank you!

---

## 🤝 How to Contribute

### Reporting Bugs

Found a bug? Please open an issue with:
- **Clear description** of the problem
- **Steps to reproduce** the issue
- **Expected vs. actual behavior**
- **Environment details** (Python version, OS, etc.)
- **Error messages** or logs (if applicable)

### Suggesting Features

Have an idea? Open an issue with:
- **Clear description** of the feature
- **Use case** and motivation
- **Proposed implementation** (if you have one)
- **Examples** or mockups (if applicable)

### Contributing Code

1. **Fork the repository**
2. **Create a branch:** `git checkout -b feature/your-feature-name`
3. **Make your changes:** Follow our coding standards
4. **Write tests:** Ensure your code is tested
5. **Update docs:** Update relevant documentation
6. **Submit a PR:** Include a clear description

---

## 🛠️ Development Setup

### Prerequisites

- Python 3.8+
- pip
- git

### Installation

```bash
# Clone your fork
git clone https://github.com/your-username/platform.git
cd platform

# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -e ".[dev]"
```

### Running Tests

```bash
# Run all tests
pytest tests/

# Run specific test file
pytest tests/test_agent.py

# Run with coverage
pytest --cov=agent_factory --cov-report=html
```

### Code Quality

```bash
# Format code
black agent_factory/ tests/

# Lint code
ruff check agent_factory/ tests/

# Type checking
mypy agent_factory/
```

---

## 📝 Coding Standards

### Python Style

- Follow **PEP 8** style guide
- Use **type hints** for all functions
- Write **docstrings** for all public functions/classes
- Keep functions **focused** and **small**

### Code Formatting

We use **Black** for code formatting:

```bash
black agent_factory/ tests/
```

### Linting

We use **Ruff** for linting:

```bash
ruff check agent_factory/ tests/
```

### Type Checking

We use **mypy** for type checking:

```bash
mypy agent_factory/
```

---

## 🧪 Testing

### Writing Tests

- Write tests for all new features
- Use **pytest** for testing
- Mock external dependencies
- Keep tests **fast** and **deterministic**

### Test Structure

```python
import pytest
from agent_factory import Agent

@pytest.mark.unit
def test_agent_creation():
    """Test creating an agent."""
    agent = Agent(
        id="test-agent",
        name="Test Agent",
        instructions="Test"
    )
    assert agent.id == "test-agent"
```

### Running Tests

```bash
# Run all tests
pytest

# Run unit tests only
pytest -m unit

# Run with verbose output
pytest -v

# Run specific test
pytest tests/test_agent.py::test_agent_creation
```

---

## 📚 Documentation

### Docstrings

Use Google-style docstrings:

```python
def create_agent(id: str, name: str, instructions: str) -> Agent:
    """Create a new agent.
    
    Args:
        id: Unique identifier for the agent
        name: Display name for the agent
        instructions: Instructions for the agent
        
    Returns:
        Created Agent instance
        
    Raises:
        ValueError: If agent ID already exists
    """
    pass
```

### Updating Documentation

- Update relevant docs when adding features
- Add examples for new features
- Keep documentation **clear** and **concise**

---

## 🔀 Pull Request Process

### Before Submitting

- [ ] Code follows style guidelines
- [ ] Tests pass locally
- [ ] Documentation updated
- [ ] No merge conflicts
- [ ] Commit messages are clear

### PR Description

Include:
- **What** changed
- **Why** it changed
- **How** to test
- **Screenshots** (if UI changes)

### Review Process

- Maintainers will review your PR
- Address feedback promptly
- Be open to suggestions
- Keep PRs **focused** and **small**

---

## 🎯 Good First Issues

Looking for your first contribution? Check out issues labeled `good-first-issue`:
- Documentation improvements
- Test coverage
- Example code
- Bug fixes

---

## 📋 Commit Messages

Use clear, descriptive commit messages:

```
feat: Add support for custom tools

- Allow users to define custom tools
- Add tool validation
- Update documentation

Fixes #123
```

### Commit Types

- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `test:` Test additions/changes
- `refactor:` Code refactoring
- `style:` Code style changes
- `chore:` Maintenance tasks

---

## 🚫 What Not to Contribute

- Code that breaks existing functionality
- Features without tests
- Changes without documentation
- Code that doesn't follow style guidelines

---

## ❓ Questions?

- **Technical questions:** Open a GitHub Discussion
- **Bug reports:** Open a GitHub Issue
- **General:** Check our [documentation](docs/)

---

## 🙏 Thank You!

Your contributions make Agent Factory better for everyone. Thank you for taking the time to contribute!

---

## 📜 License

By contributing, you agree that your contributions will be licensed under the GPL-3.0 License.
