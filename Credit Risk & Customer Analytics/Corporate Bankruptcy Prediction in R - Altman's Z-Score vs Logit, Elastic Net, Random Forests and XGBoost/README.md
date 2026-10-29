# Corporate Bankruptcy Prediction in R: Altman's Z-Score vs Logit, Elastic Net, Random Forests and XGBoost

Altman's Z-score is almost sixty years old and still appears in credit memos every day, because it is simple and needs only a balance sheet and an income statement. The fair question is how much modern machine learning really adds to it, and whether that gain holds years before a firm fails. This notebook puts the two side by side on 43,000 firm-years.

**What it does.** It compares the 1968 benchmark of corporate credit scoring, **Altman's Z-score**, with modern statistical learning on 43,000 firm-years of Polish companies with 64 financial ratios.

- **Classic scores:** Altman's Z′ for private firms, with its published coefficients and zones, and the same five ratios re-estimated by logistic regression.
- **Models on all 64 ratios:** a logit, an elastic net (`glmnet`), a random forest (`ranger`) and gradient boosting (`xgboost`).

The models are compared on discrimination, calibration and the cost of misclassification. Repeated stratified cross-validation and DeLong tests check whether the gains are real.

The final test is the **horizon**: a model fitted on one-year-ahead data has to give warning two to five years before failure.

**Data.** UCI *Polish Companies Bankruptcy* (Tomczak, 2016): 2000–2013, five forecasting horizons, 64 ratios per firm-year, and bankrupt status at the end of the horizon.

**Methods.** Altman Z′, logit, `glmnet` (α = 0.5, CV λ), `ranger` (500 trees, permutation importance), `xgboost` (early-stopped), `pROC` (DeLong), calibration by deciles and cost curves.

**Key output.** AUC, PR-AUC and Brier score by model with confidence intervals, how often Altman's "distress zone" is right, the ratios that matter beyond Altman's five, and how far ahead each model sees failure.

---

## Why it matters

Altman's Z-score is still the reference in corporate credit; the question is how much 64 ratios and modern learners add. On 5,910 Polish firm-years (410 bankruptcies), the published Z′ reaches a cross-validated AUC of 0.70 and a re-weighted Altman logit 0.78, while XGBoost reaches 0.95 with three times the PR-AUC (DeLong p < 0.001). At a 12:1 cost of missed bankruptcy, XGBoost catches 88% of failures rejecting 11% of good firms, cutting expected cost 64% versus Z′, and keeps an AUC of 0.86–0.94 up to five years before failure while Z′ falls to about 0.6.

## How to run

1. Once, from the repo root: `Rscript install_packages.R` (installs the CRAN packages and registers the **R** kernel with IRkernel).
2. `.env` needs no keys (public UCI data).
3. Open the notebook, choose the **R** kernel, **Run All** (about 4 minutes).

## Data sources

| Data | Source |
|---|---|
| UCI Polish Companies Bankruptcy (Tomczak, 2016) | https://archive.ics.uci.edu/dataset/365/polish+companies+bankruptcy+data |

## Outputs (`outputs/`)

- `01_bankruptcy_altman_vs_ml.png`
- `altman_zones.csv`
- `auc_by_horizon.csv`
- `calibration_deciles.csv`
- `cost_optimal_cutoffs.csv`
- `cv_metrics.csv`
- `delong_tests.csv`
- `variable_importance.csv`

## Key assumptions

- Ratios winsorised at the 1st/99th percentile and median-imputed with training statistics; missing flags for variables with more than 5% missing.
- Altman Z′ (private firms) with the published coefficients and zones 1.23 / 2.90.
- 5-fold stratified CV repeated 3 times; DeLong tests on first-repeat out-of-fold predictions.
- Cost of a missed bankruptcy 60% of exposure, of a rejected good firm 5%.
- Horizon analysis applies models fitted on the 1-year file unchanged to the 2–5-year files.

## Suggested commit plan

1. `data reader and preprocessing`
2. `Altman Z′ and re-estimated Altman`
3. `logit, elastic net, random forest and XGBoost CV`
4. `DeLong tests, zones, calibration and costs`
5. `importance and horizon analysis`
6. `charts and narrative`

## References

### Finance and regulation

- Altman, E. I. (1968). Financial ratios, discriminant analysis and the prediction of corporate bankruptcy. *The Journal of Finance, 23*(4), 589–609. https://doi.org/10.1111/j.1540-6261.1968.tb00843.x
- Altman, E. I., Iwanicz-Drozdowska, M., Laitinen, E. K., & Suvas, A. (2017). Financial distress prediction in an international context: A review and empirical analysis of Altman's Z-score model. *Journal of International Financial Management & Accounting, 28*(2), 131–171. https://doi.org/10.1111/jifm.12053
- Ohlson, J. A. (1980). Financial ratios and the probabilistic prediction of bankruptcy. *Journal of Accounting Research, 18*(1), 109–131. https://doi.org/10.2307/2490395
- Shumway, T. (2001). Forecasting bankruptcy more accurately: A simple hazard model. *The Journal of Business, 74*(1), 101–124. https://doi.org/10.1086/209665
- Zięba, M., Tomczak, S. K., & Tomczak, J. M. (2016). Ensemble boosted trees with synthetic features generation in application to bankruptcy prediction. *Expert Systems with Applications, 58*, 93–101. https://doi.org/10.1016/j.eswa.2016.04.001

### Machine learning and deep learning

- Friedman, J., Hastie, T., & Tibshirani, R. (2010). Regularization paths for generalized linear models via coordinate descent. *Journal of Statistical Software, 33*(1), 1–22. https://doi.org/10.18637/jss.v033.i01
- Breiman, L. (2001). Random forests. *Machine Learning, 45*(1), 5–32. https://doi.org/10.1023/A:1010933404324
- Wright, M. N., & Ziegler, A. (2017). ranger: A fast implementation of random forests for high dimensional data in C++ and R. *Journal of Statistical Software, 77*(1), 1–17. https://doi.org/10.18637/jss.v077.i01
- Chen, T., & Guestrin, C. (2016). XGBoost: A scalable tree boosting system. In *Proceedings of the 22nd ACM SIGKDD International Conference on Knowledge Discovery and Data Mining*. https://doi.org/10.1145/2939672.2939785
- Robin, X., Turck, N., Hainard, A., Tiberti, N., Lisacek, F., Sanchez, J.-C., & Müller, M. (2011). pROC: An open-source package for R and S+ to analyze and compare ROC curves. *BMC Bioinformatics, 12*, 77. https://doi.org/10.1186/1471-2105-12-77
