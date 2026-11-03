# A Multi-Asset Market Risk Engine in R: EWMA, GARCH, DCC Correlations, Expected Shortfall, Monte Carlo and Machine-Learning VaR

Stocks and bonds hedged each other for twenty years and then fell together in 2022. A risk number built on fixed correlations understates the danger exactly when it matters. This notebook builds a daily market risk engine for a multi-asset portfolio with seven methods, from simple history to dynamic correlations and machine learning, and lets thirteen years of backtests decide which one to trust.

**What it does.** It computes the daily 99% VaR and 97.5% Expected Shortfall of a $100mm multi-asset portfolio (U.S., international and emerging equities, Treasuries, investment-grade and high-yield credit, gold and commodities) with seven methods, and backtests them out of sample from 2012:

1. historical simulation;
2. EWMA (RiskMetrics) covariance;
3. a GARCH model of the portfolio return;
4. a **DCC-GARCH** model of all eight assets (written from scratch);
5. a filtered-historical-simulation **Monte Carlo** on the DCC model;
6. a **quantile random forest**;
7. **XGBoost** quantile regression.

It reports today's risk split by asset (Euler allocation), how correlations behave in crises, and which method wins on regulatory backtests and on the Fissler–Ziegel loss.

**Data.** Yahoo Finance (eight ETFs since 2007, via `quantmod`) and FRED (VIX, Baa credit spread, Treasury term spread).

**Methods.** `rugarch` GJR-GARCH with skewed-t errors, DCC(1,1) by two-step quasi-maximum likelihood, multivariate filtered historical simulation, `ranger` quantile forests and `xgboost` quantile loss.

The backtests are Kupiec, Christoffersen and the Basel traffic light for VaR, the Acerbi–Székely test for ES, and Fissler–Ziegel FZ0 scoring.

**Key output.** VaR and ES today by method, component VaR by asset, rolling DCC correlations, backtest tables and loss rankings.

---

## Why it matters

A market risk engine has to get both volatility and changing correlations right, and FRTB moved the regulatory measure to Expected Shortfall. Seven 99% VaR / 97.5% ES models for a $100mm multi-asset ETF portfolio are backtested on 3,720 days from 2012. A filtered-historical-simulation Monte Carlo on a hand-written DCC-GARCH wins: 0.97% exceptions, no clustering, 93% green traffic-light windows, an ES Z2 close to zero and the best Fissler–Ziegel loss. EWMA-normal and historical simulation fail, and quantile random forests and XGBoost are acceptable but not better. The DCC also shows the stock–bond hedge turning from −0.5 in past crises to +0.2 today.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 25 minutes (60 re-estimations of eight GARCH models and the DCC)).

## Data sources

| Data | Source |
|---|---|
| ETF prices (Yahoo Finance via quantmod) | https://finance.yahoo.com |
| VIX, Baa–Treasury spread, 10y–3m term spread (FRED) | https://fred.stlouisfed.org |

## Outputs (`outputs/`)

- `01_market_risk_engine.png`
- `backtest_by_model.csv`
- `component_var_today.csv`
- `daily_forecasts.csv`
- `dashboard.html`
- `dashboard.png`
- `dcc_correlation_in_crises.csv`
- `exception_rate_by_period.csv`
- `garch_parameters.csv`
- `var_es_today.csv`

## Key assumptions

- Fixed weights rebalanced daily: SPY 30%, TLT 20%, LQD 15%, EFA 10%, GLD 10%, EEM 5%, HYG 5%, DBC 5%.
- GJR-GARCH(1,1) with skewed-t errors and DCC(1,1) re-estimated every 63 days on an expanding window; ML models re-estimated yearly.
- FHS Monte Carlo: 10,000 resampled past decorrelated shock vectors per day; ES tests use each model's own 97.5% VaR.

## Suggested commit plan

1. `market-risk-engine-r: add ETF data, per-asset GARCH and the DCC estimator`
2. `market-risk-engine-r: add rolling VaR/ES forecasts for seven models`
3. `market-risk-engine-r: add backtests, FZ0 scoring, Euler allocation and dashboard`

## References

### Finance and regulation

- Engle, R. (2002). Dynamic conditional correlation: A simple class of multivariate generalized autoregressive conditional heteroskedasticity models. *Journal of Business & Economic Statistics, 20*(3), 339–350. https://doi.org/10.1198/073500102288618487
- Glosten, L. R., Jagannathan, R., & Runkle, D. E. (1993). On the relation between the expected value and the volatility of the nominal excess return on stocks. *The Journal of Finance, 48*(5), 1779–1801. https://doi.org/10.1111/j.1540-6261.1993.tb05128.x
- Barone-Adesi, G., Giannopoulos, K., & Vosper, L. (1999). VaR without correlations for portfolios of derivative securities. *Journal of Futures Markets, 19*(5), 583–602. https://doi.org/10.1002/(SICI)1096-9934(199908)19:5<583::AID-FUT5>3.0.CO;2-S
- Basel Committee on Banking Supervision. (2019). *Minimum capital requirements for market risk*. Bank for International Settlements. https://www.bis.org/bcbs/publ/d457.htm
- Patton, A. J., Ziegel, J. F., & Chen, R. (2019). Dynamic semiparametric models for expected shortfall (and value-at-risk). *Journal of Econometrics, 211*(2), 388–413. https://doi.org/10.1016/j.jeconom.2018.10.008

### Machine learning and deep learning

- Meinshausen, N. (2006). Quantile regression forests. *Journal of Machine Learning Research, 7*, 983–999. https://jmlr.org/papers/v7/meinshausen06a.html
- Chen, T., & Guestrin, C. (2016). XGBoost: A scalable tree boosting system. In *Proceedings of the 22nd ACM SIGKDD International Conference on Knowledge Discovery and Data Mining*. https://doi.org/10.1145/2939672.2939785
- Wright, M. N., & Ziegler, A. (2017). ranger: A fast implementation of random forests for high dimensional data in C++ and R. *Journal of Statistical Software, 77*(1), 1–17. https://doi.org/10.18637/jss.v077.i01
