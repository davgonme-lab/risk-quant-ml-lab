# Non-Maturity Deposit Behaviour Modelling

Checking and savings accounts can be withdrawn any day, yet most of the money stays for years and earns a rate that barely follows the market. That makes them a bank's cheapest and most stable funding, until it is not: in 2022–2023 about a trillion dollars left U.S. bank deposits for money-market funds. This notebook estimates the two behaviours that decide how much risk sits in these deposits and turns them into the inputs an ALM model needs.

**What it does.** It models the two behaviours that decide how much interest-rate and liquidity risk sits in non-maturity deposits (NMDs):

- how much of a policy-rate move banks pass on to depositors (the **deposit beta**, which differs between hikes and cuts);
- how deposit **volumes** react to the gap between market and deposit rates.

It then turns them into the behavioural inputs an IRRBB or ALM model needs: the core share, the decay curve and the weighted average life.

**Data.** FDIC national deposit rates for savings, money-market and 12-month CDs, spliced across the 2021 methodology change, the effective fed funds rate, H.8 deposits, large and small time deposits, and retail money-market fund balances (all FRED).

**Methods.** Cycle betas and an asymmetric error-correction model (OLS), and a generalised additive model of deposit growth (statsmodels GAM with B-splines) against a linear benchmark.

A discrete-time proportional-hazards model (complementary log-log GLM, the monthly equivalent of Cox) with a time-varying rate gap runs on a synthetic account panel driven by the real rate path. An LSTM, ARIMA and a GAM-type regression are compared for forecasting deposit growth.

**Key output.** Betas by product and cycle, the nonlinear volume response to the rate gap, deposit decay curves and average life under three rate scenarios, and out-of-sample forecast accuracy.

---

## Why it matters

Non-maturity deposits are the largest liability of a bank and their behaviour is an assumption, not a contract. National data show low, asymmetric betas (7 bp per 100 bp for savings in 2022–23) and outflows of about 1.3 points of growth per point of rate gap. A survival model turns the rate gap into decay curves: a 4.4-year average life today, 5.4 years if cuts pass through and 3.8 years in a 2023-style gap. Those are the inputs IRRBB needs.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 30 seconds).

## Data sources

| Data | Source |
|---|---|
| National deposit rates (savings, money market, 12-month CD), fed funds | https://fred.stlouisfed.org |
| H.8 deposits, small and large time deposits; retail money-market funds | https://fred.stlouisfed.org |

## Outputs (`outputs/`)

- `01_betas_and_volume_response.png`
- `02_decay_and_forecasts.png`
- `behavioural_assumptions.csv`
- `cox_recovery.csv`
- `cycle_betas.csv`
- `ecm_betas.csv`
- `forecast_accuracy.csv`

## Key assumptions

- National averages spliced across the 2021 FDIC methodology change; betas are lower bounds for rate-sensitive balances.
- Synthetic panel of 12,000 accounts driven by the real monthly rate gap with illustrative coefficients; discrete-time cloglog hazard (Cox with time-varying covariates did not converge).
- Forecasts one month ahead with annual expanding-window refits from 2017.

## Suggested commit plan

1. `add README and NMD framework`
2. `deposit-rate and volume ETL`
3. `cycle betas and asymmetric error-correction model`
4. `GAM volume response and survival-model decay`
5. `LSTM vs ARIMA vs regression forecast and executed outputs`

## References

### Finance and regulation

- Drechsler, I., Savov, A., & Schnabl, P. (2017). The deposits channel of monetary policy. *The Quarterly Journal of Economics, 132*(4), 1819–1876. https://doi.org/10.1093/qje/qjx019
- Drechsler, I., Savov, A., & Schnabl, P. (2021). Banking on deposits: Maturity transformation without interest rate risk. *The Journal of Finance, 76*(3), 1091–1143. https://doi.org/10.1111/jofi.13013
- Basel Committee on Banking Supervision. (2016). *Interest rate risk in the banking book* (BCBS 368). Bank for International Settlements. https://www.bis.org/bcbs/publ/d368.htm
- Hutchison, D. E., & Pennacchi, G. G. (1996). Measuring rents and interest rate risk in imperfect financial markets: The case of retail bank deposits. *Journal of Financial and Quantitative Analysis, 31*(3), 399–417. https://doi.org/10.2307/2331398
- Neumark, D., & Sharpe, S. A. (1992). Market structure and the nature of price rigidity: Evidence from the market for consumer deposits. *The Quarterly Journal of Economics, 107*(2), 657–680. https://doi.org/10.2307/2118485

### Machine learning and deep learning

- Hastie, T., & Tibshirani, R. (1986). Generalized additive models. *Statistical Science, 1*(3), 297–310. https://doi.org/10.1214/ss/1177013604
- Hochreiter, S., & Schmidhuber, J. (1997). Long short-term memory. *Neural Computation, 9*(8), 1735–1780. https://doi.org/10.1162/neco.1997.9.8.1735
- Cox, D. R. (1972). Regression models and life-tables. *Journal of the Royal Statistical Society: Series B, 34*(2), 187–202. https://doi.org/10.1111/j.2517-6161.1972.tb00899.x
