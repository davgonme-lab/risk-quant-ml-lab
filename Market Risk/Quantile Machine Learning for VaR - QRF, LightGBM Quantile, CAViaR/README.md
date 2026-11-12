# Quantile Machine Learning for VaR: QRF, LightGBM Quantile, CAViaR

A classical VaR engine models the whole return distribution and then reads the loss quantile off it. Validation teams increasingly add challenger models that forecast the quantile directly. The question is whether that extra flexibility gives a better-calibrated VaR, or just more ways to overfit. This notebook runs the comparison over eleven years of walk-forward forecasts.

**What it does.** It forecasts the daily 99% and 97.5% Value-at-Risk of a multi-asset portfolio directly as a conditional quantile, with machine-learning and econometric quantile models, and asks whether they beat the standard VaR engines out of sample.

**Data.** Daily total-return prices of an eight-ETF multi-asset portfolio (Yahoo Finance) and market indicators from FRED: VIX, Baa credit spread, 10-year Treasury yield and the 2s10s slope.

**Methods.** Linear quantile regression, the Quantile Random Forest (Meinshausen 2006), LightGBM with the quantile loss and the CAViaR asymmetric-slope model (Engle & Manganelli 2004), against historical simulation and GJR-GARCH-t, in an annual walk-forward from 2015 to 2026.

**Key output.** Pinball-loss rankings, coverage and independence tests including the Dynamic Quantile test, VaR paths through the 2020 and 2022 stress episodes, and what the models learn from market indicators.

---

## Why it matters

Quantile models forecast VaR directly and are natural challengers in model validation. Over a 2015–2026 walk-forward, CAViaR and QRF pass every test at 99% and linear quantile regression wins at 97.5%, while LightGBM with the quantile loss is badly calibrated in the tail: a useful, documented result for a model-risk committee.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 3 minutes).

## Data sources

| Data | Source |
|---|---|
| ETF total-return prices (eight-ETF multi-asset portfolio) | Yahoo Finance via `yfinance` |
| `VIXCLS`, `BAA10Y`, `DGS10`, `T10Y2Y` | https://fred.stlouisfed.org |

## Outputs (`outputs/`)

- `01_var_paths_stress.png`
- `02_pinball_and_coverage.png`
- `03_what_the_models_learn.png`
- `quantile_var_scores.csv`
- `var_forecasts_walk_forward.csv`

## Key assumptions

- Annual walk-forward re-estimation, expanding window, fixed hyper-parameters.
- QRF implemented from scikit-learn leaves with Meinshausen weights (min. 40 observations per leaf).
- CAViaR asymmetric-slope estimated by random search + Nelder–Mead on the pinball loss.

## Suggested commit plan

1. `add README and quantile-loss framework`
2. `portfolio and market-indicator features`
3. `QRF, LightGBM quantile, linear QR and CAViaR`
4. `walk-forward estimation with HS and GARCH benchmarks`
5. `pinball, Kupiec, Christoffersen and DQ evaluation with executed outputs`

## References

### Finance and regulation

- Engle, R. F., & Manganelli, S. (2004). CAViaR: Conditional autoregressive value at risk by regression quantiles. *Journal of Business & Economic Statistics, 22*(4), 367–381. https://doi.org/10.1198/073500104000000370
- Kupiec, P. H. (1995). Techniques for verifying the accuracy of risk measurement models. *The Journal of Derivatives, 3*(2), 73–84. https://doi.org/10.3905/jod.1995.407942
- Christoffersen, P. F. (1998). Evaluating interval forecasts. *International Economic Review, 39*(4), 841–862. https://doi.org/10.2307/2527341
- Glosten, L. R., Jagannathan, R., & Runkle, D. E. (1993). On the relation between the expected value and the volatility of the nominal excess return on stocks. *The Journal of Finance, 48*(5), 1779–1801. https://doi.org/10.1111/j.1540-6261.1993.tb05128.x
- Gneiting, T. (2011). Making and evaluating point forecasts. *Journal of the American Statistical Association, 106*(494), 746–762. https://doi.org/10.1198/jasa.2011.r10138

### Machine learning and deep learning

- Koenker, R., & Bassett, G. (1978). Regression quantiles. *Econometrica, 46*(1), 33–50. https://doi.org/10.2307/1913643
- Meinshausen, N. (2006). Quantile regression forests. *Journal of Machine Learning Research, 7*, 983–999. https://jmlr.org/papers/v7/meinshausen06a.html
- Ke, G., Meng, Q., Finley, T., Wang, T., Chen, W., Ma, W., Ye, Q., & Liu, T.-Y. (2017). LightGBM: A highly efficient gradient boosting decision tree. *Advances in Neural Information Processing Systems, 30*. https://proceedings.neurips.cc/paper/2017/hash/6449f44a102fde848669bdd9eb6b76fa-Abstract.html
