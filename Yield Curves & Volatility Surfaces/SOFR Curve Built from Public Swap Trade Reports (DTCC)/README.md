# SOFR Curve Built from Public Swap Trade Reports (DTCC)

A SOFR curve built only from free data has to guess its long end, usually Treasury yields plus an assumed swap spread. Every swap with a U.S. person, though, must be reported publicly within minutes. This notebook turns those raw trade reports into a curve, which is a real data-engineering problem, and in doing so replaces the guess with the swap spread the market actually traded.

**What it does.** It rebuilds the USD SOFR swap curve from thousands of real, anonymised swap trades reported to the DTCC swap data repository, with no dealer quotes and no assumptions about swap spreads.

**Data.** DTCC Public Price Dissemination cumulative rates files (CFTC jurisdiction, last 60 business days by default), the SOFR fixing (FRED) and the Treasury par curve (U.S. Treasury).

**Methods.** An ETL that filters and cleans raw trade reports, SQL aggregation with DuckDB, robust (Huber) estimation of the par swap rate per tenor and day, outlier flagging, and QuantLib bootstrapping.

**Key output.** A trade-based SOFR curve, its daily history, the **observed** swap spreads to Treasuries (which replace the usual textbook assumption) and a market-activity dashboard.

---

## Why it matters

A curve built from what actually traded is the benchmark for validating any vendor or model curve, for example during a system migration (Numerix → Murex). Cleaning regulatory trade reports is also a realistic data-engineering task: lifecycle events, corrections, package legs, forward starts and capped notionals all have to be handled explicitly.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All**.
3. The first run downloads ~60 daily files (~1–2 MB each, a few minutes). Later runs reuse the cache in `data/dtcc/`.
4. Change `N_BUSINESS_DAYS` in the setup cell for a longer history (DTCC keeps about one year).

## Data sources

| Data | Source | Link |
|---|---|---|
| Daily cumulative rates swap reports (CFTC) | DTCC Public Price Dissemination | https://pddata.dtcc.com/ppd/cftcdashboard |
| Direct file pattern | DTCC (S3) | `https://kgc0418-tdw-data-0.s3.amazonaws.com/cftc/eod/CFTC_CUMULATIVE_RATES_YYYY_MM_DD.zip` |
| SOFR fixing | FRED | https://fred.stlouisfed.org/series/SOFR |
| Treasury par yield curve | U.S. Treasury | https://home.treasury.gov/resource-center/data-chart-center/interest-rates |

## Outputs (`outputs/`)

| File | Content |
|---|---|
| `01_cleaning_funnel.png` | How many reports survive each cleaning step |
| `02_volume_heatmap.png` | Clean notional by trade date and tenor |
| `03_latest_day_trades_vs_estimate.png` | Every trade on the latest day, outliers and the robust par curve |
| `04_swap_rate_history.png` | Daily 2Y / 5Y / 10Y / 30Y par swap rates |
| `05_observed_swap_spreads.png` | Observed swap spreads vs the textbook assumption |
| `dashboard.html` / `.png` | Interactive and static dashboard |
| `dtcc_par_rate_estimates.csv` | Robust par rate per day and tenor |

## Suggested commit plan

1. `add README and project scope`
2. `DTCC daily-file extractor with caching`
3. `trade-report parsing and cleaning funnel`
4. `DuckDB aggregation and volume heatmap`
5. `Huber par-rate estimation and outlier flags`
6. `QuantLib bootstrap and observed swap spreads`
7. `dashboard and executed outputs`

## References

### Finance and regulation

- Jermann, U. J. (2020). Negative swap spreads and limited arbitrage. *The Review of Financial Studies, 33*(1), 212–238. https://doi.org/10.1093/rfs/hhz030
- Hagan, P. S., & West, G. (2006). Interpolation methods for curve construction. *Applied Mathematical Finance, 13*(2), 89–129. https://doi.org/10.1080/13504860500396032
- Huber, P. J. (1964). Robust estimation of a location parameter. *The Annals of Mathematical Statistics, 35*(1), 73–101. https://doi.org/10.1214/aoms/1177703732
- Schrimpf, A., & Sushko, V. (2019). Beyond LIBOR: A primer on the new benchmark rates. *BIS Quarterly Review*, March, 29–52. https://www.bis.org/publ/qtrpdf/r_qt1903e.htm

### Machine learning and deep learning

- Raasveldt, M., & Mühleisen, H. (2019). DuckDB: An embeddable analytical database. In *Proceedings of the 2019 International Conference on Management of Data*. https://doi.org/10.1145/3299869.3320212
- Rousseeuw, P. J., & Leroy, A. M. (1987). *Robust regression and outlier detection*. Wiley. https://doi.org/10.1002/0471725382
