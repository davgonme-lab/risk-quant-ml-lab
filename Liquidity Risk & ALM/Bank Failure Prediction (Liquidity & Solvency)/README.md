# Bank Failure Prediction (Liquidity & Solvency)

**What it does:** predicts which U.S. banks will fail within the next year from their quarterly call reports, for every FDIC-insured bank since 2007. It trains on the 2007–2012 failure wave and tests out of time on 2013–2026, and checks whether the models would have flagged Silicon Valley Bank, Signature Bank and First Republic before March 2023.
**Data:** quarterly financials of all FDIC-insured institutions and the FDIC failure list (FDIC BankFind Suite API, `api.fdic.gov`), 2007 Q1 onwards.
**Methods:** CAMELS-style ratios (capital, asset quality, earnings, liquidity, funding structure, CRE concentration, growth); logistic regression; LightGBM with class weighting; a discrete-time hazard model (complementary log-log); out-of-time validation with ROC-AUC, PR-AUC, top-decile capture and calibration; TreeSHAP explanations; a case study of the 2023 failures.
**Key output:** out-of-time discrimination by model; the drivers of failure risk; how early failures are flagged; and the 2023 case study showing what solvency ratios miss.

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
