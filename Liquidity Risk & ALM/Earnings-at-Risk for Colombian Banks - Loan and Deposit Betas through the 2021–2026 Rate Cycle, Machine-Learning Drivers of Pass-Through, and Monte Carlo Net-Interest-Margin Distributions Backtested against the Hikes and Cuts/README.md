# Earnings-at-Risk for Colombian Banks: Loan and Deposit Betas through the 2021–2026 Rate Cycle, Machine-Learning Drivers of Pass-Through, and Monte Carlo Net-Interest-Margin Distributions Backtested against the Hikes and Cuts

Earnings-at-risk (EaR) asks how much a bank's net interest income could fall over the next year if interest rates move against it. The answer depends on two sets of numbers that are hard to observe: how fast and how fully each bank passes rate changes through to its loans and to its deposits (its *betas*), and how far rates can plausibly move. Colombia offers an unusually informative test. Banco de la República cut its policy rate to 1.75% in 2020–2021, raised it to 13.25% by 2023, cut it to 9.25% by 2025 and raised it again to 12.25% in 2026. Each bank's loan yields and funding costs over these swings are published monthly, so betas can be measured bank by bank, their drivers modelled, and EaR forecasts checked against what actually happened.

**What it does.**

1. It downloads monthly balances and interest income and expense for every Colombian bank (2016–2026) and the deposit-rate reports with each bank's savings and CDT rates (2018–2026).
2. It measures, for each bank, the share of the policy-rate move passed through to its loan yield, deposit cost, savings rate and new-CDT rate in the 2021–2023 hiking cycle and the 2023–2025 cutting cycle, and how the net interest margin moved.
3. It models the monthly change in each bank's deposit cost from past policy-rate changes and bank characteristics (deposit mix, size, loan mix, capital) with a pooled distributed-lag model, the same model with characteristic interactions, and LightGBM, trained up to 2023 and tested on 2024–2026, and explains the LightGBM forecasts with tree SHAP values.
4. It simulates 5,000 twelve-month paths of the policy rate from a mean-reverting model with momentum, propagates them to each bank's loan yield and deposit cost through its shrunk betas, and reads off the distribution of its net interest margin: the expected margin, the 5th percentile and the earnings-at-risk.
5. It backtests the same procedure as of December 2021 (before the hikes) and December 2023 (before the cuts): were the banks' realised margins inside their forecast ranges?

**Data.** Superintendencia Financiera de Colombia via datos.gov.co: *Información financiera con fines de supervisión – CUIF por moneda* (mxk5-ce6w) and *Tasas de interés de captación y operaciones del mercado monetario* (axk9-g2nh).

**Methods.** Cycle betas, distributed-lag pass-through models with bank characteristics, LightGBM with out-of-time validation and tree SHAP explanations, empirical-Bayes shrinkage, a mean-reverting rate model with momentum and bootstrapped residuals, Monte Carlo net-interest-margin simulation, and forecast-interval backtests.

**Key output.** Each bank's loan and deposit betas in both directions; out-of-sample accuracy of the pass-through models and what drives them; each bank's twelve-month margin distribution and earnings-at-risk today; and the coverage of the forecast ranges in two historical backtests.

---

## Why it matters

Across 30 Colombian banks, funding costs moved more than loan yields in both directions: in the 2021–2023 hikes the median bank's deposit beta was 0.79 against a loan beta of 0.53 and its margin fell 1.4 points, and in the 2023–2025 cuts it recovered 0.8. Deposit pass-through is fast and symmetric (93% within six months; no lower betas in the cuts), and a simple distributed-lag model beat LightGBM out of time. Rate-driven earnings-at-risk is small (4–75 bp of assets) next to margin changes that rates do not explain, and backtests from December 2021 and December 2023 show that the statistical rate forecast, not the bank models, missed both turning points.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY` in `.env` (required by the shared setup cell; the data themselves need no key).
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 3 minutes the first time (data download), about 1 minute afterwards).

## Data sources

| Data | Source |
|---|---|
| CUIF supervisory accounts by currency (Superintendencia Financiera via datos.gov.co) | https://www.datos.gov.co/d/mxk5-ce6w |
| Deposit and money-market interest rates (Superintendencia Financiera via datos.gov.co) | https://www.datos.gov.co/d/axk9-g2nh |

## Outputs (`outputs/`)

- `01_ear_colombia.png`
- `backtest_by_bank.csv`
- `backtest_summary.csv`
- `betas_by_bank.csv`
- `betas_by_cycle_summary.csv`
- `dashboard.html`
- `dashboard.png`
- `ear_by_bank.csv`
- `lightgbm_shap_shares.csv`
- `passthrough_models_out_of_time.csv`
- `pooled_lag_model.csv`
- `rate_model.csv`

## Key assumptions

- Banks (entity type 1) with at least COP 1 trillion of assets; monthly accounting yields and costs smoothed over three months; effective annual deposit rates converted to nominal; policy proxy = repo rate with Banco de la República.
- Cycle betas between August 2021 and August 2023 (hikes) and November 2023 and September 2025 (cuts); pass-through models trained to December 2023 and tested from January 2024.
- Rate paths from a momentum and mean-reversion model with bootstrapped residuals (5,000 paths, floor 0.5%); bank betas shrunk by empirical Bayes; balances fixed; investments and other items held at their current contribution; non-rate margin changes bootstrapped from each bank's history.

## Suggested commit plan

1. `ear-colombian-banks: add supervisory accounts and deposit-rate data for Colombian banks`
2. `ear-colombian-banks: add loan and deposit betas by bank over the hiking and cutting cycles`
3. `ear-colombian-banks: add out-of-time pass-through models with SHAP explanations`
4. `ear-colombian-banks: add Monte Carlo earnings-at-risk and backtests`
5. `ear-colombian-banks: add charts, dashboard and narrative`

## References

- Basel Committee on Banking Supervision. (2016). *Standards: Interest rate risk in the banking book*. Bank for International Settlements. https://www.bis.org/bcbs/publ/d368.htm
- Drechsler, I., Savov, A., & Schnabl, P. (2017). The deposits channel of monetary policy. *Quarterly Journal of Economics*, 132(4), 1819–1876. https://doi.org/10.1093/qje/qjx019
- Efron, B., & Morris, C. (1973). Stein's estimation rule and its competitors—An empirical Bayes approach. *Journal of the American Statistical Association*, 68(341), 117–130. https://doi.org/10.1080/01621459.1973.10481350
- Hutchison, D. E., & Pennacchi, G. G. (1996). Measuring rents and interest rate risk in imperfect financial markets: The case of retail bank deposits. *Journal of Financial and Quantitative Analysis*, 31(3), 399–417. https://doi.org/10.2307/2331398
- Ke, G., Meng, Q., Finley, T., Wang, T., Chen, W., Ma, W., Ye, Q., & Liu, T.-Y. (2017). LightGBM: A highly efficient gradient boosting decision tree. In *Advances in Neural Information Processing Systems 30* (pp. 3146–3154).
- Lundberg, S. M., Erion, G., Chen, H., DeGrave, A., Prutkin, J. M., Nair, B., Katz, R., Himmelfarb, J., Bansal, N., & Lee, S.-I. (2020). From local explanations to global understanding with explainable AI for trees. *Nature Machine Intelligence*, 2(1), 56–67. https://doi.org/10.1038/s42256-019-0138-9
- Neumark, D., & Sharpe, S. A. (1992). Market structure and the nature of price rigidity: Evidence from the market for consumer deposits. *Quarterly Journal of Economics*, 107(2), 657–680. https://doi.org/10.2307/2118485
- Superintendencia Financiera de Colombia. (2026). *Información financiera con fines de supervisión – CUIF por moneda* and *Tasas de interés de captación y operaciones del mercado monetario* [Data sets]. datos.gov.co. https://www.datos.gov.co
