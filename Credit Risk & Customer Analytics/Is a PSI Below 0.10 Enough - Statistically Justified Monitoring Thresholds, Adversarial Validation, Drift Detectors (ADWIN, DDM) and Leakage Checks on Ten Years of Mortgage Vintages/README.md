# Is a PSI Below 0.10 Enough? Statistically Justified Monitoring Thresholds, Adversarial Validation, Drift Detectors (ADWIN, DDM) and Leakage Checks on Ten Years of Mortgage Vintages

Credit models are monitored with a handful of rules of thumb, the best known being the population stability index: below 0.10 the population is "stable", above 0.25 the model needs attention. The rule ignores sample size, says nothing about whether the model still ranks or predicts well, and cannot see a deterioration that does not change the applicants' attributes. This notebook puts the standard monitoring toolkit through two real episodes: the 2006–2008 mortgage vintages, which defaulted at three to four times the rate of 2005 with applicants that looked much the same, and the 2019–2024 vintages, whose applicant mix swung with the 2020–2021 refinancing boom while their credit quality barely moved. It also answers the questions validators ask before monitoring starts: is anything leaking from the future, are the scorecard's bins stable, how uncertain are its parameters, and does it beat a simple benchmark?

**What it does.**

1. It reads loan-level origination data for Fannie Mae loans originated in 2005–2008 and Freddie Mac loans originated in 2018–2023, with a flag for default (90 days past due or a credit event, ignoring arrears accrued in COVID-19 forbearance) in the first 18 months.
2. It develops a weight-of-evidence logistic scorecard and a LightGBM challenger on one vintage per book (2005 and 2018), with FICO-only and three-variable benchmarks.
3. It monitors every later quarterly cohort: population stability of the score and each attribute against thresholds derived from the PSI's sampling distribution, discrimination with confidence intervals, calibration, and adversarial validation (how well a classifier can tell the cohort from the development sample).
4. It runs two streaming drift detectors, ADWIN and DDM, on the score as loans are originated and on outcomes as they become known 18 months later, and records when each would have raised an alarm.
5. It checks for target and temporal leakage, the stability of the weight-of-evidence bins across vintages, the bootstrap uncertainty of the scorecard's parameters, and the gain over simple benchmarks.

**Data.** Fannie Mae Single-Family Loan Performance Data and Freddie Mac Single-Family Loan-Level Dataset (samples, downloaded once by hand into `data/` at the repository root); the 30-year mortgage rate (FRED).

**Methods.** Weight-of-evidence binning with monotone merging, information value, logistic regression, LightGBM, the population and characteristic stability indices with chi-square thresholds, AUC with Hanley–McNeil standard errors, adversarial validation, ADWIN and DDM drift detectors, univariate leakage screens, random versus out-of-time cross-validation, and bootstrap parameter uncertainty.

**Key output.** For each cohort, the score PSI against the 0.10 rule and the statistical threshold, AUC with confidence intervals, observed versus predicted default rates and the adversarial AUC; the alarm dates of each detector; and the leakage, bin-stability, parameter-uncertainty and benchmark checks.

---

## Why it matters

The population stability index is monitored against fixed rules of thumb. On ten years of mortgage vintages it missed the largest deterioration in the data: from 2006 to 2008 the score PSI stayed below 0.04 while the default rate of each cohort rose from 0.9% to 4.7% against a predicted 0.7–1.0%. It then flagged a benign shift: the 2020–2021 refinancing boom pushed it to 0.19–0.33 while the model stayed well calibrated. Statistical thresholds for these sample sizes are around 0.003, so most shifts are real but immaterial; the implied change in expected defaults is the better filter. Outcome-based drift detectors (ADWIN, DDM) found the 2006–2007 problem only in 2008, because of the 18-month label delay. A post-origination field ranked above FICO in the leakage screen and lifted the cross-validated AUC from 0.79 to 0.90.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY` (30-year mortgage rate). The Fannie Mae 2005–2008 and Freddie Mac 2018–2023 sample files must be in `data/fannie_mae/sample/` and `data/freddie_mac/` at the repository root (free registration, manual download, never committed).
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 5 minutes on CPU the first time, about 2 minutes afterwards).

## Data sources

| Data | Source |
|---|---|
| Fannie Mae Single-Family Loan Performance Data, 2005–2008 acquisitions (sampled) | https://capitalmarkets.fanniemae.com/credit-risk-transfer/single-family-credit-risk-transfer/fannie-mae-single-family-loan-performance-data |
| Freddie Mac Single-Family Loan-Level Dataset, samples 2018–2023 | https://www.freddiemac.com/research/datasets/sf-loanlevel-dataset |
| Freddie Mac PMMS 30-year fixed mortgage rate (FRED) | https://fred.stlouisfed.org/series/MORTGAGE30US |

## Outputs (`outputs/`)

- `01_model_monitoring.png`
- `adversarial_validation.csv`
- `benchmark_auc.csv`
- `bootstrap_coefficients.csv`
- `characteristic_stability_by_cohort.csv`
- `dashboard.html`
- `dashboard.png`
- `drift_detector_alarms.csv`
- `information_value.csv`
- `leakage_cross_validation.csv`
- `leakage_screen.csv`
- `monitoring_by_cohort.csv`
- `psi_thresholds_by_sample_size.csv`
- `woe_bin_stability.csv`

## Key assumptions

- Default = 90 days past due or a credit event within 18 months of the first payment, ignoring arrears accrued in COVID-19 forbearance; loans whose window ends after March 2026 are dropped.
- Scorecard on monotone WoE bins (deciles merged until monotone, missing bin, half a default added per bin), fitted on 2005 (Fannie Mae) and 2018 (Freddie Mac); cohorts = later origination quarters with at least 500 loans.
- PSI over ten development score deciles; 99% threshold = (1/n + 1/m) χ²₉; implied default-rate shift = Σ (q − p) × development decile default rate.
- ADWIN with δ = 0.002 checked every 250 loans; DDM with a 1,000-loan warm-up and three-standard-deviation rule, restarted after each alarm; outcome alarms dated at the end of the 18-month window.

## Suggested commit plan

1. `psi-thresholds-drift-leakage: add origination samples with 18-month default flag and post-origination fields`
2. `psi-thresholds-drift-leakage: add monotone WoE scorecard, LightGBM challenger and benchmarks`
3. `psi-thresholds-drift-leakage: add cohort monitoring: PSI with statistical thresholds, CSI, AUC intervals and calibration`
4. `psi-thresholds-drift-leakage: add adversarial validation and ADWIN/DDM drift detectors`
5. `psi-thresholds-drift-leakage: add leakage, bin-stability, bootstrap and benchmark checks, charts, dashboard and narrative`

## References

### Credit scoring and model monitoring

- Siddiqi, N. (2017). *Intelligent credit scoring: Building and implementing better credit risk scorecards* (2nd ed.). Wiley. https://doi.org/10.1002/9781119282396
- Yurdakul, B., & Naranjo, J. (2020). Statistical properties of the population stability index. *The Journal of Risk Model Validation*. https://doi.org/10.21314/JRMV.2020.227
- Hanley, J. A., & McNeil, B. J. (1982). The meaning and use of the area under a receiver operating characteristic (ROC) curve. *Radiology, 143*(1), 29–36. https://doi.org/10.1148/radiology.143.1.7063747
- Kaufman, S., Rosset, S., Perlich, C., & Stitelman, O. (2012). Leakage in data mining: Formulation, detection, and avoidance. *ACM Transactions on Knowledge Discovery from Data, 6*(4), 1–21. https://doi.org/10.1145/2382577.2382579
- Basel Committee on Banking Supervision. (2005). *Studies on the validation of internal rating systems* (Working Paper No. 14). Bank for International Settlements. https://www.bis.org/publ/bcbs_wp14.htm

### Drift detection and machine learning

- Gama, J., Medas, P., Castillo, G., & Rodrigues, P. (2004). Learning with drift detection. In *Advances in Artificial Intelligence – SBIA 2004* (pp. 286–295). Springer. https://doi.org/10.1007/978-3-540-28645-5_29
- Bifet, A., & Gavaldà, R. (2007). Learning from time-changing data with adaptive windowing. In *Proceedings of the 2007 SIAM International Conference on Data Mining* (pp. 443–448). https://doi.org/10.1137/1.9781611972771.42
- Ke, G., Meng, Q., Finley, T., Wang, T., Chen, W., Ma, W., Ye, Q., & Liu, T.-Y. (2017). LightGBM: A highly efficient gradient boosting decision tree. *Advances in Neural Information Processing Systems, 30*. https://proceedings.neurips.cc/paper/2017/hash/6449f44a102fde848669bdd9eb6b76fa-Abstract.html

### Data

- Fannie Mae. (2026). *Single-Family Loan Performance Data* [Data set]. https://capitalmarkets.fanniemae.com/credit-risk-transfer/single-family-credit-risk-transfer/fannie-mae-single-family-loan-performance-data
- Freddie Mac. (2026). *Single-Family Loan-Level Dataset* [Data set]. https://www.freddiemac.com/research/datasets/sf-loanlevel-dataset
- Freddie Mac. (2026). *30-year fixed rate mortgage average in the United States* [Data set]. Federal Reserve Bank of St. Louis (FRED). https://fred.stlouisfed.org/series/MORTGAGE30US
