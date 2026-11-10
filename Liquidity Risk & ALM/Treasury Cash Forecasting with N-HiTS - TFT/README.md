# Treasury Cash Forecasting with N-HiTS / TFT

A treasury that cannot predict its cash needs has to hold a bigger buffer, borrow at short notice, or both. The size of the forecast error is therefore a direct input to the liquidity buffer. This notebook forecasts the U.S. Treasury's own daily cash flows, the cleanest public example of the problem, with two modern deep-learning models and the classical benchmarks.

**What it does.** It forecasts the U.S. Treasury's daily operating cash flows (deposits and withdrawals, excluding debt issuance and redemptions) 20 business days ahead, the problem every treasury cash-management desk solves to size its liquidity buffer.

Two deep-learning forecasters (N-HiTS and the Temporal Fusion Transformer) are compared with seasonal-naive, ETS and ARIMA benchmarks in a rolling-origin backtest. Results are shown for daily flows and for the cumulative cash-balance path.

**Data.** The Daily Treasury Statement from the U.S. Treasury Fiscal Data API: every line of Table II (deposits and withdrawals of operating cash) since 2015.

**Methods.** ETL of about 340,000 DTS lines into daily totals with DuckDB, and a calendar feature set (tax dates, benefit-payment days, month ends, holidays).

The forecasters are `statsforecast` (SeasonalNaive, AutoETS, AutoARIMA) and `neuralforecast` (NHITS, and TFT with future calendar covariates), compared over 8 rolling 20-day windows.

**Key output.** Error by model and horizon for daily flows and for the 20-day cumulative balance change, the calendar effects the models learn, and a forecast dashboard.

---

## Why it matters

A treasury sizes its cash buffer from its forecast error. On the U.S. Treasury's daily operating cash flows, a Temporal Fusion Transformer that sees the future calendar halves the daily error of seasonal naive and ETS/ARIMA (net-flow MAE $42bn vs $51–73bn) and gives the smallest 95% buffer for the 20-day cumulative path ($477bn). N-HiTS, despite good gross-flow forecasts, accumulates bias in the net and needs the largest buffer.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (**about 20 minutes** on a CPU (AutoARIMA search and two neural nets over 8 windows)).

## Data sources

| Data | Source |
|---|---|
| Daily Treasury Statement, Table II (deposits and withdrawals of operating cash) | https://fiscaldata.treasury.gov/datasets/daily-treasury-statement/ |

## Outputs (`outputs/`)

- `01_flows_calendar_horizon.png`
- `dashboard.html`
- `dashboard.png`
- `cv_forecasts.csv`
- `dts_daily_flows.csv`
- `forecast_scores.csv`
- `liquidity_buffer.csv`

## Key assumptions

- Debt issuance and redemptions excluded (decisions, not forecasts); daily totals by DuckDB from ~340,000 DTS lines since 2015.
- Calendar covariates known in advance: tax dates, 15 April, Social Security Wednesdays, month start and end, holidays.
- 8 rolling 20-business-day windows; statistical models on the last ~3 years; NHITS 800 steps, TFT 300 steps.

## Suggested commit plan

1. `add README and cash-forecasting framework`
2. `Fiscal Data API ETL into DuckDB`
3. `calendar features`
4. `statsforecast and neuralforecast backtests`
5. `cumulative-path errors, buffer sizing, dashboard and executed outputs`

## References

### Finance and regulation

- Hyndman, R. J., & Athanasopoulos, G. (2021). *Forecasting: Principles and practice* (3rd ed.). OTexts. https://otexts.com/fpp3/
- Hyndman, R. J., & Koehler, A. B. (2006). Another look at measures of forecast accuracy. *International Journal of Forecasting, 22*(4), 679–688. https://doi.org/10.1016/j.ijforecast.2006.03.001
- Basel Committee on Banking Supervision. (2008). *Principles for sound liquidity risk management and supervision*. Bank for International Settlements. https://www.bis.org/publ/bcbs144.htm

### Machine learning and deep learning

- Challu, C., Olivares, K. G., Oreshkin, B. N., Garza Ramirez, F., Mergenthaler Canseco, M., & Dubrawski, A. (2023). NHITS: Neural hierarchical interpolation for time series forecasting. In *Proceedings of the AAAI Conference on Artificial Intelligence, 37*(6), 6989–6997. https://doi.org/10.1609/aaai.v37i6.25854
- Lim, B., Arık, S. Ö., Loeff, N., & Pfister, T. (2021). Temporal fusion transformers for interpretable multi-horizon time series forecasting. *International Journal of Forecasting, 37*(4), 1748–1764. https://doi.org/10.1016/j.ijforecast.2021.03.012
- Oreshkin, B. N., Carpov, D., Chapados, N., & Bengio, Y. (2020). N-BEATS: Neural basis expansion analysis for interpretable time series forecasting. In *Proceedings of the 8th International Conference on Learning Representations*. https://arxiv.org/abs/1905.10437
- Hyndman, R. J., & Khandakar, Y. (2008). Automatic time series forecasting: The forecast package for R. *Journal of Statistical Software, 27*(3), 1–22. https://doi.org/10.18637/jss.v027.i03
