# Bank Failure Prediction (Liquidity & Solvency)

A development bank deals with commercial banks every day, as swap counterparties, custodians and bond issuers, so it needs to know which ones are getting weaker before the rating agencies say so. U.S. data make this testable: every insured bank files quarterly accounts, and every failure is public. This notebook builds a bank early-warning model and asks whether it would have seen the 2023 failures coming.

**What it does.** It predicts which U.S. banks will fail within the next year from their quarterly call reports, for every FDIC-insured bank since 2007.

It trains on the 2007–2012 failure wave, tests out of time on 2013–2026, and checks whether the models would have flagged Silicon Valley Bank, Signature Bank and First Republic before March 2023.

**Data.** Quarterly financials of all FDIC-insured institutions and the FDIC failure list (FDIC BankFind Suite API, `api.fdic.gov`), from 2007 Q1.

**Methods.** CAMELS-style ratios (capital, asset quality, earnings, liquidity, funding structure, CRE concentration, growth), logistic regression, LightGBM with class weighting and a discrete-time hazard model (complementary log-log).

Validation is out of time, with ROC-AUC, PR-AUC, top-decile capture and calibration, plus TreeSHAP explanations and a case study of the 2023 failures.

**Key output.** Out-of-time discrimination by model, the drivers of failure risk, how early failures are flagged, and the 2023 case study showing what solvency ratios miss.

---

## Why it matters

Counterparty reviews of banks start from call-report ratios. Trained on the 2007–2012 failure wave and tested out of time on 2013–2026, LightGBM reaches an AUC of 0.95 and puts 87.5% of failing banks in its top risk decile, flagging most of them four or more quarters ahead; capital, non-performing loans and CRE concentration drive the score. The 2023 case study is the caveat: Signature and First Republic ranked in the top 10% because of CRE concentration, but SVB sat at the 28th percentile, with strong capital and clean loans. Its risk was 86% uninsured deposits and unhedged securities losses, which a solvency model trained on credit failures does not price.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY` (loaded by the shared setup cell; the FDIC API itself needs no key).
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 5 minutes the first time (downloads ~80 quarters of call reports), seconds afterwards).

## Data sources

| Data | Source |
|---|---|
| Quarterly financials of FDIC-insured institutions; failed-bank list | FDIC BankFind Suite API (`https://api.fdic.gov/banks`) |

## Outputs (`outputs/`)

- `01_shap_capture_lead.png`
- `case_study_2023.csv`
- `lead_time.csv`
- `out_of_time_evaluation.csv`
- `shap_importance.csv`

## Key assumptions

- Target: failure 1–4 quarters after the reporting lag; banks leave the panel after failing or merging.
- Train 2007–2012, test 2013 onwards (out of time); balanced class weights (logit) and `scale_pos_weight` (LightGBM); ratios clipped at the 0.5%/99.5% quantiles.
- SVB, Signature and First Republic are scored on their December 2022 call reports with the model trained on the earlier wave.

## Suggested commit plan

1. `add README and bank-failure framework`
2. `FDIC API ETL and failure labels`
3. `CAMELS-style ratios`
4. `logistic, hazard and LightGBM out-of-time models`
5. `SHAP, lead time, 2023 case study and executed outputs`

## References

### Finance and regulation

- Cole, R. A., & White, L. J. (2012). Déjà vu all over again: The causes of U.S. commercial bank failures this time around. *Journal of Financial Services Research, 42*(1–2), 5–29. https://doi.org/10.1007/s10693-011-0116-9
- Shumway, T. (2001). Forecasting bankruptcy more accurately: A simple hazard model. *The Journal of Business, 74*(1), 101–124. https://doi.org/10.1086/209665
- Board of Governors of the Federal Reserve System. (2023). *Review of the Federal Reserve's supervision and regulation of Silicon Valley Bank*. https://www.federalreserve.gov/publications/files/svb-review-20230428.pdf
- Jiang, E. X., Matvos, G., Piskorski, T., & Seru, A. (2024). Monetary tightening and U.S. bank fragility in 2023: Mark-to-market losses and uninsured depositor runs? *Journal of Financial Economics, 159*, 103899. https://doi.org/10.1016/j.jfineco.2024.103899
- Wheelock, D. C., & Wilson, P. W. (2000). Why do banks disappear? The determinants of U.S. bank failures and acquisitions. *The Review of Economics and Statistics, 82*(1), 127–138. https://doi.org/10.1162/003465300558560

### Machine learning and deep learning

- Ke, G., Meng, Q., Finley, T., Wang, T., Chen, W., Ma, W., Ye, Q., & Liu, T.-Y. (2017). LightGBM: A highly efficient gradient boosting decision tree. *Advances in Neural Information Processing Systems, 30*. https://proceedings.neurips.cc/paper/2017/hash/6449f44a102fde848669bdd9eb6b76fa-Abstract.html
- Lundberg, S. M., Erion, G., Chen, H., DeGrave, A., Prutkin, J. M., Nair, B., … Lee, S.-I. (2020). From local explanations to global understanding with explainable AI for trees. *Nature Machine Intelligence, 2*(1), 56–67. https://doi.org/10.1038/s42256-019-0138-9
- Petropoulos, A., Siakoulis, V., Stavroulakis, E., & Vlachogiannakis, N. E. (2020). Predicting bank insolvencies using machine learning techniques. *International Journal of Forecasting, 36*(3), 1092–1113. https://doi.org/10.1016/j.ijforecast.2019.11.005
