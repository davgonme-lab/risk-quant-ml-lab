# Small-Business Lending with Public Credit Guarantees: Default Models for 900,000 SBA Loans, a Great-Recession Out-of-Time Test and the Economics of the Guarantee

Small firms create most jobs but struggle to borrow, because they have short histories and little collateral. Public credit guarantees fix part of that by having the government absorb part of the lender's loss. To run such a scheme, the guarantor needs to know how risky each loan is, how much it loses when a loan fails, and how much of that loss it is taking off the banks. This notebook answers those questions on the largest guarantee programme in the world.

**What it does.** It models the default risk of U.S. small-business loans backed by the Small Business Administration's 7(a) guarantee programme, the template for many development-bank SME guarantee facilities. The notebook:

- trains logistic regression, LightGBM and a Keras network with embeddings on loans approved in fiscal years 1990–2004;
- tests them out of time on 2005–2010 approvals, the vintages that went through the Great Recession;
- estimates loss given default from charged-off principal;
- splits expected losses between the bank and the government according to the guaranteed share, and computes the break-even loan spread with and without the guarantee.

**Data.** The SBA national 7(a) loan dataset: 899,164 loans approved 1962–2014 (Kaggle `mirbektoktogaraev/should-this-loan-be-approved-or-denied`; Li, Mickel and Taylor, 2018, *Journal of Statistics Education*).

**Methods.** Out-of-time validation by approval vintage, class-weighted LightGBM, entity embeddings for state and industry, calibration by vintage, LGD estimation, an expected-loss split with risk-based pricing, and gain importance.

**Key output.** AUC and calibration by model and vintage, how the models handled the crisis, a data-leakage audit of the loan term, LGD by loan size, and how much expected loss the guarantee moves from banks to the government, by industry.

---

## Why it matters

Most public models on the SBA 7(a) data report AUCs above 0.9 because they use the loan term, which this notebook shows is rewritten after default: 86% of repaid loans have whole-year terms against 9% of charged-off ones. Without it, a network with industry and state embeddings reaches an AUC of 0.68 out of time on the 2005–2010 vintages. The ranking held through the Great Recession, but PDs fitted on 1990–2004 under-predicted defaults by up to 2.9×. The guarantee absorbs 64% of expected loss and cuts break-even spreads from 230–744 bp to 87–276 bp.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`, `KAGGLE_API_TOKEN`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 2 minutes).

## Data sources

| Data | Source |
|---|---|
| SBA national 7(a) loans, Li, Mickel and Taylor (2018) (Kaggle) | https://www.kaggle.com/datasets/mirbektoktogaraev/should-this-loan-be-approved-or-denied |

## Outputs (`outputs/`)

- `01_sme_guarantees.png`
- `calibration_by_vintage.csv`
- `dashboard.html`
- `dashboard.png`
- `guarantee_economics_by_sector.csv`
- `lgd_by_loan_size.csv`
- `model_scores_out_of_time.csv`
- `term_leakage_check.csv`
- `vintages.csv`

## Key assumptions

- Train on approval years 1990–2004, test on 2005–2010; later vintages dropped (not yet matured).
- LGD = charged-off principal / amount disbursed, by size band and industry, from training charge-offs.
- Break-even spread = PD × LGD × (1 − guarantee) / average life, with PDs rescaled to each vintage's realised default rate.

## Suggested commit plan

1. `sme-credit-guarantees: add SBA loan cleaning, vintage split and term-leakage audit`
2. `sme-credit-guarantees: add logistic, LightGBM and Keras embedding default models with vintage calibration`
3. `sme-credit-guarantees: add LGD, guarantee loss split, break-even spreads and dashboard`

## References

### Finance and regulation

- Li, M., Mickel, A., & Taylor, S. (2018). "Should this loan be approved or denied?": A large dataset with class assignment guidelines. *Journal of Statistics Education, 26*(1), 55–66. https://doi.org/10.1080/10691898.2018.1434342
- Beck, T., Klapper, L. F., & Mendoza, J. C. (2010). The typology of partial credit guarantee funds around the world. *Journal of Financial Stability, 6*(1), 10–25. https://doi.org/10.1016/j.jfs.2008.12.003
- Honohan, P. (2010). Partial credit guarantees: Principles and practice. *Journal of Financial Stability, 6*(1), 1–9. https://doi.org/10.1016/j.jfs.2009.05.008
- Glennon, D., & Nigro, P. (2005). Measuring the default risk of small business loans: A survival analysis approach. *Journal of Money, Credit and Banking, 37*(5), 923–947. https://doi.org/10.1353/mcb.2005.0051
- Altman, E. I., & Sabato, G. (2007). Modelling credit risk for SMEs: Evidence from the U.S. market. *Abacus, 43*(3), 332–357. https://doi.org/10.1111/j.1467-6281.2007.00234.x

### Machine learning and deep learning

- Guo, C., & Berkhahn, F. (2016). Entity embeddings of categorical variables. *arXiv*. https://arxiv.org/abs/1604.06737
- Ke, G., Meng, Q., Finley, T., Wang, T., Chen, W., Ma, W., Ye, Q., & Liu, T.-Y. (2017). LightGBM: A highly efficient gradient boosting decision tree. *Advances in Neural Information Processing Systems, 30*. https://proceedings.neurips.cc/paper/2017/hash/6449f44a102fde848669bdd9eb6b76fa-Abstract.html
- Kaufman, S., Rosset, S., Perlich, C., & Stitelman, O. (2012). Leakage in data mining: Formulation, detection, and avoidance. *ACM Transactions on Knowledge Discovery from Data, 6*(4), 1–21. https://doi.org/10.1145/2382577.2382579
- Chollet, F., et al. (2015). *Keras*. https://keras.io
