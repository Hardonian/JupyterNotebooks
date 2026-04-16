# Quickstart

Minimal local setup for this repository.

## Prerequisites

- Git
- Current language runtime(s) used in this repo

## Setup

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt || pip install -e .
pytest || true
```

## Notes

- Prefer reproducible, testable changes
- Run CI-equivalent checks before PR
