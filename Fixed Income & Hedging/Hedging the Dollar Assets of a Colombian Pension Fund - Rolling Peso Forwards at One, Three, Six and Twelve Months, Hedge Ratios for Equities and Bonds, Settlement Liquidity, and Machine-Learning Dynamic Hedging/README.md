# Hedging the Dollar Assets of a Colombian Pension Fund: Rolling Peso Forwards at One, Three, Six and Twelve Months, Hedge Ratios for Equities and Bonds, Settlement Liquidity, and Machine-Learning Dynamic Hedging

Colombian pension funds hold a large share of their assets abroad, mostly in dollars, while their members' pensions are paid in pesos. Every dollar asset therefore carries two risks: the asset's own and the peso's. The funds hedge part of the currency risk with **forwards and FX swaps**, contracts that sell dollars for pesos at a future date at a price fixed today. Three questions decide how:

1. **How much to hedge?** The peso is a commodity- and risk-sensitive currency: it tends to fall when global stocks fall. An unhedged dollar equity holding therefore pays off in pesos precisely when the stocks lose, a natural diversifier. Hedging it could raise risk, not lower it. For bonds, whose dollar returns are steady, the peso is most of the risk.
2. **At what tenor?** Short forwards rolled monthly track the exposure closely but must be settled every month. When the peso falls sharply, the fund pays large amounts in cash at the worst moment. Longer forwards defer the settlement but lock in a rate for longer.
3. **What does it cost?** The forward price embeds the interest-rate differential. Peso rates are higher than dollar rates, so selling dollars forward *earns* the differential (the **carry**): for a Colombian investor, hedging pays rather than costs, on average.

The notebook answers them on fifteen years of real data and then tests whether **machine learning** can set a better hedge ratio each month than a fixed rule:

- **Hedge costs from real trades:** the implied devaluation of forwards bought and sold by Colombian residents, published daily by Banco de la República by maturity bucket.
- **Portfolios:** global equities (MSCI ACWI), U.S. investment-grade bonds (Bloomberg U.S. Aggregate) and a 60/40 mix, held in dollars and measured in pesos.
- **Strategies:** unhedged; 50% and 100% hedged with forwards rolled every 1, 3, 6 or 12 months; the rolling minimum-variance hedge ratio; and two models that predict the peso and set the hedge ratio each month, LightGBM on macro and market signals and a small LSTM on their recent history, both trained up to 2018 and tested from 2019.

**Data.** Banco de la República (implied devaluation and amounts of resident forward trades by maturity; IBR); datos.gov.co (official exchange rate, TRM); Yahoo Finance (ACWI and AGG ETFs, total return); FRED (VIX, broad dollar index, Brent, Treasury bills).

**Methods.** Forward pricing and rolling-hedge accounting with mark-to-market, carry decomposition, minimum-variance hedge ratios, drawdown and CVaR, settlement cash-flow stress, LightGBM and LSTM forecasts of peso depreciation, out-of-time evaluation.

**Key output.** Return, volatility, drawdown and tail risk in pesos for every strategy and asset; the carry earned by hedging; the cash the fund must find to settle its hedges in the worst months; and whether dynamic hedge ratios beat fixed ones out of time.

---

## Why it matters

Fourteen years of peso forward prices from Banco de la República's resident trade statistics drive a backtest of how a Colombian pension fund should hedge its dollar assets. Selling dollars forward earns a carry of 3.7–4.3% a year, but the peso fell faster, so hedging lowered returns. For global equities the dollar is a natural hedge (correlation −0.53 with peso depreciation): fully hedging raises volatility, and the minimum-variance ratio averages 0.43; for bonds it averages 0.93 and hedging cuts volatility from 13% to under 5%. Monthly forwards would have required settlements of 15% of assets in one month and 49% over the worst year; laddered 6–12-month forwards cut the worst month to under 5%. LightGBM and LSTM forecasts of the peso have no out-of-time skill, so a fixed hedge ratio near 50% for a 60/40 portfolio is the robust choice.

## How to run

1. `conda activate quant-risk`. Put `FRED_API_KEY` in `.env`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 5 minutes).

## Data sources

| Data | Source |
|---|---|
| Banco de la República: resident forward trades by maturity (implied devaluation and amounts); IBR | https://www.banrep.gov.co/es/estadisticas/derivados |
| Datos Abiertos Colombia: TRM | https://www.datos.gov.co/ |
| Yahoo Finance via yfinance: ACWI and AGG ETFs | https://github.com/ranaroussi/yfinance |
| FRED: VIX, broad dollar index, Brent, 3-month Treasury bill | https://fred.stlouisfed.org/ |

## Outputs (`outputs/`)

- `01_peso_hedging.png`
- `dashboard.html`
- `dashboard.png`
- `dynamic_hedging_test_period.csv`
- `hedging_strategies_full_sample.csv`
- `implied_devaluation_by_tenor.csv`
- `peso_forecast_accuracy.csv`
- `peso_forecasts.csv`
- `rolling_min_variance_hedge_ratios.csv`

## Key assumptions

- Monthly amount-weighted median implied devaluation per maturity bucket (trades of at least USD 1 million); the >180-day bucket stands in for 12-month forwards; no bid–ask or collateral costs.
- Laddered hedges: each month 1/τ of the hedge is rolled at tenor τ; open forwards marked to market; settlements reinvested in or paid from the portfolio; 60/40 rebalanced monthly.
- Dynamic hedge ratio h = clip(0.5 + z/2, 0, 1) from a forecast of the next three months' depreciation; models refitted each year, tested 2019–2025.

## Suggested commit plan

1. `peso-hedging-pension-fund: add peso forwards, exchange rate, ETFs and macro data`
2. `peso-hedging-pension-fund: add laddered rolling-hedge backtests by tenor and hedge ratio`
3. `peso-hedging-pension-fund: add minimum-variance hedge ratios and settlement liquidity`
4. `peso-hedging-pension-fund: add LightGBM and LSTM dynamic hedge ratios tested out of time`
5. `peso-hedging-pension-fund: add charts, dashboard and narrative`

## References

- Banco de la República. *Operaciones de derivados: devaluación implícita y montos de forwards de residentes por plazo*. https://www.banrep.gov.co/es/estadisticas/derivados
- Banco de la República. *Indicador Bancario de Referencia (IBR)*. https://www.banrep.gov.co/es/estadisticas/indicador-bancario-referencia-ibr
- Campbell, J. Y., Serfaty-de Medeiros, K., & Viceira, L. M. (2010). Global currency hedging. *Journal of Finance*, 65(1), 87–121.
- Du, W., Tepper, A., & Verdelhan, A. (2018). Deviations from covered interest rate parity. *Journal of Finance*, 73(3), 915–957.
- Hochreiter, S., & Schmidhuber, J. (1997). Long short-term memory. *Neural Computation*, 9(8), 1735–1780.
- Ke, G., Meng, Q., Finley, T., et al. (2017). LightGBM: A highly efficient gradient boosting decision tree. *Advances in Neural Information Processing Systems*, 30.
- Lustig, H., Roussanov, N., & Verdelhan, A. (2011). Common risk factors in currency markets. *Review of Financial Studies*, 24(11), 3731–3777.
- Perold, A. F., & Schulman, E. C. (1988). The free lunch in currency hedging: Implications for investment policy and performance standards. *Financial Analysts Journal*, 44(3), 45–50.
- Datos Abiertos Colombia. *Tasa de Cambio Representativa del Mercado (TRM)*. https://www.datos.gov.co/
- Federal Reserve Bank of St. Louis. *FRED: VIX, nominal broad dollar index, Brent crude oil, 3-month Treasury bill*. https://fred.stlouisfed.org/
