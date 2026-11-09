# Mortgage Prepayment (CPR) & Default (CDR) Competing Risks

A mortgage can leave a pool in two ways: the borrower refinances or sells and pays it off early, or stops paying. Each outcome rules out the other, and treating them separately overstates both. For an investor in mortgage bonds, the timing of these two events decides when the money comes back. This notebook models them together on 500,000 real loans from two very different periods: the 2005–08 vintages that went through the housing crisis and the 2018–23 vintages that went through the pandemic refinancing boom.

**What it does.** It measures and models the two ways a mortgage leaves a securitised pool, voluntary prepayment and default, on 200,000 Fannie Mae loans originated in 2005–08 and 300,000 Freddie Mac loans originated in 2018–23.

It computes pool CPR and CDR by vintage, draws the refinancing S-curve for four periods (before, during and after the crisis, and since 2018), and estimates cumulative incidence with the Aalen–Johansen estimator, showing how much the naive Kaplan–Meier overstates each risk.

It then fits cause-specific monthly hazard models (a GLM with seasoning, incentive, burnout and seasonality, and a multiclass LightGBM), back-tests them out of time on pool-level CPR and CDR, and projects pool prepayment speeds under ±100 bp mortgage-rate scenarios.

**Data.** Fannie Mae Single-Family Loan Performance data (2005–2008 acquisitions) and the Freddie Mac Single-Family Loan-Level Dataset (vintages 2018–2023), monthly performance to March 2026, and Freddie Mac's 30-year mortgage rate survey (FRED).

**Methods.** SMM/CPR and MDR/CDR, Aalen–Johansen cumulative incidence against 1 − Kaplan–Meier, discrete-time cause-specific logistic hazards, a LightGBM multiclass hazard, an out-of-time pool back-test and a rate-shock projection.

**Key output.** CPR and CDR history by vintage, the S-curve by period, competing-risk incidence curves, model accuracy out of time, and projected speeds under rate shocks.

---

## Why it matters


Prepayment and default decide when a mortgage bond's money comes back. Adding Fannie Mae's 2005–08 vintages to Freddie Mac's 2018–23 shows both regimes: crisis vintages defaulted at 7–8% a year in 2009–10, and their refinancing S-curve was much flatter (21% CPR at +1 point in 2009–13 against 30% since 2018) because underwater borrowers could not refinance. Aalen–Johansen shows that ignoring prepayment overstates four-year default by 41–51% for the crisis vintages and 117% for 2018; out of time, a GLM trained on both periods predicts 2024–26 speeds without bias.

## How to run


1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`, plus the Freddie Mac sample zips in `data/freddie_mac/` and the Fannie Mae quarterly files 2005Q1–2008Q4 in `data/fannie_mae/` at the repo root (see the root README). The first run builds a 200,000-loan Fannie Mae sample in `data/fannie_mae/sample/` (about 20–30 minutes, once).
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 4 minutes after the first run).

## Data sources


| Data | Source |
|---|---|
| Fannie Mae Single-Family Loan Performance Data, 2005–2008 acquisitions | https://capitalmarkets.fanniemae.com |
| Freddie Mac Single-Family Loan-Level Dataset, sample files 2018–2023 | https://www.freddiemac.com/research/datasets/sf-loanlevel-dataset |
| Freddie Mac 30-year mortgage rate (PMMS) | https://fred.stlouisfed.org/series/MORTGAGE30US |

## Outputs (`outputs/`)


- `01_cpr_scurve_cif_backtest.png`
- `competing_risks_incidence.csv`
- `cpr_cdr_by_vintage_year.csv`
- `hazard_coefficients.csv`
- `out_of_time_errors.csv`
- `rate_shock_prepayment.csv`
- `s_curve.csv`
- `s_curve_by_period.csv`

## Key assumptions

- Refinancing incentive = note rate − current 30-year mortgage rate.
- Competing risks: voluntary payoff (zero-balance code 01) vs credit event; lagged UPB for loan size to avoid leakage.
- Out-of-time test on 2024–2026 performance; models trained on 2005–2023 months (default model without the 2020–21 forbearance months).
- Fannie Mae sample: loans whose identifier modulo 1000 is below 80, then 12,500 drawn at random per acquisition quarter (50,000 per vintage, like the Freddie Mac sample files).

## Suggested commit plan

1. `add README, Fannie Mae 2005-08 sample builder and pool CPR/CDR`
2. `refinancing S-curve by period`
3. `Aalen–Johansen vs Kaplan–Meier`
4. `GLM and LightGBM hazards with out-of-time test`
5. `rate-shock scenarios and charts`

## References

### Finance and regulation

- Schwartz, E. S., & Torous, W. N. (1989). Prepayment and the valuation of mortgage-backed securities. *The Journal of Finance, 44*(2), 375–392. https://doi.org/10.1111/j.1540-6261.1989.tb05062.x
- Deng, Y., Quigley, J. M., & Van Order, R. (2000). Mortgage terminations, heterogeneity and the exercise of mortgage options. *Econometrica, 68*(2), 275–307. https://doi.org/10.1111/1468-0262.00110
- Richard, S. F., & Roll, R. (1989). Prepayments on fixed-rate mortgage-backed securities. *The Journal of Portfolio Management, 15*(3), 73–82. https://doi.org/10.3905/jpm.1989.409207
- Fabozzi, F. J. (Ed.). (2016). *The handbook of mortgage-backed securities* (7th ed.). Oxford University Press. https://doi.org/10.1093/acprof:oso/9780198785774.001.0001
- Fannie Mae. (2026). *Single-Family Loan Performance Data* [Data set]. https://capitalmarkets.fanniemae.com/credit-risk-transfer/single-family-credit-risk-transfer/fannie-mae-single-family-loan-performance-data

### Machine learning and deep learning

- Fine, J. P., & Gray, R. J. (1999). A proportional hazards model for the subdistribution of a competing risk. *Journal of the American Statistical Association, 94*(446), 496–509. https://doi.org/10.1080/01621459.1999.10474144
- Kaplan, E. L., & Meier, P. (1958). Nonparametric estimation from incomplete observations. *Journal of the American Statistical Association, 53*(282), 457–481. https://doi.org/10.1080/01621459.1958.10501452
- Ke, G., Meng, Q., Finley, T., Wang, T., Chen, W., Ma, W., Ye, Q., & Liu, T.-Y. (2017). LightGBM: A highly efficient gradient boosting decision tree. *Advances in Neural Information Processing Systems, 30*. https://proceedings.neurips.cc/paper/2017/hash/6449f44a102fde848669bdd9eb6b76fa-Abstract.html
