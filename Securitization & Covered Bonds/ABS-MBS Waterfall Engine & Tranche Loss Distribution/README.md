# ABS/MBS Waterfall Engine & Tranche Loss Distribution

In 2007–08 senior mortgage tranches rated AAA lost money because their risk depended on how loan losses moved together, not just on how large they were on average. A securitisation slices a pool's losses into tranches, and only the full loss distribution says how risky each slice is. This notebook builds the cash-flow waterfall of a mortgage deal and simulates that distribution.

**What it does.** It builds a monthly cash-flow waterfall for a residential mortgage securitisation (senior, mezzanine and junior notes, overcollateralisation and excess spread). The waterfall is driven by default, liquidation, prepayment and severity inputs estimated on ten loan vintages, four of them through the 2008 crisis, and 10,000 economic scenarios are simulated with a systematic credit factor whose volatility is set by how much the vintages differed.

It produces each tranche's loss distribution, probability of loss, expected loss, weighted-average life and yield, shows how credit enhancement and the OC turbo protect the senior notes, measures how tranche risk responds to default correlation, and places the realised losses of the 2005–08 vintages in the simulated distribution.

**Data.** Fannie Mae Single-Family Loan Performance data (2005–2008 acquisitions) and the Freddie Mac Single-Family Loan-Level Dataset (vintages 2018–2023): default and prepayment curves by loan age, liquidation rates, realised severities and vintage losses; the 30-year mortgage rate (FRED). The deal structure, coupons and the median-scenario severity are stated assumptions.

**Methods.** Through-the-cycle hazard curves averaged over vintages, a factor volatility estimated from the dispersion of vintage default rates, a one-factor frailty model for defaults (lognormal hazard multiplier) with correlated severity and prepayment, and a vectorised monthly waterfall (interest, sequential principal, reverse-sequential loss allocation, OC target and turbo).

Tranche metrics come from Monte Carlo, compared with a large-homogeneous-pool (Vasicek) model, with sensitivity to the systematic volatility.

**Key output.** The calibration from ten vintages, the pool loss distribution against the tranche attachment points and against realised crisis losses, each tranche's PD, EL, 99th-percentile loss, WAL and yield, cash-flow paths for a typical and a stressed scenario, and the correlation sensitivity.

---

## Why it matters


Tranche risk is set by the tail of the pool loss distribution, not its mean. Calibrated on ten vintages, four of them through the 2008 crisis, the systematic factor's volatility comes out at 0.95 and crisis severities at 33–45%; the realised losses of the 2005–08 vintages land between the 58th and 81st percentiles of the simulated distribution. The senior notes lose principal in 0.45% of 10,000 scenarios and the junior notes in 5.3%; excess spread cuts junior expected loss from 10% to 3.6%, and raising default correlation multiplies senior risk while the pool mean barely moves.

## How to run


1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`, plus the Freddie Mac sample zips in `data/freddie_mac/` and the Fannie Mae quarterly files 2005Q1–2008Q4 in `data/fannie_mae/` at the repo root. The first run builds a 200,000-loan Fannie Mae sample in `data/fannie_mae/sample/` (about 20–30 minutes, once).
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 1 minute after the first run).

## Data sources


| Data | Source |
|---|---|
| Fannie Mae Single-Family Loan Performance Data, 2005–2008 acquisitions (curves, liquidations, severities, vintage losses) | https://capitalmarkets.fanniemae.com |
| Freddie Mac Single-Family Loan-Level Dataset, sample files 2018–2023 (curves) | https://www.freddiemac.com/research/datasets/sf-loanlevel-dataset |
| 30-year mortgage rate | https://fred.stlouisfed.org |

## Outputs (`outputs/`)


- `01_pool_loss_paths_correlation.png`
- `calibrated_curves.csv`
- `correlation_sensitivity.csv`
- `severity_by_vintage.csv`
- `tranche_metrics.csv`
- `vintage_validation.csv`

## Key assumptions


- Pool: through-the-cycle default curve (equal weight per vintage, 2005–08 and 2018–23), times the share of 90+ day defaults that ended in liquidation in the crisis vintages; faded beyond observed ages.
- Systematic factor: lognormal hazard multiplier with σ estimated from the dispersion of 60-month vintage default rates, held for the life of the deal.
- Severity 30% in the median scenario, with a slope set so the 1-in-100 scenario has the worst crisis vintage's severity.
- Structure: A 85% / M 7% / B 4% with 4% OC target and turbo; sequential principal, reverse-sequential write-downs; 6.5% WAC, 25 bp servicing.

## Suggested commit plan


1. `add README and deal structure`
2. `Fannie Mae 2005-08 sample builder and vintage calibration`
3. `vectorised waterfall engine`
4. `Monte Carlo tranche metrics, yields and vintage validation`
5. `correlation sensitivity and charts`

## References

### Finance and regulation

- Coval, J., Jurek, J., & Stafford, E. (2009). The economics of structured finance. *Journal of Economic Perspectives, 23*(1), 3–25. https://doi.org/10.1257/jep.23.1.3
- Duffie, D., & Gârleanu, N. (2001). Risk and valuation of collateralized debt obligations. *Financial Analysts Journal, 57*(1), 41–59. https://doi.org/10.2469/faj.v57.n1.2418
- Basel Committee on Banking Supervision. (2016). *Revisions to the securitisation framework*. Bank for International Settlements. https://www.bis.org/bcbs/publ/d374.htm
- Deng, Y., Quigley, J. M., & Van Order, R. (2000). Mortgage terminations, heterogeneity and the exercise of mortgage options. *Econometrica, 68*(2), 275–307. https://doi.org/10.1111/1468-0262.00110
- Fannie Mae. (2026). *Single-Family Loan Performance Data* [Data set]. https://capitalmarkets.fanniemae.com/credit-risk-transfer/single-family-credit-risk-transfer/fannie-mae-single-family-loan-performance-data

### Machine learning and deep learning

- Glasserman, P. (2004). *Monte Carlo methods in financial engineering*. Springer. https://doi.org/10.1007/978-0-387-21617-1
- Vaupel, J. W., Manton, K. G., & Stallard, E. (1979). The impact of heterogeneity in individual frailty on the dynamics of mortality. *Demography, 16*(3), 439–454. https://doi.org/10.2307/2061224
