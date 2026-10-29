# Concentration Risk in an Emerging-Market Corporate Portfolio: Multi-Factor Capital, Granularity and ML-Detected Stress Regimes

Regulatory capital formulas assume a loan book spread across countless small borrowers, all driven by one global economy. An emerging-market corporate book looks nothing like that: a few large issuers, defaults that cluster by country, and correlations that jump in a crisis. This notebook measures how much extra risk that concentration creates, and where it sits.

**What it does.** It treats the iShares J.P. Morgan EM Corporate Bond ETF (about 570 issuers in 57 countries) as the corporate loan book of a development lender and measures **name, country and sector concentration** three ways:

- Herfindahl indices and effective numbers;
- the regulatory single-factor IRB capital and its **granularity adjustment** (Gordy–Lütkebohmert);
- a **multi-factor Monte Carlo credit VaR** where obligors load on country and global-sector equity factors, with Euler risk contributions by name, country and sector.

Machine learning comes in where concentration bites hardest. A **Gaussian mixture regime model** on weekly EM market data separates calm weeks from stress weeks, and the stress-regime factor correlations show how much more capital the same book needs when correlations jump.

A **gradient-boosting** model maps market spreads to PDs for issuers whose spreads are distorted.

**Data.** iShares CEMB holdings (issuers, countries, sectors, prices, par), the U.S. Treasury curve, Yahoo Finance weekly returns of 22 MSCI country ETFs (Colombia from its ADRs) and 5 global sector ETFs plus EEM and EMB, and the FRED VIX.

**Methods.** Z-spread → hazard → PD, HHI, Basel IRB ASRF, granularity adjustment, a multi-factor Gaussian copula Monte Carlo with stochastic LGD, Euler allocation, Gaussian mixture regimes and LightGBM.

**Key output.** Concentration indices, capital under each method and regime, the names and countries that use more capital than their share of exposure, and a rebalancing that reduces capital per unit of spread income.

---

## Why it matters

Regulatory IRB capital assumes an infinitely granular book driven by one global factor; an EM corporate or MDB book is concentrated by country and sector by construction. On the 574-issuer iShares EM corporate universe scaled to a $10bn book, name concentration is modest (granularity add-on 5% of IRB capital), but a multi-factor Monte Carlo shows capital piling into a few countries: Hong Kong, Colombia (6.2% of tail capital for 4.4% of exposure), South Africa, Brazil and Argentina. A Gaussian-mixture regime model on EM markets lifts the average country-factor correlation from 0.38 (calm) to 0.51 (stress), raising economic capital 12%. An Euler-gradient rebalancing keeps spread income unchanged and cuts simulated capital 11%.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 1 minute).

## Data sources

| Data | Source |
|---|---|
| iShares J.P. Morgan EM Corporate Bond ETF (CEMB) holdings | https://www.ishares.com/us/products/239525/ |
| U.S. Treasury par yield curve | https://home.treasury.gov/resource-center/data-chart-center/interest-rates |
| MSCI country and global sector ETF prices, Bancolombia and Ecopetrol ADRs | Yahoo Finance (yfinance) |
| VIX (VIXCLS) | https://fred.stlouisfed.org/series/VIXCLS |

## Outputs (`outputs/`)

- `01_concentration_capital_regimes.png`
- `concentration_indices.csv`
- `country_capital_contributions.csv`
- `irb_and_granularity.csv`
- `monte_carlo_capital_by_regime.csv`
- `obligor_detail.csv`
- `rebalancing.csv`
- `sector_capital_contributions.csv`

## Key assumptions

- PDs from 5-year-equivalent z-spreads with 40% recovery and a risk-neutral/physical intensity ratio of 2.5, floored at 5 bp.
- Asset correlation from the Basel corporate formula; 75% of systematic variance from the country factor (100% for agencies), the rest from a global sector factor.
- Equity ETF returns proxy the credit factors; Colombia from two ADRs; countries without an ETF use EEM.
- One-year horizon, beta LGD (mean 45%, s.d. 20%) independent of the factors, no migration.
- Stress regime = GMM clusters with average EEM volatility at least 1.75 times the calm cluster.

## Suggested commit plan

1. `portfolio, PDs and concentration indices`
2. `IRB capital and granularity adjustment`
3. `GMM regimes and factor correlations`
4. `multi-factor Monte Carlo and Euler contributions`
5. `LightGBM spread outliers and rebalancing`
6. `charts and narrative`

## References

### Finance and regulation

- Basel Committee on Banking Supervision. (2005). *An explanatory note on the Basel II IRB risk weight functions*. Bank for International Settlements. https://www.bis.org/bcbs/irbriskweight.htm
- Gordy, M. B. (2003). A risk-factor model foundation for ratings-based bank capital rules. *Journal of Financial Intermediation, 12*(3), 199–232. https://doi.org/10.1016/S1042-9573(03)00040-8
- Gordy, M. B., & Lütkebohmert, E. (2013). Granularity adjustment for regulatory capital assessment. *International Journal of Central Banking, 9*(3), 33–70. https://www.ijcb.org/journal/ijcb13q3a2.htm
- Düllmann, K., & Masschelein, N. (2007). A tractable model to measure sector concentration risk in credit portfolios. *Journal of Financial Services Research, 32*(1–2), 55–79. https://doi.org/10.1007/s10693-007-0014-3
- Tasche, D. (2008). Capital allocation to business units and sub-portfolios: The Euler principle. In A. Resti (Ed.), *Pillar II in the new Basel Accord*. Risk Books. https://arxiv.org/abs/0708.2542
- Longin, F., & Solnik, B. (2001). Extreme correlation of international equity markets. *The Journal of Finance, 56*(2), 649–676. https://doi.org/10.1111/0022-1082.00340

### Machine learning and deep learning

- Hamilton, J. D. (1989). A new approach to the economic analysis of nonstationary time series and the business cycle. *Econometrica, 57*(2), 357–384. https://doi.org/10.2307/1912559
- McLachlan, G., & Peel, D. (2000). *Finite mixture models*. Wiley. https://doi.org/10.1002/0471721182
- Schwarz, G. (1978). Estimating the dimension of a model. *The Annals of Statistics, 6*(2), 461–464. https://doi.org/10.1214/aos/1176344136
- Ke, G., Meng, Q., Finley, T., Wang, T., Chen, W., Ma, W., Ye, Q., & Liu, T.-Y. (2017). LightGBM: A highly efficient gradient boosting decision tree. *Advances in Neural Information Processing Systems, 30*. https://proceedings.neurips.cc/paper/2017/hash/6449f44a102fde848669bdd9eb6b76fa-Abstract.html
