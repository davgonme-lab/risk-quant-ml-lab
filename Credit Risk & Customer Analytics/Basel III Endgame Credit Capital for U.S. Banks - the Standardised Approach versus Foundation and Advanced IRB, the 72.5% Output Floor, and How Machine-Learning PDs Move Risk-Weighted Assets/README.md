# Basel III Endgame Credit Capital for U.S. Banks: the Standardised Approach versus Foundation and Advanced IRB, the 72.5% Output Floor, and How Machine-Learning PDs Move Risk-Weighted Assets

Basel III's final reform, called the "endgame" in the United States, changes how banks turn credit risk into capital. Large banks may use their own models of the probability of default (PD) and loss given default (LGD), the internal-ratings-based (IRB) approaches, but their risk-weighted assets (RWA) can no longer fall below 72.5% of what the new standardised approach would give. This notebook rebuilds the credit RWA of the loan book of every U.S. bank from public call-report data under four rules: today's U.S. standardised approach, the Basel III standardised approach (SA-CR), foundation IRB and advanced IRB. It then asks how much the floor binds and how much the choice of PD model, logistic regression or gradient boosting, moves capital.

**What it does.**

1. It reads year-end call reports from 2001 to 2025 for every FDIC-insured bank: loans by type (residential mortgages, home-equity lines, construction, commercial real estate, multifamily, farmland, commercial and industrial, credit cards, auto and other consumer, agricultural), noncurrent loans and net charge-offs by type, risk-weighted assets and CET1 capital.
2. It measures each bank's annual **default rate** by loan type (loans 90 days past due or on non-accrual at year-end plus the year's net charge-offs, relative to the book) and the **loss given default** of each loan type (net charge-offs relative to that default measure).
3. It forecasts next year's default rate for every bank and loan type with a persistence rule, a fractional logistic regression and LightGBM, trained on earlier years and tested out of time from 2008.
4. It computes credit RWA with the U.S. standardised weights, the Basel III SA-CR weights, and the IRB formulas, with long-run average (through-the-cycle) PDs and with point-in-time PDs from each model. The 72.5% output floor is applied to the IRB results.
5. It shows the effect on the largest banks' CET1 ratios, and how procyclical capital becomes when PDs follow the cycle.

**Data.** FDIC call reports through the BankFind Suite API (financial data for every insured bank); unemployment rate, house prices and the federal funds rate (FRED).

**Methods.** Basel III standardised risk weights, the IRB asymptotic single-risk-factor formula with supervisory correlations and maturity adjustment, Basel III PD and LGD input floors, the output floor, fractional logistic regression, LightGBM with expanding-window out-of-time tests, and cyclicality analysis.

**Key output.** Credit RWA density by approach and bank size; the share of banks for which the floor binds; pro forma CET1 ratios of the largest banks; the accuracy of the PD forecasts; and the swing in IRB capital over the cycle.

---

## Why it matters

Basel III lets large banks model credit risk but floors their risk-weighted assets at 72.5% of the new standardised approach. Rebuilt from call reports for all 4,317 U.S. banks (\$11.0 trillion of loans), the Basel III standardised approach weighs loans at 74% against 89% under today's U.S. rules; advanced IRB would cut that to 53%, so the floor binds for 94% of banks but only 35% of those over \$100 billion, where credit-card books carry heavy IRB weights. Out of time, gradient boosting and logistic regression do not beat this year's default rate as a forecast of next year's, and point-in-time PDs make capital swing by up to 63 points of RWA density over the cycle.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY` (unemployment, house prices, federal funds rate).
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 10 minutes the first time (25 year-ends of call reports from the FDIC API), about 6 minutes afterwards).

## Data sources

| Data | Source |
|---|---|
| FDIC BankFind Suite financial data (call reports), year-ends 2001–2025 | https://api.fdic.gov/banks/docs/ |
| Unemployment rate, house price index and federal funds rate (FRED) | https://fred.stlouisfed.org/ |

## Outputs (`outputs/`)

- `01_credit_capital.png`
- `bank_level_rwa.csv`
- `dashboard.html`
- `dashboard.png`
- `default_rates_and_lgd_by_type.csv`
- `largest_banks_pro_forma_cet1.csv`
- `pd_forecast_scores_by_year.csv`
- `rwa_density_by_size.csv`
- `rwa_density_through_the_cycle.csv`

## Key assumptions

- Default rate = (noncurrent loans + net charge-offs) / loans by loan type; LGD = net charge-offs / (noncurrent + charged-off loans), pooled by loan type.
- Basel III SA-CR weights without LTV data: mortgages 30%, home-equity and consumer 75%, SME corporate 85%, CRE 100%, construction 150%; U.S. standardised 50% mortgages, 150% construction, 100% otherwise.
- IRB: Basel correlations, 2.5-year maturity for corporates, F-IRB LGD 40% (25% real-estate secured), Basel III PD and LGD floors, no 1.06 scaling; output floor 72.5% of SA-CR; on-balance-sheet loans only.

## Suggested commit plan

1. `basel3-credit-capital-irb-floor: add call-report loan books, default rates and LGD by loan type`
2. `basel3-credit-capital-irb-floor: add out-of-time PD forecasts (persistence, fractional logit, LightGBM)`
3. `basel3-credit-capital-irb-floor: add standardised, F-IRB and A-IRB credit RWA with the output floor`
4. `basel3-credit-capital-irb-floor: add pro forma CET1 for the largest banks and procyclicality analysis`
5. `basel3-credit-capital-irb-floor: add charts, dashboard and narrative`

## References

### Finance and regulation

- Basel Committee on Banking Supervision. (2017). *Basel III: Finalising post-crisis reforms*. Bank for International Settlements. https://www.bis.org/bcbs/publ/d424.htm
- Basel Committee on Banking Supervision. (2005). *An explanatory note on the Basel II IRB risk weight functions*. Bank for International Settlements. https://www.bis.org/bcbs/irbriskweight.htm
- Board of Governors of the Federal Reserve System, Federal Deposit Insurance Corporation, & Office of the Comptroller of the Currency. (2023). Regulatory capital rule: Large banking organizations and banking organizations with significant trading activity. *Federal Register, 88*, 64028. https://www.federalregister.gov/documents/2023/09/18/2023-19200
- Gordy, M. B. (2003). A risk-factor model foundation for ratings-based bank capital rules. *Journal of Financial Intermediation, 12*(3), 199–232. https://doi.org/10.1016/S1042-9573(03)00040-8
- Repullo, R., & Suarez, J. (2013). The procyclical effects of bank capital regulation. *The Review of Financial Studies, 26*(2), 452–490. https://doi.org/10.1093/rfs/hhs118
- Federal Deposit Insurance Corporation. (2026). *BankFind Suite: Financial data API* [Data set]. https://api.fdic.gov/banks/docs/

### Machine learning and econometrics

- Papke, L. E., & Wooldridge, J. M. (1996). Econometric methods for fractional response variables with an application to 401(k) plan participation rates. *Journal of Applied Econometrics, 11*(6), 619–632. https://doi.org/10.1002/(SICI)1099-1255(199611)11:6<619::AID-JAE418>3.0.CO;2-1
- Ke, G., Meng, Q., Finley, T., Wang, T., Chen, W., Ma, W., Ye, Q., & Liu, T.-Y. (2017). LightGBM: A highly efficient gradient boosting decision tree. *Advances in Neural Information Processing Systems, 30*. https://proceedings.neurips.cc/paper/2017/hash/6449f44a102fde848669bdd9eb6b76fa-Abstract.html
