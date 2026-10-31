# Yield Curve Forecasting: Dynamic Nelson–Siegel + Kalman Filter vs Transformer

ALM, exposure models, stress tests and the funding plan all need scenarios for the whole yield curve, not ten separate forecasts. Factor models deliver that, but the benchmark is brutal: at monthly frequency, yields behave almost like a random walk, and many published models fail to beat "no change". This notebook tests the classic factor models and a Transformer against that benchmark over eighteen years, strictly out of sample.

**What it does.** It forecasts the U.S. Treasury curve 1, 6 and 12 months ahead with the Dynamic Nelson–Siegel model estimated as a state-space system with the Kalman filter.

It compares this with the Diebold–Li two-step model, a Transformer neural network and the random walk, over an 18-year out-of-sample period.

**Data.** Month-end constant-maturity Treasury yields from 3 months to 20 years, 1994–2026 (FRED).

**Methods.** The Nelson–Siegel factor model (level, slope, curvature), Diebold–Li (2006) cross-sectional OLS with AR(1) factors, and the Diebold–Rudebusch–Aruoba (2006) state-space DNS with VAR(1) factors, estimated by maximum likelihood with a hand-written Kalman filter.

A small PyTorch Transformer reads 24-month curve histories. The evaluation is rolling-origin with periodic re-estimation and Diebold–Mariano tests (HAC).

**Key output.** Out-of-sample RMSE by maturity and horizon, significance against the random walk, the filtered level, slope and curvature factors, and today's 12-month curve forecast with Kalman uncertainty bands.

---

## Why it matters

Curve scenarios feed ALM, PFE and stress tests. Over 18 years out of sample, no model beats the random walk with significance. The Kalman DNS model ties it at 6–12 months, is better at the short end, and gives coherent scenarios with uncertainty bands. The two-step Diebold–Li model and a Transformer do worse.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (**about 8 minutes** (maximum-likelihood re-estimations and Transformer refits)).

## Data sources

| Data | Source |
|---|---|
| Treasury CMT yields 3m–20y (`DGS3MO` … `DGS20`) | https://fred.stlouisfed.org |

## Outputs (`outputs/`)

- `01_ns_factors_and_loadings.png`
- `02_oos_rmse_by_maturity.png`
- `03_forecast_from_today.png`
- `dns_forecast_today.csv`
- `dns_kalman_factors.csv`
- `oos_forecast_league.csv`

## Key assumptions

- Month-end curves 1994–2026 (the last row is the latest available day); 30-year excluded because of its 2002–2006 gap.
- Expanding-window re-estimation every 36 months, monthly filtering/updating; no look-ahead.
- DNS not arbitrage-free; measurement s.d. floored at 0.2 bp.

## Suggested commit plan

1. `add README and DNS framework`
2. `CMT ETL and Nelson–Siegel factors`
3. `Kalman filter and maximum likelihood (PyTorch gradients)`
4. `Transformer on curve histories`
5. `rolling-origin evaluation, Diebold–Mariano tests and executed outputs`

## References

### Finance and regulation

- Diebold, F. X., & Li, C. (2006). Forecasting the term structure of government bond yields. *Journal of Econometrics, 130*(2), 337–364. https://doi.org/10.1016/j.jeconom.2005.03.005
- Diebold, F. X., Rudebusch, G. D., & Aruoba, S. B. (2006). The macroeconomy and the yield curve: A dynamic latent factor approach. *Journal of Econometrics, 131*(1–2), 309–338. https://doi.org/10.1016/j.jeconom.2005.01.011
- Nelson, C. R., & Siegel, A. F. (1987). Parsimonious modeling of yield curves. *The Journal of Business, 60*(4), 473–489. https://doi.org/10.1086/296409
- Duffee, G. R. (2002). Term premia and interest rate forecasts in affine models. *The Journal of Finance, 57*(1), 405–443. https://doi.org/10.1111/1540-6261.00426
- Diebold, F. X., & Mariano, R. S. (1995). Comparing predictive accuracy. *Journal of Business & Economic Statistics, 13*(3), 253–263. https://doi.org/10.1080/07350015.1995.10524599

### Machine learning and deep learning

- Kalman, R. E. (1960). A new approach to linear filtering and prediction problems. *Journal of Basic Engineering, 82*(1), 35–45. https://doi.org/10.1115/1.3662552
- Durbin, J., & Koopman, S. J. (2012). *Time series analysis by state space methods* (2nd ed.). Oxford University Press. https://doi.org/10.1093/acprof:oso/9780199641178.001.0001
- Vaswani, A., Shazeer, N., Parmar, N., Uszkoreit, J., Jones, L., Gomez, A. N., Kaiser, Ł., & Polosukhin, I. (2017). Attention is all you need. *Advances in Neural Information Processing Systems, 30*. https://arxiv.org/abs/1706.03762
