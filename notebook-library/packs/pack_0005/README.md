# Stripe Export Cleaner

## What Problem This Pack Solves

Stripe export CSV files often contain formatting inconsistencies, missing values, currency in cents, and duplicate entries that make analysis difficult. Manually cleaning these files is time-consuming and error-prone. This pack eliminates that friction by automating the cleaning and transformation of Stripe exports into analysis-ready datasets without requiring API access.

## What You Get

- **Data Cleaning** - Automated handling of missing values, duplicates, and formatting issues
- **Format Standardization** - Consistent date formats, currency handling (cents to dollars), and column naming
- **Analysis Ready** - Clean CSV output ready for financial analysis and reporting

## How It Works

The notebook follows a deterministic, step-by-step process:

1. **Configuration** - Sets input/output paths and cleaning options
2. **Environment Validation** - Checks Python version, required packages, and write permissions
3. **Input Loading** - Loads Stripe export CSV or generates sample data if not provided
4. **Data Cleaning** - Removes duplicates, standardizes dates and currency, cleans column names
5. **Output Writing** - Saves cleaned CSV to outputs directory

The notebook is designed to run top-to-bottom without any hidden state or dependencies on prior executions. All randomness is seeded for deterministic results.

## Inputs Required

### Required
- None (pack generates sample Stripe export if input not provided)

### Optional
- `data/stripe_export.csv` - Your Stripe export file (will generate sample if not provided)

### Example Inputs

```bash
# Export from Stripe dashboard and place in data directory
cp stripe_export.csv data/stripe_export.csv
```

## Outputs Produced

All outputs are written to the `outputs/` directory:

1. **`outputs/stripe_cleaned.csv`** - Cleaned and transformed CSV
   - Duplicates removed
   - Dates standardized
   - Currency converted from cents to dollars (amount_decimal column)
   - Column names standardized (lowercase, underscores)

## Common Failure Modes + Fixes

### Error: "Python 3.10+ required"
**Fix:** Upgrade Python to 3.10 or higher. Check version with `python --version`.

### Error: "Required package not installed"
**Fix:** Install dependencies: `pip install -r requirements.txt`

### Error: "Cannot write to outputs"
**Fix:** Ensure write permissions in the current directory. Run `chmod u+w .` if needed.

### Error: "Input CSV is empty"
**Fix:** Provide a Stripe export CSV file with data, or let the pack generate sample data automatically.

### Warning: "Input CSV not found"
**Fix:** This is normal. The pack will generate sample Stripe export data automatically. To use your own export, place it at `data/stripe_export.csv`.

### Note: Column Names
**Important:** The pack standardizes column names to lowercase with underscores. If your Stripe export has different column names, the cleaning will adapt accordingly.

## License + Support Expectations

- **License:** GPL-3.0-only (see LICENSE.txt)
- **Support:** This is a commercial pack sold through the Keys marketplace. Support is provided through the marketplace platform.
- **Warranty:** Pack is provided "as-is" without warranty. Test in a development environment before production use.

## This Pack Is For

- Finance teams analyzing Stripe transaction data
- Business analysts preparing financial reports
- Developers building financial dashboards
- Accountants needing clean transaction data

## This Pack Is NOT For

- Complete beginners to Python (requires Python 3.10+ knowledge)
- Users needing real-time Stripe API integration (this processes static exports)
- Projects requiring proprietary/closed-source licensing (pack is GPL-3.0)
- Users who need advanced financial calculations (basic cleaning only)

## Technical Details

- **Runtime:** ~10 minutes (depends on CSV size)
- **Dependencies:** pandas (see requirements.txt)
- **Deterministic:** Yes - all randomness seeded, no hidden state
- **Idempotent:** Yes - can be run multiple times safely (overwrites outputs)
- **API Required:** No - works with Stripe export CSV files only

## Next Steps After Running

1. Review `outputs/stripe_cleaned.csv` for cleaned data
2. Import into Excel, Python, R, or other analysis tools
3. Perform financial analysis and reporting
4. Set up automated cleaning pipeline for regular exports

---

**Version:** 1.0.0  
**Last Updated:** 2026-01-04
