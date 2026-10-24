# PD Scorecard: WoE / IV + Logistic Regression

**What it does:** builds a classic application-style credit scorecard in Python from scratch: monotonic optimal binning, weight of evidence (WoE) and information value (IV), a stepwise logistic regression on WoE, and points scaling. It then validates it the way a model-risk team would (Gini, KS, bootstrap confidence intervals, calibration, PSI), compares it with a LightGBM challenger, sets a cutoff, produces adverse-action reason codes and runs a fair-lending check.
**Data:** the UCI *Default of Credit Card Clients* dataset: 30,000 Taiwanese card holders, six months of repayment history and default on the next payment (`ucimlrepo`, with the UCI mirror on Kaggle as a fallback).
**Methods:** chi-square-merged monotonic binning written by hand; WoE/IV; forward stepwise logistic regression with sign and VIF checks; 600 points at 50:1 odds and 20 points to double the odds; ROC/Gini/KS with bootstrap intervals; Hosmer–Lemeshow; PSI; LightGBM challenger; DuckDB strategy table; ECOA-style reason codes and adverse-impact ratios.
**Key output:** the scorecard points table; validation metrics and their confidence intervals; the accuracy given up for interpretability; the cutoff strategy; and the fair-lending check.

---

## Why it matters

The WoE/logistic scorecard is still the benchmark for retail and SME PD models. Built from scratch in Python, with hand-written monotonic binning, it reaches a hold-out Gini of 0.51 (95% CI 0.48–0.53) with nine characteristics, stable populations and correct signs. A LightGBM challenger is 6 Gini points better, which is the measured price of interpretability. The notebook also turns the score into a cutoff strategy (70% approval, 12.7% bad rate), adverse-action reason codes and a four-fifths-rule fair-lending check that the scorecard passes.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY` (shared setup cell) and Kaggle access: `KAGGLE_API_TOKEN` in `.env` or `~/.kaggle/access_token` (the Kaggle mirror is only used if the UCI site is unreachable).
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (under a minute).

## Data sources

| Data | Source |
|---|---|
| Default of Credit Card Clients (UCI dataset 350) | UCI Machine Learning Repository via `ucimlrepo`; mirror `uciml/default-of-credit-card-clients-dataset` on Kaggle |

## Outputs (`outputs/`)

- `01_iv_and_woe.png`
- `02_validation_and_strategy.png`
- `cutoff_strategy.csv`
- `fair_lending_check.csv`
- `information_value.csv`
- `principal_reason_codes.csv`
- `scorecard_points.csv`
- `validation_metrics.csv`

## Key assumptions

- Target: default on next month's payment; 70/30 stratified split; sex, marital status and age excluded from the model and used only for the fair-lending check.
- Chi-square-merged monotonic binning (max 6 bins, min 5% per bin); IV ≥ 0.02, WoE correlation ≤ 0.7, forward AIC, negative signs and VIF ≤ 5.
- Points: 600 at 50:1 odds, PDO 20; cutoff at 70% approval.

## Suggested commit plan

1. `add README and scorecard framework`
2. `data download and behavioural features`
3. `monotonic binning, WoE and IV`
4. `stepwise logistic model and points scaling`
5. `validation, challenger, cutoff, reason codes, fair-lending check and executed outputs`
