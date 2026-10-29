# ML PD Model: Monotonic Constraints, SHAP & Calibration

Gradient boosting usually beats a scorecard at ranking borrowers, but a model-risk team will only approve it if it behaves sensibly, gives probabilities at the right level, and can explain every decline. This notebook builds a boosted PD model that meets those three conditions and measures what each one costs.

**What it does.** It builds a gradient-boosting PD model on the Home Credit loan applications, with features engineered in SQL from the credit-bureau, previous-application and instalment histories.

It compares an unconstrained LightGBM with one whose key risk drivers are forced to be monotonic, and measures what the constraints cost in accuracy and what they buy in behaviour. It then calibrates the PDs (Platt and isotonic) and explains every decision with TreeSHAP and reason codes.

**Data.** Home Credit Default Risk (Kaggle competition): 307,511 applications with 8.1% defaults, plus 1.7 million bureau records, 1.7 million previous applications and 13.6 million instalment payments.

**Methods.** DuckDB feature aggregation, a logistic-regression benchmark, LightGBM with and without `monotone_constraints`, and ICE-based monotonicity tests.

The calibration work covers class weighting and its effect on probabilities, and Platt scaling against isotonic regression, scored with the Brier score, expected calibration error and reliability curves. TreeSHAP gives global and local explanations.

**Key output.** Discrimination of the three models, the accuracy cost of monotonicity, calibration before and after, SHAP drivers, and an explained decision for a single applicant.

---

## Why it matters

Gradient boosting is the standard challenger to a scorecard, and model-risk teams accept it when it behaves monotonically, produces calibrated PDs and can be explained. On 307,511 Home Credit applications with SQL-built bureau and payment-history features, LightGBM beats logistic regression by 7 Gini points (0.556 vs 0.487); monotonic constraints cost 0.7 points. The ICE test caught that LightGBM's 'advanced' constraint method still allows reversals when the feature has missing values; the 'intermediate' method has none. Class weighting inflates PDs from 8% to 39%; Platt scaling restores calibration (ECE 0.4 points). Every decision is explained with TreeSHAP reason codes.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY` (shared setup cell) and Kaggle access: `KAGGLE_API_TOKEN` in `.env` or `~/.kaggle/access_token`; the Home Credit competition rules must be accepted on Kaggle.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 4 minutes (first run also downloads ~440 MB)).

## Data sources

| Data | Source |
|---|---|
| Home Credit Default Risk: application_train, bureau, previous_application, installments_payments | Kaggle competition `home-credit-default-risk` |

## Outputs (`outputs/`)

- `01_shap_monotonic_calibration.png`
- `02_ice_and_local_explanation.png`
- `approval_by_gender.csv`
- `calibration.csv`
- `discrimination.csv`
- `ice_monotonicity_violations.csv`
- `local_explanation.csv`
- `shap_importance.csv`

## Key assumptions

- Random 60/20/20 split (train / calibration / test); gender is excluded from the model and used only for monitoring.
- Monotonic constraints on 14 features with a clear economic direction; early stopping on an inner 15% of training.
- Platt and isotonic calibration fitted on the calibration sample only.

## Suggested commit plan

1. `add README and challenger-model framework`
2. `Kaggle download and DuckDB feature engineering`
3. `logistic benchmark and LightGBM with and without constraints`
4. `ICE monotonicity tests and calibration`
5. `TreeSHAP, reason codes, gender screen and executed outputs`

## References

### Finance and regulation

- Board of Governors of the Federal Reserve System. (2011). *Supervisory guidance on model risk management* (SR 11-7). https://www.federalreserve.gov/boarddocs/srletters/2011/sr1107.htm
- Lessmann, S., Baesens, B., Seow, H.-V., & Thomas, L. C. (2015). Benchmarking state-of-the-art classification algorithms for credit scoring: An update of research. *European Journal of Operational Research, 247*(1), 124–136. https://doi.org/10.1016/j.ejor.2015.05.030
- Bussmann, N., Giudici, P., Marinelli, D., & Papenbrock, J. (2021). Explainable machine learning in credit risk management. *Computational Economics, 57*(1), 203–216. https://doi.org/10.1007/s10614-020-10042-0

### Machine learning and deep learning

- Ke, G., Meng, Q., Finley, T., Wang, T., Chen, W., Ma, W., Ye, Q., & Liu, T.-Y. (2017). LightGBM: A highly efficient gradient boosting decision tree. *Advances in Neural Information Processing Systems, 30*. https://proceedings.neurips.cc/paper/2017/hash/6449f44a102fde848669bdd9eb6b76fa-Abstract.html
- Lundberg, S. M., Erion, G., Chen, H., DeGrave, A., Prutkin, J. M., Nair, B., … Lee, S.-I. (2020). From local explanations to global understanding with explainable AI for trees. *Nature Machine Intelligence, 2*(1), 56–67. https://doi.org/10.1038/s42256-019-0138-9
- Zadrozny, B., & Elkan, C. (2002). Transforming classifier scores into accurate multiclass probability estimates. In *Proceedings of the Eighth ACM SIGKDD International Conference on Knowledge Discovery and Data Mining*. https://doi.org/10.1145/775047.775151
- Goldstein, A., Kapelner, A., Bleich, J., & Pitkin, E. (2015). Peeking inside the black box: Visualizing statistical learning with plots of individual conditional expectation. *Journal of Computational and Graphical Statistics, 24*(1), 44–65. https://doi.org/10.1080/10618600.2014.907095
- Guo, C., Pleiss, G., Sun, Y., & Weinberger, K. Q. (2017). On calibration of modern neural networks. In *Proceedings of the 34th International Conference on Machine Learning*. https://arxiv.org/abs/1706.04599
