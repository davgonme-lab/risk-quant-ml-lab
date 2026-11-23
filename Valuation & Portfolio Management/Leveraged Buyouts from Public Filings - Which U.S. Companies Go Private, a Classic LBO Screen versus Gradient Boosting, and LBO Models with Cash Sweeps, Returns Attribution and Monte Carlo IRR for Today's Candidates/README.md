# Leveraged Buyouts from Public Filings: Which U.S. Companies Go Private, a Classic LBO Screen versus Gradient Boosting, and LBO Models with Cash Sweeps, Returns Attribution and Monte Carlo IRR for Today's Candidates

In a **leveraged buyout** a financial sponsor buys a company with a small slice of equity and a large amount of debt, runs it for four to six years, and sells it. The debt is repaid from the company's own cash flow, so the sponsor's return comes from three sources: **EBITDA growth**, **multiple expansion** (selling at a higher EV/EBITDA than it paid) and **deleveraging** (the debt paid down with the company's cash). The classic LBO candidate has stable cash flows, low capital needs, little existing debt and a low valuation.

This notebook does three things with public data:

1. **Who actually goes private?** Every Schedule 13E-3 filed with the SEC since 2011 (the disclosure required when a public company is taken private by insiders, a sponsor or a controlling holder) is matched to the company's financial statements from XBRL. A **classic LBO screen** (a logistic regression on the textbook criteria) is compared with **gradient boosting** on a wider set of ratios, trained up to 2017 and tested on 2019–2022 fundamentals with going-private filings in 2020–2024.
2. **An LBO model** for today's top-ranked candidates: sources and uses, a term loan with mandatory amortisation and a cash sweep, senior notes, interest at current market rates, a five-year hold and an exit at the entry multiple, with IRR, money multiple and the attribution of the equity gain.
3. **Monte Carlo IRR:** revenue growth, margins and the exit multiple are simulated from each company's own history, giving the distribution of sponsor returns and the probability of losing money.

**Data.** SEC EDGAR full-index of filings (Schedule 13E-3); SEC XBRL frames API (annual financial statements and public float of every filer); FRED (SOFR, 10-year Treasury yield, ICE BofA US High Yield option-adjusted spread); Yahoo Finance (current market capitalisation of the candidates); SEC company tickers.

**Methods.** LBO model with sources and uses, term-loan amortisation, cash sweep and bullet notes; IRR, MOIC and value-creation attribution; logistic regression on textbook LBO criteria vs LightGBM; out-of-time testing with ROC AUC, precision–recall and top-decile capture; SHAP-style feature importance; Monte Carlo simulation of operating paths and exit multiples.

**Key output.** What distinguishes companies that went private; how much better than the textbook screen a machine-learning screen ranks them; a complete LBO model for the top candidate; and the distribution of IRRs for the top candidates.

---

## Why it matters

Matching every SEC Schedule 13E-3 since 2011 to XBRL fundamentals shows that companies taken private are cheap (EV/EBITDA 5.6 vs 9.6), small and lightly indebted, but not more cash-generative than the market. Out of time, a LightGBM screen ranks targets clearly better than the textbook LBO screen (AUC 0.65 vs 0.55; 36% vs 23% of targets in the top quintile). Full LBO models at today's rates (term loan 7.6%, notes 8.2%) show that the entry multiple decides the deal: at 5–8× EBITDA deleveraging delivers 15–28% IRRs, at 15–20× the sponsor funds two-thirds of the price and earns 0–11%; Monte Carlo puts the probability of losing money at 27–57%.

## How to run

1. `conda activate quant-risk`. `.env` needs `SEC_USER_AGENT` and `FRED_API_KEY` in `.env`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 5 minutes on first run (EDGAR indexes and XBRL frames); under a minute afterwards).

## Data sources

| Data | Source |
|---|---|
| SEC EDGAR full-index (Schedule 13E-3 filings) | https://www.sec.gov/Archives/edgar/full-index/ |
| SEC XBRL frames API | https://www.sec.gov/search-filings/edgar-application-programming-interfaces |
| FRED: SOFR, 10-year Treasury, ICE BofA US High Yield OAS | https://fred.stlouisfed.org/ |
| Yahoo Finance (market capitalisation of candidates) | https://finance.yahoo.com/ |

## Outputs (`outputs/`)

- `01_lbo.png`
- `dashboard.html`
- `dashboard.png`
- `lbo_base_case.csv`
- `lbo_model_EPAC.csv`
- `lbo_monte_carlo.csv`
- `lightgbm_deciles.csv`
- `screen_out_of_time.csv`

## Key assumptions

- Label: a Schedule 13E-3 (amendments excluded) filed by the company's CIK within two calendar years of the fundamentals; companies with revenue of at least USD 50 million and positive EBITDA; public float stands in for market value.
- Classic screen = logistic regression on free-cash-flow margin, net debt/EBITDA, margin volatility and EV/EBITDA; LightGBM on 14 ratios; trained to 2017, tested on 2019–2022 fundamentals.
- LBO: 30% premium, 2% fees, debt = min(6.0× EBITDA, 2× interest cover, 70% of EV), 65% term loan (SOFR + 3.75%, 1% amortisation, 75% sweep) and 35% notes; five-year hold, exit at the entry multiple; Monte Carlo with company-specific growth and margin volatility and a 20% exit-multiple shock.

## Suggested commit plan

1. `lbo-screen-and-models: add Schedule 13E-3 index and XBRL frames`
2. `lbo-screen-and-models: add going-private features, classic screen and LightGBM`
3. `lbo-screen-and-models: add out-of-time tests, deciles and feature importance`
4. `lbo-screen-and-models: add LBO engine with tranches, sweep and attribution`
5. `lbo-screen-and-models: add Monte Carlo IRR, charts, dashboard and narrative`

## References

- U.S. Securities and Exchange Commission. EDGAR full-text index of filings (form.idx) and XBRL frames API. https://www.sec.gov/search-filings/edgar-application-programming-interfaces
- U.S. Securities and Exchange Commission. Rule 13e-3 and Schedule 13E-3 (going-private transactions). https://www.sec.gov/rules-regulations/staff-guidance/compliance-disclosure-interpretations/going-private-transactions-exchange-act-rule-13e-3-schedule-13e-3
- Federal Reserve Bank of St. Louis. FRED series SOFR, DGS10 and BAMLH0A0HYM2 (ICE BofA US High Yield Index Option-Adjusted Spread). https://fred.stlouisfed.org/
- Kaplan, S. N., & Strömberg, P. (2009). Leveraged buyouts and private equity. *Journal of Economic Perspectives*, 23(1), 121–146.
- Axelson, U., Jenkinson, T., Strömberg, P., & Weisbach, M. S. (2013). Borrow cheap, buy high? The determinants of leverage and pricing in buyouts. *Journal of Finance*, 68(6), 2223–2267.
- Guo, S., Hotchkiss, E. S., & Song, W. (2011). Do buyouts (still) create value? *Journal of Finance*, 66(2), 479–517.
- Achleitner, A.-K., Braun, R., Engel, N., Figge, C., & Tappeiner, F. (2010). Value creation drivers in private equity buyouts: Empirical evidence from Europe. *Journal of Private Equity*, 13(2), 17–27.
- Rosenbaum, J., & Pearl, J. (2020). *Investment Banking: Valuation, LBOs, M&A, and IPOs* (3rd ed.). Wiley.
- Ke, G., Meng, Q., Finley, T., Wang, T., Chen, W., Ma, W., Ye, Q., & Liu, T.-Y. (2017). LightGBM: A highly efficient gradient boosting decision tree. In *Advances in Neural Information Processing Systems 30*.
