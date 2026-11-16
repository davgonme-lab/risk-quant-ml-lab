# Index Construction and Smart Beta: Price-Weighted, Capitalisation-Weighted, Equal-Weighted and Fundamental Indexes of the S&P 500 from Public Data, Turnover and Rebalancing Costs, and a Machine-Learning Tilt

An index is a portfolio rule. The CFA curriculum's equity readings define the classic weighting schemes:

- **Price-weighted** (the Dow): each stock weighted by its price, so a USD 500 stock counts ten times a USD 50 stock regardless of size.
- **Capitalisation-weighted** (the S&P 500): weight = price × shares, self-rebalancing, low turnover, but it puts more money into whatever has gone up.
- **Equal-weighted:** every stock the same weight, rebalanced back each period; it tilts towards smaller companies and sells winners.
- **Fundamentally weighted** (Arnott, Hsu and Moore, 2005): weights from sales, cash flow, book value and dividends, which breaks the link between weight and price.

"Smart beta" products are these rules packaged as funds. This notebook builds all four from public data for the stocks in today's S&P 500, from 2011 to 2026, measures their returns, risk, turnover and rebalancing costs, and adds a fifth: a capitalisation-weighted index **tilted by a LightGBM forecast** of each stock's next-year return, trained only on past data.

**Data.** Yahoo Finance (monthly adjusted prices of today's S&P 500 members and the S&P 500 ETF, 2010–2026); iShares Core S&P 500 ETF holdings (members); SEC XBRL frames API (shares outstanding, revenue, operating cash flow, equity, dividends, 2010–2025).

**Methods.** Price, capitalisation, equal and fundamental weighting, annual rebalancing, turnover and transaction costs, tracking error and information ratio, Sharpe ratios, LightGBM cross-sectional return forecasts and weight tilts.

**Key output.** Return, volatility, Sharpe ratio, turnover and tracking error of each index rule; how much of the difference survives costs; and whether an ML tilt adds value out of sample.

---

## Why it matters

Five index rules are rebuilt for today's S&P 500 members from public data (Yahoo prices and SEC share counts and fundamentals), 2011–2026, after putting split-restated prices and as-filed share counts on the same basis. The cap-weighted index tracks the ETF within 1.1% a year, but beats it by 1.7 points because of survivorship. Equal weighting earned most (18.5% a year) with three times the turnover; price and fundamental weighting landed close to cap weighting; a LightGBM return tilt added +0.9% a year out of sample (t = 1.3) with a rank correlation of 0.04.

## How to run

1. `conda activate quant-risk`. Put `SEC_USER_AGENT` and `FRED_API_KEY` in `.env` (the FRED key is required by the shared setup cell).
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 10 minutes on the first run (XBRL frames and Yahoo prices for 500 stocks), under a minute afterwards).

## Data sources

| Data | Source |
|---|---|
| iShares Core S&P 500 ETF (IVV) holdings | https://www.ishares.com/us/products/239726/ |
| SEC XBRL frames API | https://www.sec.gov/search-filings/edgar-application-programming-interfaces |
| Yahoo Finance: monthly prices and split history | https://finance.yahoo.com/ |

## Outputs (`outputs/`)

- `01_index_construction.png`
- `dashboard.html`
- `dashboard.png`
- `index_performance.csv`
- `ml_rank_ic.csv`
- `monthly_index_returns.csv`

## Key assumptions

- Universe: today's S&P 500 members (survivorship-biased); annual rebalance at the end of May using prices then and fiscal-year data from the previous year; weights drift between rebalances.
- Share counts from XBRL cover pages (fallback: balance sheet, diluted average), restated to the rebalance date with Yahoo's split history; company-years more than 1.5× away from the company's neighbouring years are dropped.
- Costs of 10 bp per one-way trade; the ML tilt multiplies cap weights by 1 + 0.5 × standardised predicted rank, with LightGBM trained only on earlier rebalances.

## Suggested commit plan

1. `index-construction-smart-beta: add S&P 500 members, prices and XBRL fundamentals`
2. `index-construction-smart-beta: add split-consistent share counts and data checks`
3. `index-construction-smart-beta: add five index rules with turnover and costs`
4. `index-construction-smart-beta: add LightGBM return tilt tested out of sample`
5. `index-construction-smart-beta: add charts, dashboard and narrative`

## References

- Yahoo Finance. Monthly prices. https://finance.yahoo.com/
- BlackRock iShares. iShares Core S&P 500 ETF holdings. https://www.ishares.com/
- U.S. Securities and Exchange Commission. XBRL frames API. https://www.sec.gov/edgar/sec-api-documentation
- CFA Institute. *CFA Program Curriculum Level I*, Equity Investments: Security Market Indexes.
- Arnott, R. D., Hsu, J., & Moore, P. (2005). Fundamental indexation. *Financial Analysts Journal*, 61(2), 83–99.
- DeMiguel, V., Garlappi, L., & Uppal, R. (2009). Optimal versus naive diversification: How inefficient is the 1/N portfolio strategy? *Review of Financial Studies*, 22(5), 1915–1953.
- Gu, S., Kelly, B., & Xiu, D. (2020). Empirical asset pricing via machine learning. *Review of Financial Studies*, 33(5), 2223–2273.
