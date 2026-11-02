# Peer Groups and Proxy Credit Spreads for Unquoted Emerging-Market Names (K-means & KNN)

Every emerging-market lender and CVA desk faces the same question: what credit spread should we use for a country or company that has no bond or CDS quote? The usual answer, an average over the same region and sector, puts Chile in the same bucket as Bolivia. This notebook builds peer groups from fundamentals instead and tests honestly whether they give better proxies.

**What it does.** It builds a peer-group engine from about 1,800 emerging-market USD bonds.

**K-means** clusters countries on macro and governance fundamentals, and issuers on their country risk and sector. **K-nearest neighbours (KNN)** then imputes a spread from the most similar quoted names.

Both are benchmarked against the regulatory-style region × sector bucket proxy, a ridge regression and LightGBM, in tests that hide each name before predicting it.

The engine then produces proxy sovereign spreads for countries with no USD bonds, a KNN spread-tier classifier, and the CVA impact of the choice of proxy.

**Data.** iShares J.P. Morgan USD EM sovereign (EMB) and EM corporate (CEMB) bond holdings, the U.S. Treasury par curve, and World Bank WDI (GDP per capita, growth, inflation, current account, reserves, external debt) and Worldwide Governance Indicators.

**Methods.** Z-spreads, a pooled maturity adjustment, K-means with silhouette selection, PCA for display, KNN regression and classification with tuned k and distance weighting, ridge and LightGBM benchmarks, and leave-one-country-out and grouped cross-validation by issuer.

**Key output.** The peer groups, the out-of-sample error of each proxy method for sovereigns and corporates, proxy spreads (with their nearest peers) for unquoted countries, spread-tier classification accuracy, and the CVA difference between bucket and KNN proxies.

---

## Why it matters

An EM lender or CVA desk must assign a spread to sovereigns and companies with no bond or CDS quote. On 1,722 EM USD bonds, fundamentals-based proxies beat the regulatory region bucket for sovereigns (ridge 38 bp median error vs 57 bp, ranking correlation 0.76 vs 0.28). For corporates, same-country peers win and KNN matches the Basel-style bucket on median error but cuts the portfolio CVA bias from −19% to −7% while giving an auditable list of peers. Proxies are produced for 79 unquoted countries, with clear warnings where fundamentals miss defaults (Ethiopia, Zimbabwe) or conflict (Libya).

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 1 minute).

## Data sources

| Data | Source |
|---|---|
| iShares J.P. Morgan USD EM Bond (EMB) and EM Corporate Bond (CEMB) holdings | https://www.ishares.com/us/products/239572/ |
| U.S. Treasury par yield curve | https://home.treasury.gov/resource-center/data-chart-center/interest-rates |
| World Bank WDI and Worldwide Governance Indicators | https://api.worldbank.org/v2 |

## Outputs (`outputs/`)

- `01_peer_groups_proxies_tiers.png`
- `corporate_proxy_scores.csv`
- `cva_proxy_impact.csv`
- `sovereign_peer_groups.csv`
- `sovereign_proxies_loco.csv`
- `sovereign_proxy_scores.csv`
- `tier_classifier_scores.csv`
- `unquoted_country_proxies.csv`

## Key assumptions

- Spreads are Treasury z-spreads of USD bonds, put on a 5-year-equivalent basis with a pooled maturity slope.
- K by silhouette; KNN k by inner cross-validation; the learned metric scales features by |ridge coefficients|.
- Leave-one-country-out (sovereigns) and 5-fold grouped-by-issuer CV (corporates).
- Stylised CVA: EE(t) = 0.6%·√t·N on a 5-year swap, flat hazard, 40% recovery.

## Suggested commit plan

1. `add README and proxy-spread framework`
2. `EM bond z-spreads and World Bank fundamentals`
3. `sovereign K-means and KNN proxies`
4. `corporate proxies and KNN tier classifier`
5. `unquoted-country proxies and CVA impact`

## References

### Finance and regulation

- Basel Committee on Banking Supervision. (2020). *Targeted revisions to the credit valuation adjustment risk framework*. Bank for International Settlements. https://www.bis.org/bcbs/publ/d507.htm
- International Accounting Standards Board. (2011). *IFRS 13 Fair value measurement*. IFRS Foundation. https://www.ifrs.org/issued-standards/list-of-standards/ifrs-13-fair-value-measurement/
- Cantor, R., & Packer, F. (1996). Determinants and impact of sovereign credit ratings. *Economic Policy Review, 2*(2), 37–53. https://doi.org/10.2139/ssrn.1028774
- Longstaff, F. A., Pan, J., Pedersen, L. H., & Singleton, K. J. (2011). How sovereign is sovereign credit risk? *American Economic Journal: Macroeconomics, 3*(2), 75–103. https://doi.org/10.1257/mac.3.2.75
- Kaufmann, D., Kraay, A., & Mastruzzi, M. (2011). The Worldwide Governance Indicators: Methodology and analytical issues. *Hague Journal on the Rule of Law, 3*(2), 220–246. https://doi.org/10.1017/S1876404511200046

### Machine learning and deep learning

- Lloyd, S. (1982). Least squares quantization in PCM. *IEEE Transactions on Information Theory, 28*(2), 129–137. https://doi.org/10.1109/TIT.1982.1056489
- Cover, T., & Hart, P. (1967). Nearest neighbor pattern classification. *IEEE Transactions on Information Theory, 13*(1), 21–27. https://doi.org/10.1109/TIT.1967.1053964
- Rousseeuw, P. J. (1987). Silhouettes: A graphical aid to the interpretation and validation of cluster analysis. *Journal of Computational and Applied Mathematics, 20*, 53–65. https://doi.org/10.1016/0377-0427(87)90125-7
- Hoerl, A. E., & Kennard, R. W. (1970). Ridge regression: Biased estimation for nonorthogonal problems. *Technometrics, 12*(1), 55–67. https://doi.org/10.1080/00401706.1970.10488634
