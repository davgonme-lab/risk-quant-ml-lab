# SOFR Swap Spreads: Fair Value, Relative-Value Trading and Hedging with Machine Learning

A 30-year swap now yields less than a 30-year Treasury, something that would have looked impossible before 2008. Swap spreads today reflect the cost of holding Treasuries on bank balance sheets far more than credit risk. For a treasury desk that means a basis risk in every swap hedge, and a classic relative-value trade. This notebook builds the spreads from public trade reports, explains what drives them, and tests trading and hedging rules.

**What it does.** It builds two years of daily **SOFR swap rates** (2, 5, 10 and 30 years) from every interest-rate swap publicly reported to the DTCC repository, together with the **swap spreads** against Treasury yields. It then works in three steps:

1. **Fair value.** Ridge regression and LightGBM explain the spreads with their economic drivers: repo pressure, the Fed balance sheet and reverse repo, Treasury supply, the term premium and rate volatility. The residual is a rich/cheap signal.
2. **Relative value.** A DV01-neutral spread trade (swap against Treasury) is backtested walk-forward with costs. The signals are mean reversion, the fair-value residual and an ML forecast of the 20-day spread change.
3. **Hedging.** A Treasury position is hedged with swaps, using hedge ratios from DV01 matching, rolling OLS, a Kalman filter and a state-dependent LightGBM beta.

**Data.** The DTCC public swap data repository (CFTC cumulative rates reports, November 2024 to today), FRED (Treasury yields, SOFR, IORB, Fed balance sheet, reverse repo, TGA, Kim–Wright term premium, VIX), Treasury Fiscal Data (debt to the penny) and Yahoo Finance (MOVE index).

**Methods.** Robust aggregation of trades, ridge, LightGBM, SHAP, walk-forward backtests, a Kalman filter and conditional betas.

---

## Why it matters

Swap spreads are the basis risk of every bond portfolio hedged with swaps and a classic relative-value trade. Two years of daily SOFR swap rates are rebuilt from 126,000 publicly reported trades (1–4 pm New York, matching the Treasury marks) and compared with Treasury yields. Spreads collapsed in the April 2025 tariff sell-off (30Y to −95 bp) and have since widened back. Liquidity drivers (TGA, reverse repo, Fed balance sheet) dominate in sample, but no fair-value model explains the level out of sample, and mean-reversion, residual and ML signals do not beat costs; a swap hedge of a 10Y Treasury removes 89% of daily variance whatever the hedge-ratio method, and the ML conditional beta is worse.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 25 minutes the first time (≈490 daily DTCC reports), about 2 minutes afterwards).

## Data sources

| Data | Source |
|---|---|
| DTCC public swap data repository (CFTC cumulative rates reports, Nov-2024 onwards) | https://pddata.dtcc.com/ppd/cftcdashboard |
| Treasury yields, SOFR, IORB, Fed balance sheet, ON RRP, TGA, Kim–Wright term premium, VIX (FRED) | https://fred.stlouisfed.org |
| Debt to the Penny (Treasury Fiscal Data) | https://fiscaldata.treasury.gov/datasets/debt-to-the-penny/ |
| MOVE index (Yahoo Finance) | https://finance.yahoo.com/quote/%5EMOVE |

## Outputs (`outputs/`)

- `01_swap_spreads.png`
- `dashboard.html`
- `dashboard.png`
- `fair_value_model_scores.csv`
- `fair_value_shap_10y.csv`
- `hedge_effectiveness.csv`
- `rv_backtest_performance.csv`
- `sofr_swap_rates_daily.csv`
- `swap_spreads_and_drivers.csv`

## Key assumptions

- Spread = SOFR swap rate (annual ACT/360) − CMT yield (semi-annual), no convention adjustment.
- Spread trade P&L in bp of spread per unit DV01, 20-day overlapping sleeves, 0.5 bp round-trip cost, no carry or repo.
- Fair value validated with five contiguous blocks and a 10-day embargo; walk-forward signals refitted every 20 days.

## Suggested commit plan

1. `sofr-swap-spreads: add daily SOFR swap rates from DTCC trades and swap spreads`
2. `sofr-swap-spreads: add fair-value models, walk-forward RV backtest`
3. `sofr-swap-spreads: add hedge-ratio comparison (DV01, OLS, Kalman, ML)`

## References

### Finance and regulation

- Jermann, U. J. (2020). Negative swap spreads and limited arbitrage. *The Review of Financial Studies, 33*(1), 212–238. https://doi.org/10.1093/rfs/hhz030
- Du, W., Hébert, B., & Li, W. (2023). Intermediary balance sheets and the Treasury yield curve. *Journal of Financial Economics, 150*(3), 103722. https://doi.org/10.1016/j.jfineco.2023.103722
- Feldhütter, P., & Lando, D. (2008). Decomposing swap spreads. *Journal of Financial Economics, 88*(2), 375–405. https://doi.org/10.1016/j.jfineco.2007.07.004
- Duarte, J., Longstaff, F. A., & Yu, F. (2007). Risk and return in fixed-income arbitrage: Nickels in front of a steamroller? *The Review of Financial Studies, 20*(3), 769–811. https://doi.org/10.1093/rfs/hhl026
- Kim, D. H., & Wright, J. H. (2005). *An arbitrage-free three-factor term structure model and the recent behavior of long-term yields and distant-horizon forward rates* (Finance and Economics Discussion Series 2005-33). Federal Reserve Board. https://www.federalreserve.gov/pubs/feds/2005/200533/200533abs.html

### Machine learning and deep learning

- Kalman, R. E. (1960). A new approach to linear filtering and prediction problems. *Journal of Basic Engineering, 82*(1), 35–45. https://doi.org/10.1115/1.3662552
- Ke, G., Meng, Q., Finley, T., Wang, T., Chen, W., Ma, W., Ye, Q., & Liu, T.-Y. (2017). LightGBM: A highly efficient gradient boosting decision tree. *Advances in Neural Information Processing Systems, 30*. https://proceedings.neurips.cc/paper/2017/hash/6449f44a102fde848669bdd9eb6b76fa-Abstract.html
- Lundberg, S. M., & Lee, S.-I. (2017). A unified approach to interpreting model predictions. *Advances in Neural Information Processing Systems, 30*. https://arxiv.org/abs/1705.07874
- Hoerl, A. E., & Kennard, R. W. (1970). Ridge regression: Biased estimation for nonorthogonal problems. *Technometrics, 12*(1), 55–67. https://doi.org/10.1080/00401706.1970.10488634
