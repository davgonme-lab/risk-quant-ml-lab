# VaR / ES with GARCH and Backtesting (R)

A VaR model is only as good as its record, and regulators judge that record by counting the days the model was wrong. This notebook estimates daily VaR and Expected Shortfall for a multi-asset portfolio with five models, from plain history to GARCH with skewed tails, and shows exactly where and when each one fails.

**What it does.** It estimates the 1-day 99% Value-at-Risk and 97.5% Expected Shortfall of a five-ETF multi-asset portfolio every day since 2011 with five models, from historical simulation to GJR-GARCH with skewed Student-t errors, all re-estimated on a rolling 1,000-day window.

Every model is backtested with the Kupiec, Christoffersen and McNeil–Frey tests and the Basel traffic light, and the notebook shows where each one fails: 2020, 2022 and the recent past.

**Data.** Daily adjusted prices of SPY, EFA, TLT, LQD and GLD since 2007 (Yahoo Finance via `quantmod`).

**Methods.** Historical simulation, RiskMetrics EWMA, GARCH(1,1) with normal and Student-t errors, GJR-GARCH(1,1) with skewed-t errors (`rugarch::ugarchroll`) and filtered historical simulation.

The backtests are the unconditional and conditional coverage tests (`VaRTest`), the ES test (`ESTest`) and rolling 250-day Basel traffic-light zones, with `PerformanceAnalytics` for the portfolio returns.

**Key output.** VaR and ES paths with their exceedances, a backtest scorecard, the traffic-light history and an interactive dashboard.

---

## Why it matters

VaR models are approved or rejected on their backtests. On a five-ETF portfolio over 2011–2026, historical simulation has the right number of exceptions but fails conditional coverage because its misses cluster; EWMA and normal GARCH roughly double the expected exceptions. GJR-GARCH with skewed-t errors and filtered historical simulation pass coverage and the ES test and spend almost no time in the Basel red zone, and filtered HS had zero exceptions in 2022. No model fully removes exception clustering.

## How to run

1. Once, from the repo root: `Rscript install_packages.R` (installs the CRAN packages and registers the **R** kernel with IRkernel).
2. `.env` needs no keys (Yahoo Finance is open).
3. Open the notebook, choose the **R** kernel, **Run All** (about 10 minutes (five rolling models refitted every 25 days)).

## Data sources

| Data | Source |
|---|---|
| Daily adjusted prices of SPY, EFA, TLT, LQD, GLD | Yahoo Finance via `quantmod` |

## Outputs (`outputs/`)

- `01_var_paths_traffic_light.png`
- `dashboard.html`
- `dashboard.png`
- `backtest_scorecard.csv`
- `stress_window_exceptions.csv`
- `var_es_paths.csv`

## Key assumptions

- Constant weights 35/15/20/20/10, rebalanced daily; log returns.
- 1,000-day rolling window, refit every 25 days; 1-day 99% VaR and 97.5% ES.
- Kupiec and Christoffersen via `rugarch::VaRTest`, McNeil–Frey via `ESTest`; Basel zones on a rolling 250-day count.

## Suggested commit plan

1. `add README and VaR framework`
2. `price download and portfolio returns`
3. `HS, EWMA and rugarch rolling forecasts`
4. `filtered HS and ES`
5. `backtests, traffic light, dashboard and executed outputs`

## References

### Finance and regulation

- Basel Committee on Banking Supervision. (1996). *Supervisory framework for the use of "backtesting" in conjunction with the internal models approach to market risk capital requirements*. Bank for International Settlements. https://www.bis.org/publ/bcbs22.htm
- McNeil, A. J., & Frey, R. (2000). Estimation of tail-related risk measures for heteroscedastic financial time series: An extreme value approach. *Journal of Empirical Finance, 7*(3–4), 271–300. https://doi.org/10.1016/S0927-5398(00)00012-8
- Kupiec, P. H. (1995). Techniques for verifying the accuracy of risk measurement models. *The Journal of Derivatives, 3*(2), 73–84. https://doi.org/10.3905/jod.1995.407942
- Christoffersen, P. F. (1998). Evaluating interval forecasts. *International Economic Review, 39*(4), 841–862. https://doi.org/10.2307/2527341
- Glosten, L. R., Jagannathan, R., & Runkle, D. E. (1993). On the relation between the expected value and the volatility of the nominal excess return on stocks. *The Journal of Finance, 48*(5), 1779–1801. https://doi.org/10.1111/j.1540-6261.1993.tb05128.x
- Fernández, C., & Steel, M. F. J. (1998). On Bayesian modeling of fat tails and skewness. *Journal of the American Statistical Association, 93*(441), 359–371. https://doi.org/10.1080/01621459.1998.10474117

### Machine learning and deep learning

- Ghalanos, A. (2024). *rugarch: Univariate GARCH models* (R package). CRAN. https://CRAN.R-project.org/package=rugarch
- Peterson, B. G., & Carl, P. (2024). *PerformanceAnalytics: Econometric tools for performance and risk analysis* (R package). CRAN. https://CRAN.R-project.org/package=PerformanceAnalytics
