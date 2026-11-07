# A Commercial Real Estate Cover Pool: Loan-Level ML Distress Model, VAE Macro Scenarios and Required Overcollateralisation

Commercial mortgages are repaid from rents and usually have to be refinanced at maturity, which is exactly what failed for many office loans when rates rose in 2023. When such loans back a covered bond, the issuer has to hold extra collateral to absorb that risk. This notebook builds a cover pool from real loans and works out how much extra collateral it needs.

**What it does.** It builds a hypothetical covered bond cover pool from about 540 real U.S. commercial mortgages and stress-tests it. The loans come from the current loan-level tapes (SEC Form ABS-EE) of fifteen 2024 conduit CMBS trusts.

**Distress model.** A LightGBM model with monotonic constraints is trained on nine years of quarterly loan tapes from fourteen 2016–2017 conduit trusts. It predicts the 12-month probability that a performing loan becomes **distressed** (60+ days delinquent, non-performing at maturity, transferred to special servicing or liquidated).

Its features are DSCR, NOI and occupancy trends, marked-to-market LTV, maturity, property type and the macro state. The model is validated **out of time** on 2023–2025, the office and higher-rates stress.

**Macro scenarios.** A Keras **variational autoencoder** learns the joint one-year moves of CRE prices, Treasury yields, corporate spreads, unemployment and bank CRE delinquencies (FRED, 1991–2026) and generates thousands of coherent scenarios.

**Stress test.** Each scenario is pushed through the loans:

- property values and NOI are shocked;
- term-default probabilities come from the model;
- loans maturing within the horizon face a **refinancing test**, the classic covered-bond risk.

The output is a three-year loss distribution and the **overcollateralisation the pool needs** at each confidence level. It is reported for the full loans and for a Pfandbrief-style pool that only counts each loan up to 60% of the property's lending value.

**Data.** SEC EDGAR ABS-EE (EX-102 CMBS asset data) and FRED (CRE price index, 10-year Treasury, Baa spread, unemployment, CRE delinquency rate).

**Methods.** A loan-quarter panel, LightGBM with monotonic constraints, a logistic regression benchmark, out-of-time validation, SHAP, a variational autoencoder (Keras 3) and a Monte Carlo credit-loss simulation.

---

## Why it matters

Several covered bond frameworks allow commercial mortgages in the cover pool, and CRE is where refinancing risk bites hardest. Using the public SEC loan tapes of US conduit CMBS, a monotonic LightGBM distress model is trained on nine years of quarterly data (in-regime AUC 0.89) and honestly shown to degrade out of time (0.60) when the 2023 rates-and-office wave arrived. A Keras VAE generates macro scenarios with realistic joint tails, and a stress engine with a refinancing test turns them into a three-year loss distribution for a 538-loan, $12.8bn pool: required OC is 3.7% at 99% and 6.8% at 99.5%, while a Pfandbrief-style 60% lending-value cap cuts the eligible pool's 99.5% loss to 0.2%.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY` and `SEC_USER_AGENT`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 25 minutes the first time (≈500 loan-tape files from EDGAR), about 5 minutes afterwards).

## Data sources

| Data | Source |
|---|---|
| SEC EDGAR ABS-EE filings (EX-102 CMBS asset data) of 2016–2017 and 2024 conduit trusts | https://www.sec.gov/edgar/search/ |
| Commercial real estate price index (BOGZ1FL075035503Q), 10-year Treasury, Baa spread, unemployment, CRE delinquency rate | https://fred.stlouisfed.org |

## Outputs (`outputs/`)

- `01_cre_cover_pool_stress.png`
- `cover_pool_by_property_type.csv`
- `cover_pool_loss_and_required_oc.csv`
- `dashboard.html`
- `dashboard.png`
- `distress_model_calibration.csv`
- `distress_model_out_of_time.csv`
- `distress_shap_importance.csv`
- `macro_scenario_tails.csv`
- `vae_macro_scenarios.csv`

## Key assumptions

- Distress = 60+ days delinquent, non-performing matured balloon, active special-servicing workout or liquidation, within 12 months.
- Whole-loan balance of pari passu notes inferred from whole-loan debt service; implied securitisation LTVs above 85% reset to 65%.
- Property-type value betas to the CRE index and NOI sensitivities to unemployment are stated assumptions; liquidation costs 25%.
- Refinancing test at maturity: interest-only DSCR ≥ 1.25 at the 10-year yield + 2% and LTV ≤ 75%; failure means default.
- Eligible amount = 60% of a lending value of 85% of market value; defaults independent given the macro scenario.

## Suggested commit plan

1. `cre-cover-pool: add CMBS loan-tape loader and loan-quarter distress panel`
2. `cre-cover-pool: add monotonic LightGBM distress model with out-of-time test`
3. `cre-cover-pool: add VAE macro scenarios and cover pool stress with required OC`

## References

### Finance and regulation

- European Parliament & Council of the European Union. (2019). *Directive (EU) 2019/2162 on the issue of covered bonds and covered bond public supervision*. https://eur-lex.europa.eu/eli/dir/2019/2162/oj
- Black, L., Chu, C. S., Cohen, A., & Nichols, J. B. (2012). Differences across originators in CMBS loan underwriting. *Journal of Financial Services Research, 42*(1–2), 115–134. https://doi.org/10.1007/s10693-011-0120-0
- Ambrose, B. W., & Sanders, A. B. (2003). Commercial mortgage-backed securities: Prepayment and default. *The Journal of Real Estate Finance and Economics, 26*(2–3), 179–196. https://doi.org/10.1023/A:1022978708728
- Packer, F., Stever, R., & Upper, C. (2007). The covered bond market. *BIS Quarterly Review*, September, 43–55. https://www.bis.org/publ/qtrpdf/r_qt0709f.htm

### Machine learning and deep learning

- Kingma, D. P., & Welling, M. (2014). Auto-encoding variational Bayes. In *Proceedings of the 2nd International Conference on Learning Representations*. https://arxiv.org/abs/1312.6114
- Ke, G., Meng, Q., Finley, T., Wang, T., Chen, W., Ma, W., Ye, Q., & Liu, T.-Y. (2017). LightGBM: A highly efficient gradient boosting decision tree. *Advances in Neural Information Processing Systems, 30*. https://proceedings.neurips.cc/paper/2017/hash/6449f44a102fde848669bdd9eb6b76fa-Abstract.html
- Lundberg, S. M., & Lee, S.-I. (2017). A unified approach to interpreting model predictions. *Advances in Neural Information Processing Systems, 30*. https://arxiv.org/abs/1705.07874
