# REIT Valuation: Funds from Operations, Adjusted FFO and Price Multiples for U.S. REITs from SEC Filings, Implied Cap Rates and Net Asset Value at Property-Type Peer Cap Rates, and Whether NAV Discounts Predict Returns

Real estate investment trusts are valued differently from other companies, and the CFA curriculum's real-estate reading gives three approaches:

- **Funds from operations (FFO)** = net income + real-estate depreciation − gains on property sales. GAAP depreciation understates the value of well-maintained buildings, so REITs and analysts add it back. **Adjusted FFO (AFFO)** subtracts the recurring capital spending needed to keep the properties competitive. Price/FFO and price/AFFO are the sector's P/E ratios.
- **Net asset value (NAV):** value the property portfolio by capitalising its net operating income at a **cap rate**, $V = NOI / \text{cap rate}$, subtract liabilities, and compare with the share price. REITs trade at premiums or discounts to NAV.
- **Discounted cash flow**, not used here.

This notebook applies the first two to U.S. REITs:

1. **Universe and data:** the members of the iShares Core U.S. REIT ETF, their property type, annual financials from SEC company facts (10-K filings, 2012–2025) and prices from Yahoo.
2. **FFO, AFFO and multiples** by property type and over time.
3. **Implied cap rates** (NOI ÷ enterprise value) and a **NAV at the median cap rate of the property type**, giving a premium or discount relative to peers.
4. **Do cheap REITs outperform?** Next-year total returns against NAV discounts, FFO and AFFO yields, leverage and size, with a cross-sectional regression and LightGBM trained on 2013–2018 and tested on 2019–2025.

**Data.** iShares Core U.S. REIT ETF holdings; SEC EDGAR company facts (XBRL); Yahoo Finance (monthly prices); FRED (10-year Treasury yield).

**Methods.** FFO and AFFO construction from XBRL, price multiples, implied cap rates, peer-cap-rate NAV, premium/discount, cross-sectional regression, LightGBM, rank information coefficients, quintile portfolios.

**Key output.** FFO and AFFO multiples and implied cap rates by property type; the distribution of NAV premiums and discounts; and whether they predict returns.

---

## Why it matters

For 121 REITs in the iShares Core U.S. REIT ETF with 10-K data from 2012 to 2025, FFO, AFFO and an EBITDAre-based NOI are built from SEC company facts. Multiples and implied cap rates line up by property type, from data centers (29× FFO, 3.5% cap rate) to hotels (8×, 8.6%). The median implied cap rate rose from 4.7% to about 6.1% as the 10-year Treasury went from below 3% to above 4%, but the cap-rate spread over Treasuries shrank from about 3 points to under 2. Out of sample in 2019–2024, simple value signals predict next-year returns: high-cap-rate REITs beat low-cap-rate ones by about 17 points a year, and REITs at premiums to NAV lagged. Combined linear and LightGBM models trained on 2012–2018 fail.

## How to run

1. `conda activate quant-risk`. `.env` needs `SEC_USER_AGENT` and `FRED_API_KEY` in `.env`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 5 minutes (SEC company facts for 122 REITs on the first run)).

## Data sources

| Data | Source |
|---|---|
| iShares Core U.S. REIT ETF (USRT) holdings | https://www.ishares.com/us/products/239544/ |
| SEC EDGAR XBRL company facts API | https://www.sec.gov/search-filings/edgar-application-programming-interfaces |
| FRED: 10-year Treasury yield (DGS10) | https://fred.stlouisfed.org/series/DGS10 |
| Yahoo Finance | https://finance.yahoo.com/ |

## Outputs (`outputs/`)

- `01_reit_valuation.png`
- `dashboard.html`
- `dashboard.png`
- `multiples_by_property_type.csv`
- `multiples_by_year.csv`
- `reit_valuation_panel.csv`
- `return_prediction_test.csv`

## Key assumptions

- FFO = net income to common + D&A − gains on property sales; AFFO = FFO − capital improvements; NOI proxied by EBITDAre (net income + interest + taxes + D&A − gains + impairments).
- Valuation at the end of April after each fiscal year (10-K public); enterprise value = market value + liabilities − cash; implied cap rate = NOI / EV.
- NAV at the median implied cap rate of the property type in each year (all-REIT median for types with fewer than three members); today's ETF members only (survivorship).

## Suggested commit plan

1. `reit-valuation-ffo-nav: add ETF universe, SEC company facts and monthly prices`
2. `reit-valuation-ffo-nav: add FFO, AFFO, multiples and implied cap rates by property type`
3. `reit-valuation-ffo-nav: add NAV at peer cap rates and premiums and discounts`
4. `reit-valuation-ffo-nav: add out-of-time return tests of value signals, linear model and LightGBM`
5. `reit-valuation-ffo-nav: add charts, dashboard and narrative`

## References

- BlackRock iShares. iShares Core U.S. REIT ETF (USRT), fund holdings. https://www.ishares.com/us/products/239544/
- U.S. Securities and Exchange Commission. EDGAR XBRL company facts API. https://www.sec.gov/search-filings/edgar-application-programming-interfaces
- Federal Reserve Bank of St. Louis. FRED: Market Yield on U.S. Treasury Securities at 10-Year Constant Maturity (DGS10). https://fred.stlouisfed.org/series/DGS10
- Yahoo Finance. Historical prices. https://finance.yahoo.com/
- CFA Institute. CFA Program Level II curriculum, Equity Valuation: Private Real Estate Investments and Publicly Traded Real Estate Securities.
- Nareit (2018). Nareit Funds from Operations White Paper, 2018 Restatement. https://www.reit.com/data-research/research/nareit-research/nareit-funds-operations-white-paper-2018-restatement
- Clayton, J., & MacKinnon, G. (2003). The relative importance of stock, bond and real estate factors in explaining REIT returns. *Journal of Real Estate Finance and Economics*, 27(1), 39–60.
- Capozza, D. R., & Seguin, P. J. (1999). Focus, transparency and value: The REIT evidence. *Real Estate Economics*, 27(4), 587–619.
- Barkham, R., & Geltner, D. (1995). Price discovery in American and British property markets. *Real Estate Economics*, 23(1), 21–44.
- Ke, G., et al. (2017). LightGBM: A highly efficient gradient boosting decision tree. *Advances in Neural Information Processing Systems*, 30.
