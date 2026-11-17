# Option-Adjusted Spreads for Agency Mortgage Pools: a Hull–White Model Calibrated to Today's Treasury Curve and the MOVE Index, Three Prepayment Functions from 2.9 Million Freddie Mac Loan-Months, Effective Duration and Negative Convexity

An agency mortgage pool pays its investors the interest and principal of thousands of fixed-rate mortgages, with the credit risk guaranteed by Freddie Mac, Fannie Mae or Ginnie Mae. What is left is interest-rate risk with a twist: every borrower holds an option to repay at par. When rates fall, borrowers refinance and the investor gets cash back just when it can only be reinvested at lower rates; when rates rise, nobody refinances and the pool's life extends just when its cash would be worth more elsewhere. The option-adjusted spread (OAS) is the spread over the Treasury curve that, averaged over many interest-rate paths, discounts the pool's projected cash flows to its price. It needs three ingredients: a term-structure model calibrated to today's market, a prepayment function that turns each rate path into cash flows, and a price.

This notebook builds all three from public data. A one-factor Hull–White model is fitted exactly to today's Treasury curve and given the volatility implied by the MOVE index. Three prepayment functions are estimated on monthly loan-level histories of Freddie Mac mortgages originated in 2018–2023, through the 2020–2021 refinancing wave and the 2022–2023 lock-in: an industry-style parametric S-curve, a spline logistic regression and LightGBM, each tested out of time. The pools are the loans of the sample still outstanding at the end of the data, grouped by coupon, and priced with each prepayment model.

**What it does.**

1. It reads the monthly payment histories of 72,000 loans, labels each month in which a loan was repaid in full, and computes each loan's refinancing incentive (note rate minus the prevailing mortgage rate), its burnout (accumulated past incentive it did not use), age, season and borrower characteristics.
2. It fits the three prepayment functions on 2018–2023 and tests them on 2024–2026: log loss, discrimination, the S-curve of prepayment speed against incentive, and the tracking of the monthly prepayment rate of the whole sample.
3. It builds the Treasury zero curve from today's constant-maturity yields, calibrates Hull–White's volatility to the MOVE index, simulates 1,000 monthly rate paths over 30 years, and maps the 10-year yield on each path into a mortgage rate.
4. It groups outstanding loans into pools by coupon, projects their cash flows on every path with each prepayment model, fixes the OAS by pricing a newly produced current-coupon pool at par, and computes, for each pool, the price at that OAS, the static (zero-volatility) spread, the option cost, effective duration and effective convexity.
5. It shows the price profile under parallel rate shifts, the sensitivity of OAS and duration to the volatility and mean-reversion assumptions and to the prepayment model, and compares the model durations with the empirical duration of the largest mortgage-backed securities ETF.

**Data.** Freddie Mac Single-Family Loan-Level Dataset, sample files 2018–2023 (free registration; downloaded once by hand into `data/freddie_mac/` at the repository root); Treasury constant-maturity yields and the 30-year mortgage rate (FRED); the MOVE index and the MBB and IEF ETFs (Yahoo Finance).

**Methods.** Hull–White one-factor model fitted to the initial curve, volatility calibration to the MOVE index, Monte Carlo with antithetic paths and moment matching, prepayment hazard models (parametric S-curve by maximum likelihood, spline logistic regression, LightGBM with monotonic constraints), out-of-time validation, option-adjusted and zero-volatility spreads, effective duration and convexity, rolling empirical duration.

**Key output.** Out-of-time accuracy of the three prepayment functions and their S-curves; the Hull–White calibration; for each coupon pool, the price, OAS, option cost, effective duration and convexity; price profiles under rate shocks; and how much OAS and duration depend on the volatility and prepayment assumptions.

---

## Why it matters

Every agency mortgage pool is short a refinancing option, and its value depends on a rate model, a prepayment model and volatility. Three prepayment functions fitted to 2.9 million Freddie Mac loan-months (2018–2023) all overstated speeds after 2023 near the money (18% actual vs 27–34% predicted), while LightGBM ranked loans best. With Hull–White calibrated to today's Treasury curve and MOVE, the current coupon prices at par with an OAS of 105 bp and an option cost of 73 bp, duration 3.8 and convexity −177; deep-discount pools from the 2020–2021 vintages have durations above 8 and positive convexity. The prepayment model moves the book's duration from 4.6 to 7.1, more than any change in volatility or mean reversion; the market's empirical duration of MBB is 6.4.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY` in `.env`. The Freddie Mac sample files `sample_2018.zip` … `sample_2023.zip` must be in `data/freddie_mac/` at the repository root (free registration, manual download, never committed).
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 10 minutes on CPU).

## Data sources

| Data | Source |
|---|---|
| Freddie Mac Single-Family Loan-Level Dataset, sample files 2018–2023 | https://www.freddiemac.com/research/datasets/sf-loanlevel-dataset |
| Treasury constant-maturity yields and the 30-year mortgage rate (FRED) | https://fred.stlouisfed.org/series/MORTGAGE30US |
| MOVE index, MBB and IEF (Yahoo Finance) | https://finance.yahoo.com/quote/%5EMOVE/ |

## Outputs (`outputs/`)

- `01_mbs_oas.png`
- `cpr_by_incentive.csv`
- `dashboard.html`
- `dashboard.png`
- `empirical_duration_summary.csv`
- `hull_white_calibration.csv`
- `lightgbm_feature_importance.csv`
- `monthly_cpr_actual_vs_model.csv`
- `pool_analytics.csv`
- `pools.csv`
- `prepayment_model_comparison.csv`
- `prepayment_model_risk.csv`
- `price_profiles.csv`
- `rate_model_sensitivity.csv`
- `s_curve_parameters.csv`
- `sample_by_vintage.csv`
- `treasury_zero_curve.csv`

## Key assumptions

- 12,000 thirty-year fixed-rate loans per vintage; a prepayment is a full payoff (zero-balance code 01); credit exits are censored; months starting 60+ days past due are dropped; loan age enters the models capped at six years.
- Incentive = current note rate minus the previous month's 30-year mortgage rate; burnout = accumulated positive incentive; training before 2024, test from 2024.
- Hull–White a = 3%, σ from MOVE; 1,000 antithetic monthly paths; mortgage rate = today's rate + β × change in the simulated 10-year yield; pools by coupon (note rate minus 0.5–1.0%); OAS anchored on a current-coupon pool at par.

## Suggested commit plan

1. `agency-mbs-oas: add Freddie Mac loan-months, incentive, burnout and prepayment labels`
2. `agency-mbs-oas: add parametric S-curve, spline logistic and LightGBM prepayment models with out-of-time tests`
3. `agency-mbs-oas: add Treasury curve bootstrap, Hull-White calibration to MOVE and path simulation`
4. `agency-mbs-oas: add pool cash flows, OAS, option cost, effective duration and convexity`
5. `agency-mbs-oas: add model and volatility sensitivity, price profiles, empirical ETF duration, charts and narrative`

## References

- Boudoukh, J., Whitelaw, R. F., Richardson, M., & Stanton, R. (1997). Pricing mortgage-backed securities in a multifactor interest rate environment: A multivariate density estimation approach. *Review of Financial Studies*, 10(2), 405–446. https://doi.org/10.1093/rfs/10.2.405
- Brigo, D., & Mercurio, F. (2006). *Interest rate models: Theory and practice* (2nd ed.). Springer.
- Fabozzi, F. J. (Ed.). (2016). *The handbook of mortgage-backed securities* (7th ed.). Oxford University Press.
- Freddie Mac. (2026). *Single-Family Loan-Level Dataset* [Data set]. https://www.freddiemac.com/research/datasets/sf-loanlevel-dataset
- Hull, J., & White, A. (1990). Pricing interest-rate-derivative securities. *Review of Financial Studies*, 3(4), 573–592. https://doi.org/10.1093/rfs/3.4.573
- Ke, G., Meng, Q., Finley, T., Wang, T., Chen, W., Ma, W., Ye, Q., & Liu, T.-Y. (2017). LightGBM: A highly efficient gradient boosting decision tree. In *Advances in Neural Information Processing Systems 30* (pp. 3146–3154).
- Richard, S. F., & Roll, R. (1989). Prepayments on fixed-rate mortgage-backed securities. *Journal of Portfolio Management*, 15(3), 73–82. https://doi.org/10.3905/jpm.1989.409207
- Sadhwani, A., Giesecke, K., & Sirignano, J. (2021). Deep learning for mortgage risk. *Journal of Financial Econometrics*, 19(2), 313–368. https://doi.org/10.1093/jjfinec/nbaa025
- Schwartz, E. S., & Torous, W. N. (1989). Prepayment and the valuation of mortgage-backed securities. *Journal of Finance*, 44(2), 375–392. https://doi.org/10.1111/j.1540-6261.1989.tb05062.x
- Stanton, R. (1995). Rational prepayment and the valuation of mortgage-backed securities. *Review of Financial Studies*, 8(3), 677–708. https://doi.org/10.1093/rfs/8.3.677
