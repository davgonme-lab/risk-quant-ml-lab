# PFE Behaviour Under Market Moves

Credit limits are usually breached without a single new trade: the market moves, and the existing swaps become worth more. A credit officer therefore needs to know which limits are fragile before the move happens. This notebook measures how each bank's exposure reacts to rates, curve slope and volatility, and replays twenty years of real market moves against today's book.

**What it does.** It shows how the potential future exposure of a reference book of SOFR swaps with five banks, and the use of each bank's credit limit, respond to moves in rate level, curve slope and rate volatility.

A Gaussian-process surrogate of the exposure engine makes this fast enough to replay twenty years of real market moves and named stress episodes.

**Data.** Today's SOFR curve and Treasury volatility (U.S. Treasury, FRED), daily 2- and 10-year Treasury yields since 2002 (FRED), and the ICE BofAML MOVE index of implied Treasury volatility (Yahoo Finance).

**Methods.** Hull–White Monte Carlo revaluation under shocked curves and volatilities (with common random numbers), a Sobol design of 64 scenarios, and Gaussian-process regression with ARD kernels for each counterparty, validated out of sample. The scenarios include a historical 3-month replay and named stress tests.

**Key output.** PFE sensitivities to level, slope and volatility, the probability that each bank's limit is breached after a 3-month market move, a stress-test table and a limit-monitoring dashboard.

---

## Why it matters

Limits are breached because markets move, often without a single new trade. A Gaussian-process surrogate of the exposure engine gives level, slope and volatility sensitivities, the probability of a breach after a historical 3-month move, and named stress tests in seconds, so the credit officer can act before the breach.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 2 minutes).

## Data sources

| Data | Source |
|---|---|
| Treasury par yield curve | https://home.treasury.gov/resource-center/data-chart-center/interest-rates |
| SOFR, Treasury CMT yields (`DGS1` … `DGS30`) | https://fred.stlouisfed.org |
| 2- and 10-year Treasury yields since 2002 (`DGS2`, `DGS10`) | https://fred.stlouisfed.org |
| ICE BofAML MOVE index (`^MOVE`) | Yahoo Finance via `yfinance` |

## Outputs (`outputs/`)

- `01_pfe_sensitivity_curves.png`
- `02_historical_replay.png`
- `dashboard.html`
- `dashboard.png`
- `gp_surrogate_scores.csv`
- `historical_replay_utilisation.csv`
- `pfe_sensitivities.csv`
- `stress_tests_engine_vs_gp.csv`

## Key assumptions

- Reference swap book and limits generated with a fixed seed; scenarios are instantaneous shocks to today's market (no ageing).
- Scenario = parallel shift, 2s10s slope change and a volatility multiplier from the MOVE ratio.
- GP trained on 64 Sobol scenarios (2,000 paths each, common random numbers); historical scenarios outside the box are clipped and counted, and named stresses outside it use the engine only.

## Suggested commit plan

1. `add README and scenario parameterisation`
2. `exposure engine as a function of the market`
3. `Sobol design and Gaussian-process surrogates`
4. `sensitivities and historical 3-month replay`
5. `named stress tests, dashboard and executed outputs`

## References

### Finance and regulation

- Gregory, J. (2020). *The xVA challenge: Counterparty risk, funding, collateral, capital and initial margin* (4th ed.). Wiley. https://doi.org/10.1002/9781119508991
- Basel Committee on Banking Supervision. (2018). *Stress testing principles*. Bank for International Settlements. https://www.bis.org/bcbs/publ/d450.htm
- Hull, J., & White, A. (1990). Pricing interest-rate-derivative securities. *The Review of Financial Studies, 3*(4), 573–592. https://doi.org/10.1093/rfs/3.4.573
- Glasserman, P. (2004). *Monte Carlo methods in financial engineering*. Springer. https://doi.org/10.1007/978-0-387-21617-1
- Cesari, G., Aquilina, J., Charpillon, N., Filipović, Z., Lee, G., & Manda, I. (2009). *Modelling, pricing, and hedging counterparty credit exposure: A technical guide*. Springer. https://doi.org/10.1007/978-3-642-04454-0

### Machine learning and deep learning

- Rasmussen, C. E., & Williams, C. K. I. (2006). *Gaussian processes for machine learning*. MIT Press. https://gaussianprocess.org/gpml/
- Sobol', I. M. (1967). On the distribution of points in a cube and the approximate evaluation of integrals. *USSR Computational Mathematics and Mathematical Physics, 7*(4), 86–112. https://doi.org/10.1016/0041-5553(67)90144-9
- Crépey, S., & Dixon, M. (2020). Gaussian process regression for derivative portfolio modeling and application to credit valuation adjustment computations. *Journal of Computational Finance, 24*(1), 47–81. https://doi.org/10.21314/JCF.2020.386
- Pedregosa, F., Varoquaux, G., Gramfort, A., Michel, V., Thirion, B., Grisel, O., … Duchesnay, É. (2011). Scikit-learn: Machine learning in Python. *Journal of Machine Learning Research, 12*, 2825–2830. https://jmlr.org/papers/v12/pedregosa11a.html
