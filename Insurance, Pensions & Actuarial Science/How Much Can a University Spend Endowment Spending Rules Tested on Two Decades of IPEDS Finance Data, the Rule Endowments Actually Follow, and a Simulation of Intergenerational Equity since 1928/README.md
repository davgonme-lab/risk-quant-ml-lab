# How Much Can a University Spend? Endowment Spending Rules Tested on Two Decades of IPEDS Finance Data, the Rule Endowments Actually Follow, and a Simulation of Intergenerational Equity since 1928

A university endowment is meant to last forever. Each year the board decides how much of it to spend on scholarships, professorships and research. Spend too much and future students inherit a smaller fund; spend too little and today's students pay for a wealth they never use. Most U.S. endowments solve the problem with a **spending rule**: a fixed percentage of a moving average of past market values, sometimes blended with last year's spending adjusted for inflation. This notebook measures the market, finds the rule endowments actually follow in their own reported numbers, and tests the common rules against almost a century of market history.

**What it does.**

1. It reads the endowment section of the IPEDS finance survey for every U.S. college and university, fiscal years 2005 to 2023: the endowment's value at the start and end of each year and, from 2020, what moved it (new gifts, investment return, spending and other changes).
2. It describes the market: total assets of private and public endowments, their concentration, and returns and spending rates by size from 2020 to 2023.
3. It finds the **revealed spending rule**. It compares spending with the beginning value and with the trailing three-year average, and estimates how much weight institutions put on last year's spending versus the market value.
4. It predicts each institution's 2023 spending out of time with the revealed rule, its own past rate, ridge regression and LightGBM.
5. It simulates 50 years of an endowment invested in a diversified portfolio, using block-bootstrapped annual market returns and inflation since 1928. It compares five rules on spending stability and on preserving the endowment's real value, searches for the best smoothing weight and spending rate, and replays three historical starting years.

**Data.** IPEDS finance survey, endowment section of forms F1A (public, GASB) and F2 (private not-for-profit, FASB), and institutional characteristics (National Center for Education Statistics); annual returns on U.S. stocks, Treasury and Baa corporate bonds and real estate since 1928 (Damodaran Online); consumer price index (FRED).

**Methods.** Endowment flow decomposition, spending rates on beginning and trailing-average values, robust regression of the spending rule, out-of-time prediction with ridge regression and LightGBM, block-bootstrap Monte Carlo of asset returns and inflation, five spending rules, grid search of smoothing weight and spending rate, and historical replays.

**Key output.** The size and concentration of U.S. endowments; returns and spending rates by size; the revealed spending rule; the accuracy of the spending forecasts; and the trade-off between stable spending and preserved purchasing power for each rule.

---

## Why it matters

A university endowment is meant to last forever, so its spending rule decides how much each generation of students receives. IPEDS shows that U.S. endowments (\$913 billion in fiscal 2023) kept spending at 4.3–4.5% of their three-year average value while returns swung from +27.5% to −8.6%; the revealed rule puts a weight of about 0.3 on last year's spending (0.8 for endowments above \$1 billion). In 5,000 simulated 50-year paths since 1928, the form of smoothing changes how often real spending is cut, not how much is spent, while the spending rate decides intergenerational equity: at 4.5% the endowment loses real value in 40% of paths, at 3.5% in 19%, and constant real spending exhausts it in 35%.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY` (consumer price index). The IPEDS finance files are read from `data/ipeds_finance/` at the repository root and downloaded from NCES when missing.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (under a minute on CPU once the data are cached; the first run downloads about 50 MB of IPEDS files).

## Data sources

| Data | Source |
|---|---|
| IPEDS finance survey (forms F1A and F2), fiscal 2005–2023, and institutional characteristics (NCES) | https://nces.ed.gov/ipeds/datacenter/DataFiles.aspx |
| Historical returns on stocks, bonds, bills and real estate, 1928–2025 (Damodaran Online) | https://pages.stern.nyu.edu/~adamodar/New_Home_Page/datafile/histret.html |
| Consumer price index for all urban consumers (FRED) | https://fred.stlouisfed.org/series/CPIAUCNS |

## Outputs (`outputs/`)

- `01_endowment_spending.png`
- `dashboard.html`
- `dashboard.png`
- `endowment_market_by_year.csv`
- `historical_replays.csv`
- `hybrid_rule_grid.csv`
- `returns_spending_by_size.csv`
- `returns_spending_by_year.csv`
- `revealed_spending_rule.csv`
- `spending_forecast_2023.csv`
- `spending_rules_simulation.csv`

## Key assumptions

- Endowments above \$10 million; spending = distributions for current use; three-year average of fiscal year-end values; inflation = CPI change to June.
- Revealed rule S = w × S(t−1) × (1 + π) + (1 − w) × r × three-year average, estimated by Huber regression without intercept; forecasts trained on fiscal 2021–2022 and tested on 2023.
- Simulated portfolio 60% S&P 500, 20% Baa corporate bonds, 10% 10-year Treasuries, 10% real estate, rebalanced yearly, 0.5% costs; 5,000 paths of 50 years from five-year blocks of 1928–2025; no new gifts; first-year spending 4.5%.

## Suggested commit plan

1. `endowment-spending-rules: add IPEDS endowment panel and market overview`
2. `endowment-spending-rules: add returns, spending rates and the revealed spending rule`
3. `endowment-spending-rules: add out-of-time spending forecasts`
4. `endowment-spending-rules: add spending-rule simulation, grid search and historical replays`
5. `endowment-spending-rules: add charts, dashboard and narrative`

## References

### Endowments, spending and data

- Tobin, J. (1974). What is permanent endowment income? *The American Economic Review, 64*(2), 427–432.
- Brown, J. R., Dimmock, S. G., Kang, J.-K., & Weisbenner, S. J. (2014). How university endowments respond to financial market shocks: Evidence and implications. *American Economic Review, 104*(3), 931–962. https://doi.org/10.1257/aer.104.3.931
- Lerner, J., Schoar, A., & Wang, J. (2008). Secrets of the academy: The drivers of university endowment success. *Journal of Economic Perspectives, 22*(3), 207–222. https://doi.org/10.1257/jep.22.3.207
- Dybvig, P. H. (1995). Dusenberry's ratcheting of consumption: Optimal dynamic consumption and investment given intolerance for any decline in standard of living. *The Review of Economic Studies, 62*(2), 287–313. https://doi.org/10.2307/2297806
- National Center for Education Statistics. (2026). *Integrated Postsecondary Education Data System (IPEDS): Finance survey and institutional characteristics* [Data set]. U.S. Department of Education. https://nces.ed.gov/ipeds/datacenter/DataFiles.aspx
- Damodaran, A. (2026). *Historical returns on stocks, bonds and bills: 1928–2025* [Data set]. NYU Stern School of Business. https://pages.stern.nyu.edu/~adamodar/New_Home_Page/datafile/histret.html

### Statistics and machine learning

- Künsch, H. R. (1989). The jackknife and the bootstrap for general stationary observations. *The Annals of Statistics, 17*(3), 1217–1241. https://doi.org/10.1214/aos/1176347265
- Huber, P. J. (1964). Robust estimation of a location parameter. *The Annals of Mathematical Statistics, 35*(1), 73–101. https://doi.org/10.1214/aoms/1177703732
- Hoerl, A. E., & Kennard, R. W. (1970). Ridge regression: Biased estimation for nonorthogonal problems. *Technometrics, 12*(1), 55–67. https://doi.org/10.1080/00401706.1970.10488634
- Ke, G., Meng, Q., Finley, T., Wang, T., Chen, W., Ma, W., Ye, Q., & Liu, T.-Y. (2017). LightGBM: A highly efficient gradient boosting decision tree. *Advances in Neural Information Processing Systems, 30*. https://proceedings.neurips.cc/paper/2017/hash/6449f44a102fde848669bdd9eb6b76fa-Abstract.html
