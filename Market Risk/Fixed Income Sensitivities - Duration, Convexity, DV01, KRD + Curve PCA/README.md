# Fixed Income Sensitivities: Duration, Convexity, DV01, KRD + Curve PCA

**What it does:** computes the full set of interest-rate sensitivities of a USD 1 billion MDB-style treasury portfolio built from real bonds, and checks how well each measure predicts the P&L of realistic curve scenarios.
**Data:** live bond-level holdings of four iShares ETFs (Treasuries, agencies, sub-sovereigns, banks, corporates), today's Treasury par curve (U.S. Treasury) and 10 years of daily Treasury yields (FRED).
**Methods:** yield-based and effective duration and convexity, DV01, key-rate durations, PCA of curve moves for level / slope / curvature scenarios, and full revaluation versus first- and second-order Taylor approximations.
**Key output:** a sensitivity report by bond and by sleeve, a key-rate heatmap, a scenario P&L table (parallel, twist, butterfly, PCA, historical) and a map of where the duration approximation breaks down.

---

## Why it matters

Duration is the first number anyone asks for, and it is only exact for small parallel moves. This notebook shows, on a real portfolio, when duration is good enough, when convexity matters, and why curve-shape scenarios need key-rate durations. PCA keeps the stress scenarios realistic rather than arbitrary.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (under a minute).

## Data sources

| Data | Link |
|---|---|
| iShares holdings (GOVT 239468, AGZ 239457, MUB 239766, IGIB 239463) | `https://www.ishares.com/us/products/<id>/fund/latest-holdings.csv` |
| Treasury par yield curve | https://home.treasury.gov/resource-center/data-chart-center/interest-rates |
| Treasury CMT yields (`DGS3MO` … `DGS30`) | https://fred.stlouisfed.org |

## Outputs (`outputs/`)

| File | Content |
|---|---|
| `01_duration_and_convexity.png` | Effective duration vs maturity, convexity vs duration |
| `02_kr01_heatmap.png` | Key-rate DV01 by sleeve and tenor |
| `03_pca_components.png` | One-month 1σ level / slope / curvature moves |
| `04_scenario_pnl.png` | Scenario P&L: full revaluation vs approximations |
| `05_taylor_error.png` | Duration and duration + convexity errors for parallel shifts |
| `bond_sensitivities.csv`, `sensitivities_by_sleeve.csv`, `scenario_pnl.csv` | Report tables |

## Key assumptions

- Z-spreads held fixed (rate risk only; spread risk is not measured).
- Callable munis priced to maturity.
- FRED CMT par-yield changes used as a proxy for zero-rate moves in the PCA.

## Suggested commit plan

1. `add README and sensitivity definitions`
2. `holdings ETL, Treasury curve and 10y history`
3. `bond-level duration, convexity, DV01 and KR01`
4. `curve PCA and scenario design`
5. `full revaluation vs Taylor approximations and executed outputs`
