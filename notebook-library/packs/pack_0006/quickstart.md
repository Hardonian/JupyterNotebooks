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

## Optional: Use Your Own Documents

```bash
# Place your documents in the data directory
cat your_documents.txt > data/documents.txt
jupyter notebook main.ipynb
```

## Check Outputs

```bash
ls -la outputs/
cat outputs/rag_preparation_report.md
cat outputs/chunks.json | head -50
```
