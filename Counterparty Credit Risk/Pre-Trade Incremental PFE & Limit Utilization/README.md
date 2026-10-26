# Pre-Trade Incremental PFE & Limit Utilization

**What it does:** builds the pre-trade credit check a counterparty-risk officer signs off. For a proposed swap it estimates the *incremental* PFE on the bank's netting set in milliseconds, decides whether the trade fits within the limit, and routes it to auto-approval, a full simulation or the credit officer. Limits, trades and decisions live in SQL tables.
**Data:** today's SOFR curve and Treasury volatility (U.S. Treasury, FRED); a reference book of SOFR swaps with five banks and limits; 4,000 simulated trade requests (synthetic).
**Methods:** Hull–White Monte Carlo with exact incremental revaluation, LightGBM regression of incremental peak PFE with netting-set features, split-conformal upper bounds for a guaranteed false-approval rate, and DuckDB for the limit database, the utilisation report and the decision log.
**Key output:** a utilisation and headroom report, the decision rule's false-approval and escalation rates against the naive stand-alone add-on rule, and a pre-trade dashboard.

---

## Why it matters

Every new trade needs a credit check against the netting set, not against the trade alone. The notebook builds the full pre-trade workflow: SQL limit tables, an instant LightGBM estimate of incremental PFE, and a conformal upper bound that guarantees the false-approval rate. Compared with the naive stand-alone add-on, it cuts escalations while keeping false approvals at zero.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 1.5 minutes).

## Data sources

| Data | Source |
|---|---|
| Treasury par yield curve | https://home.treasury.gov/resource-center/data-chart-center/interest-rates |
| SOFR, Treasury CMT yields (`DGS1` … `DGS30`) | https://fred.stlouisfed.org |

## Outputs (`outputs/`)

- `01_standalone_vs_incremental.png`
- `02_model_accuracy_and_rules.png`
- `dashboard.html`
- `dashboard.png`
- `decision_rules_comparison.csv`
- `limit_utilisation_report.csv`
- `pretrade_decision_log.csv`

## Key assumptions

- Existing reference swap book and limits (fixed seed); 6,000 synthetic spot-starting SOFR swap requests.
- Limit on netting-set peak PFE (97.5%); a trade that does not increase peak PFE is acceptable even for a bank in breach.
- Split-conformal bound normalised by stand-alone PFE, α = 5%; early stopping uses a slice of the training set so calibration stays clean.

## Suggested commit plan

1. `add README and pre-trade workflow`
2. `DuckDB limit, exposure and trade tables`
3. `exact incremental PFE for simulated requests`
4. `LightGBM model and conformal upper bound`
5. `decision rules, SQL decision log, dashboard and executed outputs`
