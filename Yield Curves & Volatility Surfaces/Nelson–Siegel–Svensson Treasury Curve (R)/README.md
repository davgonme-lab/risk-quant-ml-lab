# Nelson–Siegel–Svensson Treasury Curve (R)

Treasury yields are published at eleven maturities, but pricing and risk systems need a rate for every date. A parametric curve fills the gaps with a smooth shape whose few parameters have an economic meaning: level, slope and curvature. This notebook fits that curve by hand in base R, follows its factors for 26 years, and checks the result against the Federal Reserve's own fitted curve.

**What it does.** It fits the Nelson–Siegel and Nelson–Siegel–Svensson models to the daily Treasury constant-maturity curve with a hand-written estimator in base R (`optim`).

It fits the latest day and every month-end since 2000, tracks the level, slope and curvature factors, tests stability by leaving tenors out, and validates the fitted zero curve against the Federal Reserve's Gürkaynak–Sack–Wright (GSW) NSS curve.

**Data.** 11 constant-maturity Treasury yields from 1 month to 30 years (FRED via `fredr`), and the GSW zero-coupon curve and parameters (federalreserve.gov).

**Methods.** NS and NSS discount functions, with par yields computed from the discount function so the model is fitted on the same basis as the CMT data. The fit uses multi-start L-BFGS-B with bounds on the decay parameters.

Leave-one-tenor-out cross-validation and a comparison with GSW zero rates at 2, 5, 10 and 20 years check the result.

**Key output.** Today's fitted par, zero and forward curves, fit errors by tenor and model, 26 years of factor history, the gap to the Fed's curve, and an interactive dashboard.

---

## Why it matters

Every bond valuation, DV01 and IRRBB number starts from a fitted curve. A hand-written NSS estimator in base R fits the 11 Treasury CMT tenors to within 2.5 bp today (NS: 8 bp) and 3.2 bp at the median month-end since 2000, and its zero rates agree with the Federal Reserve's GSW curve within 3 bp at 2–5 years and about 8 bp at the long end. The fit is reliable; the parameters are not: β0 and β3 trade off (GSW's published parameters show the same), so risk systems should store and shock zero rates rather than NSS betas.

## How to run

1. Once, from the repo root: `Rscript install_packages.R` (installs the CRAN packages and registers the **R** kernel with IRkernel).
2. `.env` needs `FRED_API_KEY`.
3. Open the notebook, choose the **R** kernel, **Run All** (about 15 minutes (322 month-end multi-start fits)).

## Data sources

| Data | Source |
|---|---|
| Treasury constant-maturity yields, 1 month to 30 years | https://fred.stlouisfed.org |
| Gürkaynak–Sack–Wright zero-coupon curve and NSS parameters | https://www.federalreserve.gov/data/yield-curve-tables/feds200628.csv |

## Outputs (`outputs/`)

- `01_curve_today.png`
- `02_history_errors_gsw.png`
- `dashboard.html`
- `dashboard.png`
- `gap_vs_fed_gsw.csv`
- `leave_one_tenor_out.csv`
- `monthly_nss_fits.csv`
- `nss_parameters_today.csv`

## Key assumptions

- Model fitted on par yields derived from the NSS discount function, the same basis as CMT data.
- Multi-start L-BFGS-B, τ1 in 0.1–5 years and τ2 in 5–30 years; β0 ≥ 0.
- Leave-one-tenor-out on the last 36 month-ends; GSW comparison on zero rates at 2, 5, 10 and 20 years.

## Suggested commit plan

1. `add README and curve framework`
2. `FRED CMT and Fed GSW ETL`
3. `NS/NSS discount, par and forward functions and optimiser`
4. `today's fit and month-end history`
5. `leave-one-out, GSW validation, dashboard and executed outputs`

## References

### Finance and regulation

- Nelson, C. R., & Siegel, A. F. (1987). Parsimonious modeling of yield curves. *The Journal of Business, 60*(4), 473–489. https://doi.org/10.1086/296409
- Svensson, L. E. O. (1994). *Estimating and interpreting forward interest rates: Sweden 1992–1994* (NBER Working Paper No. 4871). National Bureau of Economic Research. https://doi.org/10.3386/w4871
- Gürkaynak, R. S., Sack, B., & Wright, J. H. (2007). The U.S. Treasury yield curve: 1961 to the present. *Journal of Monetary Economics, 54*(8), 2291–2304. https://doi.org/10.1016/j.jmoneco.2007.06.029
- Bank for International Settlements. (2005). *Zero-coupon yield curves: Technical documentation* (BIS Papers No. 25). https://www.bis.org/publ/bppdf/bispap25.htm
- Diebold, F. X., & Li, C. (2006). Forecasting the term structure of government bond yields. *Journal of Econometrics, 130*(2), 337–364. https://doi.org/10.1016/j.jeconom.2005.03.005

### Machine learning and deep learning

- Byrd, R. H., Lu, P., Nocedal, J., & Zhu, C. (1995). A limited memory algorithm for bound constrained optimization. *SIAM Journal on Scientific Computing, 16*(5), 1190–1208. https://doi.org/10.1137/0916069
- Arlot, S., & Celisse, A. (2010). A survey of cross-validation procedures for model selection. *Statistics Surveys, 4*, 40–79. https://doi.org/10.1214/09-SS054
