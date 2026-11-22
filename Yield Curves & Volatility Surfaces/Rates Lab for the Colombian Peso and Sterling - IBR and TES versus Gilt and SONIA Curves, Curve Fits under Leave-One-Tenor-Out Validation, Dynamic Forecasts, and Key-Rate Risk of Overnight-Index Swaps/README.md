# Rates Lab for the Colombian Peso and Sterling: IBR and TES versus Gilt and SONIA Curves, Curve Fits under Leave-One-Tenor-Out Validation, Dynamic Forecasts, and Key-Rate Risk of Overnight-Index Swaps

A rates desk needs three things from a yield curve: a smooth curve through the few rates the market actually quotes, a view of how that curve may move, and the sensitivity of each position to every part of it. This notebook builds all three for two very different markets. The Colombian peso curve is short of data: Banco de la República publishes the interbank reference rate (IBR) from overnight to twelve months and zero-coupon yields of government bonds (TES) at one, five and ten years, and rates have swung from 1.75% to 13.25% and back in five years. The sterling curve is rich: the Bank of England publishes fitted zero-coupon gilt and SONIA overnight-index-swap (OIS) curves at half-year steps out to 25–40 years.

**What it does.**

1. It downloads month-end curves: since 2016 for the peso (when the six-month IBR starts) and since 2008 for gilts and 2016 for SONIA swaps: IBR and TES zero-coupon rates and the policy rate from Banco de la República's statistics service, and the Bank of England's nominal gilt and SONIA OIS spot curves.
2. It decomposes monthly curve changes into principal components (level, slope, curvature) in each market and measures how much the two markets move together.
3. It compares four ways of drawing a curve through the quoted points: Nelson–Siegel, Nelson–Siegel–Svensson, a cubic spline and a Gaussian process, by leaving out one quoted tenor at a time and predicting it.
4. It forecasts the curve one month ahead with a random walk, the dynamic Nelson–Siegel model of Diebold and Li, and LightGBM, out of sample from 2015 for gilts and 2019 for the peso.
5. It values five-year receive-fixed OIS positions in both currencies (IBR and SONIA), computes their DV01 and key-rate DV01s, measures their one-month 99% value-at-risk from historical curve moves, and hedges level and slope risk with two other swaps.

**Data.** Banco de la República (suameca statistics service): monetary policy rate, IBR overnight to 12 months, TES zero-coupon rates at 1, 5 and 10 years. Bank of England: nominal government liability curve and OIS (SONIA) curve, month-end.

**Methods.** Principal component analysis, Nelson–Siegel and Svensson fits, cubic splines, Gaussian-process regression, leave-one-tenor-out validation, the Diebold–Li dynamic factor model, LightGBM, OIS pricing, DV01 and key-rate DV01, historical value-at-risk and principal-component hedging.

**Key output.** Variance shares of curve factors and cross-market correlation; out-of-sample errors of every curve fit and forecast by tenor; par rates, DV01, key-rate profiles and hedged and unhedged value-at-risk of the two swaps.

---

## Why it matters

The peso curve, built from Banco de la República's IBR and TES zero-coupon rates, behaves like two markets: money-market rates follow the policy rate almost one for one while TES yields move with other risks, so a slope factor explains 27% of its moves against 9–14% for sterling. With only seven quoted tenors, a cubic spline predicts a removed quote within 34 bp while Svensson overfits badly; on the dense sterling curve all fits are within 5 bp. LightGBM beats a random walk only at the short end of the peso curve, and hedging five-year OIS receivers against level and slope cuts their one-month value-at-risk by 82% (pesos) and 94% (sterling).

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY` in `.env` (required by the shared setup cell; the data themselves need no key).
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 4 minutes (the forecast and curve-fit loops dominate)).

## Data sources

| Data | Source |
|---|---|
| Policy rate, IBR and TES zero-coupon rates (Banco de la República statistics service) | https://suameca.banrep.gov.co/estadisticas-economicas/ |
| Nominal gilt and SONIA OIS yield curves (Bank of England) | https://www.bankofengland.co.uk/statistics/yield-curves |

## Outputs (`outputs/`)

- `01_rates_lab.png`
- `cross_market_correlations.csv`
- `curve_fit_loto_rmse.csv`
- `curve_fit_loto_rmse_cop_by_tenor.csv`
- `dashboard.html`
- `dashboard.png`
- `forecast_rmse_by_tenor.csv`
- `key_rate_dv01.csv`
- `ois_valuation_and_risk.csv`
- `pca_variance_shares.csv`
- `zero_curves_today.csv`

## Key assumptions

- Month-end zero rates converted to continuous compounding; the peso curve joins IBR (overnight to six months) with TES zero-coupon rates at 1, 5 and 10 years, so its long end proxies the swap curve with government yields.
- Curve-fit validation removes one interior quoted tenor at a time; forecasts are re-estimated monthly (LightGBM yearly) from 2015 for gilts and 2019 for the peso.
- Five-year OIS valued single-curve with linear interpolation of zero rates; VaR from historical monthly changes since 2016 applied to today's curve; hedges neutralise the first two principal components.

## Suggested commit plan

1. `cop-gbp-rates-lab: add Banco de la República and Bank of England curve data`
2. `cop-gbp-rates-lab: add principal components and cross-market correlations`
3. `cop-gbp-rates-lab: add leave-one-tenor-out curve-fit validation`
4. `cop-gbp-rates-lab: add one-month curve forecasts`
5. `cop-gbp-rates-lab: add OIS valuation, key-rate risk, value-at-risk and hedging`
6. `cop-gbp-rates-lab: add charts, dashboard and narrative`

## References

- Anderson, N., & Sleath, J. (2001). *New estimates of the UK real and nominal yield curves* (Bank of England Working Paper No. 126). Bank of England.
- Diebold, F. X., & Li, C. (2006). Forecasting the term structure of government bond yields. *Journal of Econometrics*, 130(2), 337–364. https://doi.org/10.1016/j.jeconom.2005.03.005
- Ke, G., Meng, Q., Finley, T., Wang, T., Chen, W., Ma, W., Ye, Q., & Liu, T.-Y. (2017). LightGBM: A highly efficient gradient boosting decision tree. In *Advances in Neural Information Processing Systems 30* (pp. 3146–3154).
- Litterman, R., & Scheinkman, J. (1991). Common factors affecting bond returns. *Journal of Fixed Income*, 1(1), 54–61. https://doi.org/10.3905/jfi.1991.692347
- Nelson, C. R., & Siegel, A. F. (1987). Parsimonious modeling of yield curves. *Journal of Business*, 60(4), 473–489. https://doi.org/10.1086/296409
- Rasmussen, C. E., & Williams, C. K. I. (2006). *Gaussian processes for machine learning*. MIT Press.
- Svensson, L. E. O. (1994). *Estimating and interpreting forward interest rates: Sweden 1992–1994* (NBER Working Paper No. 4871). National Bureau of Economic Research. https://doi.org/10.3386/w4871
- Banco de la República. (2026). *Portal de estadísticas económicas* [Data: monetary policy rate, IBR, TES zero-coupon rates]. https://suameca.banrep.gov.co/estadisticas-economicas/
- Bank of England. (2026). *Yield curves* [Data: nominal government liability curve and OIS curve]. https://www.bankofengland.co.uk/statistics/yield-curves
