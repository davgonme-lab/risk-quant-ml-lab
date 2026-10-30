# Continuous Forward Curves for SOFR, €STR and EURIBOR: Bootstraps, Nelson–Siegel–Svensson, Splines, Gaussian Processes and Neural Networks

A swap curve is quoted at a dozen tenors, but every trading and risk system needs a forward rate for every date in between. How the gaps are filled decides whether FRAs make sense, whether the risk of a bump lands in the right bucket, and whether the curve jumps when one quote moves. This notebook builds daily curves from real trades and compares nine ways of filling the gaps, judged against prices the market actually traded.

**What it does.** It builds daily forward curves from **real swap trades** reported to the CFTC: SOFR OIS, €STR OIS and EURIBOR-6M swaps discounted on €STR. It then compares nine ways of turning a handful of quotes into a continuous curve:

- four **bootstraps** (QuantLib: linear zero, flat forward, natural cubic zero, Hagan–West monotone convex);
- two **parametric** fits (Nelson–Siegel and Svensson);
- a **penalised forward spline**;
- a **Gaussian-process** (kernel) curve;
- a **neural-network** forward curve fitted directly to swap prices.

**The benchmark is the market itself.** Every method is judged on how well it reprices **forward-starting swaps traded the same day**, which were *not* used to build the curve. It is also judged on leave-one-tenor-out errors, forward smoothness, day-to-day stability and how *local* its hedge ratios are.

**Data.** The DTCC public swap data repository (CFTC cumulative rates reports, ten business days), FRED (SOFR fixing) and the ECB (€STR fixing, EURIBOR 6M).

**Methods.** QuantLib piecewise bootstrapping, Nelson–Siegel(–Svensson), penalised splines, kernel / Gaussian-process regression, and neural networks in PyTorch with a differentiable swap pricer, all tested by repricing forward-start swaps out of sample.

---

## Why it matters

Every swap, FRA and hedge ratio depends on how a handful of quotes is turned into a continuous forward curve. Using ten days of real swap trades reported to the DTCC (SOFR OIS, €STR OIS and EURIBOR-6M swaps discounted on €STR), nine methods are compared on the criteria a desk cares about: exact fit, repricing of same-day forward-starting swaps that were never used to build the curve, leave-one-tenor-out interpolation, forward smoothness, day-to-day stability and hedge locality. Monotone convex (Hagan–West) ranks best overall; a penalised forward spline interpolates and smooths best but spreads risk; NS/Svensson cannot fit the curve; neural-network and Gaussian-process curves give beautiful forwards but non-local, unstable hedge ratios (a 1 bp 10Y bump moves the NN's 30Y forward by 60 bp).

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 15–20 minutes (270 daily fits plus leave-one-out and bump tests; the PyTorch methods dominate)).

## Data sources

| Data | Source |
|---|---|
| DTCC public swap data repository (CFTC cumulative rates reports) | https://pddata.dtcc.com/ppd/cftcdashboard |
| SOFR fixing (FRED) | https://fred.stlouisfed.org/series/SOFR |
| €STR fixing and EURIBOR 6M monthly average (ECB Data Portal) | https://data.ecb.europa.eu |

## Outputs (`outputs/`)

- `01_forward_curve_methods.png`
- `daily_fit_results.csv`
- `dashboard.html`
- `dashboard.png`
- `forward_curves_latest_day.csv`
- `method_average_ranks.csv`
- `method_scores_by_curve.csv`
- `spot_quotes_from_dtcc.csv`

## Key assumptions

- Spot-starting, non-package, standard-term trades only; MAC (12.5 bp multiple) coupons removed; daily quote = notional-weighted median after a 3-MAD filter.
- EURIBOR 6M anchored with the last monthly average fixing; EURIBOR swaps discounted on the same day's €STR monotone-convex curve.
- No payment lags; OIS compounding via discount-factor ratios (checked against QuantLib to 0.05 bp).
- Forward-start buckets missed by more than 25 bp by every exact bootstrap are treated as off-market.

## Suggested commit plan

1. `forward-curve-methods: add DTCC swap trade extraction and daily par quotes`
2. `forward-curve-methods: add QuantLib bootstraps and PyTorch NS/NSS/spline/GP/NN curves with a shared differentiable pricer`
3. `forward-curve-methods: add forward-start benchmark, leave-one-out, stability and locality tests`

## References

### Finance and regulation

- Hagan, P. S., & West, G. (2006). Interpolation methods for curve construction. *Applied Mathematical Finance, 13*(2), 89–129. https://doi.org/10.1080/13504860500396032
- Nelson, C. R., & Siegel, A. F. (1987). Parsimonious modeling of yield curves. *The Journal of Business, 60*(4), 473–489. https://doi.org/10.1086/296409
- Svensson, L. E. O. (1994). *Estimating and interpreting forward interest rates: Sweden 1992–1994* (NBER Working Paper No. 4871). National Bureau of Economic Research. https://doi.org/10.3386/w4871
- Ametrano, F. M., & Bianchetti, M. (2013). *Everything you always wanted to know about multiple interest rate curve bootstrapping but were afraid to ask*. SSRN. https://doi.org/10.2139/ssrn.2219548

### Machine learning and deep learning

- Rasmussen, C. E., & Williams, C. K. I. (2006). *Gaussian processes for machine learning*. MIT Press. https://gaussianprocess.org/gpml/
- Filipović, D., Pelger, M., & Ye, Y. (2022). *Stripping the discount curve: A robust machine learning approach*. SSRN. https://doi.org/10.2139/ssrn.4058150
- Paszke, A., Gross, S., Massa, F., Lerer, A., Bradbury, J., Chanan, G., … Chintala, S. (2019). PyTorch: An imperative style, high-performance deep learning library. *Advances in Neural Information Processing Systems, 32*. https://arxiv.org/abs/1912.01703
