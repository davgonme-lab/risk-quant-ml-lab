# CAPM, the Security Market Line and Betas in R: Rolling OLS, Kalman Filter, Bayesian Shrinkage and Machine Learning

Beta is everywhere in finance: in the cost of equity, in hedge ratios, in performance attribution. Yet it is never observed, and a five-year estimate is noisy and drifts. This notebook uses sixty years of U.S. returns to ask whether the CAPM actually holds, and which way of estimating beta best predicts the beta that follows.

**What it does.** It uses 60 years of U.S. portfolio returns to answer two questions about beta.

1. **Does the CAPM hold?** The security market line is tested on ten beta-sorted portfolios with time-series alphas, the GRS test and Fama–MacBeth cross-sectional regressions.
2. **How should beta be estimated?** Six forecasts of each of 49 industries' beta over the next three years are compared out of sample: rolling OLS, the Blume adjustment, Vasicek's Bayesian shrinkage, a **Kalman filter** with time-varying beta (written from scratch), a **random forest** and **XGBoost**.

**Data.** The Kenneth French Data Library (monthly market factor and risk-free rate, 49 value-weighted industry portfolios, and portfolios formed on market beta, all since 1963).

**Methods.** OLS and Newey–West, the GRS F-test, Fama–MacBeth (plain t-statistics, no Shanken correction), a random-walk-beta state-space model by maximum likelihood, empirical-Bayes shrinkage, and `ranger` and `xgboost` with a rolling panel design.

**Key output.** The empirical SML against the CAPM line, alphas by beta decile, and the forecast error of each beta method.

---

## Why it matters

Beta sets the cost of equity, hedge ratios and performance attribution, yet it is estimated with noise and is not what the CAPM says it should be paid. On 63 years of Kenneth French data, the security market line is too flat: low-beta portfolios earn a +2.5% annual alpha, the GRS test rejects the CAPM (p = 0.03) and Fama–MacBeth prices beta at 2.9% a year against a 7.1% market premium. Forecasting each of 49 industries' next-36-month beta, XGBoost, Blume, random forests, a pooled Kalman filter and Vasicek shrinkage all beat raw 60-month OLS (by 6–15% in MSE), but ML gains only about a point over the one-line Blume rule.

## How to run

1. `conda activate quant-risk`. `.env` needs nothing (Kenneth French data are public).
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 2 minutes).

## Data sources

| Data | Source |
|---|---|
| Fama–French factors, 49 industry portfolios, portfolios formed on beta (Kenneth French Data Library) | https://mba.tuck.dartmouth.edu/pages/faculty/ken.french/data_library.html |

## Outputs (`outputs/`)

- `01_capm_sml_betas.png`
- `beta_decile_alphas.csv`
- `beta_forecast_scores.csv`
- `dashboard.html`
- `dashboard.png`
- `fama_macbeth.csv`
- `industry_betas_latest.csv`
- `kalman_parameters.csv`
- `rf_feature_importance.csv`
- `sml_by_decade.csv`

## Key assumptions

- Monthly value-weighted returns, July 1963 to the latest month; 60-month estimation windows.
- Kalman model: random-walk beta, measurement variance per industry, beta-noise variance pooled across industries, both estimated before 1985.
- Beta forecasts made every December from 1985; ML trained only on industry-years whose 36-month target window had ended.

## Suggested commit plan

1. `capm-betas-r: add Kenneth French data loader and SML tests (alphas, GRS, Fama–MacBeth)`
2. `capm-betas-r: add Kalman-filter betas and Vasicek shrinkage`
3. `capm-betas-r: add out-of-sample beta forecast comparison with random forest and XGBoost`

## References

### Finance and regulation

- Sharpe, W. F. (1964). Capital asset prices: A theory of market equilibrium under conditions of risk. *The Journal of Finance, 19*(3), 425–442. https://doi.org/10.1111/j.1540-6261.1964.tb02865.x
- Fama, E. F., & MacBeth, J. D. (1973). Risk, return, and equilibrium: Empirical tests. *Journal of Political Economy, 81*(3), 607–636. https://doi.org/10.1086/260061
- Gibbons, M. R., Ross, S. A., & Shanken, J. (1989). A test of the efficiency of a given portfolio. *Econometrica, 57*(5), 1121–1152. https://doi.org/10.2307/1913625
- Blume, M. E. (1971). On the assessment of risk. *The Journal of Finance, 26*(1), 1–10. https://doi.org/10.1111/j.1540-6261.1971.tb00584.x
- Vasicek, O. A. (1973). A note on using cross-sectional information in Bayesian estimation of security betas. *The Journal of Finance, 28*(5), 1233–1239. https://doi.org/10.1111/j.1540-6261.1973.tb01452.x
- Frazzini, A., & Pedersen, L. H. (2014). Betting against beta. *Journal of Financial Economics, 111*(1), 1–25. https://doi.org/10.1016/j.jfineco.2013.10.005

### Machine learning and deep learning

- Kalman, R. E. (1960). A new approach to linear filtering and prediction problems. *Journal of Basic Engineering, 82*(1), 35–45. https://doi.org/10.1115/1.3662552
- Wright, M. N., & Ziegler, A. (2017). ranger: A fast implementation of random forests for high dimensional data in C++ and R. *Journal of Statistical Software, 77*(1), 1–17. https://doi.org/10.18637/jss.v077.i01
- Chen, T., & Guestrin, C. (2016). XGBoost: A scalable tree boosting system. In *Proceedings of the 22nd ACM SIGKDD International Conference on Knowledge Discovery and Data Mining*. https://doi.org/10.1145/2939672.2939785
