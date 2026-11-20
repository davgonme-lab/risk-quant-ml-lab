# Hedging a Bank's Interest-Rate Risk: Swap Notionals on the Frontier between Net-Interest-Income-at-Risk and Economic-Value-at-Risk for the Colombian Banking System and a UK Bank, under Basel Shocks and Historical Scenarios

A bank's treasury can hedge interest-rate risk in two currencies of account: earnings (net interest income over the next year) and value (the present value of all its assets minus all its liabilities). The two pull in opposite directions. A bank funded with sticky deposits and lending at fixed rates loses economic value when rates rise, so it would pay fixed on swaps; but paying fixed raises the cost of the hedge when rates fall and makes next year's income more sensitive to rate cuts. Basel's standards on interest-rate risk in the banking book (IRRBB) ask banks to measure both, under six prescribed shocks, and supervisors flag banks whose economic value would fall by more than 15% of Tier 1 capital.

This notebook builds the trade-off explicitly. It takes the balance sheet of the whole Colombian banking system from the supervisory accounts and a stylised UK retail bank, maps them to repricing buckets, measures earnings-at-risk and economic-value-at-risk under the Basel shocks and thousands of historical curve scenarios, and finds the overnight-index-swap (OIS) notionals by tenor that minimise any mix of the two risks, tracing the efficient frontier between them.

**What it does.**

1. It downloads the Colombian banking system's balance sheet (latest month) from the supervisory accounts, today's peso curve (IBR and TES zero-coupon rates) and its history from Banco de la República, and the Bank of England's SONIA OIS curve and history.
2. It assigns every balance-sheet line a repricing profile (contractual for loans and term deposits, behavioural for savings and current accounts) and computes repricing gaps, the change in economic value of equity (ΔEVE) and the change in twelve-month net interest income (ΔNII) under the six Basel shocks.
3. It generates rate scenarios by bootstrapping twelve-month changes of each curve since 2016 in blocks of three months, and measures EVE-at-risk and NII-at-risk as expected shortfalls at 95%.
4. It solves a linear programme for the OIS notionals at five tenors that minimise a weighted mix of the two expected shortfalls, traces the frontier from "protect value" to "protect income", and tests the chosen hedges against the Basel shocks and the supervisory outlier test.

**Data.** Superintendencia Financiera de Colombia via datos.gov.co (*CUIF por moneda*, mxk5-ce6w); Banco de la República (policy rate, IBR, TES zero-coupon rates); Bank of England (SONIA OIS curve).

**Methods.** Repricing-gap analysis, cash-flow discounting for EVE, twelve-month NII simulation, Basel IRRBB shock scenarios, block bootstrap of curve changes, expected shortfall, linear programming (Rockafellar–Uryasev), efficient-frontier analysis.

**Key output.** Repricing gaps, ΔEVE and ΔNII of both banks under every Basel shock; their EVE-at-risk and NII-at-risk; the optimal swap notionals along the frontier; and how far each hedge reduces one risk at the cost of the other.

---

## Why it matters

Both the Colombian banking system and a stylised UK bank fail the Basel outlier test unhedged (worst ΔEVE −53% and −18% of equity), because long fixed-rate assets are funded with deposits that reprice within a year. An expected-shortfall linear programme over 5,000 historical curve scenarios shows that in pesos, protecting value means paying fixed for ten years and raises income risk from 1.9% to 4.5% of equity, while a single five-year duration hedge is worse on both counts; in sterling, hedges at one, three and five years cut both risks at once.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY` in `.env` (required by the shared setup cell; the data themselves need no key).
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 2 minutes).

## Data sources

| Data | Source |
|---|---|
| CUIF supervisory accounts (Superintendencia Financiera via datos.gov.co) | https://www.datos.gov.co/d/mxk5-ce6w |
| IBR and TES zero-coupon rates (Banco de la República statistics service) | https://suameca.banrep.gov.co/estadisticas-economicas/ |
| SONIA OIS curve (Bank of England) | https://www.bankofengland.co.uk/statistics/yield-curves |

## Outputs (`outputs/`)

- `01_hedge_frontier.png`
- `basel_shocks_unhedged.csv`
- `dashboard.html`
- `dashboard.png`
- `efficient_frontier.csv`
- `hedges_compared.csv`
- `historical_risk_unhedged.csv`
- `repricing_gaps.csv`

## Key assumptions

- Colombian balance sheet = all banks, latest month; repricing profiles are assumptions (behavioural core deposits up to five years); the UK bank is stylised (£100 billion).
- Basel shocks: sterling 250/300/150 bp (parallel/short/long), peso 400/500/300 bp; historical scenarios = 12-month sums of monthly curve changes since 2016 in 3-month blocks.
- Hedges: receive- or pay-fixed OIS at 1, 2, 3, 5 and 10 years, single-curve, 1 bp a year cost, gross notional up to three times equity; ES at 95%.

## Suggested commit plan

1. `irrbb-hedge-frontier: add supervisory balance sheet, peso and SONIA curves`
2. `irrbb-hedge-frontier: add repricing profiles, gaps and Basel shock results`
3. `irrbb-hedge-frontier: add historical scenarios and expected-shortfall hedge optimisation`
4. `irrbb-hedge-frontier: add the efficient frontier and hedge comparison`
5. `irrbb-hedge-frontier: add charts, dashboard and narrative`

## References

- Basel Committee on Banking Supervision. (2016). *Standards: Interest rate risk in the banking book*. Bank for International Settlements. https://www.bis.org/bcbs/publ/d368.htm
- Bessis, J. (2015). *Risk management in banking* (4th ed.). Wiley.
- Rockafellar, R. T., & Uryasev, S. (2000). Optimization of conditional value-at-risk. *Journal of Risk*, 2(3), 21–41. https://doi.org/10.21314/JOR.2000.038
- Rockafellar, R. T., & Uryasev, S. (2002). Conditional value-at-risk for general loss distributions. *Journal of Banking & Finance*, 26(7), 1443–1471. https://doi.org/10.1016/S0378-4266(02)00271-6
- Banco de la República. (2026). *Portal de estadísticas económicas* [Data: IBR and TES zero-coupon rates]. https://suameca.banrep.gov.co/estadisticas-economicas/
- Bank of England. (2026). *Yield curves* [Data: OIS (SONIA) curve]. https://www.bankofengland.co.uk/statistics/yield-curves
- Superintendencia Financiera de Colombia. (2026). *Información financiera con fines de supervisión – CUIF por moneda* [Data set]. datos.gov.co. https://www.datos.gov.co
