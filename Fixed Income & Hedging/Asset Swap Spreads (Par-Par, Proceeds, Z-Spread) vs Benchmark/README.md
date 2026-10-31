# Asset Swap Spreads (Par-Par, Proceeds, Z-Spread) vs Benchmark

A development bank's treasury borrows at SOFR plus a small spread, so a bond is only worth buying if it pays more than that once its fixed coupons are swapped into floating. That extra is the asset swap spread. This notebook computes it bond by bond for a realistic treasury portfolio and flags which bonds look rich or cheap.

**What it does.** It measures how much each bond in an MDB-style treasury portfolio pays over SOFR once it is asset-swapped, and flags which bonds are rich or cheap against their peers and against market benchmarks.

**Data.** Live bond-level holdings of four iShares ETFs (Treasuries, agencies, sub-sovereigns, banks, corporates), the Treasury par curve (U.S. Treasury), and ICE BofA investment-grade OAS indices (FRED).

**Methods.** Cash-flow pricing on a SOFR discount curve, three spread measures (par-par asset swap, proceeds asset swap, Z-spread) plus the I-spread, and a robust relative-value regression of spread on sector and duration.

**Key output.** A bond-by-bond spread table, the richest and cheapest bonds, sleeve averages against the IG benchmark and its 10-year history, and a relative-value dashboard.

---

## Why it matters

An MDB funds at SOFR plus a spread, so it judges investments by their **asset swap spread**, not their yield. Different desks quote different definitions of "spread over swaps", and the gap between them grows when bonds trade away from par. This project computes all of them consistently and turns them into a relative-value screen.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (under a minute).

## Data sources

| Data | Link |
|---|---|
| iShares holdings (GOVT 239468, AGZ 239457, MUB 239766, IGIB 239463) | `https://www.ishares.com/us/products/<id>/fund/latest-holdings.csv` |
| Treasury par yield curve | https://home.treasury.gov/resource-center/data-chart-center/interest-rates |
| ICE BofA OAS (`BAMLC0A0CM`, `BAMLC0A2CAA`, `BAMLC0A3CA`, `BAMLC0A4CBBB`) | https://fred.stlouisfed.org/series/BAMLC0A0CM |

## Outputs (`outputs/`)

| File | Content |
|---|---|
| `01_asw_vs_maturity.png` | Par-par ASW by maturity and sleeve |
| `02_measure_differences_vs_price.png` | Why spread measures diverge away from par |
| `03_rich_cheap.png` | Ten cheapest and ten richest bonds vs peers |
| `04_benchmark_history.png` | ICE BofA OAS history vs our credit sleeves today |
| `dashboard.html` / `.png` | Relative-value dashboard |
| `bond_spreads.csv` | All spread measures, fair value and residual per bond |

## Key assumptions

- SOFR curve = Treasury zero + an explicit swap-spread term structure. Replace `SWAP_SPREAD_BP` with swap spreads observed from reported trades to remove the assumption.
- Callable bonds are treated as bullets.

## Suggested commit plan

1. `add README and spread definitions`
2. `holdings ETL, Treasury/SOFR curves and IG benchmarks`
3. `par-par, proceeds, Z- and I-spreads bond by bond`
4. `measure-difference analysis`
5. `robust relative-value regression and rich/cheap screen`
6. `benchmark history, dashboard and executed outputs`

## References

### Finance and regulation

- Tuckman, B., & Serrat, A. (2022). *Fixed income securities: Tools for today's markets* (4th ed.). Wiley. https://doi.org/10.1002/9781119835622
- Feldhütter, P., & Lando, D. (2008). Decomposing swap spreads. *Journal of Financial Economics, 88*(2), 375–405. https://doi.org/10.1016/j.jfineco.2007.07.004
- Duffie, D., & Singleton, K. J. (1997). An econometric model of the term structure of interest-rate swap yields. *The Journal of Finance, 52*(4), 1287–1321. https://doi.org/10.1111/j.1540-6261.1997.tb01111.x
- O'Kane, D. (2008). *Modelling single-name and multi-name credit derivatives*. Wiley. https://doi.org/10.1002/9781119201960

### Machine learning and deep learning

- Huber, P. J. (1964). Robust estimation of a location parameter. *The Annals of Mathematical Statistics, 35*(1), 73–101. https://doi.org/10.1214/aoms/1177703732
- Rousseeuw, P. J., & Leroy, A. M. (1987). *Robust regression and outlier detection*. Wiley. https://doi.org/10.1002/0471725382
