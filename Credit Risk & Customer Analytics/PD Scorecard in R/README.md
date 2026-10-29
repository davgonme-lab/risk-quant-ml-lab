# PD Scorecard in R

Many credit-risk teams build their scorecards in R, with packages that turn the whole workflow, from variable selection to the points table, into a few readable steps. This notebook follows that workflow end to end on 30,000 credit-card clients and finishes with the approval cutoff a credit committee would sign.

**What it does.** It filters variables by information value, bins them with monotonic weight of evidence, fits a logistic regression on the WoE values and scales it to points.

It then validates the scorecard on a hold-out sample with Gini, KS, calibration and population stability, and sets an approval cutoff from expected losses.

**Data.** The UCI *Default of Credit Card Clients* dataset (Yeh & Lien, 2009): 30,000 Taiwanese card holders, six months of repayment status, bill and payment amounts, and default in the following month. It is downloaded from the UCI archive, or from UCI's mirror on Kaggle if the archive is unreachable.

**Methods.** The `scorecard` package (variable filter, `woebin` binning with manual monotonic adjustments, `scorecard` points, `perf_eva`, `perf_psi`), logistic regression with stepwise AIC selection, `pROC` for the ROC and the DeLong confidence interval of the AUC, score-band calibration and an expected-loss cutoff.

**Key output.** The IV ranking, WoE tables, model coefficients, the points table, train and test Gini and KS, PSI, calibration by score band, and the approval cutoff with its approval rate and expected loss.

---

## Why it matters

The WoE/logistic scorecard is still the standard for retail PD models because it is transparent and easy to validate. Built end to end in R with `scorecard`, it reaches a test Gini of 0.51 with stable populations (PSI 0.001) and all-positive WoE coefficients. It also shows two findings a validator would raise: PDs need recalibration (the Hosmer–Lemeshow test fails), and the current delinquency status has a 'suspicious' IV of 0.92 that is genuine behavioural signal rather than leakage. A profit-based cutoff turns the score into an approval policy.

## How to run

1. Once, from the repo root: `Rscript install_packages.R` (installs the CRAN packages and registers the **R** kernel with IRkernel).
2. `.env` needs nothing for the UCI download; `KAGGLE_API_TOKEN` only if the UCI site is unreachable (the notebook then uses the UCI mirror on Kaggle).
3. Open the notebook, choose the **R** kernel, **Run All** (about one minute).

## Data sources

| Data | Source |
|---|---|
| Default of credit card clients (Taiwan, 30,000 clients) | UCI Machine Learning Repository, dataset 350; mirror `uciml/default-of-credit-card-clients-dataset` on Kaggle |

## Outputs (`outputs/`)

- `01_iv_and_woe.png`
- `02_validation_and_cutoff.png`
- `calibration_by_decile.csv`
- `cutoff_analysis.csv`
- `discrimination.csv`
- `information_value.csv`
- `scorecard_points.csv`

## Key assumptions

- Target: default on next month's payment; 70/30 stratified split with a fixed seed.
- Tree-based WoE binning, IV ≥ 0.02 filter, manual monotonic re-binning, stepwise AIC; points scaled to 600 at 19:1 odds with PDO 50.
- Cutoff economics illustrative: 4% annual margin on the limit, LGD 75%, EAD = current bill (at least 50% of the limit).

## Suggested commit plan

1. `add README and scorecard framework`
2. `data download with Kaggle fallback and feature engineering`
3. `WoE binning and IV filter`
4. `logistic model and points scaling`
5. `validation, calibration, cutoff analysis and executed outputs`

## References

### Finance and regulation

- Siddiqi, N. (2017). *Intelligent credit scoring: Building and implementing better credit risk scorecards* (2nd ed.). Wiley. https://doi.org/10.1002/9781119282396
- Thomas, L. C., Crook, J., & Edelman, D. (2017). *Credit scoring and its applications* (2nd ed.). SIAM. https://doi.org/10.1137/1.9781611974560
- Yeh, I.-C., & Lien, C.-H. (2009). The comparisons of data mining techniques for the predictive accuracy of probability of default of credit card clients. *Expert Systems with Applications, 36*(2), 2473–2480. https://doi.org/10.1016/j.eswa.2007.12.020
- Basel Committee on Banking Supervision. (2005). *Studies on the validation of internal rating systems* (Working Paper No. 14). Bank for International Settlements. https://www.bis.org/publ/bcbs_wp14.htm
- Hand, D. J., & Henley, W. E. (1997). Statistical classification methods in consumer credit scoring: A review. *Journal of the Royal Statistical Society: Series A, 160*(3), 523–541. https://doi.org/10.1111/j.1467-985X.1997.00078.x

### Machine learning and deep learning

- Robin, X., Turck, N., Hainard, A., Tiberti, N., Lisacek, F., Sanchez, J.-C., & Müller, M. (2011). pROC: An open-source package for R and S+ to analyze and compare ROC curves. *BMC Bioinformatics, 12*, 77. https://doi.org/10.1186/1471-2105-12-77
- DeLong, E. R., DeLong, D. M., & Clarke-Pearson, D. L. (1988). Comparing the areas under two or more correlated receiver operating characteristic curves: A nonparametric approach. *Biometrics, 44*(3), 837–845. https://doi.org/10.2307/2531595
- Xie, S. (2024). *scorecard: Credit risk scorecard* (R package). CRAN. https://CRAN.R-project.org/package=scorecard
- Akaike, H. (1974). A new look at the statistical model identification. *IEEE Transactions on Automatic Control, 19*(6), 716–723. https://doi.org/10.1109/TAC.1974.1100705
