# IFRS 9 / CECL Lifetime PD & ECL with Survival Models

Since the 2008 crisis, banks have to provision for losses they expect, not only for losses that have already happened. For a mortgage book that means estimating, for every loan, the chance of default in every future month until maturity, under several economic scenarios. This notebook builds that machinery on 500,000 real U.S. mortgages: loans originated in 2005–08, which went through the housing crisis, and loans originated in 2018–23, which went through the pandemic.

**What it does.** It builds lifetime default probabilities and expected credit losses from Fannie Mae and Freddie Mac loan-level data.

It compares three survival models for default timing (Cox, random survival forest, DeepSurv) and fits monthly cause-specific hazards for default and prepayment whose sensitivity to house prices and unemployment is estimated on the crisis years themselves. It tests the default model out of time twice: on 2024–26, and on the crisis, with a model trained only on data up to 2008.

Each active loan is projected to maturity under the Federal Reserve's 2026 baseline and severely adverse scenarios, with a loss given default estimated from 13,500 crisis foreclosure and short sales. The notebook then computes IFRS 9 staged ECL (12-month against lifetime, with a test for a significant increase in credit risk) and CECL lifetime ECL.

**Data.** Fannie Mae Single-Family Loan Performance data for 2005–2008 acquisitions and the Freddie Mac Single-Family Loan-Level Dataset for 2018–2023 (50,000 loans per vintage, monthly performance to March 2026); the U.S. unemployment rate, Case-Shiller national and FHFA state house prices and the 30-year mortgage rate (FRED); and the Fed's 2026 supervisory scenarios (federalreserve.gov).

**Methods.** A default definition that excludes COVID forbearance, Cox proportional hazards (lifelines), a random survival forest (scikit-survival) and a DeepSurv network (PyTorch) on origination data.

The projections use discrete-time logistic hazards with competing risks and a mark-to-market LTV rebuilt from state house prices, two back-tests, an empirical downturn LGD, amortising EAD, scenario-weighted lifetime PD and ECL, and stage allocation.

**Key output.** A comparison of survival models, the drivers of default and prepayment, out-of-time and crisis calibration, the LGD fit, lifetime PD by vintage, ECL by stage and scenario, and the difference between CECL and IFRS 9.

---

## Why it matters


IFRS 9 and CECL are the accounting numbers a risk officer signs off. Adding Fannie Mae's 2005–08 vintages to Freddie Mac's 2018–23 gives the model a real crisis: the default hazard's sensitivity to house prices and mark-to-market LTV is now estimated on loans that went through it, a model trained only up to 2008 under-predicts 2009–11 defaults by 7–21%, and 13,500 foreclosure and short sales give a downturn LGD of about 45% that barely depends on LTV. With that LGD, probability-weighted ECL on today's \$41bn book is \$27mm under IFRS 9 and \$55mm under CECL; a structural LGD would have given a sixth of that.

## How to run


1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`, plus the Freddie Mac sample zips in `data/freddie_mac/` and the Fannie Mae quarterly files 2005Q1–2008Q4 in `data/fannie_mae/` at the repo root (see the root README). The first run builds a 200,000-loan sample of the Fannie Mae files in `data/fannie_mae/sample/` (about 20–30 minutes, once).
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 8 minutes after the first run).

## Data sources


| Data | Source |
|---|---|
| Fannie Mae Single-Family Loan Performance Data, 2005–2008 acquisitions | https://capitalmarkets.fanniemae.com |
| Freddie Mac Single-Family Loan-Level Dataset, sample files 2018–2023 | https://www.freddiemac.com/research/datasets/sf-loanlevel-dataset |
| Unemployment, Case-Shiller HPI, FHFA state HPIs, 30-year mortgage rate, bank SFR delinquency rate | https://fred.stlouisfed.org |
| Fed 2026 supervisory scenarios | https://www.federalreserve.gov/supervisionreg/dfa-stress-tests-2026.htm |

## Outputs (`outputs/`)


- `01_vintages_backtest_scenarios_ecl.png`
- `cox_hazard_ratios.csv`
- `crisis_backtest_2009_2011.csv`
- `ecl_by_scenario.csv`
- `ecl_by_stage.csv`
- `hazard_model_coefficients.csv`
- `lgd_calibration_crisis.csv`
- `lifetime_pd_by_vintage.csv`
- `out_of_time_backtest.csv`
- `survival_model_comparison.csv`

## Key assumptions


- Default = 90+ days past due outside forbearance, or a credit-event zero balance (codes 02/03/09/15).
- Fannie Mae sample: loans whose identifier modulo 1000 is below 80, then 12,500 drawn at random per acquisition quarter; mark-to-market LTV rebuilt with FHFA state house-price indices.
- Default hazard trained excluding 2020-03 to 2021-12, with unemployment and house-price growth six months earlier as covariates.
- Empirical downturn LGD from 2005–08 disposals (about 45% at 90% LTV); structural LGD with a 25% haircut as a sensitivity; mortgage insurance credited.
- Scenario weights 60/30/10 (baseline / adverse midpoint / severely adverse); 24-month reversion to long-run values.

## Suggested commit plan


1. `add README and ECL framework`
2. `Fannie Mae 2005-08 sample builder and Freddie Mac ETL with on-disk DuckDB`
3. `survival models: Cox, RSF, DeepSurv`
4. `cause-specific monthly hazards with macro terms, out-of-time and crisis backtests`
5. `crisis LGD calibration and Fed scenarios`
6. `IFRS 9 staging, CECL and charts`

## References

### Finance and regulation

- International Accounting Standards Board. (2014). *IFRS 9 Financial instruments*. IFRS Foundation. https://www.ifrs.org/issued-standards/list-of-standards/ifrs-9-financial-instruments/
- Deng, Y., Quigley, J. M., & Van Order, R. (2000). Mortgage terminations, heterogeneity and the exercise of mortgage options. *Econometrica, 68*(2), 275–307. https://doi.org/10.1111/1468-0262.00110
- Bellotti, T., & Crook, J. (2009). Credit scoring with macroeconomic variables using survival analysis. *Journal of the Operational Research Society, 60*(12), 1699–1707. https://doi.org/10.1057/jors.2008.130
- Fine, J. P., & Gray, R. J. (1999). A proportional hazards model for the subdistribution of a competing risk. *Journal of the American Statistical Association, 94*(446), 496–509. https://doi.org/10.1080/01621459.1999.10474144
- Fannie Mae. (2026). *Single-Family Loan Performance Data* [Data set]. https://capitalmarkets.fanniemae.com/credit-risk-transfer/single-family-credit-risk-transfer/fannie-mae-single-family-loan-performance-data

### Machine learning and deep learning

- Katzman, J. L., Shaham, U., Cloninger, A., Bates, J., Jiang, T., & Kluger, Y. (2018). DeepSurv: Personalized treatment recommender system using a Cox proportional hazards deep neural network. *BMC Medical Research Methodology, 18*, 24. https://doi.org/10.1186/s12874-018-0482-1
- Ishwaran, H., Kogalur, U. B., Blackstone, E. H., & Lauer, M. S. (2008). Random survival forests. *The Annals of Applied Statistics, 2*(3), 841–860. https://doi.org/10.1214/08-AOAS169
- Cox, D. R. (1972). Regression models and life-tables. *Journal of the Royal Statistical Society: Series B, 34*(2), 187–202. https://doi.org/10.1111/j.2517-6161.1972.tb00899.x
- Davidson-Pilon, C. (2019). lifelines: Survival analysis in Python. *Journal of Open Source Software, 4*(40), 1317. https://doi.org/10.21105/joss.01317
