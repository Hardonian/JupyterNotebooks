# CSV → Insight Report Generator

## What Problem This Pack Solves

Analyzing CSV data manually requires loading data, calculating statistics, creating visualizations, and writing reports—a time-consuming process that often leads to inconsistent analysis and missed insights. This pack eliminates that friction by automating the entire pipeline from raw CSV data to comprehensive insight reports with statistical analysis and actionable recommendations.

## What You Get

- **Statistical Analysis** - Automated calculation of descriptive statistics, correlations, and data quality metrics
- **Data Quality Assessment** - Missing values, duplicates, and data completeness analysis
- **Insight Report** - Professional markdown report with findings and recommendations

## How It Works

The notebook follows a deterministic, step-by-step process:

1. **Configuration** - Sets input/output paths and analysis parameters
2. **Environment Validation** - Checks Python version, required packages, and write permissions
3. **Input Loading** - Loads CSV file or generates sample data if not provided
4. **Statistical Analysis** - Calculates numeric and categorical summaries
5. **Report Generation** - Creates comprehensive markdown report with insights
6. **Output Writing** - Saves statistics JSON and report markdown to outputs directory

The notebook is designed to run top-to-bottom without any hidden state or dependencies on prior executions. All randomness is seeded for deterministic results.

## Inputs Required

### Required
- None (pack generates sample data if input not provided)

### Optional
- `data/input.csv` - Your CSV file to analyze (will generate sample if not provided)

### Example Inputs

```bash
# Place your CSV file in the data directory
cp your_data.csv data/input.csv
```

## Outputs Produced

All outputs are written to the `outputs/` directory:

1. **`outputs/statistics.json`** - Complete statistical analysis results
   ```json
   {
     "summary": {
       "total_rows": 100,
       "total_columns": 5,
       "missing_values": 0,
       "duplicate_rows": 0
     },
     "numeric_summary": {...},
     "categorical_summary": {...}
   }
   ```

2. **`outputs/report.md`** - Generated insight report with analysis and recommendations

## Common Failure Modes + Fixes

### Error: "Python 3.10+ required"
**Fix:** Upgrade Python to 3.10 or higher. Check version with `python --version`.

### Error: "Required package not installed"
**Fix:** Install dependencies: `pip install -r requirements.txt`

### Error: "Cannot write to outputs"
**Fix:** Ensure write permissions in the current directory. Run `chmod u+w .` if needed.

### Error: "Input CSV is empty"
**Fix:** Provide a CSV file with data, or let the pack generate sample data automatically.

### Warning: "Input CSV not found"
**Fix:** This is normal. The pack will generate sample data automatically. To use your own data, place it at `data/input.csv`.

## License + Support Expectations

- **License:** GPL-3.0-only (see LICENSE.txt)
- **Support:** This is a commercial pack sold through the Keys marketplace. Support is provided through the marketplace platform.
- **Warranty:** Pack is provided "as-is" without warranty. Test in a development environment before production use.

## This Pack Is For

- Data analysts needing quick insight reports from CSV files
- Business users who want automated data analysis
- Developers building data analysis pipelines
- Teams needing consistent reporting formats

## This Pack Is NOT For

- Complete beginners to Python (requires Python 3.10+ knowledge)
- Users needing real-time streaming analysis (this processes static CSV files)
- Projects requiring proprietary/closed-source licensing (pack is GPL-3.0)
- Users who need advanced visualizations (basic analysis only)

## Technical Details

- **Runtime:** ~15 minutes (depends on CSV size)
- **Dependencies:** pandas, numpy (see requirements.txt)
- **Deterministic:** Yes - all randomness seeded, no hidden state
- **Idempotent:** Yes - can be run multiple times safely (overwrites outputs)

## Next Steps After Running

1. Review `outputs/report.md` for insights
2. Check `outputs/statistics.json` for detailed metrics
3. Use the statistics for further analysis or visualization
4. Customize the report template for your specific needs

---

**Version:** 1.0.0  
**Last Updated:** 2026-01-04
