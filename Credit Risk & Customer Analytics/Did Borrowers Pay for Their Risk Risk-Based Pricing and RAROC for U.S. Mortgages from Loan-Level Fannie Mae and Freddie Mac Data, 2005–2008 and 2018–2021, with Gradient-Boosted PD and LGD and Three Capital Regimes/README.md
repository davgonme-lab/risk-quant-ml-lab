# Did Borrowers Pay for Their Risk? Risk-Based Pricing and RAROC for U.S. Mortgages from Loan-Level Fannie Mae and Freddie Mac Data, 2005–2008 and 2018–2021, with Gradient-Boosted PD and LGD and Three Capital Regimes

A lender that prices a loan well charges enough to cover the losses it expects, the capital it must hold against unexpected losses and the cost of running the loan, and charges riskier borrowers more. Before 2008 U.S. mortgage rates barely varied with borrower risk; after the crisis the government-sponsored enterprises introduced explicit risk-based fees. This notebook rebuilds a risk-based price for every loan from its expected loss and capital, and asks how much of that risk borrowers actually paid for, in the crisis vintages of 2005–2008 and in 2018–2021.

**What it does.**

1. It reads loan-level origination and monthly performance data for 50,000 loans per year from Fannie Mae (2005–2008) and Freddie Mac (2018–2021). From them it measures defaults, loss severities and the *spread at origination* (SATO): the note rate minus the market mortgage rate in the week the loan was made.
2. It trains probability-of-default models (logistic regression and LightGBM) and loss-given-default models (linear and LightGBM) on early vintages and tests them on later ones.
3. It computes capital per loan under three regimes: the Basel IRB formula for residential mortgages, the Basel III standardised LTV-based risk weights and the current U.S. 50% risk weight.
4. It builds a risk-based price, made of expected loss, the cost of capital and operating cost, for every loan, and measures how much of it was reflected in what borrowers paid.
5. It compares three pricing schemes on the loans of 2006–2008 against their realised losses: one flat fee, a FICO × LTV grid like the GSEs' loan-level price adjustments, and a loan-level machine-learning price. It reports the risk-adjusted return on capital (RAROC) by risk band.

**Data.** Fannie Mae Single-Family Loan Performance Data and Freddie Mac Single-Family Loan-Level Dataset (samples, downloaded once by hand into `data/` at the repository root); Freddie Mac Primary Mortgage Market Survey 30-year rate and 10-year Treasury yield (FRED).

**Methods.** Loan-level default and loss measurement from performance histories, logistic regression and LightGBM for PD and LGD, out-of-time testing by vintage, Basel IRB and standardised capital, risk-based pricing (expected loss + cost of capital + operating cost), RAROC, SATO regressions and calibration by risk decile.

**Key output.** Default and loss rates by vintage; the out-of-time accuracy of PD and LGD models; capital by FICO and LTV under three regimes; the share of risk priced into mortgage rates before and after the crisis; and the realised RAROC of each pricing scheme.

---

## Why it matters

A well-priced loan pays for its expected loss, its capital and its running costs, and riskier borrowers pay more. On about 320,000 Fannie Mae and Freddie Mac loans, a one-point rise in the risk-based price raised the borrower's rate by only 0.05–0.06 points in 2005–2007 and 0.10–0.15 points in 2018–2021. Out of time, logistic regression ranks defaults as well as LightGBM (AUC 0.78–0.80 vs 0.77), while loss severity is almost unpredictable from origination data. On the 2006–2008 loans, a flat fee earned −1% RAROC on borrowers below 660 and 61% above 780; a loan-level ML price brings every band close to the hurdle and cuts the loans whose fee fell short of their cost from 20% to 7%.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY` (Primary Mortgage Market Survey rate, 10-year Treasury). The Fannie Mae 2005–2008 and Freddie Mac 2018–2021 sample files must be in `data/fannie_mae/sample/` and `data/freddie_mac/` at the repository root (free registration, manual download, never committed).
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 3 minutes on CPU the first time, under a minute afterwards).

## Data sources

| Data | Source |
|---|---|
| Fannie Mae Single-Family Loan Performance Data, 2005–2008 acquisitions (sampled) | https://capitalmarkets.fanniemae.com/credit-risk-transfer/single-family-credit-risk-transfer/fannie-mae-single-family-loan-performance-data |
| Freddie Mac Single-Family Loan-Level Dataset, samples 2018–2021 | https://www.freddiemac.com/research/datasets/sf-loanlevel-dataset |
| Freddie Mac PMMS 30-year rate and 10-year Treasury yield (FRED) | https://fred.stlouisfed.org/ |

## Outputs (`outputs/`)

- `01_mortgage_pricing.png`
- `capital_by_fico_ltv.csv`
- `dashboard.html`
- `dashboard.png`
- `lgd_out_of_time.csv`
- `ml_fee_calibration.csv`
- `pd_out_of_time.csv`
- `pricing_schemes.csv`
- `raroc_by_fico.csv`
- `risk_price_by_fico.csv`
- `sato_by_fico.csv`
- `sato_pricing_slopes.csv`
- `vintages.csv`

## Key assumptions

- 30-year fixed-rate loans; default = first 180-day delinquency or short sale, third-party sale, note sale or REO within 60 months (2005–2008) or 36 months (2018–2021).
- PD models trained on 2005 (Fannie Mae) and 2018 (Freddie Mac) and tested on later vintages; LGD trained on 2005 defaults with a loss and floored at 10%.
- Capital at a 10.5% total ratio: Basel IRB residential (R = 15%), Basel III standardised LTV weights (20–70%) and the U.S. 50% weight.
- Risk-based price = lifetime EL over a 7-year life + IRB capital × 10% hurdle spread + 0.25% operating cost; SATO = note rate − monthly PMMS rate.

## Suggested commit plan

1. `mortgage-risk-pricing-raroc: add loan-level panel from Fannie Mae and Freddie Mac samples and SATO`
2. `mortgage-risk-pricing-raroc: add out-of-time PD and LGD models`
3. `mortgage-risk-pricing-raroc: add IRB, standardised and U.S. capital and the risk-based price`
4. `mortgage-risk-pricing-raroc: add SATO pricing regressions`
5. `mortgage-risk-pricing-raroc: add pricing schemes, realised RAROC, charts, dashboard and narrative`

## References

### Finance and regulation

- Basel Committee on Banking Supervision. (2017). *Basel III: Finalising post-crisis reforms*. Bank for International Settlements. https://www.bis.org/bcbs/publ/d424.htm
- Gordy, M. B. (2003). A risk-factor model foundation for ratings-based bank capital rules. *Journal of Financial Intermediation, 12*(3), 199–232. https://doi.org/10.1016/S1042-9573(03)00040-8
- Zaik, E., Walter, J., Retting, G., & James, C. (1996). RAROC at Bank of America: From theory to practice. *Journal of Applied Corporate Finance, 9*(2), 83–93. https://doi.org/10.1111/j.1745-6622.1996.tb00117.x
- Demyanyk, Y., & Van Hemert, O. (2011). Understanding the subprime mortgage crisis. *Review of Financial Studies, 24*(6), 1848–1880. https://doi.org/10.1093/rfs/hhp033
- Mayer, C., Pence, K., & Sherlund, S. M. (2009). The rise in mortgage defaults. *Journal of Economic Perspectives, 23*(1), 27–50. https://doi.org/10.1257/jep.23.1.27
- Freddie Mac. (2026). *Single-Family Loan-Level Dataset* [Data set]. https://www.freddiemac.com/research/datasets/sf-loanlevel-dataset
- Fannie Mae. (2026). *Single-Family Loan Performance Data* [Data set]. https://capitalmarkets.fanniemae.com/credit-risk-transfer/single-family-credit-risk-transfer/fannie-mae-single-family-loan-performance-data

### Machine learning and deep learning

- Fuster, A., Goldsmith-Pinkham, P., Ramadorai, T., & Walther, A. (2022). Predictably unequal? The effects of machine learning on credit markets. *The Journal of Finance, 77*(1), 5–47. https://doi.org/10.1111/jofi.13090
- Ke, G., Meng, Q., Finley, T., Wang, T., Chen, W., Ma, W., Ye, Q., & Liu, T.-Y. (2017). LightGBM: A highly efficient gradient boosting decision tree. *Advances in Neural Information Processing Systems, 30*. https://proceedings.neurips.cc/paper/2017/hash/6449f44a102fde848669bdd9eb6b76fa-Abstract.html
