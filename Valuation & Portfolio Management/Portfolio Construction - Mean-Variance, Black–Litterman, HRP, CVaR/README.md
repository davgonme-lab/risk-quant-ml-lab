# Portfolio Construction: Mean-Variance, Black–Litterman, HRP, CVaR

Every allocation method looks good in sample. What an investment or treasury committee needs to know is how a method behaves when its inputs are estimated, re-estimated every month and traded at a cost. This notebook runs seven methods through the same walk-forward test and shows what each one holds today and where its risk comes from.

**What it does.** It builds a 12-ETF multi-asset portfolio with seven allocation methods and runs them all through the same walk-forward backtest, re-optimised monthly from January 2010, net of transaction costs. It then shows what each method holds today and where its risk comes from.

**Data.** Daily total-return prices of 12 U.S.-listed ETFs since 2007 covering U.S. and international equity, Treasuries, TIPS, credit, real estate, gold and commodities (Yahoo Finance), and the 3-month T-bill (FRED) as the risk-free rate.

**Methods.** 1/N, minimum variance and mean-variance (max Sharpe) on a Ledoit–Wolf covariance, Black–Litterman with momentum views, equal risk contribution, hierarchical risk parity (López de Prado, 2016), and minimum CVaR by linear programming (Rockafellar–Uryasev) in cvxpy. All are long-only with a 35% cap.

**Key output.** Out-of-sample return, volatility, Sharpe ratio, drawdown, CVaR and turnover by method, cumulative wealth, current weights and risk contributions, and an allocation dashboard.

---

## Why it matters

An MDB liquidity portfolio is judged on drawdown and turnover more than on Sharpe. Walk-forward 2010–2026, net of costs, no method dominates and 1/N is hard to beat. Minimum variance, minimum CVaR and HRP keep drawdowns at 15–18% with low turnover, and risk contributions show where risk really sits (a third in high yield for the minimum-variance book).

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 30 seconds).

## Data sources

| Data | Source |
|---|---|
| 12 ETF total-return prices | Yahoo Finance via `yfinance` |
| 3-month T-bill (`DTB3`) | https://fred.stlouisfed.org |

## Outputs (`outputs/`)

- `01_wealth_and_drawdowns.png`
- `dashboard.html`
- `dashboard.png`
- `backtest_scoreboard.csv`
- `current_weights.csv`
- `weights_history.csv`

## Key assumptions

- Monthly rebalancing on a trailing 3-year window, Ledoit–Wolf covariance, long-only with a 35% cap.
- 10 bp one-way costs; no taxes; ETFs as asset-class proxies.
- Black–Litterman prior from a 60/40-style policy portfolio and a single momentum view.

## Suggested commit plan

1. `add README and allocation framework`
2. `ETF data ETL and cleaning`
3. `seven allocators in cvxpy`
4. `walk-forward backtest with costs`
5. `risk contributions, dashboard and executed outputs`

## References

### Finance and regulation

- Markowitz, H. (1952). Portfolio selection. *The Journal of Finance, 7*(1), 77–91. https://doi.org/10.1111/j.1540-6261.1952.tb01525.x
- Black, F., & Litterman, R. (1992). Global portfolio optimization. *Financial Analysts Journal, 48*(5), 28–43. https://doi.org/10.2469/faj.v48.n5.28
- López de Prado, M. (2016). Building diversified portfolios that outperform out of sample. *The Journal of Portfolio Management, 42*(4), 59–69. https://doi.org/10.3905/jpm.2016.42.4.059
- Maillard, S., Roncalli, T., & Teïletche, J. (2010). The properties of equally weighted risk contribution portfolios. *The Journal of Portfolio Management, 36*(4), 60–70. https://doi.org/10.3905/jpm.2010.36.4.060
- Rockafellar, R. T., & Uryasev, S. (2000). Optimization of conditional value-at-risk. *Journal of Risk, 2*(3), 21–41. https://doi.org/10.21314/JOR.2000.038
- DeMiguel, V., Garlappi, L., & Uppal, R. (2009). Optimal versus naive diversification: How inefficient is the 1/N portfolio strategy? *The Review of Financial Studies, 22*(5), 1915–1953. https://doi.org/10.1093/rfs/hhm075
- Ledoit, O., & Wolf, M. (2004). Honey, I shrunk the sample covariance matrix. *The Journal of Portfolio Management, 30*(4), 110–119. https://doi.org/10.3905/jpm.2004.110

### Machine learning and deep learning

- Diamond, S., & Boyd, S. (2016). CVXPY: A Python-embedded modeling language for convex optimization. *Journal of Machine Learning Research, 17*(83), 1–5. https://jmlr.org/papers/v17/15-408.html
- Ward, J. H. (1963). Hierarchical grouping to optimize an objective function. *Journal of the American Statistical Association, 58*(301), 236–244. https://doi.org/10.1080/01621459.1963.10500845
