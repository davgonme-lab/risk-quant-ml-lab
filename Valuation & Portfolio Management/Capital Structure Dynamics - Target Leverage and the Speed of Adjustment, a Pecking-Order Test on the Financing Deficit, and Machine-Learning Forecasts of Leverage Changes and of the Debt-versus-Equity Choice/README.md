# Capital Structure Dynamics: Target Leverage and the Speed of Adjustment, a Pecking-Order Test on the Financing Deficit, and Machine-Learning Forecasts of Leverage Changes and of the Debt-versus-Equity Choice

Why do companies have the debt they have? The CFA curriculum presents two classic answers:

- **Trade-off theory:** each company has a **target** leverage that balances the tax shield of debt against the expected cost of financial distress; deviations from the target are corrected over time, at a measurable **speed of adjustment** (Flannery and Rangan, 2006).
- **Pecking-order theory:** because of information asymmetry, companies finance with internal cash first, then debt, and issue equity only as a last resort; leverage is then the cumulative result of past financing deficits, not of a target (Shyam-Sunder and Myers, 1999).

Both are tested here on every U.S. non-financial company that reports the inputs in XBRL from 2010 to 2025, and machine learning is asked two practical questions: how much will a company's leverage change next year, and when it raises external money, will it issue debt or equity?

**Data.** SEC XBRL frames API (debt, assets, equity, EBIT, depreciation, property, plant and equipment, operating cash flow, capital expenditure, dividends, debt and equity issued and repaid, revenue; 2009–2025); SEC Financial Statement Data Sets (industry codes).

**Methods.** Book leverage, target-leverage regressions, partial-adjustment models (pooled OLS and firm fixed effects), financing-deficit (pecking-order) regressions, LightGBM forecasts of leverage changes, logistic regression and LightGBM for the debt-versus-equity choice, rolling out-of-sample evaluation.

**Key output.** What drives target leverage; how fast companies close the gap; whether financing deficits are funded with debt; and how well leverage changes and issuance choices can be predicted.

---

## Why it matters

Book leverage of about 5,000 U.S. non-financial, non-utility companies (2010–2025) is tested against the trade-off and pecking-order theories with XBRL data. The partial-adjustment model closes 11% of the gap to target each year with pooled OLS and 46% with firm fixed effects; targets follow industry leverage and size. Financing deficits are funded mostly with equity (coefficient 0.37) rather than debt (0.06), far from a strict pecking order. Next year's leverage is best forecast as unchanged (mean error 5.6 points; LightGBM 5.8), but the debt-versus-equity choice is very predictable (AUC 0.86): profitable, large, dividend-paying companies borrow.

## How to run

1. `conda activate quant-risk`. Put `SEC_USER_AGENT` and `FRED_API_KEY` in `.env` (the FRED key is required by the shared setup cell).
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 6 minutes on the first run (SEC downloads), 1 minute afterwards).

## Data sources

| Data | Source |
|---|---|
| SEC XBRL frames API and Financial Statement Data Sets | https://www.sec.gov/edgar/sec-api-documentation |

## Outputs (`outputs/`)

- `01_capital_structure.png`
- `dashboard.html`
- `dashboard.png`
- `issuance_choice.csv`
- `leverage_forecasts.csv`
- `pecking_order_tests.csv`
- `speed_of_adjustment.csv`
- `target_leverage_determinants.csv`

## Key assumptions

- Non-financial, non-utility companies with assets above USD 100 m; book leverage = (long-term + short-term debt) / assets.
- Partial adjustment with profitability, tangibility, size, growth, depreciation, dividend payment and industry median leverage, by pooled OLS and firm fixed effects (clustered errors).
- Financing deficit = dividends + capex − CFO; net debt = change in balance-sheet debt; issuers = net debt or net equity above 5% of assets; issuance models trained to 2018 and tested on 2019–2025.

## Suggested commit plan

1. `capital-structure-dynamics: add XBRL capital-structure items`
2. `capital-structure-dynamics: add target leverage and speed of adjustment`
3. `capital-structure-dynamics: add pecking-order tests on the financing deficit`
4. `capital-structure-dynamics: add leverage forecasts and issuance-choice models`
5. `capital-structure-dynamics: add charts, dashboard and narrative`

## References

- U.S. Securities and Exchange Commission. XBRL frames API and Financial Statement Data Sets. https://www.sec.gov/edgar/sec-api-documentation
- CFA Institute. *CFA Program Curriculum Level I*, Corporate Issuers: Capital Structure.
- Myers, S. C., & Majluf, N. S. (1984). Corporate financing and investment decisions when firms have information that investors do not have. *Journal of Financial Economics*, 13(2), 187–221.
- Shyam-Sunder, L., & Myers, S. C. (1999). Testing static tradeoff against pecking order models of capital structure. *Journal of Financial Economics*, 51(2), 219–244.
- Frank, M. Z., & Goyal, V. K. (2003). Testing the pecking order theory of capital structure. *Journal of Financial Economics*, 67(2), 217–248.
- Flannery, M. J., & Rangan, K. P. (2006). Partial adjustment toward target capital structures. *Journal of Financial Economics*, 79(3), 469–506.
- Lemmon, M. L., Roberts, M. R., & Zender, J. F. (2008). Back to the beginning: Persistence and the cross-section of corporate capital structure. *Journal of Finance*, 63(4), 1575–1608.
