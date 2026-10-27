# LGD Modeling: Two-Stage, Beta & Fractional Regression

**What it does:** estimates loss given default on 260,000 charged-off Lending Club consumer loans. It measures realised LGD from the recovery cash flows, shows how incomplete workouts bias recent vintages, and compares six LGD models out of time: a grade lookup table, OLS, fractional logit, beta regression, a two-stage (zero-recovery + severity) model and LightGBM. It ends with a downturn view of LGD against U.S. unemployment.
**Data:** Lending Club accepted loans 2007–2018 (Kaggle `wordsforthewise/lending-club`), filtered and aggregated with DuckDB; U.S. unemployment rate (FRED).
**Methods:** workout-LGD definition; resolution-bias analysis; OLS; Papke–Wooldridge fractional logit (quasi-binomial GLM); beta regression with the Smithson–Verkuilen squeeze; two-stage hurdle model; LightGBM with a cross-entropy objective; out-of-time validation with RMSE, MAE, rank correlation, calibration by decile and loss-weighted accuracy; downturn LGD.
**Key output:** the realised LGD distribution; out-of-time accuracy by model; drivers of recovery; and the downturn add-on.

---

## Why it matters

LGD drives capital almost one for one, yet it is the weakest credit parameter. On 269,000 charged-off Lending Club loans, realised LGD averages 91% and is set mostly by the recovery channel (debt sale, settlement or nothing) rather than by the borrower. Six models, from a sub-grade lookup to beta regression, a two-stage hurdle model and LightGBM, all explain almost nothing out of time (R² ≈ 0, rank correlation 0.08–0.15), and the lookup table is as accurate as any. The notebook documents resolution bias in recent defaults, a 1%→18% jump in collection fees in 2015, and a downturn LGD of 94% against a 90% long run.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY` (shared setup cell) and Kaggle access: `KAGGLE_API_TOKEN` in `.env` or `~/.kaggle/access_token`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 1 minute the first time (390 MB download filtered with DuckDB), seconds afterwards).

## Data sources

| Data | Source |
|---|---|
| Lending Club accepted loans 2007–2018 | Kaggle `wordsforthewise/lending-club` |
| U.S. unemployment rate (UNRATE) | https://fred.stlouisfed.org |

## Outputs (`outputs/`)

- `01_lgd_distribution_bias_calibration.png`
- `02_model_comparison_drivers.png`
- `downturn_lgd_quarterly.csv`
- `lgd_by_default_year.csv`
- `lgd_drivers.csv`
- `out_of_time_validation.csv`

## Key assumptions

- LGD = 1 − (recoveries − collection fees) / (funded amount − principal repaid), capped to [0, 1]; last payment date used as the default date.
- Train on defaults in 2010–2015, test on 2016; later defaults have incomplete workouts.
- Recoveries are not discounted (timing not public).

## Suggested commit plan

1. `add README and LGD framework`
2. `DuckDB extraction of charged-off loans and LGD definition`
3. `resolution bias and recovery channels`
4. `six LGD models and out-of-time validation`
5. `drivers, downturn LGD and executed outputs`
