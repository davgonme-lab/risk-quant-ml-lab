# Spread Duration & CS01 by Asset Class

Once a treasury swaps its bonds to floating, interest-rate risk is mostly gone, but credit-spread risk is not: when spreads widen, the bonds lose value and the swaps do not move. How much that costs depends a lot on what the portfolio holds. This notebook measures spread risk sleeve by sleeve and replays the crises that would hurt most.

**What it does.** It measures the credit-spread risk of an MDB-style treasury portfolio sleeve by sleeve (agencies, USD sovereigns, sub-sovereigns, banks and corporates) and stresses it with historical and hypothetical spread scenarios.

**Data.** Live bond-level holdings of five iShares ETFs (GOVT, AGZ, EMB, MUB, IGIB), today's Treasury par curve (U.S. Treasury), three years of daily ICE BofA OAS by rating bucket and 40 years of Moody's Baa/Aaa spreads (FRED).

**Methods.** Spread duration, CS01 and duration-times-spread (DTS) per bond, regression betas of each rating bucket to the long-history Baa spread, and an empirical test of the DTS hypothesis.

Full-revaluation scenario P&L and historical spread VaR and ES complete the analysis.

**Key output.** CS01 and DTS by sleeve against limits, crisis-replay losses (2008, 2011, 2020, 2022), parallel and proportional spread shocks, spread VaR, and a spread-risk dashboard.

---

## Why it matters

Once a treasury swaps its bonds to floating, the main residual market risk is the credit spread of each bond. Spread risk differs a lot across asset classes, and the usual DTS shortcut does not hold everywhere: the data here show tight-spread buckets moving more than their spread level implies. Betas estimated on recent data, applied to 40 years of Baa history, turn past crises into today's losses.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (under a minute).

## Data sources

| Data | Link |
|---|---|
| iShares holdings (GOVT 239468, AGZ 239457, EMB 239572, MUB 239766, IGIB 239463) | `https://www.ishares.com/us/products/<id>/fund/latest-holdings.csv` |
| Treasury par yield curve | https://home.treasury.gov/resource-center/data-chart-center/interest-rates |
| ICE BofA OAS (`BAMLC0A1CAAA`, `BAMLC0A2CAA`, `BAMLC0A3CA`, `BAMLC0A4CBBB`, `BAMLEMIBHGCRPIOAS`, `BAMLC0A0CM`) | https://fred.stlouisfed.org |
| Moody's Baa / Aaa minus 10Y (`BAA10Y`, `AAA10Y`) | https://fred.stlouisfed.org/series/BAA10Y |

## Outputs (`outputs/`)

| File | Content |
|---|---|
| `01_cs01_and_spread_map.png` | CS01 by sleeve vs limit; spread vs spread duration |
| `02_dts_test.png` | DTS test: absolute vs relative volatility; betas vs DTS prediction |
| `03_scenario_pnl.png` | Spread-scenario P&L by sleeve |
| `04_spread_history_and_var.png` | Baa/Aaa since 1986 with replayed episodes; spread P&L distribution |
| `dashboard.html` / `.png` | Spread-risk dashboard |
| `bond_spread_risk.csv`, `spread_risk_by_sleeve.csv`, `spread_scenarios.csv` | Report tables |

## Key assumptions

- EMB has no rating column: USD sovereigns are filtered as central-government bonds within 200 bp of Treasuries (investment-grade proxy).
- Each sleeve's spread moves with its ICE rating index; EM IG corporates proxy USD sovereigns.
- CS01 limits are hypothetical.
- Callables and sinkers treated as bullets.

## Suggested commit plan

1. `add README and spread-risk definitions`
2. `holdings ETL incl. USD sovereigns, Treasury curve, spread history`
3. `spread duration, CS01 and DTS by bond and sleeve`
4. `betas to Baa and the DTS test`
5. `scenarios, spread VaR, dashboard and executed outputs`

## References

### Finance and regulation

- Ben Dor, A., Dynkin, L., Hyman, J., Houweling, P., van Leeuwen, E., & Penninga, O. (2007). DTS (duration times spread). *The Journal of Portfolio Management, 33*(2), 77–100. https://doi.org/10.3905/jpm.2007.674795
- Longstaff, F. A., Mithal, S., & Neis, E. (2005). Corporate yield spreads: Default risk or liquidity? New evidence from the credit default swap market. *The Journal of Finance, 60*(5), 2213–2253. https://doi.org/10.1111/j.1540-6261.2005.00797.x
- Basel Committee on Banking Supervision. (2019). *Minimum capital requirements for market risk*. Bank for International Settlements. https://www.bis.org/bcbs/publ/d457.htm
- Gilchrist, S., & Zakrajšek, E. (2012). Credit spreads and business cycle fluctuations. *American Economic Review, 102*(4), 1692–1720. https://doi.org/10.1257/aer.102.4.1692
- Ang, A., Bhansali, V., & Xing, Y. (2010). Taxes on tax-exempt bonds. *The Journal of Finance, 65*(2), 565–601. https://doi.org/10.1111/j.1540-6261.2009.01545.x

### Machine learning and deep learning

- Huber, P. J. (1964). Robust estimation of a location parameter. *The Annals of Mathematical Statistics, 35*(1), 73–101. https://doi.org/10.1214/aoms/1177703732
- Efron, B., & Tibshirani, R. J. (1993). *An introduction to the bootstrap*. Chapman & Hall. https://doi.org/10.1201/9780429246593
