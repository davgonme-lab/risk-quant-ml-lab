# Callable vs Puttable Bonds: Tree and Monte Carlo Valuation, ML Call Probabilities and Portfolio Optimisation

A callable bond lets the issuer repay early when rates fall, which is exactly when the investor would rather keep it. A puttable bond gives the investor the opposite right. One sign flip changes almost everything about how these bonds behave. This notebook values both, checks the engine against published durations for real municipal bonds, and builds a portfolio that earns yield without loading up on the callable bond's hidden risk.

**What it does.** It values bonds with embedded options with a Hull–White trinomial tree (QuantLib) and a Longstaff–Schwartz Monte Carlo cross-check.

It shows the key differences between the two: negative against positive convexity, opposite vega, and how price and duration react to rates. Machine learning then comes in four ways:

1. a **classifier of call-exercise probability** trained on optimal exercise decisions from simulated rate paths;
2. a **neural-network surrogate pricer** that values 7,500 real callable municipal bonds in seconds;
3. the surrogate's measure of how a rise in **volatility** changes their prices and yields;
4. a **portfolio optimiser** that targets yield while controlling negative convexity, stress-tested against rate and volatility shocks.

The engine is validated against the option-adjusted durations BlackRock publishes for the same bonds.

**Data.** iShares National Muni Bond ETF (MUB) holdings (prices, coupons, maturities, dated dates and the fund's option-adjusted and modified durations), the U.S. Treasury par yield curve, and the FRED 10-year yield for volatility.

**Methods.** A Hull–White one-factor tree (QuantLib `CallableFixedRateBond`, OAS, effective duration and convexity), Longstaff–Schwartz Monte Carlo, LightGBM and logistic classifiers, an MLP surrogate and linear programming (HiGHS).

**Key output.** Callable and puttable sensitivity profiles, the tree-against-Monte-Carlo check, agreement between model and published durations with the implied volatility, call probabilities by bond, the impact of +30% volatility on callable yields, and an optimised muni portfolio against a naive yield-maximiser under stress.

---

## Why it matters

Embedded options change how bonds react to rates and volatility, and munis are the largest callable market. The engine shows a callable's negative convexity (−78, down to −176 when rates fall) against a puttable's extra convexity, and reproduces BlackRock's option-adjusted durations for 1,500 municipal bonds with R² 0.96 at a 40 bp implied volatility. An MLP surrogate values all 7,023 munis in under a second, measures that a 30% rise in volatility costs callable munis 0.2–0.5 points, and feeds an optimiser whose option-aware portfolio earns 36 bp more OAS than a yield-maximiser and loses less under ±100 bp and volatility shocks.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 2.5 minutes).

## Data sources

| Data | Source |
|---|---|
| iShares National Muni Bond ETF (MUB) holdings with option-adjusted and modified durations | https://www.ishares.com/us/products/239766/ |
| U.S. Treasury par yield curve | https://home.treasury.gov/resource-center/data-chart-center/interest-rates |
| 10-year Treasury yield (volatility) | https://fred.stlouisfed.org |

## Outputs (`outputs/`)

- `01_callable_puttable_ml_portfolio.png`
- `call_probability_scores.csv`
- `callable_puttable_profiles.csv`
- `engine_vs_aladdin_oad.csv`
- `muni_bond_analytics.csv`
- `portfolio_optimisation.csv`
- `surrogate_test_error.csv`
- `tree_vs_lsm_check.csv`
- `volatility_impact_by_call_bucket.csv`

## Key assumptions

- Hull–White one-factor tree (QuantLib), a = 0.03; σ from the 10-year normal volatility, and the σ that best matches Aladdin OAD for munis.
- Municipal call convention: par call 10 years after the dated date, semi-annual thereafter.
- Call-probability labels from Longstaff–Schwartz optimal exercise.
- Surrogate trained on coupons 1–6%, maturities 1.5–35 years, OAS ±300 bp, σ 40–160 bp; twin-bond control variate for vega.

## Suggested commit plan

1. `add README and callable/puttable framework`
2. `Hull–White tree and Longstaff–Schwartz check`
3. `ML call-exercise probability`
4. `MUB data, engine vs Aladdin OAD`
5. `MLP surrogate and volatility impact`
6. `option-aware portfolio optimisation`

## References

### Finance and regulation

- Hull, J., & White, A. (1994). Numerical procedures for implementing term structure models I: Single-factor models. *The Journal of Derivatives, 2*(1), 7–16. https://doi.org/10.3905/jod.1994.407902
- Longstaff, F. A., & Schwartz, E. S. (2001). Valuing American options by simulation: A simple least-squares approach. *The Review of Financial Studies, 14*(1), 113–147. https://doi.org/10.1093/rfs/14.1.113
- Kalotay, A. J., Williams, G. O., & Fabozzi, F. J. (1993). A model for valuing bonds and embedded options. *Financial Analysts Journal, 49*(3), 35–46. https://doi.org/10.2469/faj.v49.n3.35
- Ang, A., Bhansali, V., & Xing, Y. (2010). Taxes on tax-exempt bonds. *The Journal of Finance, 65*(2), 565–601. https://doi.org/10.1111/j.1540-6261.2009.01545.x
- Brigo, D., & Mercurio, F. (2006). *Interest rate models: Theory and practice* (2nd ed.). Springer. https://doi.org/10.1007/978-3-540-34604-3

### Machine learning and deep learning

- Ke, G., Meng, Q., Finley, T., Wang, T., Chen, W., Ma, W., Ye, Q., & Liu, T.-Y. (2017). LightGBM: A highly efficient gradient boosting decision tree. *Advances in Neural Information Processing Systems, 30*. https://proceedings.neurips.cc/paper/2017/hash/6449f44a102fde848669bdd9eb6b76fa-Abstract.html
- Ferguson, R., & Green, A. (2018). Deeply learning derivatives. *arXiv*. https://arxiv.org/abs/1809.02233
- Huangfu, Q., & Hall, J. A. J. (2018). Parallelizing the dual revised simplex method. *Mathematical Programming Computation, 10*(1), 119–142. https://doi.org/10.1007/s12532-017-0130-5
