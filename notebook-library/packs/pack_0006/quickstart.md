# Quick Start Guide

Copy and paste these commands to get started:

## 1. Install Dependencies

```bash
pip install -r requirements.txt
```

Or with uv:

```bash
uv pip install -r requirements.txt
```

## 2. Configure Environment (if needed)

```bash
cp .env.example .env
# Edit .env with your API keys or settings
```

## 3. Run the Notebook

### Option A: Interactive (Jupyter)

```bash
jupyter notebook main.ipynb
```

### Option B: Headless Execution

```bash
jupyter nbconvert --to notebook --execute main.ipynb --output executed.ipynb
```

## 4. Check Outputs

Outputs will be generated in the `outputs/` directory (or as specified in pack.json).

## Troubleshooting

- **Missing dependencies**: Ensure Python 3.10+ is installed
- **API errors**: Check `.env` file for required API keys
- **Import errors**: Verify all dependencies are installed
