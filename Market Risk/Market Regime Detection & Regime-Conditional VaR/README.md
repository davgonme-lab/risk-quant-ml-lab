# Market Regime Detection & Regime-Conditional VaR

Markets spend long stretches in calm and short bursts in turmoil, and in turmoil volatility jumps and diversification disappears. A risk model calibrated on average conditions is too cautious in quiet times and too optimistic at the start of a crisis. This notebook identifies the market's regimes and builds a VaR that adapts to the one the market is in.

**What it does.** It identifies calm, normal and stressed market regimes from weekly market data, shows how long they last and how they switch, and uses the regime probabilities to build a VaR that adapts to the state of the market, backtested out of sample.

**Data.** Daily total-return prices of an eight-ETF multi-asset portfolio (Yahoo Finance), and the VIX and the Moody's Baa credit spread (FRED), all since 2007.

**Methods.** Gaussian hidden Markov models with 2–5 states chosen by BIC, a Gaussian mixture as a benchmark without memory, and forward filtering without look-ahead.

The VaR is a mixture weighted by the predicted regime probabilities, compared with historical-simulation and EWMA VaR.

**Key output.** The regime timeline since 2007, regime statistics and the transition matrix, the current regime probabilities, and an out-of-sample weekly VaR backtest for 2017–2026.

---

## Why it matters

A regime label ("we are 90% likely in a stressed market") is a concise input for limits and risk appetite, and regime-dependent tails improve VaR. The notebook shows honestly that a pure regime-mixture VaR fails, because regimes are detected with a lag. EWMA volatility combined with regime tails is the only model that passes coverage and independence at 95% and 99%.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 1 minute).

## Data sources

| Data | Source |
|---|---|
| ETF total-return prices (eight-ETF multi-asset portfolio) | Yahoo Finance via `yfinance` |
| VIX `VIXCLS`, Moody's Baa – 10Y `BAA10Y` | https://fred.stlouisfed.org |

## Outputs (`outputs/`)

- `01_regime_timeline.png`
- `02_weekly_var_backtest.png`
- `03_regime_distributions_and_transitions.png`
- `filtered_regime_probabilities.csv`
- `regime_statistics.csv`
- `weekly_var_backtest.csv`

## Key assumptions

- Weekly features; HMM with Gaussian emissions and full covariance, 2–4 states chosen by BIC.
- Walk-forward: re-estimated every January on all data to the previous December; forward filter only (no look-ahead).
- Credit spread used as a 4-week change, not a level, so the model learns regimes rather than eras.

## Suggested commit plan

1. `add README and HMM framework`
2. `weekly features ETL`
3. `HMM selection by BIC, regime statistics and transition matrix`
4. `forward filtering and regime timeline`
5. `walk-forward regime and hybrid VaR backtest with executed outputs`

## References

### Finance and regulation

- Hamilton, J. D. (1989). A new approach to the economic analysis of nonstationary time series and the business cycle. *Econometrica, 57*(2), 357–384. https://doi.org/10.2307/1912559
- Ang, A., & Bekaert, G. (2002). International asset allocation with regime shifts. *The Review of Financial Studies, 15*(4), 1137–1187. https://doi.org/10.1093/rfs/15.4.1137
- Guidolin, M., & Timmermann, A. (2007). Asset allocation under multivariate regime switching. *Journal of Economic Dynamics and Control, 31*(11), 3503–3544. https://doi.org/10.1016/j.jedc.2006.12.004
- Kupiec, P. H. (1995). Techniques for verifying the accuracy of risk measurement models. *The Journal of Derivatives, 3*(2), 73–84. https://doi.org/10.3905/jod.1995.407942
- Christoffersen, P. F. (1998). Evaluating interval forecasts. *International Economic Review, 39*(4), 841–862. https://doi.org/10.2307/2527341

### Machine learning and deep learning

- Rabiner, L. R. (1989). A tutorial on hidden Markov models and selected applications in speech recognition. *Proceedings of the IEEE, 77*(2), 257–286. https://doi.org/10.1109/5.18626
- McLachlan, G., & Peel, D. (2000). *Finite mixture models*. Wiley. https://doi.org/10.1002/0471721182
- Schwarz, G. (1978). Estimating the dimension of a model. *The Annals of Statistics, 6*(2), 461–464. https://doi.org/10.1214/aos/1176344136
