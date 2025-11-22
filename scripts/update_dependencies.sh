#!/bin/bash
# Update dependencies safely

set -e

echo "🔍 Checking for outdated packages..."
pip list --outdated

echo ""
echo "📦 Updating security patches..."
pip install --upgrade pip
pip install --upgrade -r requirements.txt 2>/dev/null || echo "No requirements.txt found"

echo ""
echo "🧪 Running tests..."
pytest tests/ -v --tb=short || {
    echo "❌ Tests failed after dependency update!"
    exit 1
}

echo ""
echo "🔍 Running linters..."
ruff check agent_factory/ tests/ || {
    echo "⚠️  Linting issues found"
}

black --check agent_factory/ tests/ || {
    echo "⚠️  Formatting issues found"
}

echo ""
echo "✅ Dependencies updated successfully!"
