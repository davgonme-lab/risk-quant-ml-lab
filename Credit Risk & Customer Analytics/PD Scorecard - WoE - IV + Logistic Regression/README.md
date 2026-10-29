# PD Scorecard: WoE / IV + Logistic Regression

The points scorecard is decades old and still runs most retail and small-business lending, because a loan officer can read it and a regulator can audit it. This notebook builds one from scratch in Python, validates it the way a model-risk team would, and measures how much accuracy that transparency costs against a modern challenger.

**What it does.** It builds a classic application-style credit scorecard: monotonic optimal binning, weight of evidence (WoE) and information value (IV), a stepwise logistic regression on WoE, and points scaling.

It then validates the scorecard (Gini, KS, bootstrap confidence intervals, calibration, PSI), compares it with a LightGBM challenger, sets a cutoff, produces adverse-action reason codes and runs a fair-lending check.

**Data.** The UCI *Default of Credit Card Clients* dataset: 30,000 Taiwanese card holders, six months of repayment history and default on the next payment (`ucimlrepo`, with the UCI mirror on Kaggle as a fallback).

**Methods.** Chi-square-merged monotonic binning written by hand, WoE/IV, forward stepwise logistic regression with sign and VIF checks, and points scaled to 600 at 50:1 odds with 20 points to double the odds.

Validation uses ROC, Gini and KS with bootstrap intervals, Hosmer–Lemeshow and PSI. A LightGBM challenger, a DuckDB strategy table, ECOA-style reason codes and adverse-impact ratios complete the picture.

**Key output.** The scorecard points table, validation metrics with confidence intervals, the accuracy given up for interpretability, the cutoff strategy and the fair-lending check.

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

## References

### Finance and regulation

- Siddiqi, N. (2017). *Intelligent credit scoring: Building and implementing better credit risk scorecards* (2nd ed.). Wiley. https://doi.org/10.1002/9781119282396
- Thomas, L. C., Crook, J., & Edelman, D. (2017). *Credit scoring and its applications* (2nd ed.). SIAM. https://doi.org/10.1137/1.9781611974560
- Yeh, I.-C., & Lien, C.-H. (2009). The comparisons of data mining techniques for the predictive accuracy of probability of default of credit card clients. *Expert Systems with Applications, 36*(2), 2473–2480. https://doi.org/10.1016/j.eswa.2007.12.020
- Basel Committee on Banking Supervision. (2005). *Studies on the validation of internal rating systems* (Working Paper No. 14). Bank for International Settlements. https://www.bis.org/publ/bcbs_wp14.htm

### Machine learning and deep learning

- Hosmer, D. W., Lemeshow, S., & Sturdivant, R. X. (2013). *Applied logistic regression* (3rd ed.). Wiley. https://doi.org/10.1002/9781118548387
- Efron, B., & Tibshirani, R. J. (1993). *An introduction to the bootstrap*. Chapman & Hall. https://doi.org/10.1201/9780429246593
- Ke, G., Meng, Q., Finley, T., Wang, T., Chen, W., Ma, W., Ye, Q., & Liu, T.-Y. (2017). LightGBM: A highly efficient gradient boosting decision tree. *Advances in Neural Information Processing Systems, 30*. https://proceedings.neurips.cc/paper/2017/hash/6449f44a102fde848669bdd9eb6b76fa-Abstract.html
