# Interest-Rate Risk in the Banking Book from U.S. Call Reports: Synthetic Banks Built from Repricing Buckets, Behavioural Deposits, EVE and NII under the Basel Shocks, and Whether the 2021 Measures Foresaw 2022–2023

At the end of 2021 U.S. banks held record deposits, much of them invested in long fixed-rate securities and mortgages bought at near-zero rates. Over the next two years the Federal Reserve raised its policy rate by more than five points. Securities lost hundreds of billions of dollars in value, depositors moved money to higher-yielding alternatives, and in 2023 three large banks failed. Supervisors measure this risk with two standard tools: the change in the economic value of equity (EVE) under six prescribed rate shocks, and the change in net interest income (NII) over the next year. This notebook rebuilds both measures for every U.S. bank from its public call report, and then asks whether they, or a machine-learning model, saw the damage coming.

**What it does.**

1. It downloads the quarterly call-report data of every FDIC-insured bank from 2015 to 2026: repricing and maturity buckets of loans, securities, time deposits and borrowings; deposit mix; uninsured deposits; interest income and expense; and the fair value of securities.
2. It builds a **synthetic bank** for each size group (community, regional, large) and the cash flows of every individual bank from those buckets. Non-maturity deposits are treated behaviourally, with the Basel caps on stable deposits and their maturity.
3. It computes ΔEVE under the six Basel shocks and ΔNII under ±200 bp parallel shocks for every bank at the end of 2021, and runs the Basel outlier test (worst ΔEVE above 15% of Tier 1 capital).
4. It checks the 2021 measures against what happened:
   - the securities losses of 2022, given the actual move of the Treasury curve;
   - the deposit-rate pass-through (deposit beta) of 2022–2023, predicted from the 2015–2019 cycle with a cross-sectional model and with gradient boosting;
   - the change in net interest margin, with models trained on the 2015–2019 hiking cycle and tested on 2021–2023;
   - the banks that failed.

**Data.** FDIC BankFind Suite financial data (call reports) and the list of failed banks; Treasury constant-maturity yields and the effective federal funds rate (FRED).

**Methods.** Repricing-gap cash-flow construction, BCBS 368 standardised interest-rate shocks with a maturity-dependent floor, behavioural slotting of non-maturity deposits, deposit betas, ΔEVE and ΔNII, a duration check against realised securities losses, out-of-time ridge regression and LightGBM, and SHAP attribution.

**Key output.** The distribution of ΔEVE and ΔNII across U.S. banks at the end of 2021; the synthetic banks by size; how well bucket-based durations explain the 2022 securities losses; how predictable the 2022–2023 deposit betas and margin changes were; and where the failed banks sat.

---

## Why it matters

At the end of 2021 most U.S. banks held long fixed-rate assets bought at near-zero rates; two years later securities had lost hundreds of billions and three large banks had failed. Rebuilt from public call reports, the Basel EVE measure would have flagged 62% of banks as outliers, and applying the actual 2022 rate move to each bank's buckets predicts its securities losses with a 0.89 correlation. Deposit betas in 2021–2023 can be ranked from the previous cycle (rank correlation 0.72 with a ridge model) but their level rose from 0.24 to 0.35. Silicon Valley Bank and First Republic combined a large EVE loss with a high uninsured share; Signature failed on its depositors alone.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY` (Treasury yields and the federal funds rate). The FDIC BankFind API needs no key; the first run downloads about 45 quarters of call reports for all banks.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 4 minutes on CPU the first time (downloads), 2 minutes afterwards).

## Data sources

| Data | Source |
|---|---|
| FDIC BankFind Suite financial data (call reports) and failed-bank list | https://api.fdic.gov/banks/docs/ |
| Treasury constant-maturity yields and effective federal funds rate (FRED) | https://fred.stlouisfed.org/ |

## Outputs (`outputs/`)

- `01_irrbb_call_reports.png`
- `bank_level_eve_nii_2021.csv`
- `dashboard.html`
- `dashboard.png`
- `failed_banks_measures.csv`
- `failure_auc.csv`
- `hiking_cycles.csv`
- `nim_model_shap.csv`
- `out_of_time_scores.csv`
- `outlier_share_by_quarter.csv`
- `securities_loss_test.csv`
- `synthetic_banks.csv`

## Key assumptions

- Bucket midpoints for RC-B/RC-C/RC-E/RC-M maturity and repricing buckets; mortgages amortise with level payments and an 8% CPR, other loans amortise without prepayment, non-mortgage securities are bullets.
- Non-maturity deposits at the BCBS 368 caps: 90% / 70% / 50% core for transactional, non-transactional and wholesale (uninsured) balances, average maturities 5 / 4.5 / 4 years, linear run-off.
- USD shocks of 200 bp parallel, 300 bp short and 150 bp long with a 4-year decay and a maturity-dependent floor; outlier threshold 15% of Tier 1.
- ΔNII over 12 months with a constant balance sheet and a 0.40 beta on interest-bearing non-maturity deposits.
- Deposit beta = change in the cost of interest-bearing domestic deposits over the change in fed funds; models trained on 2015Q4–2019Q2 (with the 2004–2006 beta) and tested on 2021Q4–2023Q4.

## Suggested commit plan

1. `irrbb-call-reports: add FDIC call-report panel, failures and Treasury curves`
2. `irrbb-call-reports: add bucket cash flows, Basel shocks, ΔEVE and ΔNII for every bank`
3. `irrbb-call-reports: add synthetic banks by size`
4. `irrbb-call-reports: add 2022 securities-loss check`
5. `irrbb-call-reports: add out-of-time deposit-beta and margin models`
6. `irrbb-call-reports: add failed-bank review, charts, dashboard and narrative`

## References

### Finance and regulation

- Basel Committee on Banking Supervision. (2016). *Interest rate risk in the banking book* (Standards No. 368). Bank for International Settlements. https://www.bis.org/bcbs/publ/d368.htm
- Drechsler, I., Savov, A., & Schnabl, P. (2017). The deposits channel of monetary policy. *The Quarterly Journal of Economics, 132*(4), 1819–1876. https://doi.org/10.1093/qje/qjx019
- Drechsler, I., Savov, A., & Schnabl, P. (2021). Banking on deposits: Maturity transformation without interest rate risk. *The Journal of Finance, 76*(3), 1091–1143. https://doi.org/10.1111/jofi.13013
- English, W. B., Van den Heuvel, S. J., & Zakrajšek, E. (2018). Interest rate risk and bank equity valuations. *Journal of Monetary Economics, 98*, 80–97. https://doi.org/10.1016/j.jmoneco.2018.04.010
- Jiang, E. X., Matvos, G., Piskorski, T., & Seru, A. (2024). Monetary tightening and U.S. bank fragility in 2023: Mark-to-market losses and uninsured depositor runs? *Journal of Financial Economics, 159*, 103899. https://doi.org/10.1016/j.jfineco.2024.103899
- Federal Deposit Insurance Corporation. (2026). *BankFind Suite: Financial data* [Data set]. https://api.fdic.gov/banks/docs/

### Machine learning and deep learning

- Hoerl, A. E., & Kennard, R. W. (1970). Ridge regression: Biased estimation for nonorthogonal problems. *Technometrics, 12*(1), 55–67. https://doi.org/10.1080/00401706.1970.10488634
- Ke, G., Meng, Q., Finley, T., Wang, T., Chen, W., Ma, W., Ye, Q., & Liu, T.-Y. (2017). LightGBM: A highly efficient gradient boosting decision tree. *Advances in Neural Information Processing Systems, 30*. https://proceedings.neurips.cc/paper/2017/hash/6449f44a102fde848669bdd9eb6b76fa-Abstract.html
- Lundberg, S. M., & Lee, S.-I. (2017). A unified approach to interpreting model predictions. *Advances in Neural Information Processing Systems, 30*. https://proceedings.neurips.cc/paper/2017/hash/8a20a8621978632d76c43dfd28b67767-Abstract.html
