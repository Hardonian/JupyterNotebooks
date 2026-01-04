# Competitor Table Builder

## What Problem This Pack Solves

Building competitor comparison tables manually requires researching competitors, collecting data from multiple sources, formatting consistently, and maintaining updates—a time-consuming process prone to errors and inconsistencies. This pack eliminates that friction by automating competitor data collection (with optional web scraping) and generating ready-to-use comparison tables in multiple formats.

## What You Get

- **Comparison Tables** - Structured competitor data in CSV and JSON formats
- **Data Collection** - Optional web scraping with graceful offline fallback
- **Analysis Ready** - Formatted data ready for further analysis or presentation

## How It Works

The notebook follows a deterministic, step-by-step process:

1. **Configuration** - Sets input/output paths and scraping preferences
2. **Environment Validation** - Checks Python version, required packages, and write permissions
3. **Input Loading** - Loads competitor data JSON or generates sample data if not provided
4. **Table Building** - Structures data into comparison table format
5. **Output Writing** - Saves CSV and JSON outputs to outputs directory

The notebook is designed to run top-to-bottom without any hidden state or dependencies on prior executions. All randomness is seeded for deterministic results.

## Inputs Required

### Required
- None (pack generates sample competitor data if input not provided)

### Optional
- `data/competitors.json` - Your competitor data (will generate sample if not provided)
  ```json
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
  ```
- `ENABLE_SCRAPING=true` - Environment variable to enable web scraping (default: false, offline mode)

### Example Inputs

```bash
# Use sample data (automatic)
jupyter notebook main.ipynb

# Or provide your own data
cat > data/competitors.json << EOF
{
  "competitors": [
    {
      "name": "My Competitor",
      "category": "SMB",
      "pricing": "$49/month",
      "features": ["Feature A", "Feature B"],
      "rating": 4.2,
      "users": "5K+"
    }
  ]
}
EOF
```

## Outputs Produced

All outputs are written to the `outputs/` directory:

1. **`outputs/competitor_table.csv`** - Comparison table in CSV format
   ```csv
   name,category,pricing,rating,users,features_count,features
   Competitor A,Enterprise,$99/month,4.5,10K+,3,"Feature 1, Feature 2, Feature 3"
   ```

2. **`outputs/competitor_table.json`** - Comparison table in JSON format with metadata
   ```json
   {
     "metadata": {
       "generated_at": "2026-01-04T...",
       "total_competitors": 3,
       "scraping_enabled": false
     },
     "competitors": [...]
   }
   ```

## Common Failure Modes + Fixes

### Error: "Python 3.10+ required"
**Fix:** Upgrade Python to 3.10 or higher. Check version with `python --version`.

### Error: "Required package not installed"
**Fix:** Install dependencies: `pip install -r requirements.txt`

### Error: "Cannot write to outputs"
**Fix:** Ensure write permissions in the current directory. Run `chmod u+w .` if needed.

### Error: "Input data is empty or invalid"
**Fix:** Ensure your competitors.json has a "competitors" array with at least one competitor object.

### Warning: "Web scraping is disabled"
**Fix:** This is normal. The pack works in offline mode by default. To enable scraping, set `ENABLE_SCRAPING=true` environment variable (requires additional setup).

## License + Support Expectations

- **License:** GPL-3.0-only (see LICENSE.txt)
- **Support:** This is a commercial pack sold through the Keys marketplace. Support is provided through the marketplace platform.
- **Warranty:** Pack is provided "as-is" without warranty. Test in a development environment before production use.

## This Pack Is For

- Consultants building competitor analysis reports
- Product managers researching market positioning
- Business analysts comparing competitive features
- Teams needing structured competitor data

## This Pack Is NOT For

- Complete beginners to Python (requires Python 3.10+ knowledge)
- Users needing real-time live web scraping (requires additional setup)
- Projects requiring proprietary/closed-source licensing (pack is GPL-3.0)
- Users who need automated web scraping without customization (offline mode by default)

## Technical Details

- **Runtime:** ~15 minutes (depends on data size)
- **Dependencies:** pandas (see requirements.txt)
- **Deterministic:** Yes - all randomness seeded, no hidden state
- **Idempotent:** Yes - can be run multiple times safely (overwrites outputs)
- **Web Scraping:** Optional, disabled by default (offline mode)

## Next Steps After Running

1. Review `outputs/competitor_table.csv` for comparison data
2. Check `outputs/competitor_table.json` for structured format
3. Import into analysis tools (Excel, Python, etc.)
4. Enable web scraping if needed for live data collection

---

**Version:** 1.0.0  
**Last Updated:** 2026-01-04
