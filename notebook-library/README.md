# Notebook Library

A scalable, production-ready library of Jupyter notebook packs for the Keys marketplace.

## Overview

The Notebook Library provides a standardized format for creating, validating, and distributing Jupyter notebook packs. Each pack is a self-contained, runnable notebook with metadata, documentation, and sample data.

## Structure

```
notebook-library/
├── packs/              # All notebook packs
│   ├── pack_0001/     # Agentic AI Master Notebook
│   ├── pack_0002/     # CSV → Insight Report Generator
│   ├── pack_0003/     # Prompt Evaluation Harness
│   ├── pack_0004/     # Competitor Table Builder
│   ├── pack_0005/     # Stripe Export Cleaner
│   └── pack_0006/     # RAG Chunking & Embedding Prep
├── tools/             # Pack management tools
│   ├── create_pack.py      # Create new pack from template
│   ├── validate_pack.py    # Validate pack structure and execute
│   ├── build_release.py    # Build release zips
│   ├── render_previews.py  # Generate preview assets
│   └── generate_library_json.py  # Generate library index
├── templates/         # Pack template for new packs
├── dist/              # Built release zips
├── library.json       # Library index (auto-generated)
└── LICENSING.md       # Licensing boundaries documentation
```

## Quick Start

### Validate All Packs

```bash
make validate
# or
python tools/validate_pack.py --all
```

### Build Release

```bash
make build
# or
python tools/build_release.py
```

### Create New Pack

```bash
make create-pack
# or
python tools/create_pack.py
```

### Generate Library Index

```bash
make generate
# or
python tools/generate_library_json.py
```

## Pack Format

Each pack follows a standard structure:

```
pack_XXXX/
├── main.ipynb          # Main notebook (required)
├── pack.json           # Pack metadata (required)
├── README.md           # Pack documentation
├── quickstart.md       # Quick start guide
├── requirements.txt    # Python dependencies
├── pyproject.toml     # Alternative dependency spec
├── LICENSE.txt        # Pack license
├── CHANGELOG.md       # Version history
├── .env.example       # Environment variables template
├── data/              # Sample input data
├── outputs/            # Generated outputs (not in release)
└── assets/            # Cover images, flow diagrams, previews
```

## Pack Metadata Schema

See `pack.json` schema in template: `templates/pack_template/pack.json`

Key fields:
- `id`, `slug`, `title`, `version`
- `category`: ai_ops, finops, consulting, devtools, rag
- `difficulty`: beginner, intermediate, advanced
- `runtime_minutes`: Estimated execution time
- `inputs`: Required/optional input files
- `outputs`: Generated output files
- `license.spdx`: License identifier

## Tools

### create_pack.py

Creates a new pack from template with interactive prompts.

```bash
python tools/create_pack.py
```

### validate_pack.py

Validates pack structure and optionally executes notebooks.

```bash
# Validate structure only
python tools/validate_pack.py pack_0001

# Validate and execute
python tools/validate_pack.py pack_0001 --execute

# Validate all packs
python tools/validate_pack.py --all --execute
```

### build_release.py

Creates release zip files for packs and library.

```bash
# Build single pack
python tools/build_release.py pack_0001

# Build all packs and library release
python tools/build_release.py
```

### render_previews.py

Generates cover images, flow diagrams, and HTML previews.

```bash
# Render single pack
python tools/render_previews.py pack_0001

# Render all packs
python tools/render_previews.py --all
```

## CI/CD

GitHub Actions workflow (`.github/workflows/validate.yml`) automatically:
- Validates all packs on push/PR
- Generates library.json
- Builds release zips
- Uploads artifacts

## Marketplace Integration

See `/docs/notebook-library-marketplace.md` for integration details with Keys marketplace.

Key principles:
- **Metadata-only**: Keys reads only JSON metadata, no code import
- **Process separation**: Notebooks executed as subprocesses
- **Clean licensing**: No GPL contamination of Keys codebase

## Licensing

See `LICENSING.md` for detailed licensing boundaries and compliance guidelines.

Current status:
- All packs: GPL-3.0-only (inherited from seed)
- Future packs: Can be MIT/Proprietary if clean-room authored
- Keys integration: Metadata-only, no code import

## Contributing

1. Create new pack: `make create-pack`
2. Implement notebook in `main.ipynb`
3. Update `pack.json` with inputs/outputs
4. Add sample data to `data/`
5. Validate: `make validate`
6. Build: `make build`

## Current Packs

1. **pack_0001**: Agentic AI Master Notebook - Complete reference for building agentic AI systems
2. **pack_0002**: CSV → Insight Report Generator - Statistical analysis and reporting
3. **pack_0003**: Prompt Evaluation Harness - Prompt scoring and drift detection
4. **pack_0004**: Competitor Table Builder - Competitive analysis tables
5. **pack_0005**: Stripe Export Cleaner - CSV cleaning and transformation
6. **pack_0006**: RAG Chunking & Embedding Prep - Document preparation for RAG

## Next Steps

1. **Pricing Integration**: Add pricing fields to pack.json
2. **Preview Generation**: Improve HTML preview rendering
3. **Test Suite**: Add automated notebook tests
4. **Documentation**: Expand pack-specific documentation
5. **Marketplace UI**: Build Keys marketplace integration

---

**Version**: 1.0.0  
**Last Updated**: 2025-01-XX
