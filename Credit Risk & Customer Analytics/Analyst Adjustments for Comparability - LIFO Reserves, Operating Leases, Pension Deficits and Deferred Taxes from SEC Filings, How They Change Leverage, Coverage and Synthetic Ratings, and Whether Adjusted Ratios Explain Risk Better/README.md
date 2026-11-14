# Analyst Adjustments for Comparability: LIFO Reserves, Operating Leases, Pension Deficits and Deferred Taxes from SEC Filings, How They Change Leverage, Coverage and Synthetic Ratings, and Whether Adjusted Ratios Explain Risk Better

Reported ratios are not comparable across companies, because accounting choices and standards move items on and off the balance sheet. The CFA curriculum's financial-statement-analysis readings ask the analyst to **adjust** them before comparing:

- **LIFO reserve:** a company using LIFO reports inventory at old costs. Adding the reserve converts inventory (and, after tax, equity) to FIFO, and the change in the reserve converts cost of sales.
- **Operating leases:** since ASC 842 (2019) operating lease liabilities are on U.S. balance sheets, but outside reported "debt". Rating agencies add them to debt, add the lease cost back to EBITDA and treat the interest part of the lease cost as interest.
- **Pension deficits:** an underfunded defined-benefit plan is a debt-like obligation; agencies add the after-tax deficit to debt.
- **Deferred tax liabilities:** when they are not expected to reverse (a growing company keeps investing), many analysts treat them as equity rather than as liabilities.

This notebook applies the four adjustments to every U.S. listed company that reports the relevant XBRL items for fiscal 2019–2025, and measures:

1. How much the adjustments change leverage, coverage and returns, and in which industries.
2. How much they **reshuffle rankings** and synthetic credit ratings (interest coverage mapped to ratings with Damodaran's table).
3. Whether adjusted leverage is the **better risk measure**: does it explain the next year's equity volatility better than reported leverage, in a regression and in LightGBM?

**Data.** SEC XBRL frames API (debt, operating lease liabilities, cost and discount rates, LIFO reserves, pension funded status, deferred taxes, EBIT, depreciation, interest, equity, assets, revenue, cost of sales, taxes; 2019–2025); SEC Financial Statement Data Sets (industry codes); Damodaran Online (interest coverage to rating table); Yahoo Finance (monthly prices).

**Methods.** LIFO-to-FIFO conversion, lease capitalisation with interest and depreciation split, pension and deferred-tax adjustments, leverage and coverage ratios, synthetic ratings, Spearman rank changes, OLS and LightGBM with grouped cross-validation.

**Key output.** Reported vs adjusted ratios by industry; the companies most changed by each adjustment; rating migrations; and whether the adjustments improve the explanation of risk.

---

## Why it matters

The curriculum's analyst adjustments (LIFO reserves, operating leases, pension deficits, deferred taxes) are applied to about 1,700 U.S. non-financial companies from their XBRL filings. Operating leases dominate: they add 17% to reported debt, raise median debt to EBITDA from 1.7 to 2.1 (retail 0.5 to 2.2, restaurants 2.3 to 4.3) and move one company in five by more than ten percentiles in leverage rankings. LIFO and pension adjustments are large for a few companies but small overall. Synthetic ratings from coverage fall for 14% of companies and eleven drop from investment grade to high yield. Adjusted ratios explain next-year equity volatility only marginally better than reported ones (R² 0.228 vs 0.224).

## How to run

1. `conda activate quant-risk`. Put `SEC_USER_AGENT` and `FRED_API_KEY` in `.env` (the FRED key is required by the shared setup cell).
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 5 minutes on the first run (SEC and Yahoo downloads), 1 minute afterwards).

## Data sources

| Data | Source |
|---|---|
| SEC XBRL frames API and Financial Statement Data Sets | https://www.sec.gov/edgar/sec-api-documentation |
| Damodaran Online: coverage to rating table | https://pages.stern.nyu.edu/~adamodar/ |
| Yahoo Finance: monthly prices | https://finance.yahoo.com/ |

## Outputs (`outputs/`)

- `01_analyst_adjustments.png`
- `adjustments_by_sector.csv`
- `dashboard.html`
- `dashboard.png`
- `rating_migration.csv`
- `reported_vs_adjusted.csv`
- `volatility_models.csv`

## Key assumptions

- Non-financial companies with revenue above USD 250 m, fiscal 2019–2025; effective tax rate clipped to 0–35% (21% if missing).
- Adjusted debt = debt + operating lease liability + after-tax pension deficit; EBITDA + lease cost; lease interest = reported discount rate × lease liability; LIFO reserve added to inventory and (after tax) equity; net deferred tax liabilities treated as equity.
- Synthetic ratings from Damodaran's coverage table for companies reporting interest; volatility models use log annualised volatility of the next twelve months' returns, five-fold cross-validation grouped by company.

## Suggested commit plan

1. `analyst-adjustments-comparability: add XBRL items for leases, LIFO, pensions and deferred taxes`
2. `analyst-adjustments-comparability: add reported and adjusted ratios and rank changes`
3. `analyst-adjustments-comparability: add sector and company tables`
4. `analyst-adjustments-comparability: add synthetic rating migration and volatility models`
5. `analyst-adjustments-comparability: add charts, dashboard and narrative`

## References

- U.S. Securities and Exchange Commission. XBRL frames API and Financial Statement Data Sets. https://www.sec.gov/edgar/sec-api-documentation
- Damodaran, A. Ratings, interest coverage ratios and default spread. https://pages.stern.nyu.edu/~adamodar/
- Yahoo Finance. Monthly prices. https://finance.yahoo.com/
- CFA Institute. *CFA Program Curriculum Level I*, Financial Statement Analysis: Inventories; Long-Term Liabilities and Equity; Income Taxes; Financial Analysis Techniques.
- Financial Accounting Standards Board. ASC 842 *Leases*; ASC 715 *Compensation—Retirement Benefits*; ASC 330 *Inventory*; ASC 740 *Income Taxes*.
- Moody's Investors Service (2018). Financial Statement Adjustments in the Analysis of Non-Financial Corporations.
- Merton, R. C. (1974). On the pricing of corporate debt: The risk structure of interest rates. *Journal of Finance*, 29(2), 449–470.
- Kraft, P. (2015). Rating agency adjustments to GAAP financial statements and their effect on ratings and credit spreads. *The Accounting Review*, 90(2), 641–674.
