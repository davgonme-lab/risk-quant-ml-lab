# Netting Sets & CSA Collateral Modeling

A collateral agreement looks like a promise that exposure will be covered, but the details decide how much risk is really left. A threshold leaves an unsecured layer, a minimum transfer amount adds another, and the days it takes to close out a defaulted bank leave room for the market to move. This notebook measures what each bank's collateral terms actually remove, and what they cost the treasury in collateral it has to post.

**What it does.** It takes an MDB-style hedge book of SOFR swaps with five banks and measures how much counterparty exposure each bank's ISDA Credit Support Annex (CSA) removes. It covers thresholds, minimum transfer amounts, independent amounts and the margin period of risk, and also tracks the collateral the MDB itself has to post.

**Data.** Today's SOFR curve and three years of Treasury volatility (U.S. Treasury and FRED). The hedge book and the CSA terms are synthetic but realistic.

**Methods.** Hull–White Monte Carlo with exact swap revaluation on a grid that includes the margin-period lag dates, and the classical collateral model (collateral is called on the value one MPoR earlier).

On top of that sits an XGBoost surrogate trained on 2,500 simulated netting-set and CSA designs, explained with SHAP.

**Key output.** Collateralised and uncollateralised EE, PFE and EAD by bank, sensitivity to MPoR and threshold, the collateral the MDB may have to post (a liquidity need), and a CSA negotiation tool that ranks which terms buy the most exposure reduction.

---

## Why it matters

A CSA decides how much of the gross exposure is really at risk. This notebook prices each CSA term, measures the collateral the MDB itself has to post under two-way CSAs (a liquidity need), and gives the credit officer an XGBoost + SHAP negotiation tool that ranks which terms buy the most exposure reduction.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 1.5 minutes).

## Data sources

| Data | Source |
|---|---|
| Treasury par yield curve | https://home.treasury.gov/resource-center/data-chart-center/interest-rates |
| SOFR, Treasury CMT yields (`DGS1` … `DGS30`) | https://fred.stlouisfed.org |

## Outputs (`outputs/`)

- `01_csa_mechanics_one_path.png`
- `02_profiles_with_and_without_csa.png`
- `03_mpor_and_threshold_sensitivity.png`
- `04_collateral_posted_liquidity.png`
- `05_xgboost_shap_csa_terms.png`
- `csa_design_training_set.csv`
- `csa_exposure_summary.csv`
- `csa_negotiation_options.csv`

## Key assumptions

- Hedge book and CSA terms are synthetic but follow MDB practice: issuance hedges receive fixed, asset swaps pay fixed.
- Classical+ collateral model: collateral reflects the value one MPoR earlier, and trade cash flows are paid during the MPoR; MTA is treated as an extra threshold.
- Variation margin is cash, not segregated, with no haircut.
- The surrogate is trained on 2,500 random netting-set/CSA designs valued on 1,500 paths each.

## Suggested commit plan

1. `add README and CSA mechanics`
2. `Hull–White engine with margin-period lag dates`
3. `MDB hedge book and CSA terms`
4. `collateralised exposure, MPoR and threshold sensitivity`
5. `collateral posting (liquidity) view`
6. `XGBoost + SHAP CSA negotiation surrogate with executed outputs`

## References

### Finance and regulation

- Andersen, L., Pykhtin, M., & Sokol, A. (2017). Rethinking the margin period of risk. *Journal of Credit Risk, 13*(1), 1–45. https://doi.org/10.21314/JCR.2016.218
- Gregory, J. (2020). *The xVA challenge: Counterparty risk, funding, collateral, capital and initial margin* (4th ed.). Wiley. https://doi.org/10.1002/9781119508991
- Basel Committee on Banking Supervision. (2014). *The standardised approach for measuring counterparty credit risk exposures*. Bank for International Settlements. https://www.bis.org/publ/bcbs279.htm
- Basel Committee on Banking Supervision & International Organization of Securities Commissions. (2020). *Margin requirements for non-centrally cleared derivatives*. Bank for International Settlements. https://www.bis.org/bcbs/publ/d499.htm
- Hull, J., & White, A. (1990). Pricing interest-rate-derivative securities. *The Review of Financial Studies, 3*(4), 573–592. https://doi.org/10.1093/rfs/3.4.573
- Brigo, D., Morini, M., & Pallavicini, A. (2013). *Counterparty credit risk, collateral and funding: With pricing cases for all asset classes*. Wiley. https://doi.org/10.1002/9781118818589

### Machine learning and deep learning

- Chen, T., & Guestrin, C. (2016). XGBoost: A scalable tree boosting system. In *Proceedings of the 22nd ACM SIGKDD International Conference on Knowledge Discovery and Data Mining*. https://doi.org/10.1145/2939672.2939785
- Lundberg, S. M., & Lee, S.-I. (2017). A unified approach to interpreting model predictions. *Advances in Neural Information Processing Systems, 30*. https://arxiv.org/abs/1705.07874
- Lundberg, S. M., Erion, G., Chen, H., DeGrave, A., Prutkin, J. M., Nair, B., … Lee, S.-I. (2020). From local explanations to global understanding with explainable AI for trees. *Nature Machine Intelligence, 2*(1), 56–67. https://doi.org/10.1038/s42256-019-0138-9
