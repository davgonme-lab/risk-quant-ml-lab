# Economic Value Added and Market Value Added for the S&P 500: ROIC, WACC and EVA from SEC Filings since 2010, R&D Capitalisation, and Whether Value Creation Explains Market Value and Future Returns Better than Earnings

Accounting profit ignores the cost of equity. A company that earns USD 1 billion on USD 20 billion of capital looks profitable, but if its investors expect 9% a year it is destroying value. **Economic Value Added** (EVA), popularised by Stern Stewart & Co. in the 1990s, charges every company for all the capital it uses:

EVA = NOPAT − WACC × Invested capital = (ROIC − WACC) × Invested capital

**Market Value Added** (MVA) is what the market thinks of it: the market value of the company's debt and equity minus the capital invested. In theory, MVA equals the present value of all future EVA, so a firm with a positive spread between its return on invested capital (ROIC) and its weighted average cost of capital (WACC) should trade above its invested capital.

This notebook computes both for the non-financial companies of the S&P 500 from their own 10-K filings since fiscal 2010, and tests the claims made for EVA:

- **Who creates value?** ROIC, WACC and EVA by company, sector and year, and how persistent the spread between ROIC and WACC is.
- **R&D capitalisation**, the best-known EVA adjustment: research spending is treated as an investment amortised over five years instead of an expense.
- **Does EVA explain market value better than earnings?** Cross-sectional regressions and out-of-time ridge, k-nearest-neighbour and LightGBM models of the market-to-capital ratio, with EVA measures, earnings measures or both.
- **Does it predict returns?** Fama–MacBeth regressions and out-of-time models of the next year's stock return after the 10-K is filed, the test that Biddle, Bowen and Wallace (1997) made famous.

**Data.** SEC EDGAR XBRL company facts (10-K income statements and balance sheets as first filed, shares outstanding); iShares Core S&P 500 ETF holdings (constituents and sectors); Yahoo Finance (prices, dividends and splits); FRED (10-year Treasury yield).

**Methods.** NOPAT and operating invested capital, effective tax rates, CAPM cost of equity with Blume-adjusted betas, after-tax cost of debt, market-value weights, EVA and MVA, R&D capitalisation, quintile transition matrices and AR(1) persistence, cross-sectional OLS and Fama–MacBeth regressions, ridge, k-nearest-neighbour and LightGBM regression, out-of-time R² and rank correlation.

**Key output.** ROIC, WACC, EVA and MVA for each company and year; the sector map of value creation; how R&D capitalisation changes the picture; and which measures explain market value and future returns.

---

## Why it matters

From their own 10-K filings, 342 non-financial S&P 500 companies earned a median ROIC of 11.6% against a 7.1% WACC since 2010. Total EVA rose from USD 148 bn to USD 506 bn in fiscal 2025, three quarters of it from five technology companies, while the share of companies creating value fell from about 75% to about 60% as rates rose. The ROIC − WACC spread explains market-to-capital ratios better than earnings (median R² 0.47 vs 0.38; 0.61 out of time with LightGBM on both), but neither EVA nor earnings predicts next-year returns once the 10-K is public.

## How to run

1. `conda activate quant-risk`. `.env` needs `SEC_USER_AGENT` and `FRED_API_KEY` in `.env`; Yahoo Finance and iShares need no key.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 1 minute with cached data; the first SEC download takes about 5 minutes).

## Data sources

| Data | Source |
|---|---|
| SEC EDGAR XBRL company facts API (10-K statements, shares outstanding) | https://www.sec.gov/edgar/sec-api-documentation |
| iShares Core S&P 500 ETF holdings (constituents and sectors) | https://www.ishares.com/us/products/239726/ |
| Yahoo Finance daily prices, dividends and splits (yfinance) | https://finance.yahoo.com/ |
| FRED 10-year Treasury yield (DGS10) | https://fred.stlouisfed.org/series/DGS10 |

## Outputs (`outputs/`)

- `01_eva_mva_overview.png`
- `dashboard.html`
- `dashboard.png`
- `eva_by_sector_latest.csv`
- `eva_by_year.csv`
- `eva_mva_company_years.csv`
- `fama_macbeth_returns.csv`
- `market_value_cross_sectional_r2.csv`
- `market_value_models_out_of_time.csv`
- `return_models_out_of_time.csv`
- `spread_quintile_transitions_3y.csv`

## Key assumptions

- Today's S&P 500 members excluding financials and real estate; 10-K values as first filed; fiscal year = year of the fiscal year-end (year before if it ends before June); invested capital = assets − cash and short-term investments − non-interest-bearing current liabilities.
- NOPAT = operating income × (1 − effective tax rate bounded at 0–40%, statutory if pre-tax income ≤ 0); cost of equity = 10-year Treasury + Blume-adjusted 60-month beta × 5%; cost of debt = interest ÷ average debt bounded between the Treasury yield and yield + 6%, after statutory tax (35%, 21% from 2018).
- R&D capitalised over five years from fiscal 2014; models trained on fiscal years to 2018 (returns to 2017) and tested from 2019; next-year excess return over SPY starting the day after the 10-K filing.

## Suggested commit plan

1. `eva-mva-sp500: add S&P 500 universe and SEC 10-K facts`
2. `eva-mva-sp500: add ROIC, WACC, EVA and MVA`
3. `eva-mva-sp500: add persistence and R&D capitalisation`
4. `eva-mva-sp500: add market-value and return tests`
5. `eva-mva-sp500: add charts, dashboard and narrative`

## References

- Stewart, G. B. (1991). *The Quest for Value: The EVA Management Guide*. HarperBusiness.
- Biddle, G. C., Bowen, R. M., & Wallace, J. S. (1997). Does EVA beat earnings? Evidence on associations with stock returns and firm values. *Journal of Accounting and Economics*, 24(3), 301–336.
- Koller, T., Goedhart, M., & Wessels, D. (2020). *Valuation: Measuring and Managing the Value of Companies* (7th ed.). Wiley.
- Lev, B., & Sougiannis, T. (1996). The capitalization, amortization, and value-relevance of R&D. *Journal of Accounting and Economics*, 21(1), 107–138.
- Fama, E. F., & MacBeth, J. D. (1973). Risk, return, and equilibrium: Empirical tests. *Journal of Political Economy*, 81(3), 607–636.
- Blume, M. E. (1971). On the assessment of risk. *Journal of Finance*, 26(1), 1–10.
- Mauboussin, M. J., & Callahan, D. (2022). *Return on invested capital: How to calculate ROIC and handle common issues*. Morgan Stanley Investment Management, Consilient Research.
- U.S. Securities and Exchange Commission. *EDGAR XBRL company facts API*. https://www.sec.gov/edgar/sec-api-documentation
- BlackRock iShares. *iShares Core S&P 500 ETF (IVV) holdings*. https://www.ishares.com/us/products/239726/
