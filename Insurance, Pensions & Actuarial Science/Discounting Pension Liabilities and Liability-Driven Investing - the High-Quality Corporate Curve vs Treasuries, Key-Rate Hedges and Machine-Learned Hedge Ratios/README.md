# Discounting Pension Liabilities and Liability-Driven Investing: the High-Quality Corporate Curve vs Treasuries, Key-Rate Hedges and Machine-Learned Hedge Ratios

A pension promise is a long stream of payments, and its value today depends almost entirely on the interest rate used to discount it. When rates fall, the promise becomes more expensive overnight, even though nothing about the members has changed. This notebook measures how much the choice of discount curve matters, and how well different bond portfolios protect a plan against those swings.

**What it does.** It values the benefit payments of three frozen defined-benefit plans (mostly retirees, mature, and young) every month since 1984 on the high-quality corporate (HQM) spot curve, a common reference for U.S. pension accounting. It then compares four discounting bases (the full curve, a single equivalent rate, Treasuries and minimum-funding segment rates) and backtests six hedging strategies from 2008 to 2026:

1. no hedge (cash);
2. a single 10-year Treasury zero matched on duration;
3. Treasury zeros matched on key-rate durations;
4. a rolling minimum-variance hedge with Treasuries and corporate bonds;
5. a ridge regression that learns corrections to the key-rate hedge;
6. a neural network that sets the corrections from the state of the market.

**Data.** FRED: the HQM corporate spot curve from 6 months to 100 years, Treasury constant-maturity yields and the 3-month bill. Yahoo Finance: the iShares investment-grade corporate bond ETF (LQD).

**Methods.** Gompertz–Makeham survival, curve valuation, single equivalent rates, effective and key-rate durations, and Treasury curve bootstrapping. The hedges are a walk-forward rolling OLS, a ridge regression and a Keras network trained on the surplus tracking error.

**Key output.** Liability values and durations under each discount basis, the funded-status volatility each basis implies, and the surplus tracking error of each hedge, including 2008 and 2022.

---

## Why it matters

Three stylised frozen defined-benefit plans are valued every month since 1984 on the Treasury's high-quality corporate (HQM) spot curve. The mature plan's discount rate ran from 13.4% to 2.6% and back to 6.2%, and the same payments were worth 2.8 times as much at the 2020 low. Treasury discounting adds 10% to today's value, while 24-month segment rates cut volatility from 7.3% to 1.6% a year. From 2008 to 2026, Treasury hedges matched on duration or key rates remove only 31–46% of surplus variance because the liability carries corporate credit spread risk. Rolling and ridge regressions that add investment-grade corporate bonds remove 91–95%; a state-dependent neural network removes 50–70% and adds nothing over them.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 20 minutes on CPU).

## Data sources

| Data | Source |
|---|---|
| HQM corporate spot curve 6 months–100 years, Treasury constant-maturity yields, 3-month bill (FRED) | https://fred.stlouisfed.org |
| iShares iBoxx investment-grade corporate bond ETF, LQD (Yahoo Finance) | https://finance.yahoo.com |

## Outputs (`outputs/`)

- `01_liability_discounting_ldi.png`
- `average_hedge_weights.csv`
- `dashboard.html`
- `dashboard.png`
- `discount_basis_comparison.csv`
- `hedge_backtest.csv`
- `liability_history.csv`
- `liability_snapshot.csv`

## Key assumptions

- Stylised frozen plans with flat nominal pensions from 65 and Gompertz–Makeham mortality (A = 0.00022, B = 2.7e-6, c = 1.124); payments mid-year.
- HQM and Treasury rates are monthly averages with semi-annual compounding; LQD prices are averaged by month to match.
- Hedges start fully funded and rebalance monthly; regressions and networks are re-fitted walk-forward and tested from January 2008.

## Suggested commit plan

1. `liability-discounting-ldi: add HQM and Treasury curves, LQD prices and plan cash flows`
2. `liability-discounting-ldi: add monthly valuation, single equivalent rates and key-rate durations`
3. `liability-discounting-ldi: add discount-basis comparison and liability returns`
4. `liability-discounting-ldi: add analytic, regression and neural hedges with walk-forward backtest and dashboard`

## References

### Finance and regulation

- International Accounting Standards Board. (2011). *IAS 19 Employee benefits*. IFRS Foundation. https://www.ifrs.org/issued-standards/list-of-standards/ias-19-employee-benefits/
- Leibowitz, M. L., Kogelman, S., & Bader, L. N. (1994). Funding ratio return. *The Journal of Portfolio Management, 21*(1), 39–47. https://doi.org/10.3905/jpm.1994.409495
- Ho, T. S. Y. (1992). Key rate durations: Measures of interest rate risks. *The Journal of Fixed Income, 2*(2), 29–44. https://doi.org/10.3905/jfi.1992.408049
- Litterman, R., & Scheinkman, J. (1991). Common factors affecting bond returns. *The Journal of Fixed Income, 1*(1), 54–61. https://doi.org/10.3905/jfi.1991.692347
- Novy-Marx, R., & Rauh, J. (2011). Public pension promises: How big are they and what are they worth? *The Journal of Finance, 66*(4), 1211–1249. https://doi.org/10.1111/j.1540-6261.2011.01664.x
- Dickson, D. C. M., Hardy, M. R., & Waters, H. R. (2020). *Actuarial mathematics for life contingent risks* (3rd ed.). Cambridge University Press. https://doi.org/10.1017/9781108784184

### Machine learning and deep learning

- Ederington, L. H. (1979). The hedging performance of the new futures markets. *The Journal of Finance, 34*(1), 157–170. https://doi.org/10.1111/j.1540-6261.1979.tb02077.x
- Hoerl, A. E., & Kennard, R. W. (1970). Ridge regression: Biased estimation for nonorthogonal problems. *Technometrics, 12*(1), 55–67. https://doi.org/10.1080/00401706.1970.10488634
- Buehler, H., Gonon, L., Teichmann, J., & Wood, B. (2019). Deep hedging. *Quantitative Finance, 19*(8), 1271–1291. https://doi.org/10.1080/14697688.2019.1571683
