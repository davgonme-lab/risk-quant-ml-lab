# PD Scorecard in R

**What it does:** builds a full application-style credit scorecard for 30,000 credit-card clients in R. It filters variables by information value, bins them with monotonic weight of evidence, fits a logistic regression on the WoE values, scales it to points, validates it on a hold-out sample with Gini, KS, calibration and population stability, and sets an approval cutoff from expected losses.
**Data:** the UCI *Default of Credit Card Clients* dataset (Yeh & Lien, 2009): 30,000 Taiwanese card holders, six months of repayment status, bill and payment amounts, and default in the following month. Downloaded from the UCI archive, or from UCI's mirror on Kaggle if the archive is unreachable.
**Methods:** `scorecard` (variable filter, `woebin` binning with manual monotonic adjustments, `scorecard` points, `perf_eva`, `perf_psi`); logistic regression with stepwise AIC selection; `pROC` for ROC and the DeLong confidence interval of the AUC; score-band calibration; an expected-loss cutoff.
**Key output:** the IV ranking, WoE tables, model coefficients, the points table, train/test Gini and KS, PSI, calibration by score band, and the approval cutoff with its approval rate and expected loss.

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
