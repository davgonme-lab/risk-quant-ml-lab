# Pricing Partial Credit Guarantees for Blended Finance: ML Default Curves and a Keras Surrogate of the Monte Carlo Pricer

When a development bank guarantees part of a country's loan, the country borrows more cheaply and for longer, and investors who could not take the full risk can come in. The hard part is the fee: what the market would charge, what the guarantee really costs the development bank, and how much subsidy lies in the gap. This notebook builds a pricer for both common guarantee structures and a fast surrogate of it.

**What it does.** It prices the **partial credit guarantees (PCGs)** that multilateral development banks (MDBs) give on loans and bonds of emerging-market sovereigns and state-owned borrowers. A Monte Carlo pricer covers two structures:

- **pari-passu** guarantees of a share of every loss;
- **first-loss** guarantees capped at a share of the outstanding amount.

The pricer has stochastic default intensity, stochastic recovery, grace periods and amortisation. It returns:

- the **market-consistent fee**;
- the **MDB cost-based fee** (expected loss with preferred-creditor recovery, plus a capital charge);
- the **spread compression** the borrower obtains, and the **subsidy** embedded in charging the MDB fee.

**Machine learning, twice.**

1. A **LightGBM** model maps World Bank fundamentals to sovereign spreads, so guarantees can be priced for countries with no market bonds (most IDA countries).
2. A **Keras 3 neural network (torch backend)** learns the Monte Carlo pricer. It prices every country and structure in milliseconds, and **SHAP** explains which terms drive the fee.

**Data.** iShares J.P. Morgan EM USD sovereign bonds (EMB) for market spreads and term structures, the U.S. Treasury curve, and World Bank WDI and WGI fundamentals with the income classification.

**Key output.** Fee grids by country, structure and tenor, the borrower's saving, the subsidy element, and a surrogate that reproduces the pricer within a few basis points at a fraction of the cost.

---

## Why it matters

MDB partial credit guarantees are priced on two bases at once: what the market would charge for the risk, and what the MDB expects to lose given preferred-creditor status; the gap is a subsidy that concessional-finance rules require to be measured. A calibrated Monte Carlo pricer with wrong-way recovery gives, for a 12-year Colombian loan, a market fee of about 206 bp (pari-passu) or 327 bp (20% first-loss) against an MDB cost-based fee of 88 and 161 bp, a subsidy of about 3% of notional. LightGBM spreads from World Bank fundamentals extend pricing to 71 countries without bonds, with honest 80% bands, and a Keras 3 surrogate reproduces the pricer within 2.5 bp at 10,000 times the speed, explained with SHAP.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 11 minutes: 16,000 Monte Carlo term sheets train the surrogate).

## Data sources

| Data | Source |
|---|---|
| iShares J.P. Morgan USD EM Bond ETF (EMB) holdings | https://www.ishares.com/us/products/239572/ |
| U.S. Treasury par yield curve | https://home.treasury.gov/resource-center/data-chart-center/interest-rates |
| World Bank WDI and Worldwide Governance Indicators, income and lending classification | https://api.worldbank.org/v2 |

## Outputs (`outputs/`)

- `01_pcg_pricing_surrogate.png`
- `fee_grid_all_countries.csv`
- `market_vs_mdb_fee_subsidy.csv`
- `mc_convergence.csv`
- `pcg_fee_surrogate.keras`
- `pricing_examples.csv`
- `sensitivities.csv`
- `sovereign_curves_market.csv`
- `sovereign_spread_ml_proxies.csv`
- `spread_model_cv.csv`
- `surrogate_accuracy_speed.csv`
- `surrogate_shap_importance.csv`

## Key assumptions

- Credit triangle with 40% market recovery; pooled term-structure slope across countries.
- Lognormal intensity shock re-calibrated date by date to the market curve; recovery falls 10 pp per unit of log intensity (wrong-way recovery).
- MDB fee = expected loss with physical intensities (risk-neutral / 2.5) and 70% preferred-creditor recovery, plus 10% cost of capital on Basel IRB unexpected loss.
- Guarantor default-free; no correlation between guarantees (portfolio effects belong in a concentration-risk model).
- ML proxies trained on non-distressed sovereigns (spread below 2,000 bp).

## Suggested commit plan

1. `sovereign curves from EMB`
2. `LightGBM spreads from fundamentals and proxies`
3. `Monte Carlo PCG pricer and MDB fee`
4. `convergence and sensitivities`
5. `Keras surrogate and SHAP`
6. `fee grids, subsidy, charts and narrative`

## References

### Finance and regulation

- Humphrey, C. (2017). He who pays the piper calls the tune: Credit rating agencies and multilateral development banks. *The Review of International Organizations, 12*(2), 281–306. https://doi.org/10.1007/s11558-017-9271-6
- Duffie, D., & Singleton, K. J. (1999). Modeling term structures of defaultable bonds. *The Review of Financial Studies, 12*(4), 687–720. https://doi.org/10.1093/rfs/12.4.687
- Longstaff, F. A., Pan, J., Pedersen, L. H., & Singleton, K. J. (2011). How sovereign is sovereign credit risk? *American Economic Journal: Macroeconomics, 3*(2), 75–103. https://doi.org/10.1257/mac.3.2.75
- Merton, R. C. (1977). An analytic derivation of the cost of deposit insurance and loan guarantees: An application of modern option pricing theory. *Journal of Banking & Finance, 1*(1), 3–11. https://doi.org/10.1016/0378-4266(77)90015-2

### Machine learning and deep learning

- Ke, G., Meng, Q., Finley, T., Wang, T., Chen, W., Ma, W., Ye, Q., & Liu, T.-Y. (2017). LightGBM: A highly efficient gradient boosting decision tree. *Advances in Neural Information Processing Systems, 30*. https://proceedings.neurips.cc/paper/2017/hash/6449f44a102fde848669bdd9eb6b76fa-Abstract.html
- Lundberg, S. M., & Lee, S.-I. (2017). A unified approach to interpreting model predictions. *Advances in Neural Information Processing Systems, 30*. https://arxiv.org/abs/1705.07874
- Ferguson, R., & Green, A. (2018). Deeply learning derivatives. *arXiv*. https://arxiv.org/abs/1809.02233
- Glasserman, P. (2004). *Monte Carlo methods in financial engineering*. Springer. https://doi.org/10.1007/978-0-387-21617-1
