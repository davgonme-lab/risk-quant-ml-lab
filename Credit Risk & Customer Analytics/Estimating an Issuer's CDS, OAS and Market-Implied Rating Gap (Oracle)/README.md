# Estimating an Issuer's CDS, OAS and Market-Implied Rating Gap (Oracle)

Oracle has borrowed heavily to build data centres for AI, and the bond market has repriced its credit. Its rating, however, moves slowly, and its CDS quotes sit behind paid terminals. This notebook shows how a credit officer can estimate the CDS curve of a name like this from public data, and measure how far the market has moved away from the agency rating.

**What it does.** It estimates the credit-default-swap curve of a single issuer without CDS quotes, Oracle Corporation, through three independent routes:

1. a **bond-implied** CDS curve from a reduced-form hazard model calibrated to the prices of Oracle's 45 bonds;
2. an **equity-implied** CDS from the CreditGrades structural model, run daily for three years;
3. a **machine-learning "fair spread"** from a LightGBM model of the spread determinants of about 4,000 U.S. corporate bonds.

It then applies the rating agencies' market-implied rating method (bond-, CDS- and equity-implied ratings) to measure Oracle's **MIR gap** against its S&P rating.

**Data.** iShares LQD and HYG holdings (bond prices, coupons, maturities), the U.S. Treasury par yield curve, Yahoo Finance equity prices, SEC EDGAR XBRL balance sheets (company facts and frames APIs), ICE BofA option-adjusted spreads by rating and maturity (FRED), and a public 5-year CDS print for validation.

**Methods.** A Treasury zero-curve bootstrap, z-spreads, piecewise-constant hazard rates by penalised least squares, ISDA-style CDS par spreads and CreditGrades.

The cross-section uses LightGBM with monotone constraints, grouped cross-validation and SHAP, against a linear determinants regression. Ratings come from a spread-band mapping with notch interpolation.

**Key output.** Oracle's estimated CDS term structure with a range across methods, its OAS and CDS–bond basis, the drivers of corporate spreads, and bond-, CDS- and equity-implied ratings with their notch gap to the agency rating over time.

---

## Why it matters

Most counterparties and issuers have no liquid CDS, yet CVA, limits and rating challenges need a market spread. For Oracle, whose credit has been repriced by debt-funded AI capex, the bond-implied 5-year CDS is 252 bp (215 bp with the basis implied by a July print), the equity-implied CreditGrades spread 134–219 bp, and an ML model of spread determinants across 2,139 bonds puts peers with Oracle's balance sheet at about 100 bp, so Oracle trades roughly 150 bp wide of its fundamentals. Bond-, CDS- and equity-implied ratings sit about three notches below S&P's BBB-, and the equity-implied rating fell below investment grade five months before S&P's July 2026 downgrade.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY` and `SEC_USER_AGENT`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 1 minute).

## Data sources

| Data | Source |
|---|---|
| iShares LQD and HYG holdings (bond prices, coupons, maturities) | https://www.ishares.com/us/products/239566/ |
| U.S. Treasury par yield curve | https://home.treasury.gov/resource-center/data-chart-center/interest-rates |
| Oracle and issuer equity prices | Yahoo Finance (yfinance) |
| Balance sheets: SEC XBRL company facts and frames APIs | https://www.sec.gov/edgar/sec-api-documentation |
| ICE BofA OAS by rating and maturity bucket | https://fred.stlouisfed.org |
| Oracle 5y CDS print, 27-Jul-2026 (validation only) | https://www.boerse-express.com/news/articles/oracle-aktie-cds-praemie-auf-215-basispunkte-933104 |
| S&P rating action, 9-Jul-2026 | https://ppc.land/s-p-cuts-oracle-to-bbb-as-ai-buildout-widens-cash-deficit-to-42bn/ |

## Outputs (`outputs/`)

- `01_cds_triangulation_mir.png`
- `equity_implied_cds_and_rating_history.csv`
- `market_implied_ratings.csv`
- `oracle_bond_spreads_and_fit.csv`
- `oracle_cds_term_structure.csv`
- `oracle_cds_triangulation.csv`
- `spread_determinants_shap.csv`
- `spread_model_cv_scores.csv`

## Key assumptions

- Recovery 40% of face; Treasury discounting; zero CDS–bond basis in the central estimate (print-implied basis as a variant).
- Piecewise-constant hazard rates at 1–45 years fitted to 45 bond prices with a smoothness penalty; ISDA-style CDS premium leg with accrual on default.
- CreditGrades with L̄ = 0.5, λ = 0.3 (textbook) and L̄ calibrated to the July print; EWMA equity volatility (λ = 0.98) on winsorised returns; financial debt from XBRL with a 45-day filing lag.
- Market-implied ratings from ICE BofA OAS by rating, scaled by the IG maturity profile, with geometric notch interpolation.

## Suggested commit plan

1. `add README and CDS estimation framework`
2. `bond z-spreads and Treasury zero curve`
3. `bond-implied hazard curve and CDS`
4. `CreditGrades equity-implied CDS history`
5. `LightGBM spread determinants with grouped CV`
6. `market-implied ratings and MIR gap`

## References

### Finance and regulation

- Duffie, D., & Singleton, K. J. (1999). Modeling term structures of defaultable bonds. *The Review of Financial Studies, 12*(4), 687–720. https://doi.org/10.1093/rfs/12.4.687
- Collin-Dufresne, P., Goldstein, R. S., & Martin, J. S. (2001). The determinants of credit spread changes. *The Journal of Finance, 56*(6), 2177–2207. https://doi.org/10.1111/0022-1082.00402
- Longstaff, F. A., Mithal, S., & Neis, E. (2005). Corporate yield spreads: Default risk or liquidity? New evidence from the credit default swap market. *The Journal of Finance, 60*(5), 2213–2253. https://doi.org/10.1111/j.1540-6261.2005.00797.x
- Bai, J., & Collin-Dufresne, P. (2019). The CDS-bond basis. *Financial Management, 48*(2), 417–439. https://doi.org/10.1111/fima.12252
- Merton, R. C. (1974). On the pricing of corporate debt: The risk structure of interest rates. *The Journal of Finance, 29*(2), 449–470. https://doi.org/10.1111/j.1540-6261.1974.tb03058.x

### Machine learning and deep learning

- Ke, G., Meng, Q., Finley, T., Wang, T., Chen, W., Ma, W., Ye, Q., & Liu, T.-Y. (2017). LightGBM: A highly efficient gradient boosting decision tree. *Advances in Neural Information Processing Systems, 30*. https://proceedings.neurips.cc/paper/2017/hash/6449f44a102fde848669bdd9eb6b76fa-Abstract.html
- Lundberg, S. M., & Lee, S.-I. (2017). A unified approach to interpreting model predictions. *Advances in Neural Information Processing Systems, 30*. https://arxiv.org/abs/1705.07874
- Bianchi, D., Büchner, M., & Tamoni, A. (2021). Bond risk premiums with machine learning. *The Review of Financial Studies, 34*(2), 1046–1089. https://doi.org/10.1093/rfs/hhaa062
