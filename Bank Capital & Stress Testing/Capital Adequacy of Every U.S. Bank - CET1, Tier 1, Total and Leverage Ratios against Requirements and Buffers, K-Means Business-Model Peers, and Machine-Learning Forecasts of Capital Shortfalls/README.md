# Capital Adequacy of Every U.S. Bank: CET1, Tier 1, Total and Leverage Ratios against Requirements and Buffers, K-Means Business-Model Peers, and Machine-Learning Forecasts of Capital Shortfalls

**Capital adequacy** is a bank's ability to absorb losses with its own funds and keep operating. It is measured as the ratio of capital to the risk the bank carries: capital over risk-weighted assets for the risk-based ratios, and capital over total exposure for the leverage ratio. Every U.S. bank reports these ratios each quarter, and supervisors sort banks into *prompt corrective action* (PCA) categories by them. Above the minimums sit buffers: a bank that dips into its capital conservation buffer faces automatic limits on dividends and bonuses.

This notebook takes the definition to the data for **all of the roughly 4,300 U.S. banks**, every quarter since 2015:

- **The definition, made concrete.** The capital components (CET1, Additional Tier 1, Tier 2), the four ratios, the PCA thresholds, the conservation buffer and the community bank leverage ratio (CBLR) option for small banks, turned into each bank's *binding headroom*: how many percentage points it stands above the buffer or CBLR threshold that binds it first.
- **The system, today and since 2015.** How many banks sit in each category, how much capital the system holds above its buffers, and how the share of banks inside their buffers moved through COVID and the 2022–2023 rate shock.
- **Business-model peers.** K-means clustering on loan mix, funding, securities, fee income and size, with the number of clusters chosen by silhouette. The clusters are named from their centroids, and a k-nearest-neighbour search finds each bank's ten closest peers. Capital is meaningful only against banks that run the same business.
- **Forecasting shortfalls.** A logistic regression, LightGBM and a GRU recurrent network read eight quarters of each bank's history. They predict which banks will fall inside their buffers within a year, trained to 2021 and tested on 2022–2025. Quantile LightGBM projects the 10th percentile of each bank's headroom a year ahead, turning risk into a projected capital shortfall in dollars.

**Data.** FDIC BankFind call-report financials of every insured U.S. bank, quarterly, 2015 to today (FDIC API).

**Methods.** PCA and buffer arithmetic, K-means with silhouette selection, k-nearest neighbours, logistic regression, LightGBM, GRU sequence classifier, quantile LightGBM, out-of-time AUC, PR-AUC and top-decile capture.

**Key output.** Every bank's capital category and headroom; the system's excess capital; business-model clusters with their capital levels; out-of-time accuracy of three shortfall models; banks most likely to breach their buffers next year and the projected shortfall.

---

## Why it matters

Capital adequacy, from its definition to every U.S. bank since 2015. About 4,300 banks hold roughly USD 765 billion above their buffers, and what binds them is leverage or total capital, not CET1. The jumps in banks inside their buffers in 2021–2022 came from the community bank leverage ratio returning to 9%, not from losses. K-means finds eight business models whose headroom ranges from 3.3 to 5.4 points. Out of time on 2022–2025, logistic regression, LightGBM and an eight-quarter GRU forecast buffer breaches a year ahead with AUC 0.90–0.92, barely better than ranking banks by today's headroom: capital moves slowly.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY` in `.env` (the FDIC data need no key).
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 6 minutes the first time (download of every quarterly call report since 2015), under a minute afterwards).

## Data sources

| Data | Source |
|---|---|
| FDIC BankFind API: quarterly call-report financials of every insured U.S. bank since 2015 | https://api.fdic.gov/banks/docs/ |

## Outputs (`outputs/`)

- `01_capital_adequacy_overview.png`
- `bank_capital_latest.csv`
- `business_model_clusters.csv`
- `capital_categories.csv`
- `dashboard.html`
- `dashboard.png`
- `nearest_peers.csv`
- `outlook.csv`
- `shortfall_forecast_accuracy.csv`
- `system_history.csv`
- `watch_list.csv`

## Key assumptions

- Buffer thresholds CET1 7.0%, Tier 1 8.5%, total 10.5%, leverage 5.0%; CBLR 9% (8% in late 2020 and 8.5% in 2021); PCA well- and adequately-capitalized thresholds at bank level; stress capital buffers and G-SIB surcharges not applied.
- Breach event: a bank outside its buffer falls inside it (or below the CBLR threshold) in any of the next four quarters; training observations to December 2021, test from March 2022.
- Clustering on eleven business-model features of banks with loans above 5% of assets; k chosen by silhouette among 4–9.

## Suggested commit plan

1. `capital-adequacy-all-us-banks: add every bank's call-report capital data since 2015`
2. `capital-adequacy-all-us-banks: add PCA categories, buffers, CBLR and binding headroom`
3. `capital-adequacy-all-us-banks: add the system history`
4. `capital-adequacy-all-us-banks: add K-means business-model clusters and nearest peers`
5. `capital-adequacy-all-us-banks: add logistic, LightGBM and GRU breach forecasts and projected shortfalls`
6. `capital-adequacy-all-us-banks: add charts, dashboard and narrative`

## References

- Basel Committee on Banking Supervision. (2011). *Basel III: A global regulatory framework for more resilient banks and banking systems* (revised June 2011). Bank for International Settlements. https://www.bis.org/publ/bcbs189.htm
- Berger, A. N., & Bouwman, C. H. S. (2013). How does capital affect bank performance during financial crises? *Journal of Financial Economics*, 109(1), 146–176. https://doi.org/10.1016/j.jfineco.2013.02.008
- Cho, K., van Merriënboer, B., Gulcehre, C., Bahdanau, D., Bougares, F., Schwenk, H., & Bengio, Y. (2014). Learning phrase representations using RNN encoder–decoder for statistical machine translation. In *Proceedings of EMNLP 2014* (pp. 1724–1734).
- Cover, T., & Hart, P. (1967). Nearest neighbor pattern classification. *IEEE Transactions on Information Theory*, 13(1), 21–27. https://doi.org/10.1109/TIT.1967.1053964
- Federal Deposit Insurance Corporation. *BankFind Suite API: institution financials*. https://api.fdic.gov/banks/docs/
- Ke, G., Meng, Q., Finley, T., Wang, T., Chen, W., Ma, W., Ye, Q., & Liu, T.-Y. (2017). LightGBM: A highly efficient gradient boosting decision tree. In *Advances in Neural Information Processing Systems 30* (pp. 3146–3154).
- Koenker, R., & Bassett, G. (1978). Regression quantiles. *Econometrica*, 46(1), 33–50. https://doi.org/10.2307/1913643
- MacQueen, J. (1967). Some methods for classification and analysis of multivariate observations. In *Proceedings of the Fifth Berkeley Symposium on Mathematical Statistics and Probability* (Vol. 1, pp. 281–297). University of California Press.
- Office of the Comptroller of the Currency, Board of Governors of the Federal Reserve System, & Federal Deposit Insurance Corporation. (2019). Regulatory capital rule: Capital simplification for qualifying community banking organizations (community bank leverage ratio). *Federal Register*, 84, 61776.
- Office of the Comptroller of the Currency & Board of Governors of the Federal Reserve System. (2013). Regulatory capital rules: Implementation of Basel III, capital adequacy, transition provisions, prompt corrective action. *Federal Register*, 78, 62018.
- Rousseeuw, P. J. (1987). Silhouettes: A graphical aid to the interpretation and validation of cluster analysis. *Journal of Computational and Applied Mathematics*, 20, 53–65. https://doi.org/10.1016/0377-0427(87)90125-7
