# Sovereign Low-Default Portfolio: Bayesian Hierarchical PD

**What it does:** estimates one-year probabilities that a sovereign enters default, for every country with World Bank data, from macro-financial fundamentals and global conditions. A Bayesian hierarchical logistic model (regional intercepts with partial pooling, in PyMC) is compared with a pooled logit and LightGBM, out of time on 2017–2025; posterior credible intervals show how uncertain each country's PD is, and the low-default problem of advanced economies is handled by pooling and by the Pluto–Tasche upper bound.
**Data:** the Bank of Canada–Bank of England Sovereign Default Database (2026 edition: debt in default by country and creditor, 1960–2025); World Bank World Development Indicators (API); U.S. 10-year Treasury yield and VIX (FRED).
**Methods:** default-onset definition with a materiality threshold; panel construction with lagged covariates; pooled logistic regression; hierarchical Bayesian logit with non-centred regional effects (NUTS); LightGBM; ROC-AUC, Brier and calibration out of time; posterior predictive PD intervals; Pluto–Tasche most-prudent estimation.
**Key output:** out-of-time accuracy by model, the drivers of sovereign default, regional effects, 2026 PDs with 90% credible intervals for the riskiest sovereigns and for Latin America, and low-default bounds.

---

## Why it matters

Sovereign and sovereign-guaranteed loans dominate a development bank's book, yet sovereign defaults are rare and uneven across regions. A hierarchical Bayesian logit on the Bank of Canada–Bank of England default database and World Bank fundamentals reaches an out-of-time AUC of 0.79 (2017–2025), pools regional effects so that regions with one or no defaults still get sensible estimates, and gives every 2026 PD a credible interval (Colombia 2.2%, 1.3–3.5%). For advanced economies, the Pluto–Tasche bound gives a prudent ceiling of 1.0–1.3%.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY` (World Bank and Bank of Canada need no key).
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 2 minutes (two PyMC fits, 4 chains each)).

## Data sources

| Data | Source |
|---|---|
| BoC–BoE Sovereign Default Database, 2026 edition | https://www.bankofcanada.ca/2026/10/staff-analytical-paper-2026-48/ |
| World Development Indicators | World Bank API (`api.worldbank.org`) |
| U.S. 10-year Treasury yield, VIX | https://fred.stlouisfed.org |

## Outputs (`outputs/`)

- `01_onsets_drivers_regions_pds.png`
- `hierarchical_coefficients.csv`
- `low_default_bounds.csv`
- `out_of_time_evaluation.csv`
- `regional_effects.csv`
- `sovereign_pd_2026.csv`

## Key assumptions

- In default = debt in default ≥ 1% of GDP; onset = first year in default; covariates at t predict onset in t+1 for countries not in default at t.
- Train on onsets 2000–2016, test 2017–2025; median imputation with missing flags; standardised design.
- Hierarchical logit with non-centred regional intercepts, N(0,1) slopes, HalfNormal(1) regional scale; NUTS, 4 chains × 1,000 draws.

## Suggested commit plan

1. `add README and sovereign-PD framework`
2. `BoC–BoE, World Bank and FRED ETL with country matching`
3. `default-onset definition and panel`
4. `pooled logit, hierarchical Bayesian model and LightGBM out of time`
5. `2026 PDs with credible intervals, Pluto–Tasche and executed outputs`
