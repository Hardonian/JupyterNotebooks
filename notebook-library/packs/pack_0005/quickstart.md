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

## Optional: Use Your Own Stripe Export

```bash
# Export from Stripe dashboard and place in data directory
cp stripe_export.csv data/stripe_export.csv
jupyter notebook main.ipynb
```

## Check Outputs

```bash
ls -la outputs/
head outputs/stripe_cleaned.csv
```
