# Estimating Asset Correlation from Forty Years of U.S. Bank Charge-Offs: Vasicek Maximum Likelihood versus the Basel Correlation Formula, the Procyclicality of Capital, and Machine-Learning Macro Default Models

The Basel IRB formula turns a probability of default into capital with one more number: the **asset correlation** R, the share of a borrower's risk that comes from a common factor, the economy. Basel fixes R by asset class (12–24% for corporates, 15% for mortgages, 4% for credit cards), calibrated in 2004 on limited data. If borrowers' defaults move together more than R assumes, capital covers less than the one-in-a-thousand-year loss it is meant to. This notebook estimates R from the default rates of U.S. banks' loan books since 1985, compares it with the Basel values, checks whether Basel capital would have covered the worst year observed, and asks how much of the common factor the macro economy explains with linear and machine-learning default models.

**What it does.**

1. It reads quarterly charge-off rates of all U.S. commercial banks by loan type (business, commercial real estate, single-family mortgages, credit cards, other consumer, farmland, leases, and all loans) since 1985 or 1991, and turns them into annual default rates with a loss-given-default assumption for each type.
2. It estimates the asset correlation of the Vasicek one-factor model three ways: the method of moments on probit-transformed default rates, maximum likelihood with a persistent (AR(1)) systematic factor, and a block bootstrap for confidence intervals.
3. It compares the estimates with Basel's R at the same long-run PD, computes the 99.9% default rate each implies, and the return period of the worst year actually observed.
4. It shows how capital would have moved over the cycle with point-in-time PDs.
5. It forecasts next year's default rate from macro variables (unemployment, growth, house prices, credit spreads, interest rates) with a linear factor model, LightGBM and a neural network, out of time from 2000, and measures how much systematic variance remains after the macro economy is accounted for: the correlation a point-in-time model should carry.

**Data.** Charge-off rates on loans and leases at all commercial banks by type (Federal Reserve, via FRED); unemployment, real GDP, house prices, the Baa–Treasury spread and the federal funds rate (FRED).

**Methods.** The Vasicek one-factor (asymptotic single-risk-factor) model, method-of-moments and maximum-likelihood estimation with an AR(1) latent factor, block bootstrap, the Basel IRB correlation functions, 99.9% conditional default rates, linear probit factor regression, LightGBM, a multilayer perceptron, and rolling-origin out-of-time tests.

**Key output.** Estimated asset correlations with confidence intervals by loan type against Basel's values; implied and observed worst-year default rates; capital through the cycle; and the out-of-time accuracy and residual correlation of the macro default models.

---

## Why it matters

Basel turns a PD into capital with a fixed asset correlation per asset class. Estimated from forty years of U.S. bank default rates, the correlation is well below Basel's for business loans (7.7% against 17%), consumer loans, cards and leases, but above it for commercial real estate (25.5%) and mortgages (33%), where losses are driven by property prices; measured by delinquencies instead of charge-offs, the mortgage correlation is only 6%, so the tail is in loss severity rather than defaults. Basel's 99.9% default rate exceeded the worst year for every book. Point-in-time PDs make capital swing from 4.5% to 10.7% of business-loan exposure over the cycle, and macro models explain most of the common factor, leaving a residual correlation of 1–2% for business loans and cards; machine learning adds little over a linear factor model.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY` (charge-off and delinquency rates, macro variables).
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (under a minute on CPU).

## Data sources

| Data | Source |
|---|---|
| Charge-off and delinquency rates on loans and leases, all commercial banks, by loan type (Federal Reserve via FRED) | https://fred.stlouisfed.org/ |
| Unemployment, real GDP, house prices, Baa spread and federal funds rate (FRED) | https://fred.stlouisfed.org/ |

## Outputs (`outputs/`)

- `01_asset_correlation.png`
- `asset_correlation_estimates.csv`
- `capital_through_the_cycle.csv`
- `dashboard.html`
- `dashboard.png`
- `default_rates_summary.csv`
- `lgd_sensitivity.csv`
- `macro_default_model_accuracy.csv`
- `residual_correlation.csv`
- `worst_year_coverage.csv`

## Key assumptions

- Default rate = charge-off rate / LGD (business and leases 45%, CRE and farmland 35%, mortgages 25%, cards 85%, other consumer 60%), annual averages of complete years, floored at 1bp; sensitivity with LGD ±15 points and with delinquency rates.
- R from the variance of probit default rates, R = σ²/(1 + σ²), by moments and by MLE with an AR(1) systematic factor; 90% intervals from a 4-year block bootstrap.
- Macro default models forecast the next four quarters' probit default rate, trained on all earlier data and tested each year from 2000; residual correlation from non-overlapping year-end errors.

## Suggested commit plan

1. `asset-correlation-vasicek-basel: add charge-off and delinquency rates and annual default rates`
2. `asset-correlation-vasicek-basel: add Vasicek moment and AR(1) MLE estimates of asset correlation with bootstrap`
3. `asset-correlation-vasicek-basel: add Basel comparison, worst-year coverage and LGD sensitivity`
4. `asset-correlation-vasicek-basel: add point-in-time capital and out-of-time macro default models`
5. `asset-correlation-vasicek-basel: add charts, dashboard and narrative`

## References

### Finance and regulation

- Vasicek, O. (2002). The distribution of loan portfolio value. *Risk, 15*(12), 160–162.
- Gordy, M. B. (2003). A risk-factor model foundation for ratings-based bank capital rules. *Journal of Financial Intermediation, 12*(3), 199–232. https://doi.org/10.1016/S1042-9573(03)00040-8
- Lopez, J. A. (2004). The empirical relationship between average asset correlation, firm probability of default, and asset size. *Journal of Financial Intermediation, 13*(2), 265–283. https://doi.org/10.1016/S1042-9573(03)00045-7
- Basel Committee on Banking Supervision. (2005). *An explanatory note on the Basel II IRB risk weight functions*. Bank for International Settlements. https://www.bis.org/bcbs/irbriskweight.htm
- Repullo, R., Saurina, J., & Trucharte, C. (2010). Mitigating the pro-cyclicality of Basel II. *Economic Policy, 25*(64), 659–702. https://doi.org/10.1111/j.1468-0327.2010.00252.x
- Board of Governors of the Federal Reserve System. (2026). *Charge-off and delinquency rates on loans and leases at commercial banks* [Data set]. Federal Reserve Bank of St. Louis (FRED). https://fred.stlouisfed.org/

### Machine learning and statistics

- Künsch, H. R. (1989). The jackknife and the bootstrap for general stationary observations. *The Annals of Statistics, 17*(3), 1217–1241. https://doi.org/10.1214/aos/1176347265
- Ke, G., Meng, Q., Finley, T., Wang, T., Chen, W., Ma, W., Ye, Q., & Liu, T.-Y. (2017). LightGBM: A highly efficient gradient boosting decision tree. *Advances in Neural Information Processing Systems, 30*. https://proceedings.neurips.cc/paper/2017/hash/6449f44a102fde848669bdd9eb6b76fa-Abstract.html
