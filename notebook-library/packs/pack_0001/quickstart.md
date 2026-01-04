# Quick Start

## Install Dependencies

```bash
pip install -r requirements.txt
```

## Run Notebook

```bash
jupyter notebook main.ipynb
```

## Or Execute Headless

```bash
jupyter nbconvert --to notebook --execute main.ipynb --output executed.ipynb
```

## Optional: Set Project Name

```bash
export PROJECT_NAME="my_custom_agent"
jupyter notebook main.ipynb
```

## Optional: Configure API Keys

```bash
cp .env.example .env
# Edit .env and add: OPENAI_API_KEY=sk-your-key-here
```

## Check Outputs

```bash
ls -la outputs/
cat outputs/execution_summary.md
```
