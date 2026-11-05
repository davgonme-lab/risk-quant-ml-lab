# Securitised Auto-Loan Pool: Early-Warning Indicators

Investors in an auto-loan securitisation watch the pool every month, but the headline numbers arrive late: a borrower shows up as 60 days late two months after the first missed payment, and losses come months after that. Earlier signals sit in the monthly flows, once the pool's normal ageing and seasonal pattern are taken out. This notebook builds that early-warning system from a real deal's loan-level filings.

**What it does.** It turns the loan-level filings of a public auto-loan securitisation (CarMax Auto Owner Trust 2022-4, about 67,700 loans and $1.66bn at closing) into a monthly early-warning system.

In SQL it builds the indicators a surveillance analyst tracks: delinquency buckets, roll rates, cure rates, net losses, payment ratios, prepayment and modifications. It removes the pool's expected seasonality and seasoning, and detects structural breaks with change-point methods and a one-sided CUSUM run month by month.

An Isolation Forest flags anomalous loans and is tested on whether loans that are still current go on to default. Control charts by borrower segment and a RAG dashboard complete it.

**Data.** SEC EDGAR Form ABS-EE, Exhibit 102 (Regulation AB II asset-level data) for CarMax Auto Owner Trust 2022-4: every monthly filing from closing (October 2022) to the latest report, about 2 million loan-months.

**Methods.** DuckDB SQL over the monthly tapes, a log-linear expected path with month-of-year and loan-age terms, PELT change-point detection (ruptures) and a one-sided CUSUM with an expanding-window baseline.

The Isolation Forest (unsupervised) is scored out of time by AUC against realised defaults, and binomial control charts cover each segment.

**Key output.** The indicator history with detected breaks and CUSUM alarms, how far ahead the alarms come compared with the 60+ delinquency rate, the anomaly score's power to anticipate defaults among loans that are still current, segment flags, and an interactive dashboard.

---

## Why it matters

Surveillance of a securitised pool is a monthly job, and the headline 60+ rate arrives late. Built from every ABS-EE filing of CarMax Auto Owner Trust 2022-4 (2 million loan-months), the indicator panel shows 60+ delinquency rising to 4.4% and cumulative net loss to 5.5% at a 12% pool factor. A real-time CUSUM first flags the deterioration in August 2024, pool-level flow indicators lead by at most a month, and an unsupervised Isolation Forest ranks future defaults among still-current loans with an out-of-time AUC of 0.84; its top decile holds 56% of them.

## How to run

1. `conda activate quant-risk`. `.env` needs `SEC_USER_AGENT` (name and email, as the SEC's fair-access policy requires).
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 1 minute once cached; the first run downloads 49 monthly files (~6 minutes)).

## Data sources

| Data | Source |
|---|---|
| SEC EDGAR Form ABS-EE, Exhibit 102 asset-level data, CarMax Auto Owner Trust 2022-4 (CIK 1946521) | https://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&CIK=0001946521&type=ABS-EE |

## Outputs (`outputs/`)

- `01_indicators_changepoints_anomalies.png`
- `dashboard.html`
- `dashboard.png`
- `anomaly_lift_by_decile.csv`
- `change_points_and_alarms.csv`
- `pool_indicators_monthly.csv`
- `rag_status.csv`
- `segment_control_chart.csv`

## Key assumptions

- Delinquency by balance at month end; roll and cure rates from each loan's previous-month status.
- Expected path: log indicator on month-of-year dummies, log(age) and age; CUSUM k = 0.5, h = 4 on expanding-window forecast errors.
- Isolation Forest fitted on the first 12 months; outcome = 60+ or charge-off within 6 months, evaluated only on currently-current loans.

## Suggested commit plan

1. `add README and ABS-EE loader`
2. `SQL indicator panel`
3. `change points and real-time CUSUM`
4. `Isolation Forest early warning`
5. `segment control charts and dashboard`

## References

### Finance and regulation

- Page, E. S. (1954). Continuous inspection schemes. *Biometrika, 41*(1–2), 100–115. https://doi.org/10.1093/biomet/41.1-2.100
- Adams, W., Einav, L., & Levin, J. (2009). Liquidity constraints and imperfect information in subprime lending. *American Economic Review, 99*(1), 49–84. https://doi.org/10.1257/aer.99.1.49

### Machine learning and deep learning

- Killick, R., Fearnhead, P., & Eckley, I. A. (2012). Optimal detection of changepoints with a linear computational cost. *Journal of the American Statistical Association, 107*(500), 1590–1598. https://doi.org/10.1080/01621459.2012.737745
- Truong, C., Oudre, L., & Vayatis, N. (2020). Selective review of offline change point detection methods. *Signal Processing, 167*, 107299. https://doi.org/10.1016/j.sigpro.2019.107299
- Liu, F. T., Ting, K. M., & Zhou, Z.-H. (2008). Isolation forest. In *Proceedings of the 2008 Eighth IEEE International Conference on Data Mining* (pp. 413–422). https://doi.org/10.1109/ICDM.2008.17
- Raasveldt, M., & Mühleisen, H. (2019). DuckDB: An embeddable analytical database. In *Proceedings of the 2019 International Conference on Management of Data*. https://doi.org/10.1145/3299869.3320212
