# Market Liquidity Risk: Amihud, Bid-Ask & LVaR

Value-at-Risk assumes a position can be sold at the mid price. In March 2020 that was not true for many bonds: spreads widened tenfold and dealers' balance sheets were full. A treasury liquidity portfolio exists to be sold in a crisis, so the real question is how much it costs, and how many days it takes, to raise cash from it when markets are stressed. This notebook measures exactly that.

**What it does.** It measures the market liquidity of 12 U.S.-listed ETFs that stand in for an MDB treasury portfolio (Treasuries, agencies, munis, MBS, IG and HY credit, EM debt, equities). It estimates effective bid-ask spreads from daily prices, Amihud price impact and turnover.

Liquidity is then added to VaR (L-VaR) in two ways: the cost of crossing a stressed spread, and the market impact of selling a $500mm position over several days. The notebook ends with a LightGBM forecast of next month's liquidity against an autoregressive benchmark.

**Data.** Daily OHLC and volume since 2007 (Yahoo Finance), and the VIX and ICE BofA OAS (FRED).

**Methods.** The Corwin–Schultz (2012) high-low and Abdi–Ranaldo (2017) close-high-low spread estimators, the Roll measure, Amihud (2002) illiquidity, and the Bangia et al. (1999) exogenous L-VaR.

Endogenous liquidity uses square-root market impact with an optimal liquidation horizon, and the forecast compares LightGBM with an AR(1) on log spreads, walk-forward.

**Key output.** Liquidity rankings in calm and stressed markets (March 2020), the L-VaR uplift by asset, days to liquidate and liquidation cost by position size, and how predictable liquidity is.

---

## Why it matters

A liquidity portfolio exists to be sold in a crisis. Spreads estimated from daily prices show that in March 2020 bond-ETF spreads widened 4–10 times, with short Treasuries the only cheap asset. At 20% of volume, $500mm takes 1 to 22 days to sell depending on the asset, which the L-VaR prices. ETF secondary volume is not asset-class liquidity (the agency ETF trades $1.5mm a day). LightGBM forecasts next month's spreads better than an AR(1), especially in stress.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 20 seconds).

## Data sources

| Data | Source |
|---|---|
| Daily OHLC and volume of 12 ETFs | Yahoo Finance via `yfinance` |
| VIX, ICE BofA HY OAS (last 900 days) | https://fred.stlouisfed.org |

## Outputs (`outputs/`)

- `01_liquidity_measures.png`
- `02_lvar_and_position_size.png`
- `03_liquidity_forecast.png`
- `liquidity_forecast_scores.csv`
- `liquidity_summary.csv`
- `lvar_500mm.csv`

## Key assumptions

- Corwin–Schultz and Abdi–Ranaldo spread estimators (floored at zero), Roll measure, Amihud illiquidity; spreads are estimates, not quotes.
- Liquidation at 20% of ADV, square-root impact, stressed case with ADV halved and March-2020 spreads.
- Walk-forward monthly forecasts of log spreads, LightGBM panel vs AR(1) per asset vs no change.

## Suggested commit plan

1. `add README and market-liquidity framework`
2. `ETF OHLCV ETL`
3. `spread and price-impact estimators`
4. `exogenous and endogenous L-VaR`
5. `liquidity forecast and executed outputs`

## References

### Finance and regulation

- Amihud, Y. (2002). Illiquidity and stock returns: Cross-section and time-series effects. *Journal of Financial Markets, 5*(1), 31–56. https://doi.org/10.1016/S1386-4181(01)00024-6
- Corwin, S. A., & Schultz, P. (2012). A simple way to estimate bid-ask spreads from daily high and low prices. *The Journal of Finance, 67*(2), 719–760. https://doi.org/10.1111/j.1540-6261.2012.01729.x
- Abdi, F., & Ranaldo, A. (2017). A simple estimation of bid-ask spreads from daily close, high, and low prices. *The Review of Financial Studies, 30*(12), 4437–4480. https://doi.org/10.1093/rfs/hhx084
- Roll, R. (1984). A simple implicit measure of the effective bid-ask spread in an efficient market. *The Journal of Finance, 39*(4), 1127–1139. https://doi.org/10.1111/j.1540-6261.1984.tb03897.x
- Bangia, A., Diebold, F. X., Schuermann, T., & Stroughair, J. D. (2001). Modeling liquidity risk, with implications for traditional market risk measurement and management. In S. Figlewski & R. M. Levich (Eds.), *Risk management: The state of the art* (pp. 3–13). Springer. https://doi.org/10.1007/978-1-4615-0791-8_1
- Almgren, R., & Chriss, N. (2001). Optimal execution of portfolio transactions. *Journal of Risk, 3*(2), 5–40. https://doi.org/10.21314/JOR.2001.041
- Haddad, V., Moreira, A., & Muir, T. (2021). When selling becomes viral: Disruptions in debt markets in the COVID-19 crisis and the Fed's response. *The Review of Financial Studies, 34*(11), 5309–5351. https://doi.org/10.1093/rfs/hhaa145

### Machine learning and deep learning

- Ke, G., Meng, Q., Finley, T., Wang, T., Chen, W., Ma, W., Ye, Q., & Liu, T.-Y. (2017). LightGBM: A highly efficient gradient boosting decision tree. *Advances in Neural Information Processing Systems, 30*. https://proceedings.neurips.cc/paper/2017/hash/6449f44a102fde848669bdd9eb6b76fa-Abstract.html
