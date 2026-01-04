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

## Optional: Use Your Own Competitor Data

```bash
# Create competitors.json with your data
cat > data/competitors.json << EOF
{
  "competitors": [
    {
      "name": "Competitor A",
      "category": "Enterprise",
      "pricing": "$99/month",
      "features": ["Feature 1", "Feature 2"],
      "rating": 4.5,
      "users": "10K+"
    }
  ]
}
EOF

jupyter notebook main.ipynb
```

## Optional: Enable Web Scraping

```bash
export ENABLE_SCRAPING=true
jupyter notebook main.ipynb
```

## Check Outputs

```bash
ls -la outputs/
cat outputs/competitor_table.csv
cat outputs/competitor_table.json
```
