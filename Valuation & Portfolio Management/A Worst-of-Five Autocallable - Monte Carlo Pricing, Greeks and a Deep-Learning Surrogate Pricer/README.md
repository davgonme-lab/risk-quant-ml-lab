# A Worst-of-Five Autocallable: Monte Carlo Pricing, Greeks and a Deep-Learning Surrogate Pricer

Autocallable notes pay generous coupons, and the reason is that the investor is quietly selling protection on the worst of several stocks. With five stocks, the chance that at least one of them falls a long way is much higher than it looks. This notebook prices a real-world note of this kind, shows where its risk sits, and replays it every month since 2006 to see what investors actually received.

**What it does.** It prices a two-year **worst-of autocallable note** on five U.S. stocks (Apple, Microsoft, Amazon, Alphabet, JPMorgan) with today's market data, finds its fair coupon, computes its Greeks and correlation risk, and replays the same note issued every month since 2006.

A **Keras neural network** is then trained on noisy Monte Carlo prices to act as a fast surrogate pricer. It values thousands of risk scenarios in milliseconds and is used for a historical-scenario VaR of the note.

**Data.** Yahoo Finance (prices since 2005, dividend yields, listed option chains for implied volatilities) and FRED (Treasury yields, VIX).

**Methods.** Correlated multi-asset Monte Carlo in PyTorch with antithetic variates and common random numbers, implied-volatility inversion and smile fitting, and bump-and-revalue Greeks.

A Keras 3 MLP surrogate trained on noisy labels feeds a historical-scenario VaR and ES.

**Key output.** Fair coupon, Greeks, correlation and skew sensitivities, the surrogate's accuracy and speed, 10-day VaR, and the distribution of realised outcomes since 2006.

---

## Why it matters

Autocallables are the largest family of retail structured products and the main source of correlation and skew risk on equity-derivatives desks. A two-year worst-of note on Apple, Microsoft, Amazon, Alphabet and JPMorgan is priced from listed two-year option smiles: it is fair at a 29% coupon with a 41% risk-neutral chance of capital loss, and the investor is long correlation (+1.8 points per +0.10). Replaying the note monthly since 2006 shows only one loss in 225 issues, a warning about survivorship rather than a sign of cheap risk. A Keras surrogate trained on noisy Monte Carlo prices is about 20,000 times faster than the pricer, matches its Greeks and drives a 10-day VaR of $1.9mm on $10mm.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 3 minutes (Monte Carlo in PyTorch on CPU)).

## Data sources

| Data | Source |
|---|---|
| Prices, dividend yields and option chains (Yahoo Finance via yfinance) | https://finance.yahoo.com |
| Treasury yields and VIX (FRED) | https://fred.stlouisfed.org |

## Outputs (`outputs/`)

- `01_worst_of_autocallable.png`
- `correlation_matrix.csv`
- `dashboard.html`
- `dashboard.png`
- `fair_coupon_and_probabilities.csv`
- `greeks.csv`
- `historical_issues_since_2006.csv`
- `implied_vols_and_dividends.csv`
- `surrogate_accuracy.csv`
- `surrogate_vs_mc_greeks.csv`
- `value_sensitivities.csv`
- `var_es_10day.csv`

## Key assumptions

- Two years, quarterly observations; autocall at 100%, memory coupon above 70%, European capital barrier at 60%; issue price 98.
- Correlated GBM with one volatility per stock (ATM or read from the smile at 65%); correlation from two years of daily returns; flat two-year Treasury rate.
- VaR scenarios: 10-day stock moves from the last five years, two-year vols moved by (VIX ratio)^0.4.

## Suggested commit plan

1. `worst-of-autocallable: add market data, implied vol smiles and the Monte Carlo pricer`
2. `worst-of-autocallable: add Greeks, correlation risk and the historical replay since 2006`
3. `worst-of-autocallable: add Keras surrogate pricer and scenario VaR`

## References

### Finance and regulation

- Bouzoubaa, M., & Osseiran, A. (2010). *Exotic options and hybrids: A guide to structuring, pricing and trading*. Wiley. https://doi.org/10.1002/9781119206965
- Henderson, B. J., & Pearson, N. D. (2011). The dark side of financial innovation: A case study of the pricing of a retail financial product. *Journal of Financial Economics, 100*(2), 227–247. https://doi.org/10.1016/j.jfineco.2010.12.006
- Célérier, C., & Vallée, B. (2017). Catering to investors through security design: Headline rate and complexity. *The Quarterly Journal of Economics, 132*(3), 1469–1508. https://doi.org/10.1093/qje/qjx007
- Glasserman, P. (2004). *Monte Carlo methods in financial engineering*. Springer. https://doi.org/10.1007/978-0-387-21617-1

### Machine learning and deep learning

- Huge, B., & Savine, A. (2020). Differential machine learning. *arXiv*. https://arxiv.org/abs/2005.02347
- Ferguson, R., & Green, A. (2018). Deeply learning derivatives. *arXiv*. https://arxiv.org/abs/1809.02233
- Paszke, A., Gross, S., Massa, F., Lerer, A., Bradbury, J., Chanan, G., … Chintala, S. (2019). PyTorch: An imperative style, high-performance deep learning library. *Advances in Neural Information Processing Systems, 32*. https://arxiv.org/abs/1912.01703
