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

## 2. Configure Environment (Optional)

```bash
cp .env.example .env
# Edit .env with your API keys:
# OPENAI_API_KEY=sk-your-key-here
# ANTHROPIC_API_KEY=sk-ant-your-key-here
```

**Note:** The notebook can run without API keys for learning purposes, but full functionality requires keys.

## 3. Run the Notebook

### Option A: Interactive (Jupyter)

```bash
jupyter notebook main.ipynb
```

### Option B: Headless Execution

```bash
jupyter nbconvert --to notebook --execute main.ipynb --output executed.ipynb
```

## 4. Quick Test Paths

**Path 1: Test in 5 minutes**
- Run Cells 1 → 3 → 4 → Done!

**Path 2: Production Bot in 2-4 hours**
- Run Cells 1-3 → 14 → 12-13 → Deploy!

**Path 3: Master Everything in 8-12 hours**
- Run all cells sequentially

## Troubleshooting

- **Missing dependencies**: Ensure Python 3.10+ is installed
- **API errors**: Check `.env` file for required API keys
- **Import errors**: Verify all dependencies are installed
- **Notebook execution errors**: Run cells sequentially, some depend on previous cells
