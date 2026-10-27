# Concentration Risk in an Emerging-Market Corporate Portfolio: Multi-Factor Capital, Granularity and ML-Detected Stress Regimes

**What it does:** treats the iShares J.P. Morgan EM Corporate Bond ETF (about 570 issuers in 57 countries) as the corporate loan book of a development lender. It measures **name, country and sector concentration**:
- Herfindahl indices and effective numbers;
- the regulatory single-factor IRB capital and its **granularity adjustment** (Gordy–Lütkebohmert);
- a **multi-factor Monte Carlo credit VaR** where obligors load on country and global-sector equity factors, with Euler risk contributions by name, country and sector.

Machine learning enters where concentration bites hardest. A **Gaussian mixture / hidden-regime model** on weekly EM market data separates calm from stress weeks, and the factor correlations of the stress regime show how much more capital the same book needs when correlations jump. A **gradient-boosting** model maps market spreads to PDs for issuers whose spreads are distorted.
**Data:** iShares CEMB holdings (issuers, countries, sectors, prices, par); U.S. Treasury curve; Yahoo Finance weekly returns of 22 MSCI country ETFs (Colombia from its ADRs) and 5 global sector ETFs, plus EEM and EMB; FRED VIX.
**Methods:** z-spread → hazard → PD; HHI; Basel IRB ASRF; granularity adjustment; multi-factor Gaussian copula Monte Carlo with stochastic LGD; Euler allocation; Gaussian mixture regimes; LightGBM.
**Key output:** concentration indices, capital under each method and regime, the names and countries that consume capital beyond their share of exposure, and a rebalancing that reduces capital per unit of spread income.

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
