# Corporate Bankruptcy Prediction in R: Altman's Z-Score vs Logit, Elastic Net, Random Forests and XGBoost

**What it does:** puts the 1968 benchmark of corporate credit scoring, **Altman's Z-score**, against modern statistical learning on 43,000 firm-years of Polish companies with 64 financial ratios.
- **Classic scores:** Altman's Z′ for private firms, with its published coefficients and zones, and the same five ratios re-estimated by logistic regression.
- **Models on all 64 ratios:** a logit, an elastic net (`glmnet`), a random forest (`ranger`) and gradient boosting (`xgboost`).

The models are compared on discrimination, calibration and the cost of misclassification. Repeated stratified cross-validation and DeLong tests check whether the gains are real. The final test is **horizon**: a model fitted on one-year-ahead data has to warn two to five years before failure.
**Data:** UCI *Polish Companies Bankruptcy* (Tomczak, 2016): 2000–2013, five forecasting horizons, 64 ratios per firm-year, bankrupt status at the end of the horizon.
**Methods:** Altman Z′; logit; `glmnet` (α = 0.5, CV λ); `ranger` (500 trees, permutation importance); `xgboost` (early-stopped); `pROC` (DeLong); calibration by deciles; cost curves.
**Key output:** AUC, PR-AUC and Brier by model with confidence intervals; how often Altman's "distress zone" is right; the ratios that matter beyond Altman's five; and how far ahead each model sees failure.

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
