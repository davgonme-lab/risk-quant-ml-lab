# Tracking Error & Risk Attribution vs Benchmark

A treasury portfolio is usually measured against a benchmark set by the board, and its managers may deviate from it only within a risk budget. The risk function then has to say how much active risk is being run, where it comes from, and whether the forecast held up. This notebook answers all three for a realistic portfolio.

**What it does.** It measures how far an MDB-style treasury portfolio can deviate from its benchmark (1–7 year U.S. Treasuries), explains where that tracking error comes from, and checks the forecast against three years of realised returns.

**Data.** Live bond-level holdings of six iShares ETFs (GOVT, AGZ, MUB and IGIB for the portfolio; SHY and IEI for the benchmark), the Treasury curve (U.S. Treasury and FRED), ICE BofA OAS by rating (FRED), and three years of daily ETF total returns (Yahoo Finance).

**Methods.** A holdings-based factor risk model (ten key rates plus four credit-spread factors), ex-ante tracking error with Euler risk decomposition by factor and by sleeve, and a PCA view of the active curve exposure.

The forecast is checked with ex-post tracking error, the information ratio and returns-based attribution, and the reporting is done in SQL (DuckDB).

**Key output.** Ex-ante against ex-post tracking error, the risk budget by factor and sleeve, the active key-rate profile, active-return contributions by sleeve, and a tracking-error dashboard.

---

## Why it matters

A treasury portfolio is managed against a board-approved benchmark and a tracking-error budget. The risk function must say how much active risk is being run, where it comes from, and whether the model is reliable. Here the ex-ante model and the realised TE agree within about 10%. The analysis also shows that a duration overlay alone is not enough: a curve-aware swap overlay is needed to fit the budget.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (under a minute).

## Data sources

| Data | Link |
|---|---|
| iShares holdings (GOVT 239468, AGZ 239457, MUB 239766, IGIB 239463, SHY 239452, IEI 239455) | `https://www.ishares.com/us/products/<id>/fund/latest-holdings.csv` |
| Treasury par curve / CMT yields | https://home.treasury.gov · https://fred.stlouisfed.org |
| ICE BofA OAS (AAA, AA, A, BBB) | https://fred.stlouisfed.org |
| ETF total returns | Yahoo Finance via `yfinance` |

## Outputs (`outputs/`)

| File | Content |
|---|---|
| `01_active_risk_budget.png` | Key-rate DV01 portfolio vs benchmark; TE by factor group and sleeve |
| `02_te_and_active_return.png` | Rolling ex-post vs ex-ante TE; cumulative active return by sleeve |
| `dashboard.html` / `.png` | Tracking-error dashboard |
| `te_decomposition_by_factor.csv`, `te_contribution_by_sleeve.csv`, `active_return_by_sleeve_year.csv` | Report tables |

## Key assumptions

- No issuer-specific risk in the ex-ante model.
- Ex-post replica uses ETFs at today's sleeve weights, rebalanced daily; banks and corporates share the IGIB proxy.
- One-day bad prints in Yahoo data are detected and interpolated (logged in the notebook).
- TE budget of 75 bp is hypothetical.

## Suggested commit plan

1. `add README and risk-model definitions`
2. `holdings ETL for portfolio and benchmark, curves, OAS, ETF returns`
3. `key-rate and spread exposures with DuckDB reporting`
4. `ex-ante TE, Euler decomposition, PCA view and swap overlays`
5. `ex-post TE, attribution, dashboard and executed outputs`

## References

### Finance and regulation

- Litterman, R. (1996). Hot spots and hedges. *The Journal of Portfolio Management, 23*(5), 52–75. https://doi.org/10.3905/jpm.1996.052
- Roll, R. (1992). A mean/variance analysis of tracking error. *The Journal of Portfolio Management, 18*(4), 13–22. https://doi.org/10.3905/jpm.1992.701922
- Brinson, G. P., Hood, L. R., & Beebower, G. L. (1986). Determinants of portfolio performance. *Financial Analysts Journal, 42*(4), 39–44. https://doi.org/10.2469/faj.v42.n4.39
- Litterman, R., & Scheinkman, J. (1991). Common factors affecting bond returns. *The Journal of Fixed Income, 1*(1), 54–61. https://doi.org/10.3905/jfi.1991.692347
- Tasche, D. (2008). Capital allocation to business units and sub-portfolios: The Euler principle. In A. Resti (Ed.), *Pillar II in the new Basel Accord*. Risk Books. https://arxiv.org/abs/0708.2542

### Machine learning and deep learning

- Jolliffe, I. T., & Cadima, J. (2016). Principal component analysis: A review and recent developments. *Philosophical Transactions of the Royal Society A, 374*(2065), 20150202. https://doi.org/10.1098/rsta.2015.0202
- Raasveldt, M., & Mühleisen, H. (2019). DuckDB: An embeddable analytical database. In *Proceedings of the 2019 International Conference on Management of Data*. https://doi.org/10.1145/3299869.3320212
