# Backtesting Trading Strategies with vectorbt: Cointegration Pairs Trading with an ML Filter, ML Sector Rotation and Beta Hedging

Most backtests look better than the strategy will ever do live, because they peek at the future, try many variants and ignore costs. This notebook builds three systematic equity strategies under rules designed to avoid those traps, and measures what machine learning and hedging really add once costs are paid.

**What it does.** It builds and backtests three systematic strategies on U.S. equities with realistic costs and strict walk-forward rules, using `vectorbt` for the portfolio simulation.

1. **Statistical arbitrage.** Every six months, cointegrated pairs are selected within seven sectors (Engle–Granger test, half-life filter) and traded on z-score signals for the next six months. A **LightGBM filter**, trained only on earlier trades, decides which signals to take.
2. **ML sector rotation.** A LightGBM model ranks the nine SPDR sector ETFs on next-month relative returns, and the top three are held, against momentum and equal weight.
3. **Hedging.** The market beta left in each strategy is removed with SPY, using a rolling-OLS or a Kalman-filter hedge ratio.

**Data.** Yahoo Finance (daily prices since 2010 for about 50 large U.S. stocks in seven sectors, the nine sector ETFs and SPY) and FRED (VIX, term spread).

**Methods.** Engle–Granger cointegration and Ornstein–Uhlenbeck half-lives (`statsmodels`), z-score entry and exit rules, a LightGBM trade classifier and return ranker with walk-forward training, and `vectorbt` `Portfolio.from_orders` with target-percent sizing, cash sharing and fees.

Hedges use rolling and Kalman betas, and results are measured by Sharpe ratio, drawdown, hit rate and trade statistics.

**Key output.** Equity curves, performance tables, the value added by the ML filter and by hedging, and trade-level diagnostics.

---

## Why it matters

A backtest is where trading ideas meet costs. Simulated in vectorbt with fees and borrow: cointegration pairs trading loses 1.7% a year since 2011 because two thirds of trades stop out as cointegration breaks. A LightGBM filter separates better trades from worse ones but only lifts the book to break-even. ML sector rotation earns market returns (Sharpe 0.78 vs SPY 0.86), and once its beta is hedged out, with a rolling OLS or a Kalman beta, almost no alpha is left. Honest negative results that keep strategies out of production.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 1 minute).

## Data sources

| Data | Source |
|---|---|
| Daily stock, sector ETF and SPY prices (Yahoo Finance) | https://finance.yahoo.com |
| VIX and term spread (FRED) | https://fred.stlouisfed.org |

## Outputs (`outputs/`)

- `01_backtests_pairs_rotation_hedging.png`
- `daily_strategy_returns.csv`
- `dashboard.html`
- `dashboard.png`
- `ml_filter_effect.csv`
- `pairs_selected_by_window.csv`
- `pairs_trade_log.csv`
- `strategy_performance.csv`
- `vectorbt_portfolio_stats.csv`

## Key assumptions

- Pairs: Engle–Granger on 252-day formation windows within sectors, entry |z| > 2, exit at 0, stop at 4.
- Costs 5 bp per side, borrow 1% a year on shorts; ML models retrained yearly.
- Hedges: 126-day rolling OLS beta and a Kalman random-walk beta to SPY.

## Suggested commit plan

1. `vectorbt-pairs-rotation: add pair selection and trade simulation`
2. `vectorbt-pairs-rotation: add ML trade filter and sector rotation model`
3. `vectorbt-pairs-rotation: add vectorbt portfolios, beta hedges and dashboard`

## References

### Finance and regulation

- Gatev, E., Goetzmann, W. N., & Rouwenhorst, K. G. (2006). Pairs trading: Performance of a relative-value arbitrage rule. *The Review of Financial Studies, 19*(3), 797–827. https://doi.org/10.1093/rfs/hhj020
- Engle, R. F., & Granger, C. W. J. (1987). Co-integration and error correction: Representation, estimation, and testing. *Econometrica, 55*(2), 251–276. https://doi.org/10.2307/1913236
- Bailey, D. H., Borwein, J. M., López de Prado, M., & Zhu, Q. J. (2014). Pseudo-mathematics and financial charlatanism: The effects of backtest overfitting on out-of-sample performance. *Notices of the American Mathematical Society, 61*(5), 458–471. https://doi.org/10.1090/noti1105
- Moskowitz, T. J., & Grinblatt, M. (1999). Do industries explain momentum? *The Journal of Finance, 54*(4), 1249–1290. https://doi.org/10.1111/0022-1082.00146
- Bailey, D. H., & López de Prado, M. (2014). The deflated Sharpe ratio: Correcting for selection bias, backtest overfitting and non-normality. *The Journal of Portfolio Management, 40*(5), 94–107. https://doi.org/10.3905/jpm.2014.40.5.094

### Machine learning and deep learning

- Ke, G., Meng, Q., Finley, T., Wang, T., Chen, W., Ma, W., Ye, Q., & Liu, T.-Y. (2017). LightGBM: A highly efficient gradient boosting decision tree. *Advances in Neural Information Processing Systems, 30*. https://proceedings.neurips.cc/paper/2017/hash/6449f44a102fde848669bdd9eb6b76fa-Abstract.html
- Kalman, R. E. (1960). A new approach to linear filtering and prediction problems. *Journal of Basic Engineering, 82*(1), 35–45. https://doi.org/10.1115/1.3662552
- Krauss, C., Do, X. A., & Huck, N. (2017). Deep neural networks, gradient-boosted trees, random forests: Statistical arbitrage on the S&P 500. *European Journal of Operational Research, 259*(2), 689–702. https://doi.org/10.1016/j.ejor.2016.10.031
