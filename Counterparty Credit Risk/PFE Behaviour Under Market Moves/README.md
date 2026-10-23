# PFE Behaviour Under Market Moves

**What it does:** shows how the potential future exposure of a reference book of SOFR swaps with five banks, and the utilisation of each bank's credit limit, respond to moves in rate level, curve slope and rate volatility. A Gaussian-process surrogate of the exposure engine makes it fast enough to replay twenty years of real market moves and named stress episodes.
**Data:** today's SOFR curve and Treasury volatility (U.S. Treasury, FRED); daily 2- and 10-year Treasury yields since 2002 (FRED); the ICE BofAML MOVE index of implied Treasury volatility (Yahoo Finance).
**Methods:** Hull–White Monte Carlo revaluation under shocked curves and volatilities (common random numbers), a Sobol design of 64 scenarios, Gaussian-process regression with ARD kernels per counterparty (validated out of sample), historical 3-month scenario replay, and named stress tests.
**Key output:** PFE sensitivities to level, slope and volatility; the probability that each bank's limit is breached after a 3-month market move; a stress-test table; and a limit-monitoring dashboard.

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
