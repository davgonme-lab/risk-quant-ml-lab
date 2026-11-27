# Industry Life Cycles and Competitive Structure: Concentration and Margins by Industry from SEC Filings, Cash-Flow Life-Cycle Stages with a Gradient-Boosting Forecast, and Text-Based Peers from 10-K Business Descriptions

Industry analysis in the CFA curriculum rests on two frameworks: the **industry life cycle** (embryonic, growth, shakeout, mature, decline) and **Porter's five forces**, of which concentration, barriers to entry and rivalry are the measurable ones. Both are usually taught qualitatively. This notebook measures them for every U.S. listed non-financial company that files XBRL, 2010–2025:

1. **Competitive structure by industry** (SIC three-digit codes): number of firms, the Herfindahl–Hirschman index (HHI) and four-firm concentration ratio (CR4) of revenue, margins, growth, R&D and capital intensity, entry and exit.
2. **Life-cycle stages of firms** from the signs of operating, investing and financing cash flows (Dickinson, 2011), and a **LightGBM forecast** of which stage a company will be in next year, against the naive forecast that it stays where it is.
3. **Do concentrated industries earn more?** Margins against concentration, and how fast unusually high or low profitability fades (Fama and French, 2000), by concentration level.
4. **Clustering industries into life-cycle groups** with k-means and Gaussian mixtures on their growth, margins, investment, concentration, entry, exit and stage mix.
5. **Text-based industries** (Hoberg and Phillips, 2016): S&P 500 companies' 10-K business descriptions embedded with a sentence-transformer, nearest peers by cosine similarity, compared with SIC codes and GICS sectors by how well each peer group explains a company's stock returns.

**Data.** SEC XBRL frames API (revenue, operating income, assets, cash flows, R&D, capital expenditure, dividends, 2010–2025); SEC Financial Statement Data Sets (SIC codes of filers); SEC SIC code list; SEC EDGAR (latest 10-K of S&P 500 members); iShares Core S&P 500 ETF holdings (members and GICS sectors); Yahoo Finance (weekly prices).

**Methods.** HHI and CR4, Dickinson life-cycle classification, panel regressions with clustered errors, partial-adjustment models of profitability, LightGBM and multinomial logistic classification, k-means, Gaussian mixtures, silhouette scores, PCA, sentence embeddings (all-MiniLM-L6-v2), cosine-similarity peers, adjusted Rand index.

**Key output.** Concentration and life-cycle profiles of U.S. industries; whether concentration goes with higher and more persistent margins; how well next year's life-cycle stage can be predicted; and whether text-based peers beat SIC codes and GICS sectors.

---

## Why it matters

For 9,330 U.S. non-financial companies filing XBRL (2010–2025), concentration, margins, growth, entry and exit are measured for about 100 SIC industries. Listed-company concentration has risen (median HHI from about 2,000 to 2,400), but concentrated industries do not earn higher margins, and abnormal profitability fades at the same speed whatever the concentration. Dickinson cash-flow stages fit the theory (introduction and decline firms lose money and spend on R&D, mature firms pay dividends) but 47% of companies change stage each year; LightGBM forecasts the next stage 58% of the time against 53% for no change. For the S&P 500, peers from 10-K business descriptions explain stock returns about as well as SIC codes and better than GICS sectors.

## How to run

1. `conda activate quant-risk`. Put `SEC_USER_AGENT` and `FRED_API_KEY` in `.env` (the FRED key is required by the shared setup cell); the sentence-embedding model (all-MiniLM-L6-v2, about 90 MB) downloads on first use.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 30 minutes on the first run (XBRL frames, six quarterly SEC data sets and 500 10-K filings), about 3 minutes afterwards).

## Data sources

| Data | Source |
|---|---|
| SEC XBRL frames API and EDGAR submissions API | https://www.sec.gov/search-filings/edgar-application-programming-interfaces |
| SEC Financial Statement Data Sets | https://www.sec.gov/data-research/sec-markets-data/financial-statement-data-sets |
| SEC SIC code list | https://www.sec.gov/search-filings/standard-industrial-classification-sic-code-list |
| iShares Core S&P 500 ETF (IVV) holdings | https://www.ishares.com/us/products/239726/ |
| Yahoo Finance: weekly prices | https://finance.yahoo.com/ |

## Outputs (`outputs/`)

- `01_industry_analysis.png`
- `dashboard.html`
- `dashboard.png`
- `industry_clusters.csv`
- `industry_profiles_latest.csv`
- `industry_year_structure.csv`
- `peer_definitions_r2.csv`
- `stage_forecast_test.csv`
- `stage_transition_matrix.csv`

## Key assumptions

- Industries are SIC three-digit codes (latest code per company); companies with at least USD 10 million of revenue; industries with at least eight such companies; financial companies (SIC 6000–6799) excluded.
- Life-cycle stages from the signs of operating, investing and financing cash flows (Dickinson, 2011); the transition model is trained on 2010–2020 and tested on 2021–2025.
- Text peers: the ten S&P 500 members with the most similar Item 1 business descriptions (mean sentence embedding, cosine similarity); peer quality = R² of three years of weekly returns on the peers' average return.

## Suggested commit plan

1. `industry-life-cycles-competition: add XBRL panel, SIC codes and industry structure measures`
2. `industry-life-cycles-competition: add concentration–margin and profitability persistence tests`
3. `industry-life-cycles-competition: add life-cycle stages and transition forecasts`
4. `industry-life-cycles-competition: add industry clustering and text-based peers`
5. `industry-life-cycles-competition: add charts, dashboard and narrative`

## References

- U.S. Securities and Exchange Commission. XBRL frames API, Financial Statement Data Sets and EDGAR submissions API. https://www.sec.gov/search-filings/edgar-application-programming-interfaces
- U.S. Securities and Exchange Commission. Standard Industrial Classification (SIC) code list. https://www.sec.gov/search-filings/standard-industrial-classification-sic-code-list
- BlackRock iShares. Core S&P 500 ETF (IVV) holdings. https://www.ishares.com/
- Yahoo Finance. Weekly prices. https://finance.yahoo.com/
- CFA Institute. CFA Program Level I curriculum, Equity Investments: Industry and Company Analysis.
- U.S. Department of Justice & Federal Trade Commission. (2023). *Merger Guidelines*.
- Porter, M. E. (2008). The five competitive forces that shape strategy. *Harvard Business Review*, 86(1), 78–93.
- Dickinson, V. (2011). Cash flow patterns as a proxy for firm life cycle. *The Accounting Review*, 86(6), 1969–1994.
- Fama, E. F., & French, K. R. (2000). Forecasting profitability and earnings. *Journal of Business*, 73(2), 161–175.
- Hoberg, G., & Phillips, G. (2016). Text-based network industries and endogenous product differentiation. *Journal of Political Economy*, 124(5), 1423–1465.
- Bhojraj, S., Lee, C. M. C., & Oler, D. K. (2003). What's my line? A comparison of industry classification schemes for capital market research. *Journal of Accounting Research*, 41(5), 745–774.
- Reimers, N., & Gurevych, I. (2019). Sentence-BERT: Sentence embeddings using Siamese BERT-networks. *Proceedings of EMNLP-IJCNLP*, 3982–3992.
