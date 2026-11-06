# VaR & Expected Shortfall Engine with Full Backtesting

A VaR number is only useful if it can be trusted, and that trust comes from comparing each day's forecast with what actually happened. This notebook builds a small but complete market-risk engine with five methods and runs every one of them through seventeen years of the backtests a regulator or validator would apply.

**What it does.** It computes daily 99% VaR and 97.5% Expected Shortfall for a USD 100mm multi-asset portfolio with five methods, and backtests every one of them over 17 years with the tests a regulator or model validator would run.

**Data.** Daily total-return prices of eight U.S.-listed ETFs since 2007 (Yahoo Finance): U.S. large and small caps, international equities, Treasuries, investment-grade and high-yield credit, and gold.

**Methods.** Historical simulation, EWMA normal and Student-t (RiskMetrics), filtered historical simulation on a GJR-GARCH and a multivariate-t Monte Carlo.

VaR is backtested with the Kupiec, Christoffersen and Basel traffic-light tests and ES with the Acerbi–Székely test, alongside stressed VaR and Euler component VaR.

**Key output.** The model scorecard (exceptions, test p-values, traffic lights), VaR against P&L through 2008-style, 2020 and 2022 stress, today's VaR and ES by method and by asset, and a market-risk dashboard.

---

## Why it matters

A VaR number is only as good as its backtest. This engine runs five industry methods side by side over 17 years of daily data and puts each through the tests a regulator or model validator applies: Kupiec, Christoffersen, the Basel traffic light and the Acerbi–Székely ES test. Only the GARCH-filtered historical simulation passes all of them, and the notebook shows why.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 30 seconds).

## Data sources

| Data | Source |
|---|---|
| ETF total-return prices (SPY, IWM, EFA, TLT, IEF, LQD, HYG, GLD) | Yahoo Finance via `yfinance` |

## Outputs (`outputs/`)

- `01_var_vs_pnl_stress.png`
- `02_basel_traffic_light.png`
- `dashboard.html`
- `dashboard.png`
- `backtest_scorecard.csv`
- `daily_var_es_forecasts.csv`
- `var_es_today.csv`

## Key assumptions

- Portfolio rebalanced daily to fixed weights; ETF proxies for positions.
- 500-day estimation window; GJR-GARCH refitted every 20 days.
- A data filter repairs one-day bad prints that reverse the next day, but never on market-wide moves (e.g. 12–13 March 2020 are kept).
- Z2 thresholds are the approximate critical values of Acerbi & Székely (2014).

## Suggested commit plan

1. `add README and VaR/ES method definitions`
2. `ETF data ETL with bad-print filter`
3. `rolling HS, EWMA, FHS-GARCH and Monte Carlo forecasts`
4. `Kupiec, Christoffersen, Basel traffic light and ES Z2 backtests`
5. `stressed VaR, component VaR, dashboard and executed outputs`

## References

### Finance and regulation

- Basel Committee on Banking Supervision. (1996). *Supervisory framework for the use of "backtesting" in conjunction with the internal models approach to market risk capital requirements*. Bank for International Settlements. https://www.bis.org/publ/bcbs22.htm
- Basel Committee on Banking Supervision. (2019). *Minimum capital requirements for market risk*. Bank for International Settlements. https://www.bis.org/bcbs/publ/d457.htm
- Kupiec, P. H. (1995). Techniques for verifying the accuracy of risk measurement models. *The Journal of Derivatives, 3*(2), 73–84. https://doi.org/10.3905/jod.1995.407942
- Christoffersen, P. F. (1998). Evaluating interval forecasts. *International Economic Review, 39*(4), 841–862. https://doi.org/10.2307/2527341
- Barone-Adesi, G., Giannopoulos, K., & Vosper, L. (1999). VaR without correlations for portfolios of derivative securities. *Journal of Futures Markets, 19*(5), 583–602. https://doi.org/10.1002/(SICI)1096-9934(199908)19:5<583::AID-FUT5>3.0.CO;2-S
- Artzner, P., Delbaen, F., Eber, J.-M., & Heath, D. (1999). Coherent measures of risk. *Mathematical Finance, 9*(3), 203–228. https://doi.org/10.1111/1467-9965.00068

### Machine learning and deep learning

- Glasserman, P. (2004). *Monte Carlo methods in financial engineering*. Springer. https://doi.org/10.1007/978-0-387-21617-1
- Efron, B., & Tibshirani, R. J. (1993). *An introduction to the bootstrap*. Chapman & Hall. https://doi.org/10.1201/9780429246593
