# Validating a Credit Scorecard When the Sample Is Small: the South German Credit Data with Bootstrap and DeLong Intervals, Calibration and Stability Tests, a Cost-Based Cut-Off, Naive Bayes and KNN Challengers, Swap Sets and Fair-Lending Checks

A scorecard is validated before it is used and again every year after. Independent validators ask four questions:
- Does it rank good and bad borrowers (*discrimination*)?
- Do its probabilities match what happens (*calibration*)?
- Is the population it scores still the one it was built on (*stability*)?
- Does it lead to sensible decisions at its cut-off, fairly across groups (*use*)?

They also build *challenger* models to see whether something simpler or more flexible would do better.

Most textbook examples use tens of thousands of loans. Many real portfolios are small: a regional lender, an SME or microfinance book, a new product. With a few hundred defaults, every validation statistic has wide error bars, and a validator who reads point estimates as facts will reject good models and accept bad ones. This notebook validates a scorecard on the **South German Credit** data, 1,000 consumer loans of which 300 went bad, the corrected 2020 release of the classic German credit dataset. It reports every statistic with its uncertainty:

- **Development.** A weight-of-evidence (WoE) scorecard with monotone coarse classing, information values and points scaled to 20 points per doubling of the odds.
- **Discrimination.** Gini and AUC with DeLong and bootstrap confidence intervals, the KS statistic with its critical value, CAP curves, and the spread of Gini across 50 repeated cross-validation splits.
- **Calibration.** Score bands against observed bad rates, Jeffreys intervals per band, Hosmer–Lemeshow and calibration-in-the-large.
- **Stability.** PSI and CSI between development and validation samples, compared with the PSI that sampling noise alone produces at this sample size.
- **Challengers.** Naive Bayes, k-nearest neighbours, LightGBM and a dummy-coded logistic regression against the scorecard: DeLong tests, and *swap sets* (who would be accepted by one model and rejected by the other, and how those borrowers behaved).
- **Use.** A cut-off chosen with the dataset's own cost matrix (accepting a bad borrower costs five times as much as rejecting a good one), and fair-lending checks: adverse impact ratios and equal-opportunity gaps for foreign workers and for applicants under 25. These characteristics are kept out of the model.
- **Verdict.** A red/amber/green summary in the form a validation report would use.

**Data.** South German Credit (UCI Machine Learning Repository, dataset 573; Grömping 2019).

**Methods.** WoE coarse classing and information value, logistic regression, points scaling, DeLong test, bootstrap, KS with critical value, CAP and accuracy ratio, Jeffreys intervals, Hosmer–Lemeshow, PSI/CSI with simulated null distributions, categorical naive Bayes, k-nearest neighbours, LightGBM, swap-set analysis, cost-based cut-off, adverse impact ratio and equal-opportunity difference.

**Key output.** A validated scorecard with its points table; every performance statistic with an interval; challengers compared by DeLong test and swap sets; a cost-optimal cut-off; fair-lending ratios; a validation verdict.

---

## Why it matters

A full independent validation of a WoE scorecard on 1,000 loans, with every statistic reported with its uncertainty. The validation Gini of 0.54 has a 95% interval of 0.42–0.65, and 50 cross-validation refits range from 0.47 to 0.65. Sampling noise alone produces a PSI of 0.10 for a 100-loan sample. Naive Bayes, KNN and LightGBM challengers are not significantly better, and swap sets confirm the scorecard. The fair-lending check fails: applicants under 25 face an adverse impact ratio of 0.43, and removing age costs no accuracy while lifting it to 0.70.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY` in `.env` (required by the shared setup cell; the data need no key).
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (under a minute).

## Data sources

| Data | Source |
|---|---|
| South German Credit (UPDATE), UCI Machine Learning Repository, dataset 573 | https://archive.ics.uci.edu/dataset/573/south+german+credit+update |

## Outputs (`outputs/`)

- `01_scorecard_validation_overview.png`
- `calibration_bands.csv`
- `challengers_and_swap_sets.csv`
- `characteristic_stability.csv`
- `cutoff.csv`
- `dashboard.html`
- `dashboard.png`
- `discrimination.csv`
- `fair_lending.csv`
- `information_values.csv`
- `scorecard_points.csv`
- `validation_verdict.csv`

## Key assumptions

- Bad = credit_risk 0; personal status/sex, foreign worker and telephone excluded from the model; foreign worker and age under 25 used only for fair-lending tests.
- 70/30 development/validation split stratified by outcome; quintile coarse classing merged to monotone bad rates; IV > 0.02; 600 points at odds 50:1, 20 points to double the odds.
- Cost matrix 5 (bad accepted) : 1 (good rejected); swap sets at a 70% approval rate; fairness on out-of-fold scores of all 1,000 loans at the cost-optimal approval rate.

## Suggested commit plan

1. `small-sample-scorecard-validation: add data, coarse classing, WoE, IV and the points table`
2. `small-sample-scorecard-validation: add discrimination with DeLong, bootstrap and repeated cross-validation`
3. `small-sample-scorecard-validation: add calibration and PSI/CSI against sampling noise`
4. `small-sample-scorecard-validation: add naive Bayes, KNN, LightGBM and logistic challengers with swap sets`
5. `small-sample-scorecard-validation: add the cost-based cut-off, fair-lending checks and the verdict`
6. `small-sample-scorecard-validation: add charts, dashboard and narrative`

## References

- Brown, L. D., Cai, T. T., & DasGupta, A. (2001). Interval estimation for a binomial proportion. *Statistical Science*, 16(2), 101–133. https://doi.org/10.1214/ss/1009213286
- DeLong, E. R., DeLong, D. M., & Clarke-Pearson, D. L. (1988). Comparing the areas under two or more correlated receiver operating characteristic curves: A nonparametric approach. *Biometrics*, 44(3), 837–845. https://doi.org/10.2307/2531595
- Grömping, U. (2019). *South German credit data: Correcting a widely used data set* (Reports in Mathematics, Physics and Chemistry, Report 4/2019). Beuth University of Applied Sciences Berlin.
- Hardt, M., Price, E., & Srebro, N. (2016). Equality of opportunity in supervised learning. In *Advances in Neural Information Processing Systems 29* (pp. 3315–3323).
- Hosmer, D. W., & Lemeshow, S. (1980). Goodness of fit tests for the multiple logistic regression model. *Communications in Statistics – Theory and Methods*, 9(10), 1043–1069. https://doi.org/10.1080/03610928008827941
- Siddiqi, N. (2017). *Intelligent credit scoring: Building and implementing better credit risk scorecards* (2nd ed.). Wiley.
- UCI Machine Learning Repository. *South German Credit (UPDATE)* (dataset 573). https://archive.ics.uci.edu/dataset/573/south+german+credit+update
- U.S. Equal Employment Opportunity Commission et al. (1978). Uniform guidelines on employee selection procedures, 29 C.F.R. § 1607.4(D) (the four-fifths rule).
