# SOFR Curve Calibrated from SOFR, Futures & Treasuries

Every number a counterparty-risk desk produces starts with a discount curve, and since the end of LIBOR the curve for U.S. dollar collateralised derivatives is the SOFR curve. Production desks build it from dealer quotes that are not free. This notebook shows how far public data can go, and which interpolation method gives forward rates a risk team can trust.

**What it does.** It builds a SOFR discounting curve and a Treasury zero curve for today's date with QuantLib, and tests which interpolation method gives the most trustworthy forward rates.

**Data.** SOFR fixings and 10 years of Treasury yields (FRED), the official daily par yield curve (U.S. Treasury), and the strip of 3-month SOFR futures (CME, via Yahoo Finance).

**Methods.** Curve bootstrapping (deposit + futures with convexity adjustment + OIS swaps), six interpolation schemes compared on exact repricing, forward smoothness and locality, and a sensitivity test on the swap-spread assumption.

**Key output.** A validated SOFR zero, forward and discount curve, the market-implied path of SOFR, and a one-page curve dashboard (PNG and interactive HTML).

---

## Why it matters

Every PFE, CVA, hedge ratio and swap valuation starts with a discount curve. For USD collateralised derivatives that curve is SOFR OIS. This project shows how to build it from public data, and how to defend the modelling choices behind it.

## How to run

1. From the repo root: `conda activate quant-risk`. The `.env` file must contain `FRED_API_KEY`.
2. Open `G01_sofr_curve_calibrated.ipynb` in VS Code, choose the **Python (quant-risk)** kernel and click **Run All**.
3. Runtime is about 1–2 minutes. Downloads are cached in `data/` for 12 hours.

## Data sources

| Data | Source | Link |
|---|---|---|
| Daily Treasury par yield curve | U.S. Treasury | https://home.treasury.gov/resource-center/data-chart-center/interest-rates |
| SOFR fixing, Treasury CMT yields (`DGS*`) | FRED | https://fred.stlouisfed.org/series/SOFR |
| 3M SOFR futures (`SR3<code><yy>.CME`) | CME via Yahoo Finance | https://finance.yahoo.com/quote/SR3Z26.CME |

## Outputs (`outputs/`)

| File | Content |
|---|---|
| `01_inputs_par_curve_and_sofr_path.png` | Par curve today vs a year ago; SOFR history vs the futures-implied path |
| `02_treasury_history_heatmap_2s10s.png` | Ten years of Treasury yields by maturity, plus the 2s10s slope |
| `03_forward_curves_by_interpolation.png` | Overnight forwards under five interpolation methods |
| `dashboard.html` / `.png` | Interactive and static curve dashboard |
| `sofr_and_treasury_curves_monthly.csv` | Monthly zero, 3M forward and discount factors, SOFR and Treasury, to 30 years |

## Key assumptions

- **Long-end SOFR swap rates** are approximated as *Treasury par yield + swap spread*, using an explicit spread term structure (section 6.1). Section 7.3 measures the impact. Swap trades reported to DTCC would remove the assumption.
- **Futures convexity** uses the Ho–Lee approximation with 100 bp normal volatility. Futures are only used up to 2 years.

## Suggested commit plan

1. `add README and project scope`
2. `data layer — Treasury par curves, FRED SOFR/history, SOFR futures with caching`
3. `exploratory charts of curve inputs`
4. `QuantLib Treasury and SOFR curve bootstrapping`
5. `interpolation comparison (repricing, roughness, locality) and spread sensitivity`
6. `curve tables, dashboard and executed outputs`

## References

### Finance and regulation

- Hagan, P. S., & West, G. (2006). Interpolation methods for curve construction. *Applied Mathematical Finance, 13*(2), 89–129. https://doi.org/10.1080/13504860500396032
- Ametrano, F. M., & Bianchetti, M. (2013). *Everything you always wanted to know about multiple interest rate curve bootstrapping but were afraid to ask*. SSRN. https://doi.org/10.2139/ssrn.2219548
- Jermann, U. J. (2020). Negative swap spreads and limited arbitrage. *The Review of Financial Studies, 33*(1), 212–238. https://doi.org/10.1093/rfs/hhz030
- Hull, J., & White, A. (1990). Pricing interest-rate-derivative securities. *The Review of Financial Studies, 3*(4), 573–592. https://doi.org/10.1093/rfs/3.4.573
- Mercurio, F. (2018). *A simple multi-curve model for pricing SOFR futures and other derivatives*. SSRN. https://doi.org/10.2139/ssrn.3225872

### Machine learning and deep learning

- Ballabio, L. (2020). *Implementing QuantLib*. Leanpub. https://leanpub.com/implementingquantlib
