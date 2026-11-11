# Local-Currency Risk & Hedging: COP vs MXN, BRL, CLP

A Colombian company with peso revenues should not carry dollar debt, so development banks lend more and more in local currency. The bank, though, funds itself in dollars, and every peso loan leaves it with a currency position it must either hedge or hold within a limit. This notebook measures how risky the peso is, compared with its neighbours, and finds the cheapest hedge that keeps the risk inside the limit.

**What it does.** It measures the risk of a Colombian peso (COP) exposure such as an MDB's local-currency loan book, compares it with the Mexican, Brazilian and Chilean currencies, forecasts its volatility, and designs the cheapest hedge that keeps the risk within limits.

**Data.** Daily USD exchange rates since 2018 (Yahoo Finance `COP=X`, `MXN=X`, `BRL=X`, `CLP=X`), local short-term interest rates (FRED / OECD), the U.S. 3-month T-bill and the VIX (FRED).

**Methods.** GARCH(1,1)-t per currency with a DCC model for time-varying correlations, and an out-of-sample volatility forecast comparison (GARCH, HAR and LightGBM).

Covered interest parity and carry price the hedge, and a `cvxpy` optimisation of direct and proxy hedges traces a cost–risk frontier.

**Key output.** The COP risk profile against its peers, dynamic correlations, next month's volatility forecast, the hedging cost curve and the optimal hedge mix, plus a local-currency risk dashboard.

---

## Why it matters

Lending in local currency protects borrowers from FX mismatch but leaves the MDB long COP and short USD. The risk officer must size that position against a VaR limit or hedge it. Hedging gives up the interest differential (about 9% a year for COP today), and cheaper proxy hedges in MXN or CLP remove only part of the risk. The frontier makes that trade-off explicit.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (under a minute).

## Data sources

| Data | Link |
|---|---|
| FX rates (`COP=X`, `MXN=X`, `BRL=X`, `CLP=X`) | Yahoo Finance via `yfinance` |
| Short-term rates: Colombia `COLIRSTCI01STM`, Mexico `IRSTCI01MXM156N`, Brazil `IRSTCI01BRM156N`, Chile `IRSTCI01CLM156N` | https://fred.stlouisfed.org (OECD MEI) |
| US 3-month T-bill `DTB3`, VIX `VIXCLS` | https://fred.stlouisfed.org |

## Outputs (`outputs/`)

| File | Content |
|---|---|
| `01_fx_levels_and_vol.png` | FX levels and rolling volatility |
| `02_dcc_correlations.png` | DCC correlations of COP with peers; by VIX regime |
| `03_vol_forecasts.png` | Out-of-sample volatility forecasts vs realised; LightGBM importance |
| `04_hedge_cost_and_carry.png` | Hedging cost history; spot vs carry of an unhedged COP position |
| `05_hedge_frontier.png` | Cost vs out-of-sample VaR of hedges |
| `dashboard.html` / `.png` | Local-currency risk dashboard |
| `currency_risk_profile.csv`, `vol_forecast_scores.csv`, `hedge_strategies_oos.csv`, `hedge_frontier.csv` | Report tables |

## Key assumptions

- Yahoo's COP history before 2018 is unreliable, so the sample starts in 2018; remaining one-day bad prints are repaired by a logged filter.
- Hedge cost = CIP carry + indicative bid–offer; the cross-currency basis is not observable from free data.
- Monthly OECD rates carried forward to daily.
- VaR limit (USD 25 mm) and exposure (USD 500 mm) are hypothetical.

## Suggested commit plan

1. `add README and local-currency risk framework`
2. `FX and rates ETL with data-quality filter`
3. `GARCH-t and DCC correlation model`
4. `volatility forecasting GARCH vs HAR vs LightGBM`
5. `CIP carry, hedge optimisation frontier, dashboard and executed outputs`

## References

### Finance and regulation

- Engle, R. (2002). Dynamic conditional correlation: A simple class of multivariate generalized autoregressive conditional heteroskedasticity models. *Journal of Business & Economic Statistics, 20*(3), 339–350. https://doi.org/10.1198/073500102288618487
- Corsi, F. (2009). A simple approximate long-memory model of realized volatility. *Journal of Financial Econometrics, 7*(2), 174–196. https://doi.org/10.1093/jjfinec/nbp001
- Du, W., Tepper, A., & Verdelhan, A. (2018). Deviations from covered interest rate parity. *The Journal of Finance, 73*(3), 915–957. https://doi.org/10.1111/jofi.12620
- Lustig, H., & Verdelhan, A. (2007). The cross section of foreign currency risk premia and consumption growth risk. *American Economic Review, 97*(1), 89–117. https://doi.org/10.1257/aer.97.1.89
- Eichengreen, B., Hausmann, R., & Panizza, U. (2007). Currency mismatches, debt intolerance, and the original sin: Why they are not the same and why it matters. In S. Edwards (Ed.), *Capital controls and capital flows in emerging economies* (pp. 121–170). University of Chicago Press. https://doi.org/10.7208/chicago/9780226184999.003.0004

### Machine learning and deep learning

- Ke, G., Meng, Q., Finley, T., Wang, T., Chen, W., Ma, W., Ye, Q., & Liu, T.-Y. (2017). LightGBM: A highly efficient gradient boosting decision tree. *Advances in Neural Information Processing Systems, 30*. https://proceedings.neurips.cc/paper/2017/hash/6449f44a102fde848669bdd9eb6b76fa-Abstract.html
- Diamond, S., & Boyd, S. (2016). CVXPY: A Python-embedded modeling language for convex optimization. *Journal of Machine Learning Research, 17*(83), 1–5. https://jmlr.org/papers/v17/15-408.html
