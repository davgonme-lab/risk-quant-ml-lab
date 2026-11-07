# Intraday Risk Forecasting for a Trading Desk: Hourly Volatility, Conformal Price Ranges and Honest Direction Forecasts across Ten Assets, HAR and GARCH versus LightGBM, an LSTM and a Transformer

A trading desk needs three numbers for the next hour of every position: how much the price is likely to move (volatility), a range it will stay inside with a stated probability, and, ideally, which way it will go. The first is forecastable, because volatility clusters and follows a strong intraday pattern. The second can be given a guaranteed coverage with conformal prediction, whatever model produces it. The third is where most forecasting claims fail: next-hour direction in liquid markets is close to a coin toss, and an honest evaluation should say so.

This notebook builds all three for ten liquid assets (U.S. equity, bond, gold and oil ETFs, two currency pairs and two cryptocurrencies) from about two years of hourly prices.

**What it does.**

1. It downloads hourly prices from Yahoo Finance, computes hourly log returns within each asset's trading hours, and builds features: recent squared returns at 1-, 8- and 40-hour horizons, the sign of the last return, the hour of the day and day of the week, and whether the bar opens a session.
2. It forecasts next-hour variance with a heterogeneous autoregressive (HAR) model with intraday seasonality and a GARCH(1,1) per asset, and with three pooled machine-learning models across all assets: LightGBM, an LSTM and a transformer encoder, all trained on the first 60% of the sample and evaluated on the remaining 40% with the QLIKE loss, which is robust to the noise in squared returns.
3. It turns each volatility forecast into a 90% range for the next hour's price in three ways (Gaussian, split conformal and adaptive conformal inference) and checks coverage and width by asset and in volatile hours.
4. It forecasts the direction of the next hourly return with a logistic regression and LightGBM, and tests accuracy against a coin toss and against always predicting the majority direction.

**Data.** Hourly prices of SPY, QQQ, IWM, TLT, GLD, USO, EUR/USD, USD/JPY, Bitcoin and Ether (Yahoo Finance, the last two years available).

**Methods.** HAR with intraday seasonality, GARCH(1,1) with Student-t errors, LightGBM with a gamma objective, LSTM and transformer networks trained on a Gaussian likelihood (QLIKE), Mincer–Zarnowitz regressions, Diebold–Mariano tests, split conformal prediction and adaptive conformal inference, binomial tests of direction accuracy.

**Key output.** QLIKE loss and R² of each volatility model by asset class; coverage and width of 90% ranges; direction accuracy with p-values.

---

## Why it matters

Across ten assets and about two years of hourly prices, the intraday pattern is most of the forecastable risk: a GARCH without it is 16% worse hour by hour than a HAR with hour-of-day effects. A transformer shared across assets was best (8% better than HAR on daily totals, 1% hourly, not significant), while LightGBM was worse. Adaptive conformal ranges held 90% coverage for every asset (89.7–90.5%) with ranges 12% narrower than Gaussian ones. Direction forecasts reached 51.3% accuracy against 50.6% for always predicting the majority, and lost money after a 1 bp switching cost.

## How to run

1. `conda activate quant-risk`. `.env` needs None (Yahoo Finance hourly data are public).
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 15 minutes on CPU (mostly the transformer)).

## Data sources

| Data | Source |
|---|---|
| Hourly prices of SPY, QQQ, IWM, TLT, GLD, USO, EUR/USD, USD/JPY, Bitcoin and Ether (Yahoo Finance) | https://finance.yahoo.com/ |

## Outputs (`outputs/`)

- `01_intraday_risk.png`
- `assets.csv`
- `daily_aggregation.csv`
- `dashboard.html`
- `dashboard.png`
- `direction_by_asset.csv`
- `direction_overall.csv`
- `lightgbm_feature_importance.csv`
- `qlike_vs_har_by_class.csv`
- `range_coverage.csv`
- `range_coverage_by_asset.csv`
- `volatility_models.csv`

## Key assumptions

- Hourly log returns within each asset's trading hours; the first ETF bar of a session (overnight gap) is flagged; returns above 25% in an hour are dropped.
- Time split per asset: first 60% training (its last 20% calibrates conformal ranges and early-stops the networks), last 40% testing; squared returns floored at 0.1 bp squared.
- Ranges use the best volatility model on the test period; adaptive conformal with γ = 0.005; direction excludes hours with no price change and charges 1 bp per change of position.

## Suggested commit plan

1. `intraday-risk-forecasting: add hourly prices, returns and features for ten assets`
2. `intraday-risk-forecasting: add HAR, GARCH and LightGBM volatility forecasts`
3. `intraday-risk-forecasting: add LSTM and transformer volatility networks`
4. `intraday-risk-forecasting: add QLIKE, Diebold-Mariano and daily evaluation`
5. `intraday-risk-forecasting: add Gaussian, split and adaptive conformal price ranges`
6. `intraday-risk-forecasting: add direction forecasts, charts and narrative`

## References

- Andersen, T. G., & Bollerslev, T. (1997). Intraday periodicity and volatility persistence in financial markets. *Journal of Empirical Finance*, 4(2–3), 115–158. https://doi.org/10.1016/S0927-5398(97)00004-2
- Bollerslev, T. (1986). Generalized autoregressive conditional heteroskedasticity. *Journal of Econometrics*, 31(3), 307–327. https://doi.org/10.1016/0304-4076(86)90063-1
- Corsi, F. (2009). A simple approximate long-memory model of realized volatility. *Journal of Financial Econometrics*, 7(2), 174–196. https://doi.org/10.1093/jjfinec/nbp001
- Diebold, F. X., & Mariano, R. S. (1995). Comparing predictive accuracy. *Journal of Business & Economic Statistics*, 13(3), 253–263. https://doi.org/10.1080/07350015.1995.10524599
- Gibbs, I., & Candès, E. (2021). Adaptive conformal inference under distribution shift. In *Advances in Neural Information Processing Systems 34* (pp. 1660–1672).
- Hochreiter, S., & Schmidhuber, J. (1997). Long short-term memory. *Neural Computation*, 9(8), 1735–1780. https://doi.org/10.1162/neco.1997.9.8.1735
- Patton, A. J. (2011). Volatility forecast comparison using imperfect volatility proxies. *Journal of Econometrics*, 160(1), 246–256. https://doi.org/10.1016/j.jeconom.2010.03.034
- Vovk, V., Gammerman, A., & Shafer, G. (2005). *Algorithmic learning in a random world*. Springer.
