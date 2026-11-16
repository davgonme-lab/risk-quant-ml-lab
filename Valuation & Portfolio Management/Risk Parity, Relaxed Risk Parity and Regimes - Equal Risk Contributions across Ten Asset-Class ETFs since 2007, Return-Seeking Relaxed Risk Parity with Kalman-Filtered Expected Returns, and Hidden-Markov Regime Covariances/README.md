# Risk Parity, Relaxed Risk Parity and Regimes: Equal Risk Contributions across Ten Asset-Class ETFs since 2007, Return-Seeking Relaxed Risk Parity with Kalman-Filtered Expected Returns, and Hidden-Markov Regime Covariances

A 60/40 portfolio looks balanced in dollars, but about 90% of its risk comes from equities: stocks are three to four times as volatile as Treasuries. **Risk parity** balances risk instead of capital. In the **equal-risk-contribution (ERC)** portfolio each asset contributes the same share of total volatility, so low-volatility assets such as Treasuries get large weights and equities small ones. The idea needs no expected-return forecasts, which are the least reliable input in portfolio construction, and it held up well through 2008, but it suffered in 2022 when stocks and bonds fell together.

Two extensions address its weak points:

- **Relaxed risk parity** (Gambeta and Kwon) keeps risk contributions close to equal but lets the optimiser tilt towards assets with higher expected returns, up to a chosen return target. It is a second-order cone program. Its expected returns here come from a **Kalman filter** that treats each asset's expected return as a slowly drifting hidden state.
- **Regime covariances**: correlations are not constant. A **hidden Markov model** on stocks, Treasuries and high-yield bonds identifies calm and stressed regimes, and the portfolio is built on the covariance expected for next month given the probability of each regime.

Everything is evaluated walk-forward on ten asset-class ETFs from 2008 to today, rebalanced monthly with transaction costs, against 1/N, 60/40 and the minimum-variance portfolio, and with risk parity levered to the volatility of 60/40.

**Data.** Yahoo Finance (daily prices of SPY, EFA, EEM, TLT, IEF, LQD, HYG, GLD, DBC and VNQ); FRED (3-month Treasury bill).

**Methods.** Equal risk contribution (Spinu's convex formulation), minimum variance, relaxed risk parity as a second-order cone program (cvxpy), Ledoit–Wolf shrinkage, local-level Kalman filter with maximum-likelihood noise variances, two-state Gaussian hidden Markov model (hmmlearn) with regime-weighted covariances, walk-forward backtest, Sharpe ratio, drawdown, expected shortfall, turnover, risk-contribution dispersion.

**Key output.** Weights and risk contributions of each portfolio over time; walk-forward performance including 2008, 2020 and 2022; whether Kalman-filtered returns or regime covariances add anything to plain risk parity.

---

## Why it matters

Across ten asset-class ETFs from May 2008 to November 2026, equal-risk-contribution portfolios kept every asset's share of realised risk close to a tenth and lost half as much as 60/40 in the 2008–09 crash, but returned 4.6% a year against 8.3% for 60/40 in a period dominated by US equities. Kalman-filtered expected returns collapse to the long-run mean and do not rank next month's returns, so relaxed risk parity adds turnover rather than Sharpe ratio. Hidden-Markov regime covariances add 0.06 to the Sharpe ratio, mainly by giving stress episodes their long-run weight.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY` in `.env` (3-month Treasury bill); Yahoo Finance needs no key.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 2 minutes).

## Data sources

| Data | Source |
|---|---|
| Yahoo Finance (SPY, EFA, EEM, TLT, IEF, LQD, HYG, GLD, DBC, VNQ) | https://finance.yahoo.com/ |
| FRED, 3-month Treasury bill (DTB3) | https://fred.stlouisfed.org/series/DTB3 |

## Outputs (`outputs/`)

- `01_risk_parity_overview.png`
- `daily_returns.csv`
- `dashboard.html`
- `dashboard.png`
- `expected_return_rank_ic.csv`
- `performance.csv`
- `regime_probabilities.csv`
- `risk_share_dispersion.csv`
- `sharpe_difference_bootstrap.csv`
- `weights.csv`

## Key assumptions

- Monthly rebalancing from May 2008 with weights from data up to each month-end; one year of daily returns with Ledoit–Wolf shrinkage; 5 bp per unit of turnover; weights drift within the month.
- Relaxed risk parity: return target = ERC expected return + 30% of the gap to the best asset, λ = 1; Kalman local-level noise variances by maximum likelihood, refitted yearly.
- Two-state Gaussian HMM on daily SPY, TLT and HYG returns, refitted yearly; regime covariances weighted by state probabilities over three years, mixed with the 21-day-ahead state probabilities; levered ERC capped at 3× and financed at the T-bill rate.

## Suggested commit plan

1. `risk-parity-regimes: add ETF data and covariance estimation`
2. `risk-parity-regimes: add minimum variance, ERC and relaxed risk parity solvers`
3. `risk-parity-regimes: add Kalman expected returns and HMM regime covariances`
4. `risk-parity-regimes: add walk-forward backtest, bootstrap and risk-share dispersion`
5. `risk-parity-regimes: add charts, dashboard and narrative`

## References

- Maillard, S., Roncalli, T., & Teïletche, J. (2010). The properties of equally weighted risk contribution portfolios. *Journal of Portfolio Management*, 36(4), 60–70.
- Spinu, F. (2013). *An algorithm for computing risk parity weights*. SSRN 2297383.
- Gambeta, V., & Kwon, R. (2020). Risk return trade-off in relaxed risk parity portfolio optimization. *Journal of Risk and Financial Management*, 13(10), 237.
- Mausser, H., & Romanko, O. (2014). Computing equal risk contribution portfolios. *IBM Journal of Research and Development*, 58(4), 5:1–5:12.
- Asness, C. S., Frazzini, A., & Pedersen, L. H. (2012). Leverage aversion and risk parity. *Financial Analysts Journal*, 68(1), 47–59.
- Qian, E. (2005). *Risk parity portfolios: Efficient portfolios through true diversification*. PanAgora Asset Management.
- DeMiguel, V., Garlappi, L., & Uppal, R. (2009). Optimal versus naive diversification: How inefficient is the 1/N portfolio strategy? *Review of Financial Studies*, 22(5), 1915–1953.
- Ledoit, O., & Wolf, M. (2004). A well-conditioned estimator for large-dimensional covariance matrices. *Journal of Multivariate Analysis*, 88(2), 365–411.
- Kalman, R. E. (1960). A new approach to linear filtering and prediction problems. *Journal of Basic Engineering*, 82(1), 35–45.
- Durbin, J., & Koopman, S. J. (2012). *Time Series Analysis by State Space Methods* (2nd ed.). Oxford University Press.
- Hamilton, J. D. (1989). A new approach to the economic analysis of nonstationary time series and the business cycle. *Econometrica*, 57(2), 357–384.
- Ang, A., & Bekaert, G. (2002). International asset allocation with regime shifts. *Review of Financial Studies*, 15(4), 1137–1187.
- Politis, D. N., & Romano, J. P. (1994). The stationary bootstrap. *Journal of the American Statistical Association*, 89(428), 1303–1313.
- Diamond, S., & Boyd, S. (2016). CVXPY: A Python-embedded modeling language for convex optimization. *Journal of Machine Learning Research*, 17(83), 1–5.
