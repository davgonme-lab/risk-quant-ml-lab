# Exchange-Rate Fair Value: Purchasing Power Parity, Real Exchange Rates and Balassa-Samuelson for Thirty Currencies, a Behavioural Equilibrium Exchange Rate and Its Misalignments, and Whether Fundamentals Beat the Random Walk

What is a currency "worth"? The CFA curriculum's economics readings give the classical answers:

- **Absolute purchasing power parity:** the exchange rate equals the ratio of price levels, so a basket costs the same everywhere.
- **Relative PPP:** the exchange rate changes by the inflation differential, $\%\Delta S \approx \pi_{\text{foreign}} - \pi_{\text{US}}$.
- **The real exchange rate**, the nominal rate adjusted for relative prices, should therefore be stable in the long run, though its deviations are large and slow to die out.

Richer countries have systematically higher price levels (the **Balassa–Samuelson** effect), so fair value must allow for productivity. A **behavioural equilibrium exchange rate (BEER)** models the real rate on such fundamentals and treats the residual as **misalignment**.

This notebook estimates all of these for about thirty currencies against the U.S. dollar, 1990–2024:

1. **Relative PPP** over 1, 5 and 10 years: the slope of exchange-rate changes on inflation differentials.
2. **Price levels and Balassa–Samuelson:** each country's price level relative to the U.S. against its relative income.
3. **A panel BEER:** the real exchange rate on relative productivity, accumulated current accounts and openness; misalignments by country and year.
4. **Mean reversion:** the half-life of misalignments.
5. **Forecasts:** next-year and three-year changes in the dollar exchange rate, out of time (trained to 2010, tested 2011–2024): random walk, PPP reversion, ridge regression and LightGBM. Can anything beat the random walk (Meese and Rogoff, 1983)?

**Data.** World Bank World Development Indicators (official exchange rates, PPP conversion factors, CPI, GDP per capita, current account, trade openness).

**Methods.** Relative and absolute PPP tests, Balassa–Samuelson regression, panel BEER with country effects, AR(1) half-lives, ridge regression, LightGBM, out-of-time evaluation against a random walk (RMSE, direction accuracy).

**Key output.** How well PPP holds by horizon, today's misalignments against the dollar (including the Colombian peso), their half-life, and whether fundamentals forecast exchange rates.

---

## Why it matters

For 30 currencies against the dollar (World Bank, 1990–2024), relative PPP has a slope of about 1 at every horizon, but among low-inflation countries inflation differentials explain only 11% of one-year moves and 42% of ten-year moves. Price levels rise 0.55 log points per log point of relative income (Balassa–Samuelson). A panel BEER finds most currencies undervalued against the strong 2024 dollar: the Colombian peso by about 22%, the yen by 38%. Misalignments have a half-life of about four years. Out of time (2011–2024), only ridge beats the random walk (RMSE −10% at one year); LightGBM does not.

## How to run

1. `conda activate quant-risk`. Put `FRED_API_KEY` in `.env` (required by the shared setup cell; the data themselves need no key).
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 2 minutes).

## Data sources

| Data | Source |
|---|---|
| World Bank: World Development Indicators API | https://datahelpdesk.worldbank.org/knowledgebase/articles/889392 |

## Outputs (`outputs/`)

- `01_fx_fair_value.png`
- `beer_misalignments_panel.csv`
- `dashboard.html`
- `dashboard.png`
- `fx_forecast_test.csv`
- `half_lives.csv`
- `misalignments_latest.csv`
- `relative_ppp_tests.csv`

## Key assumptions

- Annual average official rates in local currency per dollar; price level = PPP conversion factor ÷ market rate; the euro area drops out for lack of an official series.
- BEER with country effects on relative income, accumulated current accounts and openness; terms of trade left out because the series starts in the 2000s.
- Forecasts trained on 1992–2010 with the BEER re-estimated on data to 2010; tested on 2011–2024 against a random walk.

## Suggested commit plan

1. `exchange-rate-fair-value: add World Bank exchange rates, PPP factors and fundamentals`
2. `exchange-rate-fair-value: add relative PPP tests by horizon and Balassa–Samuelson`
3. `exchange-rate-fair-value: add panel BEER, misalignments and half-lives`
4. `exchange-rate-fair-value: add out-of-time exchange-rate forecasts`
5. `exchange-rate-fair-value: add charts, dashboard and narrative`

## References

- World Bank. World Development Indicators API (official exchange rate, PPP conversion factor, CPI, GDP per capita PPP, current account, trade). https://datahelpdesk.worldbank.org/knowledgebase/articles/889392
- CFA Institute. CFA Program Level I curriculum, Economics: Currency Exchange Rates; Level II, Currency Exchange Rates: Understanding Equilibrium Value.
- Rogoff, K. (1996). The purchasing power parity puzzle. *Journal of Economic Literature*, 34(2), 647–668.
- Meese, R. A., & Rogoff, K. (1983). Empirical exchange rate models of the seventies: Do they fit out of sample? *Journal of International Economics*, 14(1–2), 3–24.
- Balassa, B. (1964). The purchasing-power parity doctrine: A reappraisal. *Journal of Political Economy*, 72(6), 584–596.
- Samuelson, P. A. (1964). Theoretical notes on trade problems. *Review of Economics and Statistics*, 46(2), 145–154.
- Clark, P. B., & MacDonald, R. (1999). Exchange rates and economic fundamentals: A methodological comparison of BEERs and FEERs. In *Equilibrium Exchange Rates*, Springer, 285–322.
- Lane, P. R., & Milesi-Ferretti, G. M. (2004). The transfer problem revisited: Net foreign assets and real exchange rates. *Review of Economics and Statistics*, 86(4), 841–857.
- Rossi, B. (2013). Exchange rate predictability. *Journal of Economic Literature*, 51(4), 1063–1119.
- Ke, G., et al. (2017). LightGBM: A highly efficient gradient boosting decision tree. *Advances in Neural Information Processing Systems*, 30.
