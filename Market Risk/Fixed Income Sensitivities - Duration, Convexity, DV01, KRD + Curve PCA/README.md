# Fixed Income Sensitivities: Duration, Convexity, DV01, KRD + Curve PCA

"What is the duration?" is the first question about any bond portfolio, and the answer is never enough on its own, because real yield curves rarely move in parallel. This notebook computes the full set of interest-rate sensitivities for a real portfolio and checks how well each one predicts the P&L of realistic curve moves.

**What it does.** It computes the full set of interest-rate sensitivities of a USD 1 billion MDB-style treasury portfolio built from real bonds, and checks how well each measure predicts the P&L of realistic curve scenarios.

**Data.** Live bond-level holdings of four iShares ETFs (Treasuries, agencies, sub-sovereigns, banks, corporates), today's Treasury par curve (U.S. Treasury) and 10 years of daily Treasury yields (FRED).

**Methods.** Yield-based and curve-based (effective) duration and convexity, DV01, key-rate durations, and PCA of curve moves to build level, slope and curvature scenarios. Full revaluation is compared with first- and second-order Taylor approximations.

**Key output.** A sensitivity report by bond and by sleeve, a key-rate risk heatmap, a scenario P&L table (parallel, twist, butterfly, PCA and historical), and a map of where the duration approximation breaks down.

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

## References

### Finance and regulation

- Ho, T. S. Y. (1992). Key rate durations: Measures of interest rate risks. *The Journal of Fixed Income, 2*(2), 29–44. https://doi.org/10.3905/jfi.1992.408049
- Litterman, R., & Scheinkman, J. (1991). Common factors affecting bond returns. *The Journal of Fixed Income, 1*(1), 54–61. https://doi.org/10.3905/jfi.1991.692347
- Tuckman, B., & Serrat, A. (2022). *Fixed income securities: Tools for today's markets* (4th ed.). Wiley. https://doi.org/10.1002/9781119835622
- Golub, B. W., & Tilman, L. M. (1997). Measuring yield curve risk using principal components analysis, value at risk, and key rate durations. *The Journal of Portfolio Management, 23*(4), 72–84. https://doi.org/10.3905/jpm.1997.409612
- Redington, F. M. (1952). Review of the principles of life-office valuations. *Journal of the Institute of Actuaries, 78*(3), 286–340. https://doi.org/10.1017/S0020268100052811

### Machine learning and deep learning

- Jolliffe, I. T., & Cadima, J. (2016). Principal component analysis: A review and recent developments. *Philosophical Transactions of the Royal Society A, 374*(2065), 20150202. https://doi.org/10.1098/rsta.2015.0202
