# Model Validation & MLOps Capstone for a PD Model

A credit model is not ready to use just because it scores well on a test set. Before a model-risk committee signs off, an independent validator has to show that it ranks borrowers well, that its PDs are at the right level, that the population it will score looks like the one it was built on, and that every result can be reproduced. This notebook runs that full review on a real PD model.

**What it does.** It builds a LightGBM application PD model with monotone constraints and takes it through the full independent-validation and MLOps cycle.

That means experiment tracking and a model registry in MLflow, a champion–challenger comparison, and the standard validation tests: discrimination with confidence intervals, calibration, stability, segment performance, sensitivity, monotonicity and fairness.

It then monitors population stability on the real production population, summarises everything in traffic lights and generates a model card automatically.

**Data.** Home Credit Default Risk (Kaggle): 307,511 labelled applications for development, and **48,744 unlabelled applications** from the competition's test file, used as the first month of "production" for drift monitoring.

**Methods.** A DuckDB feature pipeline, LightGBM with monotonic constraints and Platt calibration (champion) against a logistic regression without WoE (challenger), and MLflow tracking, model logging and registry.

The tests include bootstrap AUC and a DeLong-style comparison, Hosmer–Lemeshow, Brier, ECE and calibration-in-the-large, PSI and characteristic stability indices, ICE monotonicity, stressed-input sensitivity and the adverse-impact ratio.

**Key output.** A validation scorecard with green, amber and red ratings, the drift report for the production population, and a model card ready for a model-risk committee.

---

## Why it matters

A model is only usable once it has been independently validated and can be reproduced. The Home Credit PD champion passes discrimination (Gini 0.536 vs 0.485 for the challenger), overall calibration and fairness, and is logged, registered and reloaded identically in MLflow. The validation finds two issues a committee would act on: a red characteristic-stability index for the loan term in the production population, hidden behind a near-zero score PSI, and miscalibration for state servants. A model card is generated automatically.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY` (shared setup cell) and Kaggle access: `KAGGLE_API_TOKEN` in `.env` or `~/.kaggle/access_token`; the Home Credit competition rules must be accepted on Kaggle.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 3 minutes).

## Data sources

| Data | Source |
|---|---|
| Home Credit Default Risk: application_train, application_test, bureau, previous_application, installments_payments | Kaggle competition `home-credit-default-risk` |

## Outputs (`outputs/`)

- `01_stability_calibration_traffic_lights.png`
- `characteristic_stability.csv`
- `discrimination_calibration.csv`
- `model_card.md`
- `segment_performance.csv`
- `sensitivity.csv`
- `validation_traffic_lights.csv`

## Key assumptions

- Random 60/20/20 split; application_test (no labels) used as the first production population for stability monitoring.
- MLflow tracking in a local SQLite store under `data/` (not committed).
- Traffic-light thresholds: Gini 0.40/0.30, PSI 0.10/0.25, adverse-impact ratio 0.80/0.70, ECE 1/2 pp; monotonicity reversals below 0.1 pp treated as immaterial.

## Suggested commit plan

1. `add README and validation framework`
2. `shared SQL feature pipeline for development and production`
3. `champion and challenger with MLflow tracking and registry`
4. `validation tests: discrimination, calibration, stability, segments, sensitivity, fairness`
5. `traffic lights, model card and executed outputs`

## References

### Finance and regulation

- Board of Governors of the Federal Reserve System. (2011). *Supervisory guidance on model risk management* (SR 11-7). https://www.federalreserve.gov/boarddocs/srletters/2011/sr1107.htm
- Basel Committee on Banking Supervision. (2005). *Studies on the validation of internal rating systems* (Working Paper No. 14). Bank for International Settlements. https://www.bis.org/publ/bcbs_wp14.htm
- Siddiqi, N. (2017). *Intelligent credit scoring: Building and implementing better credit risk scorecards* (2nd ed.). Wiley. https://doi.org/10.1002/9781119282396
- Hosmer, D. W., Lemeshow, S., & Sturdivant, R. X. (2013). *Applied logistic regression* (3rd ed.). Wiley. https://doi.org/10.1002/9781118548387

### Machine learning and deep learning

- DeLong, E. R., DeLong, D. M., & Clarke-Pearson, D. L. (1988). Comparing the areas under two or more correlated receiver operating characteristic curves: A nonparametric approach. *Biometrics, 44*(3), 837–845. https://doi.org/10.2307/2531595
- Ke, G., Meng, Q., Finley, T., Wang, T., Chen, W., Ma, W., Ye, Q., & Liu, T.-Y. (2017). LightGBM: A highly efficient gradient boosting decision tree. *Advances in Neural Information Processing Systems, 30*. https://proceedings.neurips.cc/paper/2017/hash/6449f44a102fde848669bdd9eb6b76fa-Abstract.html
- Goldstein, A., Kapelner, A., Bleich, J., & Pitkin, E. (2015). Peeking inside the black box: Visualizing statistical learning with plots of individual conditional expectation. *Journal of Computational and Graphical Statistics, 24*(1), 44–65. https://doi.org/10.1080/10618600.2014.907095
- Mitchell, M., Wu, S., Zaldivar, A., Barnes, P., Vasserman, L., Hutchinson, B., … Gebru, T. (2019). Model cards for model reporting. In *Proceedings of the Conference on Fairness, Accountability, and Transparency*. https://doi.org/10.1145/3287560.3287596
