# Pre-Trade Incremental PFE & Limit Utilization

Before a trader can add a swap with a bank, credit has to say yes, and the answer is needed in seconds, not after an overnight simulation. The right question is not how risky the new trade is on its own, but what it does to everything already on the books with that bank. This notebook builds that pre-trade check with a fast model and a statistical guarantee on how often it can be wrong.

**What it does.** It builds the pre-trade credit check a counterparty-risk officer signs off. For a proposed swap it estimates the *incremental* PFE on the bank's netting set in milliseconds, decides whether the trade fits within the limit, and sends it to auto-approval, a full simulation or the credit officer.

Limits, trades and decisions live in SQL tables.

**Data.** Today's SOFR curve and Treasury volatility (U.S. Treasury, FRED), a reference book of SOFR swaps with five banks and their limits, and 4,000 simulated trade requests (synthetic).

**Methods.** Hull–White Monte Carlo with exact incremental revaluation, a LightGBM regression of incremental peak PFE with netting-set features, and split-conformal upper bounds that guarantee the false-approval rate. DuckDB holds the limit database, the utilisation report and the decision log.

**Key output.** A utilisation and headroom report, the decision rule's false-approval and escalation rates compared with the naive stand-alone add-on rule, and a pre-trade dashboard.

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

## References

### Finance and regulation

- Gregory, J. (2020). *The xVA challenge: Counterparty risk, funding, collateral, capital and initial margin* (4th ed.). Wiley. https://doi.org/10.1002/9781119508991
- Basel Committee on Banking Supervision. (2014). *The standardised approach for measuring counterparty credit risk exposures*. Bank for International Settlements. https://www.bis.org/publ/bcbs279.htm
- Hull, J., & White, A. (1990). Pricing interest-rate-derivative securities. *The Review of Financial Studies, 3*(4), 573–592. https://doi.org/10.1093/rfs/3.4.573
- Cesari, G., Aquilina, J., Charpillon, N., Filipović, Z., Lee, G., & Manda, I. (2009). *Modelling, pricing, and hedging counterparty credit exposure: A technical guide*. Springer. https://doi.org/10.1007/978-3-642-04454-0

### Machine learning and deep learning

- Lei, J., G'Sell, M., Rinaldo, A., Tibshirani, R. J., & Wasserman, L. (2018). Distribution-free predictive inference for regression. *Journal of the American Statistical Association, 113*(523), 1094–1111. https://doi.org/10.1080/01621459.2017.1307116
- Vovk, V., Gammerman, A., & Shafer, G. (2005). *Algorithmic learning in a random world*. Springer. https://doi.org/10.1007/b106715
- Ke, G., Meng, Q., Finley, T., Wang, T., Chen, W., Ma, W., Ye, Q., & Liu, T.-Y. (2017). LightGBM: A highly efficient gradient boosting decision tree. *Advances in Neural Information Processing Systems, 30*. https://proceedings.neurips.cc/paper/2017/hash/6449f44a102fde848669bdd9eb6b76fa-Abstract.html
- Raasveldt, M., & Mühleisen, H. (2019). DuckDB: An embeddable analytical database. In *Proceedings of the 2019 International Conference on Management of Data*. https://doi.org/10.1145/3299869.3320212
