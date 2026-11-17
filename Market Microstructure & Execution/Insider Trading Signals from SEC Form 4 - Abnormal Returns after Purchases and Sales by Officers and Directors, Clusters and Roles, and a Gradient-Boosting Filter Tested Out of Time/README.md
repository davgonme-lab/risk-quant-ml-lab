# Insider Trading Signals from SEC Form 4: Abnormal Returns after Purchases and Sales by Officers and Directors, Clusters and Roles, and a Gradient-Boosting Filter Tested Out of Time

Corporate insiders (officers, directors and 10% owners) must report their trades in their company's shares on **Form 4** within two business days. The ethics part of the CFA curriculum draws a sharp line: trading on **material non-public information** is prohibited, but insiders' legal trades are public information once filed, and a long literature (Seyhun, 1986; Lakonishok and Lee, 2001; Cohen, Malloy and Pomorski, 2012) finds that insider **purchases** are followed by abnormal returns, while sales, often for diversification or liquidity, say much less.

This notebook tests that with the SEC's structured Form 4 data for 2016–2025:

1. **Event study:** abnormal returns (stock minus the S&P 500 ETF) over 5, 20, 60 and 120 trading days after the filing becomes public, for open-market purchases and sales.
2. **Which purchases matter:** by role (CEO or CFO, director, other officer), size, **clusters** of several insiders buying together, and whether the stock had fallen before (contrarian buying).
3. **A machine-learning filter:** LightGBM ranks purchases by expected 60-day abnormal return, trained on 2016–2021 and tested on 2022–2025, against simple rules a reader of Form 4s would use.

**Data.** SEC Insider Transactions Data Sets (Forms 3, 4 and 5, quarterly, 2016–2025: submissions, reporting owners, non-derivative transactions); Yahoo Finance (daily prices of the issuers and the S&P 500 ETF).

**Methods.** Event study with market-adjusted abnormal returns, t-tests clustered by date, cross-sectional regressions, LightGBM regression, out-of-time portfolio sorts.

**Key output.** Average abnormal returns after insider purchases and sales; which purchase characteristics predict them; and whether an ML filter beats simple rules after the information is public.

---

## Why it matters

The SEC's structured Form 4 data for 2016–2025 give 87,380 open-market purchases and 330,633 sales by officers, directors and 10% owners above USD 10,000. Measured from the day after the filing against the S&P 500 ETF, the average purchase earns a small five-day abnormal return (+0.12%) and nothing afterwards; sales are neutral. CFO purchases stand out (+3.4% over 60 days, t = 3.7), while very large purchases and 10% owners do worst. Out of time (2022–2025), a LightGBM filter ranks purchases with a 2.7-point spread between its top and bottom fifths, but its best fifth only matches the market; simple role and cluster rules add nothing.

## How to run

1. `conda activate quant-risk`. Put `SEC_USER_AGENT` and `FRED_API_KEY` in `.env` (the FRED key is required by the shared setup cell).
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 10 minutes on the first run (38 quarterly SEC data sets and Yahoo prices), 2 minutes afterwards).

## Data sources

| Data | Source |
|---|---|
| SEC Insider Transactions Data Sets (Forms 3, 4 and 5) | https://www.sec.gov/data-research/sec-markets-data/insider-transactions-data-sets |
| Yahoo Finance: daily prices | https://finance.yahoo.com/ |

## Outputs (`outputs/`)

- `01_insider_trading.png`
- `dashboard.html`
- `dashboard.png`
- `event_study.csv`
- `ml_filter_test.csv`
- `ml_quintiles_test.csv`
- `purchases_by_characteristic.csv`

## Key assumptions

- Form 4 transactions with codes P (purchase) and S (sale), grouped by filing; at least USD 10,000 and USD 2 per share; roles from relationship and title (CEO, CFO, other officer, director, 10% owner).
- Abnormal return = buy-and-hold return from the close of the day after the filing minus the S&P 500 ETF's, over 5, 20, 60 and 120 trading days; t-statistics from daily averages.
- Cluster = at least two other insiders of the company buying in the previous 30 days; LightGBM trained on 2016–2021 purchases, tested on 2022–2025.

## Suggested commit plan

1. `insider-trading-form4: add Form 4 purchases and sales from SEC data sets`
2. `insider-trading-form4: add event study against the S&P 500 ETF`
3. `insider-trading-form4: add purchase characteristics and cross-sectional regression`
4. `insider-trading-form4: add LightGBM filter tested out of time`
5. `insider-trading-form4: add charts, dashboard and narrative`

## References

- U.S. Securities and Exchange Commission. Insider Transactions Data Sets (Forms 3, 4 and 5). https://www.sec.gov/data-research/sec-markets-data/insider-transactions-data-sets
- Yahoo Finance. Daily prices. https://finance.yahoo.com/
- CFA Institute. *Standards of Practice Handbook*, Standard II(A) Material Nonpublic Information.
- Seyhun, H. N. (1986). Insiders' profits, costs of trading, and market efficiency. *Journal of Financial Economics*, 16(2), 189–212.
- Lakonishok, J., & Lee, I. (2001). Are insider trades informative? *Review of Financial Studies*, 14(1), 79–111.
- Cohen, L., Malloy, C., & Pomorski, L. (2012). Decoding inside information. *Journal of Finance*, 67(3), 1009–1043.
- Alldredge, D. M., & Cicero, D. C. (2015). Attentive insider trading. *Journal of Financial Economics*, 115(1), 84–101.
