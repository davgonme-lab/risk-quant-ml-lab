# ML PD Model: Monotonic Constraints, SHAP & Calibration

**What it does:** builds a gradient-boosting PD model on the Home Credit loan applications, with features engineered in SQL from the credit-bureau, previous-application and instalment histories. It compares an unconstrained LightGBM with one whose key risk drivers are forced to be monotonic, measures what the constraints cost in accuracy and what they buy in behaviour, calibrates the PDs (Platt and isotonic), and explains every decision with TreeSHAP and reason codes.
**Data:** Home Credit Default Risk (Kaggle competition): 307,511 applications with 8.1% defaults, plus 1.7 million bureau records, 1.7 million previous applications and 13.6 million instalment payments.
**Methods:** DuckDB feature aggregation; logistic-regression benchmark; LightGBM with and without `monotone_constraints`; ICE-based monotonicity tests; class weighting and its effect on calibration; Platt scaling vs isotonic regression with Brier score, expected calibration error and reliability curves; TreeSHAP global and local explanations.
**Key output:** discrimination of the three models; the accuracy cost of monotonicity; calibration before and after; SHAP drivers; and an explained decision for a single applicant.

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
