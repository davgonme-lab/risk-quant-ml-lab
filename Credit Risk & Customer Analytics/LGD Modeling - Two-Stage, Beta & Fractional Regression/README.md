# LGD Modeling: Two-Stage, Beta & Fractional Regression

Loss given default is the credit parameter banks estimate worst, even though capital moves almost one for one with it. Recoveries arrive years after default, many loans recover nothing at all, and recoveries fall exactly when the economy does. This notebook works through those problems on 260,000 real charged-off consumer loans.

**What it does.** It estimates loss given default on 260,000 charged-off Lending Club consumer loans. It measures realised LGD from the recovery cash flows and shows how incomplete workouts bias recent vintages.

It then compares six LGD models out of time: a grade lookup table, OLS, fractional logit, beta regression, a two-stage model (zero recovery + severity) and LightGBM. It ends with a downturn view of LGD against U.S. unemployment.

**Data.** Lending Club accepted loans 2007–2018 (Kaggle `wordsforthewise/lending-club`), filtered and aggregated with DuckDB, and the U.S. unemployment rate (FRED).

**Methods.** A workout-LGD definition, a resolution-bias analysis, OLS, the Papke–Wooldridge fractional logit (quasi-binomial GLM), beta regression with the Smithson–Verkuilen squeeze, a two-stage hurdle model and LightGBM with a cross-entropy objective.

Validation is out of time, with RMSE, MAE, rank correlation, calibration by decile and loss-weighted accuracy, followed by a downturn LGD.

**Key output.** The realised LGD distribution, out-of-time accuracy by model, the drivers of recovery and the downturn add-on.

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

## References

### Finance and regulation

- Basel Committee on Banking Supervision. (2005). *Guidance on paragraph 468 of the Framework Document* (downturn LGD). Bank for International Settlements. https://www.bis.org/publ/bcbs115.htm
- Altman, E. I., Brady, B., Resti, A., & Sironi, A. (2005). The link between default and recovery rates: Theory, empirical evidence, and implications. *The Journal of Business, 78*(6), 2203–2228. https://doi.org/10.1086/497044
- Loterman, G., Brown, I., Martens, D., Mues, C., & Baesens, B. (2012). Benchmarking regression algorithms for loss given default modeling. *International Journal of Forecasting, 28*(1), 161–170. https://doi.org/10.1016/j.ijforecast.2011.01.006
- Bellotti, T., & Crook, J. (2012). Loss given default models incorporating macroeconomic variables for credit cards. *International Journal of Forecasting, 28*(1), 171–182. https://doi.org/10.1016/j.ijforecast.2010.08.005

### Machine learning and deep learning

- Papke, L. E., & Wooldridge, J. M. (1996). Econometric methods for fractional response variables with an application to 401(k) plan participation rates. *Journal of Applied Econometrics, 11*(6), 619–632. https://doi.org/10.1002/(SICI)1099-1255(199611)11:6<619::AID-JAE418>3.0.CO;2-1
- Ferrari, S., & Cribari-Neto, F. (2004). Beta regression for modelling rates and proportions. *Journal of Applied Statistics, 31*(7), 799–815. https://doi.org/10.1080/0266476042000214501
- Smithson, M., & Verkuilen, J. (2006). A better lemon squeezer? Maximum-likelihood regression with beta-distributed dependent variables. *Psychological Methods, 11*(1), 54–71. https://doi.org/10.1037/1082-989X.11.1.54
- Ke, G., Meng, Q., Finley, T., Wang, T., Chen, W., Ma, W., Ye, Q., & Liu, T.-Y. (2017). LightGBM: A highly efficient gradient boosting decision tree. *Advances in Neural Information Processing Systems, 30*. https://proceedings.neurips.cc/paper/2017/hash/6449f44a102fde848669bdd9eb6b76fa-Abstract.html
