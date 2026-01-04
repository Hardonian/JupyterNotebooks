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

## Optional: Use Your Own CSV

```bash
cp your_data.csv data/input.csv
jupyter notebook main.ipynb
```

## Check Outputs

```bash
ls -la outputs/
cat outputs/report.md
cat outputs/statistics.json
```
