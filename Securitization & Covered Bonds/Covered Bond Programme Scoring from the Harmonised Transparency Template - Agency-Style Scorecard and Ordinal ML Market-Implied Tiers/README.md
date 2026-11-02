# Covered Bond Programme Scoring from the Harmonised Transparency Template: Agency-Style Scorecard and Ordinal ML Market-Implied Tiers

Almost every labelled covered bond programme is rated AAA, so the ratings barely tell programmes apart. Their spreads do. Issuers publish a standard template describing each cover pool, which makes the programmes comparable field by field. This notebook builds a transparent agency-style score from those templates and then asks which disclosed characteristics the market actually prices.

**What it does.** It downloads every published **Harmonised Transparency Template (HTT)** of the mortgage covered bond programmes that carry the Covered Bond Label: about 115 programmes, every half-year since mid-2023. Cover-pool and structural metrics are parsed directly from the standard field codes.

Two scores are built from the HTT metrics:

- an **agency-style scorecard**: transparent points for collateral quality, refinancing risk, market-risk mismatches and the overcollateralisation cushion, combined like a rating agency's collateral and structure assessment;
- a **market-implied score**: the programmes are matched to their outstanding euro benchmark covered bonds, their maturity-adjusted spreads over the ECB AAA curve are ranked into five tiers, and an **ordinal logit** and **LightGBM** learn the tiers from HTT metrics and sovereign risk.

The result shows which disclosed characteristics the market prices, and gives a shadow score for programmes with no euro benchmark bonds.

**Data.** The Covered Bond Label HTT database (coveredbondlabel.com), iShares € Covered Bond UCITS ETF month-end holdings (bond prices), and from the ECB the AAA euro-area yield curve (Svensson parameters) and ten-year government bond yields.

**Methods.** HTT parsing by field code, an expert scorecard, fuzzy entity matching, ordinal logistic regression, LightGBM with programme-grouped cross-validation, SHAP and K-means peer groups.

---

## Why it matters

The Harmonised Transparency Template is the standard disclosure of every labelled covered bond programme, and it is what analysts and agencies read first. 557 templates from 173 mortgage programmes (22 countries, 2023-2026) are parsed directly from the original workbooks into an agency-style scorecard (collateral, refinancing, market risk, OC cushion). Matched to euro benchmark spreads, the scorecard alone does not explain market prices: the sovereign dominates, a larger refinancing gap widens spreads, and high OC trades wider because it signals a weaker issuer. LightGBM on the raw HTT metrics predicts the market tier within one notch 81% of the time (country benchmark 77%) and gives shadow tiers to 56 programmes with no euro benchmark bonds.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY` (checked at start-up; the data itself needs no key).
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 15 minutes the first time (downloading and parsing ~700 HTT workbooks), under a minute afterwards).

## Data sources

| Data | Source |
|---|---|
| Covered Bond Label HTT database | https://www.coveredbondlabel.com/htt-database |
| iShares € Covered Bond UCITS ETF holdings (half-year ends) | https://www.ishares.com/ch/professionals/en/products/251842/ |
| ECB AAA yield curve (Svensson parameters) and 10-year government yields | https://data.ecb.europa.eu |

## Outputs (`outputs/`)

- `01_covered_bond_programme_scoring.png`
- `htt_metrics_and_scorecard.csv`
- `issuer_matching_audit.csv`
- `latest_scores_and_peer_groups.csv`
- `market_pricing_shap.csv`
- `market_tier_model_scores.csv`
- `ordinal_logit_coefficients.csv`
- `peer_groups.csv`

## Key assumptions

- Mortgage programmes only; the last template of each half-year from 2023-H2 (older templates are not downloadable).
- Scorecard thresholds and pillar weights (40/25/15/20) are illustrative, close to published agency bands.
- ETF issuers matched to HTT issuers by name within a country; maturity-adjusted spread = bond z-spread minus the median of its maturity bucket that month.
- Market tiers are half-year quintiles; cross-validation groups all half-years of a programme together.

## Suggested commit plan

1. `covered-bond-programme-scoring: add HTT download and field-code parser`
2. `covered-bond-programme-scoring: add agency-style scorecard`
3. `covered-bond-programme-scoring: add spread matching, ordinal logit and LightGBM market tiers, peer groups`

## References

### Finance and regulation

- European Parliament & Council of the European Union. (2019). *Directive (EU) 2019/2162 on the issue of covered bonds and covered bond public supervision*. https://eur-lex.europa.eu/eli/dir/2019/2162/oj
- Packer, F., Stever, R., & Upper, C. (2007). The covered bond market. *BIS Quarterly Review*, September, 43–55. https://www.bis.org/publ/qtrpdf/r_qt0709f.htm
- Prokopczuk, M., Siewert, J. B., & Vonhoff, V. (2013). Credit risk in covered bonds. *Journal of Empirical Finance, 21*, 102–120. https://doi.org/10.1016/j.jempfin.2012.12.003
- Svensson, L. E. O. (1994). *Estimating and interpreting forward interest rates: Sweden 1992–1994* (NBER Working Paper No. 4871). National Bureau of Economic Research. https://doi.org/10.3386/w4871

### Machine learning and deep learning

- McCullagh, P. (1980). Regression models for ordinal data. *Journal of the Royal Statistical Society: Series B, 42*(2), 109–127. https://doi.org/10.1111/j.2517-6161.1980.tb01109.x
- Ke, G., Meng, Q., Finley, T., Wang, T., Chen, W., Ma, W., Ye, Q., & Liu, T.-Y. (2017). LightGBM: A highly efficient gradient boosting decision tree. *Advances in Neural Information Processing Systems, 30*. https://proceedings.neurips.cc/paper/2017/hash/6449f44a102fde848669bdd9eb6b76fa-Abstract.html
- Christen, P. (2012). *Data matching: Concepts and techniques for record linkage, entity resolution, and duplicate detection*. Springer. https://doi.org/10.1007/978-3-642-31164-2
