# Time-Series Momentum and Trend Following Across 33 Futures Markets: Moskowitz–Ooi–Pedersen Signals versus Machine-Learning Position Sizing, Volatility Targeting and Crisis Alpha, 2001–2026

Trend following is the oldest systematic strategy in futures markets and the core of most managed-futures funds. Moskowitz, Ooi and Pedersen (2012) showed that a simple rule, long a market whose return over the past year was positive and short one whose return was negative, each position scaled to the same volatility, earned positive returns in almost every asset class, with its best results in the worst years for equities. Since then, machine-learning papers have proposed to learn the position from many trend and volatility features, or to optimise the Sharpe ratio directly with a neural network (Lim, Zohren & Roberts, 2019). This notebook rebuilds the classic strategy on 33 futures markets from Yahoo Finance, measures its crisis alpha, adds portfolio volatility targeting, and tests three machine-learning sizing rules out of time against it, before and after trading costs.

**What it does.**

1. It downloads daily front-month futures prices for equity indices, government bonds, currencies, metals, energy and agricultural commodities since 2000, and cleans the jumps that come from rolling one contract into the next.
2. It builds the Moskowitz–Ooi–Pedersen (MOP) strategy: monthly positions in the direction of each market's past 12-month return, scaled to 40% annual volatility per market using an exponentially weighted volatility estimate, then averaged across markets.
3. It compares look-back windows of 1, 3, 6 and 12 months, a blend of all four and a continuous signal, and adds portfolio-level volatility targeting at 10% a year.
4. It measures crisis alpha: returns in 2008, early 2020 and 2022, and the "smile" of quarterly trend returns against equity returns.
5. It trains a ridge regression, LightGBM and a neural network that maximises the Sharpe ratio directly on trend and volatility features, re-trains them every January from 2008, and compares their out-of-time returns with MOP's, gross and net of trading costs.

**Data.** Daily settlement prices of continuous front-month futures (Yahoo Finance).

**Methods.** Time-series momentum, exponentially weighted volatility scaling, volatility targeting, the trend "smile" regression, ridge regression, LightGBM, a Sharpe-ratio-loss neural network in PyTorch, walk-forward re-training, turnover-based trading costs and block-bootstrap tests of Sharpe-ratio differences.

**Key output.** Return, volatility, Sharpe ratio, drawdown and skewness of every variant; the trend smile and crisis returns; sector contributions; and the out-of-time performance of the machine-learning sizing rules against MOP, before and after costs.

---

## Why it matters

Trend following is the core of managed-futures funds. Rebuilt on 33 futures markets from 2001 to 2026, the Moskowitz–Ooi–Pedersen 12-month strategy earned a Sharpe ratio of 0.46 net of costs with near-zero correlation to equities, and gained 18%, 14% and 34% in the 2008, 2020 and 2022 sell-offs while the S&P 500 fell 20–53%. A continuous trend signal did best (0.54); portfolio volatility targeting cut the maximum drawdown from 30% to 21% without changing the Sharpe ratio. Machine-learning sizing (ridge, LightGBM and a network trained to maximise the Sharpe ratio) did not beat the simple rule out of time from 2008, and none kept its crisis profile.

## How to run

1. `conda activate quant-risk`. `.env` needs None (Yahoo Finance through `yfinance`, no key).
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 2 minutes on CPU).

## Data sources

| Data | Source |
|---|---|
| Continuous front-month futures prices for 33 markets (Yahoo Finance via yfinance) | https://finance.yahoo.com/ |

## Outputs (`outputs/`)

- `01_time_series_momentum.png`
- `crisis_episodes.csv`
- `dashboard.html`
- `dashboard.png`
- `lightgbm_feature_importance.csv`
- `markets.csv`
- `monthly_net_returns.csv`
- `out_of_time_ml_vs_mop.csv`
- `sector_contributions.csv`
- `strategy_performance.csv`
- `trend_smile_regression.csv`

## Key assumptions

- Daily front-month closes from 2000; commodity daily returns beyond five trailing one-year standard deviations (or 50%) treated as roll gaps and set to zero; current incomplete month dropped.
- Positions at month-end: signal × 40% / EWMA volatility (centre of mass 60 days, capped at 20× notional), equal-weighted across markets with 12 months of history; volatility targeting at 10% using trailing 36-month strategy volatility, leverage capped at 3.
- Costs per unit of notional turnover: 1 bp equity and bonds, 1.5 bp currencies, 3 bp metals, 4 bp energy, 5 bp agriculture.
- Machine-learning models pooled across markets, re-trained each January from 2008 on targets known before the year; target = next-month return × 40%/σ, clipped at ±3; positions clipped at ±1.

## Suggested commit plan

1. `time-series-momentum-futures: add Yahoo futures prices and roll-gap filter`
2. `time-series-momentum-futures: add MOP time-series momentum variants and volatility targeting`
3. `time-series-momentum-futures: add trend smile, crisis episodes and sector contributions`
4. `time-series-momentum-futures: add walk-forward ridge, LightGBM and Sharpe-loss network sizing`
5. `time-series-momentum-futures: add bootstrap tests, charts, dashboard and narrative`

## References

### Trend following and volatility management

- Moskowitz, T. J., Ooi, Y. H., & Pedersen, L. H. (2012). Time series momentum. *Journal of Financial Economics, 104*(2), 228–250. https://doi.org/10.1016/j.jfineco.2011.11.003
- Hurst, B., Ooi, Y. H., & Pedersen, L. H. (2017). A century of evidence on trend-following investing. *The Journal of Portfolio Management, 44*(1), 15–29. https://doi.org/10.3905/jpm.2017.44.1.015
- Baz, J., Granger, N., Harvey, C. R., Le Roux, N., & Rattray, S. (2015). *Dissecting investment strategies in the cross section and time series* (SSRN Working Paper 2695101). https://papers.ssrn.com/abstract=2695101
- Moreira, A., & Muir, T. (2017). Volatility-managed portfolios. *The Journal of Finance, 72*(4), 1611–1644. https://doi.org/10.1111/jofi.12513
- Harvey, C. R., Hoyle, E., Korgaonkar, R., Rattray, S., Sargaison, M., & Van Hemert, O. (2018). The impact of volatility targeting. *The Journal of Portfolio Management, 45*(1), 14–33. https://doi.org/10.3905/jpm.2018.45.1.014

### Machine learning

- Lim, B., Zohren, S., & Roberts, S. (2019). Enhancing time-series momentum strategies using deep neural networks. *The Journal of Financial Data Science, 1*(4), 19–38. https://doi.org/10.3905/jfds.2019.1.015
- Ke, G., Meng, Q., Finley, T., Wang, T., Chen, W., Ma, W., Ye, Q., & Liu, T.-Y. (2017). LightGBM: A highly efficient gradient boosting decision tree. *Advances in Neural Information Processing Systems, 30*. https://proceedings.neurips.cc/paper/2017/hash/6449f44a102fde848669bdd9eb6b76fa-Abstract.html

### Data

- Yahoo Finance. (2026). *Continuous front-month futures prices* [Data set], accessed with the `yfinance` package. https://finance.yahoo.com/
