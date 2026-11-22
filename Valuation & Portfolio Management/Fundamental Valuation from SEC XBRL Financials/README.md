# Fundamental Valuation from SEC XBRL Financials

A credit analyst needs a market-consistent view of what a company is worth, because equity value is the cushion that sits above the debt. Comparable-company multiples are the everyday tool, usually built from an expensive vendor database. Every U.S. filer, though, now tags its statements in machine-readable XBRL. This notebook builds the fundamentals panel from those filings and asks how much better than sector comps a model can price a company.

**What it does.** It builds a clean fundamentals panel for about 900 large U.S.-headquartered non-financial companies directly from SEC XBRL filings, and models each company's price-to-sales multiple from its fundamentals.

Sector comps, OLS, Elastic Net and LightGBM are compared out of fold, rich and cheap names are flagged, and the notebook checks whether last year's "cheap" names actually outperformed.

**Data.** The SEC EDGAR XBRL *frames* API (one call returns one line item for every filer), company submissions (SIC codes), the SEC ticker map, and Yahoo Finance prices for market capitalisation and forward returns.

**Methods.** ETL and tag harmonisation in DuckDB SQL, and ratio engineering (growth, margins, cash conversion, leverage, Altman Z″).

Sector-median comps, OLS, Elastic Net and LightGBM are compared with K-fold and leave-sector-out cross-validation, explained with TreeSHAP, and followed by a one-year forward-return test by valuation residual.

**Key output.** Out-of-fold valuation error by model, feature attributions, the richest and cheapest names today, and forward returns by residual quintile.

---

## Why it matters

Equity value is the cushion above a counterparty's debt. Built straight from SEC XBRL for 770 U.S. non-financial companies, a LightGBM model on fundamentals prices companies with a 47% typical error against 109% for sector-median comps. Its residuals flag names where the market prices risks the accounts miss (wildfire liabilities, guidance resets). Last year's cheap quintile beat the rich one by 16 points, but not significantly.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (**about 16 minutes** on the first run (SEC rate limits: ~100 frames requests and ~1,600 submissions files, cached for later runs) `.env` also needs `SEC_USER_AGENT="Your Name your@email"` (SEC fair-access policy).).

## Data sources

| Data | Source |
|---|---|
| XBRL frames (one tag, one period, all filers) | https://data.sec.gov/api/xbrl/frames/ |
| Company submissions (SIC codes) | https://data.sec.gov/submissions/ |
| Ticker map | https://www.sec.gov/files/company_tickers.json |
| Prices | Yahoo Finance via `yfinance` |

## Outputs (`outputs/`)

- `01_multiples_by_sector.png`
- `02_shap.png`
- `dashboard.html`
- `dashboard.png`
- `backtest_quintiles.csv`
- `cv_scores.csv`
- `valuation_residuals.csv`

## Key assumptions

- Target log(market cap / revenue); EV/Sales dropped because debt tags are missing for about half of filers.
- U.S.-headquartered filers only (ADRs mis-scale shares and currency); revenue ≥ $500m; banks, insurers and REITs excluded.
- Forward test: FY2024 fundamentals priced 30 Apr 2025, returns to 30 Apr 2026; today's ticker list (survivorship bias).

## Suggested commit plan

1. `add README and valuation framework`
2. `XBRL frames ETL and tag harmonisation in DuckDB`
3. `universe, SIC sectors and prices`
4. `ratio features and cross-validated models`
5. `TreeSHAP, rich/cheap list, forward-return test, dashboard and executed outputs`

## References

### Finance and regulation

- Liu, J., Nissim, D., & Thomas, J. (2002). Equity valuation using multiples. *Journal of Accounting Research, 40*(1), 135–172. https://doi.org/10.1111/1475-679X.00042
- Alford, A. W. (1992). The effect of the set of comparable firms on the accuracy of the price-earnings valuation method. *Journal of Accounting Research, 30*(1), 94–108. https://doi.org/10.2307/2491093
- Bhojraj, S., & Lee, C. M. C. (2002). Who is my peer? A valuation-based approach to the selection of comparable firms. *Journal of Accounting Research, 40*(2), 407–439. https://doi.org/10.1111/1475-679X.00054
- Altman, E. I. (1968). Financial ratios, discriminant analysis and the prediction of corporate bankruptcy. *The Journal of Finance, 23*(4), 589–609. https://doi.org/10.1111/j.1540-6261.1968.tb00843.x

### Machine learning and deep learning

- Zou, H., & Hastie, T. (2005). Regularization and variable selection via the elastic net. *Journal of the Royal Statistical Society: Series B, 67*(2), 301–320. https://doi.org/10.1111/j.1467-9868.2005.00503.x
- Ke, G., Meng, Q., Finley, T., Wang, T., Chen, W., Ma, W., Ye, Q., & Liu, T.-Y. (2017). LightGBM: A highly efficient gradient boosting decision tree. *Advances in Neural Information Processing Systems, 30*. https://proceedings.neurips.cc/paper/2017/hash/6449f44a102fde848669bdd9eb6b76fa-Abstract.html
- Lundberg, S. M., Erion, G., Chen, H., DeGrave, A., Prutkin, J. M., Nair, B., … Lee, S.-I. (2020). From local explanations to global understanding with explainable AI for trees. *Nature Machine Intelligence, 2*(1), 56–67. https://doi.org/10.1038/s42256-019-0138-9
- Raasveldt, M., & Mühleisen, H. (2019). DuckDB: An embeddable analytical database. In *Proceedings of the 2019 International Conference on Management of Data*. https://doi.org/10.1145/3299869.3320212
