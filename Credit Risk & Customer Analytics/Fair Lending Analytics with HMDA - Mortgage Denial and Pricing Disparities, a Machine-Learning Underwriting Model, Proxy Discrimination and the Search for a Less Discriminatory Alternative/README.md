# Fair Lending Analytics with HMDA: Mortgage Denial and Pricing Disparities, a Machine-Learning Underwriting Model, Proxy Discrimination and the Search for a Less Discriminatory Alternative

A credit model that never sees race can still treat groups very differently, because other inputs carry the same information. U.S. regulators therefore expect lenders to measure disparities, find the proxies, and look for an equally good model with less disparate impact. This notebook runs that full review on public mortgage data.

**What it does.** It uses the public loan-level **Home Mortgage Disclosure Act** (HMDA) data: every home-purchase mortgage application in Georgia in 2023 and 2024 that ended in an origination or a denial. It runs six analyses a bank's fair-lending team or a regulator would run:

1. **Denial disparities** by race, ethnicity and sex. Raw denial rates and adverse impact ratios (AIR) come first, then logistic regressions that add the legitimate underwriting factors HMDA records (debt-to-income, loan-to-value, income, loan amount and type, property type), then lender fixed effects. Whatever remains is the **unexplained** disparity.
2. **Pricing disparities**: the rate spread over the prime offer rate for originated loans, with the same controls.
3. A **LightGBM underwriting model** trained on 2023 decisions without any protected attribute and tested on 2024. Its AIR is compared with the lenders' actual decisions.
4. **Proxy analysis**: how well the model's inputs predict race, and which ones carry it.
5. A **less discriminatory alternative** (LDA) search, the test U.S. regulators apply under disparate-impact doctrine. Model variants are traded off between accuracy and AIR, and one is chosen from the frontier.
6. **Lender screening**: lenders whose adjusted AIR for Black applicants falls below the four-fifths benchmark.

**Data.** The CFPB/FFIEC HMDA Data Browser API: loan-level records for Georgia, 2023 and 2024, home purchase, actions "originated" and "denied".

**Methods.** Adverse impact ratios, logistic regression with fixed effects and odds ratios, OLS on rate spreads, LightGBM and proxy AUC.

The LDA frontier uses reweighting (Kamiran and Calders, 2012) and feature-set variants, and the lender screen uses adjusted AIR with binomial standard errors.

---

## Why it matters

228,141 Georgia home-purchase applications (2023–2024) from 845 lenders. Black applicants face odds of denial 1.97 times those of White applicants after underwriting controls and lender fixed effects (Hispanic 1.53, Asian 1.44); Hispanic borrowers pay about 10 bp more within the same lender. A LightGBM underwriting model without protected attributes (AUC 0.79–0.80) reproduces the lenders' adverse impact ratio of 0.90, and its inputs predict race with AUC up to 0.85 — tract minority share is the strongest proxy. A reweighted underwriting-only model loses under 0.01 AUC and lifts the Black AIR to 0.93: a less discriminatory alternative. Two of 88 lenders are flagged below the four-fifths benchmark.

## How to run

1. `conda activate quant-risk`. `.env` needs none.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 15 minutes).

## Data sources

| Data | Source |
|---|---|
| HMDA loan-level data (CFPB/FFIEC Data Browser API) | https://ffiec.cfpb.gov/data-browser/ |

## Outputs (`outputs/`)

- `01_fair_lending_hmda.png`
- `dashboard.html`
- `dashboard.png`
- `denial_odds_ratios.csv`
- `denial_rates_by_group.csv`
- `lda_search.csv`
- `lender_screening.csv`
- `model_disparate_impact.csv`
- `rate_spread_gaps.csv`

## Key assumptions

- Georgia, 2023 and 2024, home purchase, first-lien, actions originated or denied; groups from self-reported race and ethnicity.
- Logistic regressions with up to 110 lender fixed effects (lenders with at least 300 applications); rate-spread OLS on conventional originated loans.
- LightGBM trained on 2023 and tested on 2024 with the approval rate held at the actual 2024 rate; lenders flagged if adjusted AIR < 0.8 and more than two standard errors below 1.

## Suggested commit plan

1. `fair-lending-hmda: add HMDA Georgia loader and raw denial rates / AIR by group`
2. `fair-lending-hmda: add denial odds ratios with controls and lender fixed effects, and rate-spread gaps`
3. `fair-lending-hmda: add LightGBM underwriting model, proxy analysis and LDA search`
4. `fair-lending-hmda: add lender screening, dashboard and reading of results`

## References

### Finance and regulation

- Bartlett, R., Morse, A., Stanton, R., & Wallace, N. (2022). Consumer-lending discrimination in the FinTech era. *Journal of Financial Economics, 143*(1), 30–56. https://doi.org/10.1016/j.jfineco.2021.05.047
- Fuster, A., Goldsmith-Pinkham, P., Ramadorai, T., & Walther, A. (2022). Predictably unequal? The effects of machine learning on credit markets. *The Journal of Finance, 77*(1), 5–47. https://doi.org/10.1111/jofi.13090

### Machine learning and deep learning

- Kamiran, F., & Calders, T. (2012). Data preprocessing techniques for classification without discrimination. *Knowledge and Information Systems, 33*(1), 1–33. https://doi.org/10.1007/s10115-011-0463-8
- Black, E., Raghavan, M., & Barocas, S. (2022). Model multiplicity: Opportunities, concerns, and solutions. In *Proceedings of the 2022 ACM Conference on Fairness, Accountability, and Transparency*. https://doi.org/10.1145/3531146.3533149
- Barocas, S., Hardt, M., & Narayanan, A. (2023). *Fairness and machine learning: Limitations and opportunities*. MIT Press. https://fairmlbook.org/
- Ke, G., Meng, Q., Finley, T., Wang, T., Chen, W., Ma, W., Ye, Q., & Liu, T.-Y. (2017). LightGBM: A highly efficient gradient boosting decision tree. *Advances in Neural Information Processing Systems, 30*. https://proceedings.neurips.cc/paper/2017/hash/6449f44a102fde848669bdd9eb6b76fa-Abstract.html
