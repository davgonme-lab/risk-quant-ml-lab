# Monte Carlo Pricing Lab: GBM, Heston, Jumps + Variance Reduction

Monte Carlo is the engine behind exposure numbers and behind any product without a closed formula. Its results are only useful if they are precise enough, free of discretisation bias, and robust to the choice of model. This notebook calibrates three models to the same option market and measures all three properties.

**What it does.** It calibrates three models (Black–Scholes GBM, Heston stochastic volatility and Merton jump-diffusion) to today's SPY option smile, then prices European, Asian, barrier and digital options by Monte Carlo.

It measures how much each variance-reduction technique buys, how discretisation biases Heston, and how far exotic prices diverge between models that fit the same vanillas.

**Data.** An SPY option chain snapshot and spot (Yahoo Finance), Treasury yields for discounting (FRED), and dividends implied from put–call parity.

**Methods.** COS-method Heston and series Merton pricers for calibration, exact GBM and Merton simulation, and Heston Euler full-truncation and Andersen QE schemes.

The variance-reduction toolkit covers antithetic variates, control variates (geometric Asian, European), scrambled Sobol quasi-Monte Carlo with a Brownian bridge, and importance sampling, plus the Broadie–Glasserman–Kou correction for discrete barriers.

**Key output.** Convergence and efficiency of each technique against closed-form answers, Heston bias by time step, and a model-risk table for exotic prices.

---

## Why it matters

Every exposure and XVA number is a Monte Carlo estimate, so its error budget matters. Calibrated to today's SPY smile, the notebook shows that the right variance reduction (Sobol + control variate + antithetic) is worth about 100,000 plain paths. Heston Euler discretisation bias ($5.3 at monthly steps) is invisible in the standard errors, and two models that fit the same vanillas price a deep OTM digital 27% apart. That gap is the model-risk reserve.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 1–2 minutes).

## Data sources

| Data | Source |
|---|---|
| SPY option chain and spot | Yahoo Finance via `yfinance` |
| Treasury yields, T-bill, VIX | https://fred.stlouisfed.org |

## Outputs (`outputs/`)

- `01_calibrated_smiles.png`
- `02_variance_reduction.png`
- `03_heston_discretisation_bias.png`
- `04_model_risk_exotics.png`
- `calibrated_parameters.csv`
- `exotic_prices_by_model.csv`
- `heston_discretisation_bias.csv`
- `variance_reduction_study.csv`

## Key assumptions

- One intraday snapshot of the smile; forwards and dividend yields implied from put–call parity; American options treated as European.
- Heston and Merton calibrated separately (no Bates); flat rates per expiry.
- Reference values from 4 million paths; QMC error bars from 20 scramblings.

## Suggested commit plan

1. `add README and Monte Carlo framework`
2. `SPY chain ETL and smile calibration (Heston COS, Merton series)`
3. `variance-reduction study against closed forms`
4. `Heston Euler vs QE discretisation bias`
5. `exotic prices and model-risk table with executed outputs`

## References

### Finance and regulation

- Heston, S. L. (1993). A closed-form solution for options with stochastic volatility with applications to bond and currency options. *The Review of Financial Studies, 6*(2), 327–343. https://doi.org/10.1093/rfs/6.2.327
- Merton, R. C. (1976). Option pricing when underlying stock returns are discontinuous. *Journal of Financial Economics, 3*(1–2), 125–144. https://doi.org/10.1016/0304-405X(76)90022-2
- Andersen, L. (2008). Simple and efficient simulation of the Heston stochastic volatility model. *Journal of Computational Finance, 11*(3), 1–42. https://doi.org/10.21314/JCF.2008.189
- Broadie, M., Glasserman, P., & Kou, S. (1997). A continuity correction for discrete barrier options. *Mathematical Finance, 7*(4), 325–349. https://doi.org/10.1111/1467-9965.00035
- Fang, F., & Oosterlee, C. W. (2009). A novel pricing method for European options based on Fourier-cosine series expansions. *SIAM Journal on Scientific Computing, 31*(2), 826–848. https://doi.org/10.1137/080718061
- Kemna, A. G. Z., & Vorst, A. C. F. (1990). A pricing method for options based on average asset values. *Journal of Banking & Finance, 14*(1), 113–129. https://doi.org/10.1016/0378-4266(90)90039-5

### Machine learning and deep learning

- Glasserman, P. (2004). *Monte Carlo methods in financial engineering*. Springer. https://doi.org/10.1007/978-0-387-21617-1
- Sobol', I. M. (1967). On the distribution of points in a cube and the approximate evaluation of integrals. *USSR Computational Mathematics and Mathematical Physics, 7*(4), 86–112. https://doi.org/10.1016/0041-5553(67)90144-9
- Owen, A. B. (1997). Scrambled net variance for integrals of smooth functions. *The Annals of Statistics, 25*(4), 1541–1562. https://doi.org/10.1214/aos/1031594731
