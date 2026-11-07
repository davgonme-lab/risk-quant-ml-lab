# Bayesian Stochastic Volatility vs GARCH vs LSTM in R: Volatility Forecasts and VaR for Stocks, the Euro and Crude Oil

GARCH has been the workhorse of volatility forecasting for forty years. Stochastic volatility models are more flexible but harder to estimate, and neural networks promise to learn the patterns on their own. This notebook puts all three against each other on three very different markets and scores them out of sample on the quantity a risk manager actually uses: tomorrow's volatility and VaR.

**What it does.** It forecasts tomorrow's volatility of three very different assets with three model families, and scores them out of sample from 2012:

- the S&P 500 (SPY), with strong leverage effects;
- EUR/USD, a calm and nearly symmetric market;
- WTI crude oil, with jumps and regime changes.

The models:

1. a **Bayesian stochastic volatility** model (`stochvol`, MCMC), where volatility is a latent random process. Its parameters are re-estimated by MCMC, and the latent volatility is tracked daily with a **particle filter** written from scratch;
2. **GJR-GARCH(1,1)** with Student-t errors (`rugarch`), the industry workhorse;
3. an **LSTM** in R's native `torch`, trained by maximum likelihood on the last 22 days of returns.

An EWMA (RiskMetrics) forecast is the benchmark.

**Data.** Yahoo Finance via `quantmod` (SPY) and FRED (EUR/USD noon rate, WTI spot), daily since 2005.

**Methods.** `stochvol` MCMC with posterior credible bands, a bootstrap particle filter, `rugarch` with periodic re-estimation and daily filtering, and a `torch` LSTM with a Gaussian log-likelihood loss.

Forecasts are compared with QLIKE and MSE losses and Diebold–Mariano tests, and the VaR with 99% backtests.

**Key output.** Posterior volatility with its uncertainty, the persistence and volatility of volatility of each asset, forecast losses by model, and VaR exception rates.

---

## Why it matters

Volatility forecasts drive VaR, margins and option hedges, and three schools compete: Bayesian stochastic volatility, GARCH and neural networks. Out of sample since 2012, GJR-GARCH with Student-t errors has the best QLIKE for the S&P 500, EUR/USD and WTI. Symmetric SV ties it for the euro and oil but loses on equities (DM −2.6), where the leverage effect matters; the torch LSTM is clearly worse for the euro and oil. For 99% VaR, filtered historical simulation matters more than the model: normal quantiles breach on 1.3–2.4% of days.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 12 minutes).

## Data sources

| Data | Source |
|---|---|
| SPY prices (Yahoo Finance via quantmod) | https://finance.yahoo.com |
| EUR/USD and WTI spot (FRED) | https://fred.stlouisfed.org |

## Outputs (`outputs/`)

- `01_sv_garch_lstm.png`
- `daily_variance_forecasts.csv`
- `dashboard.html`
- `dashboard.png`
- `forecast_scores.csv`
- `qlike_by_year.csv`
- `sv_posterior_summary.csv`
- `years_won_by_model.csv`

## Key assumptions

- SV: stochvol MCMC every 126 days, bootstrap particle filter (3,000 particles) daily.
- GJR-GARCH(1,1)-t re-estimated every 63 days; LSTM (16 units, 22-day window, Gaussian NLL) every 252 days.
- QLIKE and MSE losses, Diebold–Mariano tests against GARCH, 99% VaR with normal and FHS quantiles.

## Suggested commit plan

1. `sv-garch-lstm-r: add SV posteriors with stochvol`
2. `sv-garch-lstm-r: add particle filter, GJR-GARCH and torch LSTM forecasts`
3. `sv-garch-lstm-r: add loss comparisons, VaR backtests and dashboard`

## References

### Finance and regulation

- Jacquier, E., Polson, N. G., & Rossi, P. E. (1994). Bayesian analysis of stochastic volatility models. *Journal of Business & Economic Statistics, 12*(4), 371–389. https://doi.org/10.1080/07350015.1994.10524553
- Glosten, L. R., Jagannathan, R., & Runkle, D. E. (1993). On the relation between the expected value and the volatility of the nominal excess return on stocks. *The Journal of Finance, 48*(5), 1779–1801. https://doi.org/10.1111/j.1540-6261.1993.tb05128.x
- Patton, A. J. (2011). Volatility forecast comparison using imperfect volatility proxies. *Journal of Econometrics, 160*(1), 246–256. https://doi.org/10.1016/j.jeconom.2010.03.034
- Diebold, F. X., & Mariano, R. S. (1995). Comparing predictive accuracy. *Journal of Business & Economic Statistics, 13*(3), 253–263. https://doi.org/10.1080/07350015.1995.10524599
- Kupiec, P. H. (1995). Techniques for verifying the accuracy of risk measurement models. *The Journal of Derivatives, 3*(2), 73–84. https://doi.org/10.3905/jod.1995.407942

### Machine learning and deep learning

- Kastner, G. (2016). Dealing with stochastic volatility in time series using the R package stochvol. *Journal of Statistical Software, 69*(5), 1–30. https://doi.org/10.18637/jss.v069.i05
- Gordon, N. J., Salmond, D. J., & Smith, A. F. M. (1993). Novel approach to nonlinear/non-Gaussian Bayesian state estimation. *IEE Proceedings F, 140*(2), 107–113. https://doi.org/10.1049/ip-f-2.1993.0015
- Hochreiter, S., & Schmidhuber, J. (1997). Long short-term memory. *Neural Computation, 9*(8), 1735–1780. https://doi.org/10.1162/neco.1997.9.8.1735
