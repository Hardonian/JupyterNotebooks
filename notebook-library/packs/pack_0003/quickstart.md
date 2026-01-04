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

## Optional: Use Your Own Prompts

```bash
# Create prompts.json with your data
cat > data/prompts.json << EOF
{
  "prompts": [
    {
      "id": "my_prompt",
      "text": "Your prompt text",
      "category": "summarization",
      "version": "1.0"
    }
  ]
}
EOF

jupyter notebook main.ipynb
```

## Check Outputs

```bash
ls -la outputs/
cat outputs/evaluation_report.md
cat outputs/evaluation_results.json
```
