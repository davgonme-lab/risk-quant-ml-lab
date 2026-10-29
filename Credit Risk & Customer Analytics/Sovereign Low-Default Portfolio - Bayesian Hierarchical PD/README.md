# Sovereign Low-Default Portfolio: Bayesian Hierarchical PD

Sovereign loans dominate a development bank's balance sheet, yet countries rarely default, and some regions almost never. That leaves a PD model with very little to learn from, and makes it essential to say how uncertain each estimate is. This notebook estimates sovereign default probabilities with a Bayesian model that borrows strength across regions and reports a credible interval for every country.

**What it does.** It estimates the one-year probability that a sovereign enters default, for every country with World Bank data, from macro-financial fundamentals and global conditions.

A Bayesian hierarchical logistic model (regional intercepts with partial pooling, in PyMC) is compared with a pooled logit and LightGBM, out of time on 2017–2025. Posterior credible intervals show how uncertain each country's PD is.

The low-default problem of advanced economies is handled by pooling and by the Pluto–Tasche upper bound.

**Data.** The Bank of Canada–Bank of England Sovereign Default Database (2026 edition: debt in default by country and creditor, 1960–2025), World Bank World Development Indicators (API), and the U.S. 10-year Treasury yield and VIX (FRED).

**Methods.** A default-onset definition with a materiality threshold, a panel with lagged covariates, pooled logistic regression, a hierarchical Bayesian logit with non-centred regional effects (NUTS) and LightGBM.

Models are compared out of time on ROC-AUC, Brier score and calibration, with posterior predictive PD intervals and Pluto–Tasche most-prudent estimates.

**Key output.** Out-of-time accuracy by model, the drivers of sovereign default, regional effects, 2026 PDs with 90% credible intervals for the riskiest sovereigns and for Latin America, and low-default bounds.

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

## References

### Finance and regulation

- Pluto, K., & Tasche, D. (2005). Estimating probabilities of default for low default portfolios. *Risk, 18*(8), 76–82. https://arxiv.org/abs/cond-mat/0411699
- Manasse, P., & Roubini, N. (2009). "Rules of thumb" for sovereign debt crises. *Journal of International Economics, 78*(2), 192–205. https://doi.org/10.1016/j.jinteco.2008.12.002
- Reinhart, C. M., & Rogoff, K. S. (2009). *This time is different: Eight centuries of financial folly*. Princeton University Press. https://doi.org/10.1515/9781400831722
- Kraay, A., & Nehru, V. (2006). When is external debt sustainable? *The World Bank Economic Review, 20*(3), 341–365. https://doi.org/10.1093/wber/lhl006
- Basel Committee on Banking Supervision. (2005). *Validation of low-default portfolios in the Basel II framework* (Basel Committee Newsletter No. 6). Bank for International Settlements. https://www.bis.org/publ/bcbs_nl6.htm

### Machine learning and deep learning

- Gelman, A., & Hill, J. (2007). *Data analysis using regression and multilevel/hierarchical models*. Cambridge University Press. https://doi.org/10.1017/CBO9780511790942
- Hoffman, M. D., & Gelman, A. (2014). The No-U-Turn sampler: Adaptively setting path lengths in Hamiltonian Monte Carlo. *Journal of Machine Learning Research, 15*, 1593–1623. https://jmlr.org/papers/v15/hoffman14a.html
- Abril-Pla, O., Andreani, V., Carroll, C., Dong, L., Fonnesbeck, C. J., Kochurov, M., … Zinkov, R. (2023). PyMC: A modern, and comprehensive probabilistic programming framework in Python. *PeerJ Computer Science, 9*, e1516. https://doi.org/10.7717/peerj-cs.1516
- Betancourt, M., & Girolami, M. (2015). Hamiltonian Monte Carlo for hierarchical models. In *Current trends in Bayesian methodology with applications*. CRC Press. https://arxiv.org/abs/1312.0906
