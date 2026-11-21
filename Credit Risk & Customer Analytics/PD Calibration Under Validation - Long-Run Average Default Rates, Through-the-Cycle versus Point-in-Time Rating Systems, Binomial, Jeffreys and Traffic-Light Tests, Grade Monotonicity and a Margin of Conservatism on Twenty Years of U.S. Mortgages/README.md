# PD Calibration Under Validation: Long-Run Average Default Rates, Through-the-Cycle versus Point-in-Time Rating Systems, Binomial, Jeffreys and Traffic-Light Tests, Grade Monotonicity and a Margin of Conservatism on Twenty Years of U.S. Mortgages

A rating system ranks borrowers; calibration attaches a probability of default to each grade. Under the internal-ratings-based approach the PD of a grade must be its **long-run average** one-year default rate, estimated over a period that contains good and bad years, plus a **margin of conservatism** for what the data cannot tell. Validators then test, year after year, whether the observed default rates are consistent with those PDs. The tests are simple, but how to read them is not: a through-the-cycle PD *should* be exceeded in a recession, and a binomial test that ignores default correlation will flag it. This notebook builds two rating systems for U.S. mortgages, one through-the-cycle-leaning and one point-in-time, calibrates both to long-run averages from twenty years of loan-level data, and runs the standard validation battery on loans the models never saw and on a newer book from a different lender.

**What it does.**

1. It reads loan-level origination and monthly performance data for Fannie Mae loans originated in 2005–2008 (followed to 2025) and Freddie Mac loans originated in 2018–2023, and turns them into annual snapshots: each performing loan at each year-end, with a flag for default (90 days past due or a credit event) in the next twelve months.
2. It builds a through-the-cycle-leaning scorecard (logistic regression on borrower and loan attributes, without house prices or unemployment) and a point-in-time model (LightGBM with monotone constraints that also sees mark-to-market loan-to-value and state unemployment), both trained on 2005–2012.
3. It maps both onto an eleven-grade master scale and calibrates each grade to the long-run average of its annual default rates. It checks whether the observation period is representative of the long run with a 35-year bank delinquency series.
4. It runs the validation tests by grade and year: one-sided binomial, Jeffreys, the traffic-light approach with independent and correlated defaults, Hosmer–Lemeshow, grade monotonicity, discrimination, rating migration and the degree of point-in-time-ness.
5. It quantifies a margin of conservatism in three categories (data deficiencies, representativeness, statistical uncertainty) and tests the final PDs on the newer book.

**Data.** Fannie Mae Single-Family Loan Performance Data and Freddie Mac Single-Family Loan-Level Dataset (samples, downloaded once by hand into `data/` at the repository root); state house price indices, state unemployment rates, the 30-year mortgage rate and the delinquency rate on bank single-family mortgages (FRED).

**Methods.** Annual cohort default rates, logistic regression, LightGBM with monotone constraints, a master scale, long-run average calibration, block bootstrap, binomial and Jeffreys tests, the traffic-light approach with a Vasicek one-factor adjustment, Hosmer–Lemeshow, adjacent-grade tests of monotonicity, AUC, migration matrices and an EBA-style margin of conservatism.

**Key output.** Long-run average PDs by grade with their margin of conservatism; year-by-year test results for both rating systems on held-out loans and on the newer book; how many grade-years fail with and without default correlation; and how point-in-time each system is.

---

## Why it matters

A PD must be the long-run average default rate of its grade plus a margin of conservatism, and validators test it every year. On twenty years of U.S. mortgages, the long-run average is 2.2%, but a boom-only window would give 0.8% and a crisis-only one 4.2%; the margin, dominated by estimation error, adds 35%. Through-the-cycle grades fail the binomial test in 20 of 34 grade-years of 2008–2011, yet none fails once defaults are allowed to be correlated; point-in-time grades pass because borrowers migrate (57% change grade each year). On a newer 2018–2024 book the through-the-cycle PDs are twice the observed rates, while the raw point-in-time PDs underestimate defaults in the house-price boom.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY` (state house price indices, state unemployment, 30-year mortgage rate, bank mortgage delinquency rate). The Fannie Mae 2005–2008 and Freddie Mac 2018–2023 sample files must be in `data/fannie_mae/sample/` and `data/freddie_mac/` at the repository root (free registration, manual download, never committed).
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 5 minutes on CPU the first time, about a minute afterwards).

## Data sources

| Data | Source |
|---|---|
| Fannie Mae Single-Family Loan Performance Data, 2005–2008 acquisitions (sampled) | https://capitalmarkets.fanniemae.com/credit-risk-transfer/single-family-credit-risk-transfer/fannie-mae-single-family-loan-performance-data |
| Freddie Mac Single-Family Loan-Level Dataset, samples 2018–2023 | https://www.freddiemac.com/research/datasets/sf-loanlevel-dataset |
| State house price indices (FHFA), state unemployment rates (BLS), 30-year mortgage rate and bank single-family delinquency rate (FRED) | https://fred.stlouisfed.org/ |

## Outputs (`outputs/`)

- `01_pd_calibration.png`
- `auc_by_year.csv`
- `dashboard.html`
- `dashboard.png`
- `default_rates_by_book_and_year.csv`
- `grade_long_run_averages.csv`
- `grade_year_tests.csv`
- `lra_by_observation_window.csv`
- `margin_of_conservatism.csv`
- `migration_and_pitness.csv`
- `monotonicity.csv`
- `tests_by_year.csv`
- `tests_summary.csv`

## Key assumptions

- Observation = loan performing at a year-end (under 90 days past due, never defaulted); default = 90 days past due or a credit event in the next 12 months, ignoring arrears accrued while in COVID-19 forbearance.
- Rating models trained on 70% of Fannie Mae loans, snapshots 2005–2012; grade LRAs = mean of annual grade default rates 2005–2024 (grades with at least 30 loans), made monotone by isotonic pooling.
- MoC = (A) missing DTI treated as worst-decile DTI, (B) long-run / observation-period bank delinquency rate − 1 if positive, (C) 90th percentile of a 3-year block bootstrap of the mean annual default rate; PD floor 0.05%.
- Traffic lights: red if p < 0.1%, yellow if p < 5%; correlated version with a Vasicek one-factor mixture at R = 15%.

## Suggested commit plan

1. `pd-calibration-validation: add annual performing-loan snapshots from Fannie Mae and Freddie Mac samples with forbearance-aware default flag`
2. `pd-calibration-validation: add state house price, unemployment and mortgage-rate features`
3. `pd-calibration-validation: add through-the-cycle-leaning scorecard, monotone PIT LightGBM and master scale`
4. `pd-calibration-validation: add long-run average calibration, representativeness check and margin of conservatism`
5. `pd-calibration-validation: add binomial, Jeffreys, traffic-light, Hosmer-Lemeshow, monotonicity and migration tests, charts, dashboard and narrative`

## References

### Regulation and supervisory practice

- Basel Committee on Banking Supervision. (2006). *International convergence of capital measurement and capital standards: A revised framework, comprehensive version*. Bank for International Settlements. https://www.bis.org/publ/bcbs128.htm
- Basel Committee on Banking Supervision. (2005). *Studies on the validation of internal rating systems* (Working Paper No. 14). Bank for International Settlements. https://www.bis.org/publ/bcbs_wp14.htm
- Basel Committee on Banking Supervision. (2017). *Basel III: Finalising post-crisis reforms*. Bank for International Settlements. https://www.bis.org/bcbs/publ/d424.htm
- European Banking Authority. (2017). *Guidelines on PD estimation, LGD estimation and the treatment of defaulted exposures* (EBA/GL/2017/16). https://www.eba.europa.eu/regulation-and-policy/model-validation/guidelines-on-pd-lgd-estimation-and-treatment-of-defaulted-assets
- European Banking Authority. (2020). *Guidelines on legislative and non-legislative moratoria on loan repayments applied in the light of the COVID-19 crisis* (EBA/GL/2020/02). https://www.eba.europa.eu/regulation-and-policy/credit-risk/guidelines-legislative-and-non-legislative-moratoria-loan-repayments-applied-light-covid-19-crisis
- European Central Bank. (2019). *Instructions for reporting the validation results of internal models: IRB Pillar I models for credit risk*. https://www.bankingsupervision.europa.eu/activities/internal_models/shared/pdf/instructions_validation_reporting_credit_risk.en.pdf

### Credit-risk validation and statistics

- Tasche, D. (2003). *A traffic lights approach to PD validation* (arXiv:cond-mat/0305038). https://arxiv.org/abs/cond-mat/0305038
- Vasicek, O. (2002). The distribution of loan portfolio value. *Risk, 15*(12), 160–162.
- Hosmer, D. W., & Lemeshow, S. (1980). Goodness of fit tests for the multiple logistic regression model. *Communications in Statistics – Theory and Methods, 9*(10), 1043–1069. https://doi.org/10.1080/03610928008827941
- Künsch, H. R. (1989). The jackknife and the bootstrap for general stationary observations. *The Annals of Statistics, 17*(3), 1217–1241. https://doi.org/10.1214/aos/1176347265
- Ke, G., Meng, Q., Finley, T., Wang, T., Chen, W., Ma, W., Ye, Q., & Liu, T.-Y. (2017). LightGBM: A highly efficient gradient boosting decision tree. *Advances in Neural Information Processing Systems, 30*. https://proceedings.neurips.cc/paper/2017/hash/6449f44a102fde848669bdd9eb6b76fa-Abstract.html

### Data

- Fannie Mae. (2026). *Single-Family Loan Performance Data* [Data set]. https://capitalmarkets.fanniemae.com/credit-risk-transfer/single-family-credit-risk-transfer/fannie-mae-single-family-loan-performance-data
- Freddie Mac. (2026). *Single-Family Loan-Level Dataset* [Data set]. https://www.freddiemac.com/research/datasets/sf-loanlevel-dataset
- Federal Housing Finance Agency, U.S. Bureau of Labor Statistics, Freddie Mac and Board of Governors of the Federal Reserve System. (2026). *State house price indexes, state unemployment rates, 30-year fixed mortgage average and delinquency rate on single-family residential mortgages* [Data sets]. Federal Reserve Bank of St. Louis (FRED). https://fred.stlouisfed.org/
