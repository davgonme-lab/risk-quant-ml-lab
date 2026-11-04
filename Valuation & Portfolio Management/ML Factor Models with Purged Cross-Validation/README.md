# ML Factor Models with Purged Cross-Validation

A backtest is only as honest as the way it was validated. In financial data, shuffling rows into folds lets a model peek at information from the same month or from overlapping windows, and the result can look far better than it will ever do live. This notebook measures how big that illusion is for four model families, against purged validation and a true walk-forward test.

**What it does.** It predicts next-month returns of the 49 Fama–French industry portfolios from factor characteristics with linear, elastic-net, gradient-boosting and neural-network models.

It then shows how much the usual shuffled cross-validation **overstates** their skill compared with purged, embargoed cross-validation and a true walk-forward test.

**Data.** The Kenneth French Data Library: monthly returns of 49 value-weighted industry portfolios, the Fama–French 5 factors and momentum, 1990–2026. The VIX index (Yahoo Finance) is a market-state feature.

**Methods.** Rolling characteristics (momentum, reversal, volatility, factor betas), OLS, Elastic Net, LightGBM and an MLP.

Three validation designs are compared: shuffled K-fold, purged group K-fold with an embargo (López de Prado, 2018) and an expanding walk-forward. Skill is measured by information coefficients, out-of-sample R² and long–short portfolio Sharpe ratios.

**Key output.** The size of the leakage bias by model and metric, walk-forward performance against a plain momentum sort, and feature importance.

---

## Why it matters

Model validation has to catch leakage before it reaches a committee. On the 49 Fama–French industries, shuffled K-fold gives LightGBM an impossible 34% R², because market-state features identify the month. Purged and embargoed CV and a walk-forward test bring every model's R² to about zero. Ranking skill survives for LightGBM and the MLP (long–short Sharpe 0.4–0.5 vs 0.2 for momentum).

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 2 minutes).

## Data sources

| Data | Source |
|---|---|
| 49 industry portfolios, Fama–French 5 factors and momentum | https://mba.tuck.dartmouth.edu/pages/faculty/ken.french/data_library.html |
| VIX (`VIXCLS`) | https://fred.stlouisfed.org |

## Outputs (`outputs/`)

- `01_leakage_gap.png`
- `02_walk_forward_and_importance.png`
- `validation_scores.csv`
- `walk_forward_predictions.csv`

## Key assumptions

- Monthly value-weighted industry returns 1990–2026; characteristics ranked cross-sectionally each month.
- Purged K-fold with a 12-month embargo; walk-forward refits every January from 2000 with a one-month gap.
- Fixed hyper-parameters; long–short returns gross of costs.

## Suggested commit plan

1. `add README and validation framework`
2. `Ken French and FRED ETL`
3. `characteristics and factor betas`
4. `four models under shuffled, purged and walk-forward CV`
5. `leakage diagnostics and executed outputs`

## References

### Finance and regulation

- Fama, E. F., & French, K. R. (2015). A five-factor asset pricing model. *Journal of Financial Economics, 116*(1), 1–22. https://doi.org/10.1016/j.jfineco.2014.10.010
- Moskowitz, T. J., & Grinblatt, M. (1999). Do industries explain momentum? *The Journal of Finance, 54*(4), 1249–1290. https://doi.org/10.1111/0022-1082.00146
- Harvey, C. R., Liu, Y., & Zhu, H. (2016). … and the cross-section of expected returns. *The Review of Financial Studies, 29*(1), 5–68. https://doi.org/10.1093/rfs/hhv059
- Campbell, J. Y., & Thompson, S. B. (2008). Predicting excess stock returns out of sample: Can anything beat the historical average? *The Review of Financial Studies, 21*(4), 1509–1531. https://doi.org/10.1093/rfs/hhm055
- Gu, S., Kelly, B., & Xiu, D. (2020). Empirical asset pricing via machine learning. *The Review of Financial Studies, 33*(5), 2223–2273. https://doi.org/10.1093/rfs/hhaa009

### Machine learning and deep learning

- Arlot, S., & Celisse, A. (2010). A survey of cross-validation procedures for model selection. *Statistics Surveys, 4*, 40–79. https://doi.org/10.1214/09-SS054
- Bergmeir, C., & Benítez, J. M. (2012). On the use of cross-validation for time series predictor evaluation. *Information Sciences, 191*, 192–213. https://doi.org/10.1016/j.ins.2011.12.028
- Zou, H., & Hastie, T. (2005). Regularization and variable selection via the elastic net. *Journal of the Royal Statistical Society: Series B, 67*(2), 301–320. https://doi.org/10.1111/j.1467-9868.2005.00503.x
- Ke, G., Meng, Q., Finley, T., Wang, T., Chen, W., Ma, W., Ye, Q., & Liu, T.-Y. (2017). LightGBM: A highly efficient gradient boosting decision tree. *Advances in Neural Information Processing Systems, 30*. https://proceedings.neurips.cc/paper/2017/hash/6449f44a102fde848669bdd9eb6b76fa-Abstract.html
