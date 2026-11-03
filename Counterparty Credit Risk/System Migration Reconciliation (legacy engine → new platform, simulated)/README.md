# System Migration Reconciliation (legacy engine → new platform, simulated)

Replacing a bank's risk engine is one of the riskiest projects a risk team runs. For weeks the old and new systems value every trade side by side, and every difference has to be explained before anyone signs off. Most differences are harmless noise, and the hard part is finding the real defects hidden among them. This notebook simulates that parallel run and tests which methods find the real breaks.

**What it does.** It reproduces the parallel run that comes before a risk-system migration, such as moving counterparty exposure from a Numerix-style legacy engine to a Murex-style platform.

3,000 swaps are valued in both systems, and static data, MtM, DV01 and PFE are reconciled. Anomaly-detection models then separate genuine breaks from harmless model noise to produce a sign-off pack.

**Data.** Today's SOFR curve and Treasury volatility (U.S. Treasury, FRED). The trade population and both systems' trade records are synthetic, with known defects injected so that detection can be scored.

**Methods.** Two independent Hull–White exposure engines (different curve interpolation, random numbers and market-data feeds) and a DuckDB reconciliation (outer joins, field-level compare, tolerance tests).

Isolation Forest and a PyTorch autoencoder learn the normal shape of valuation differences, and flagged trades are clustered for root-cause analysis.

**Key output.** Matched and unmatched population, static-data breaks, valuation breaks by method with precision and recall by defect type, root-cause clusters, and a sign-off dashboard by book.

---

## Why it matters

Before a risk-system migration is signed off, every difference between the old and new engines has to be explained. On 3,000 simulated swaps with known injected defects, fixed tolerances flag half of the clean trades. Static compare + an autoencoder + a segment drift test reach 96% precision and 99% recall, and clustering groups the valuation breaks into root causes.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 1.5 minutes).

## Data sources

| Data | Source |
|---|---|
| Treasury par yield curve | https://home.treasury.gov/resource-center/data-chart-center/interest-rates |
| SOFR, Treasury CMT yields | https://fred.stlouisfed.org |

## Outputs (`outputs/`)

- `01_difference_signatures.png`
- `02_recall_by_defect_and_method.png`
- `dashboard.html`
- `dashboard.png`
- `detection_scores.csv`
- `reconciliation_detail.csv`
- `root_cause_clusters.csv`

## Key assumptions

- Both systems are simulated Hull–White engines with different interpolation, random numbers and market-data feeds; trades and defects are synthetic with known labels.
- Defects: notional units, direction, rate typo, maturity roll, missing fixing, day-count on a book, wrong discount curve, wrong vol mapping; plus missing and duplicated trades.
- Anomaly detectors flag 8% of trades (planning assumption); segment test uses medians, 6 robust s.e. and materiality thresholds.

## Suggested commit plan

1. `add README and reconciliation framework`
2. `legacy population and migrated copy with injected defects`
3. `two exposure engines`
4. `DuckDB population, static and tolerance reconciliation`
5. `Isolation Forest, autoencoder and segment drift test`
6. `root-cause clustering, sign-off dashboard and executed outputs`

## References

### Finance and regulation

- Basel Committee on Banking Supervision. (2013). *Principles for effective risk data aggregation and risk reporting* (BCBS 239). Bank for International Settlements. https://www.bis.org/publ/bcbs239.htm
- Board of Governors of the Federal Reserve System. (2011). *Supervisory guidance on model risk management* (SR 11-7). https://www.federalreserve.gov/boarddocs/srletters/2011/sr1107.htm
- Hull, J., & White, A. (1990). Pricing interest-rate-derivative securities. *The Review of Financial Studies, 3*(4), 573–592. https://doi.org/10.1093/rfs/3.4.573
- Hagan, P. S., & West, G. (2006). Interpolation methods for curve construction. *Applied Mathematical Finance, 13*(2), 89–129. https://doi.org/10.1080/13504860500396032
- Gregory, J. (2020). *The xVA challenge: Counterparty risk, funding, collateral, capital and initial margin* (4th ed.). Wiley. https://doi.org/10.1002/9781119508991

### Machine learning and deep learning

- Liu, F. T., Ting, K. M., & Zhou, Z.-H. (2008). Isolation forest. In *Proceedings of the 2008 Eighth IEEE International Conference on Data Mining* (pp. 413–422). https://doi.org/10.1109/ICDM.2008.17
- Hinton, G. E., & Salakhutdinov, R. R. (2006). Reducing the dimensionality of data with neural networks. *Science, 313*(5786), 504–507. https://doi.org/10.1126/science.1127647
- Chandola, V., Banerjee, A., & Kumar, V. (2009). Anomaly detection: A survey. *ACM Computing Surveys, 41*(3), 1–58. https://doi.org/10.1145/1541880.1541882
- Raasveldt, M., & Mühleisen, H. (2019). DuckDB: An embeddable analytical database. In *Proceedings of the 2019 International Conference on Management of Data*. https://doi.org/10.1145/3299869.3320212
