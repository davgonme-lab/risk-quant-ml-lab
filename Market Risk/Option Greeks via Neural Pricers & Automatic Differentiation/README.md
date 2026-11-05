# Option Greeks via Neural Pricers & Automatic Differentiation

Risk engines need sensitivities for every option in every scenario, and for models without a closed formula each one costs several repricings. Neural networks can price millions of options in milliseconds and give every Greek in a single backward pass. The catch is that a network can match prices well and still have poor derivatives. This notebook tests both claims on the real S&P 500 option market.

**What it does.** It trains neural networks to price options (Black–Scholes, and a Heston model calibrated to today's S&P 500 option market), takes every Greek from them by automatic differentiation, and measures how accurate and how fast those Greeks are on the real SPY option chain.

**Data.** A live SPY option chain snapshot (Yahoo Finance), Treasury bill and note yields for discounting (FRED), and SPY's trailing dividends.

**Methods.** Implied-volatility inversion, and an MLP pricer trained on prices only against a *differential* MLP trained on prices and Greeks (Huge & Savine, 2020).

A COS-method Heston pricer, validated against QuantLib and calibrated to the smile, feeds a neural Heston surrogate. Autograd Greeks are compared with analytic and bump-and-reprice Greeks.

**Key output.** Greek accuracy tables on the real chain, the calibrated Heston smile, speed comparisons, and the aggregated Greeks and scenario P&L of an option book.

---

## Why it matters

Risk engines need Greeks for every trade in every scenario. A neural pricer gives prices in microseconds and Greeks by automatic differentiation, but only if it is trained on the derivatives too. This notebook proves it on the real SPY chain and on a Heston model calibrated to it.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (**about 15–20 minutes on CPU**: three networks are trained in double precision, most of the time on the Heston surrogate).

## Data sources

| Data | Source |
|---|---|
| SPY option chain snapshot, spot and dividends | Yahoo Finance via `yfinance` |
| Treasury yields `DGS1MO`, `DGS3MO`, `DGS6MO`, `DGS1`, `DGS2` | https://fred.stlouisfed.org |

## Outputs (`outputs/`)

- `01_bs_greeks_analytic_vs_nn.png`
- `02_heston_smile_fit.png`
- `03_speed_comparison.png`
- `04_book_scenario_pnl.png`
- `bs_greek_accuracy.csv`
- `heston_calibration.csv`
- `heston_greek_accuracy.csv`
- `spy_chain_iv.csv`

## Key assumptions

- The chain is a live snapshot cached for 24 hours; rerunning another day gives another market.
- European pricing for SPY options (the early-exercise premium of OTM index options is ignored).
- Heston calibrated to expiries of three weeks or more; weeklies shown out of sample.
- The neural Heston pricer is only valid inside its training box of parameters, strikes and maturities.

## Suggested commit plan

1. `add README and pricing/Greek definitions`
2. `SPY option chain ETL and implied volatility`
3. `neural Black–Scholes pricers: price-only vs differential`
4. `COS Heston pricer, QuantLib validation and calibration`
5. `neural Heston surrogate, speed tests, book Greeks and executed outputs`

## References

### Finance and regulation

- Black, F., & Scholes, M. (1973). The pricing of options and corporate liabilities. *Journal of Political Economy, 81*(3), 637–654. https://doi.org/10.1086/260062
- Heston, S. L. (1993). A closed-form solution for options with stochastic volatility with applications to bond and currency options. *The Review of Financial Studies, 6*(2), 327–343. https://doi.org/10.1093/rfs/6.2.327
- Fang, F., & Oosterlee, C. W. (2009). A novel pricing method for European options based on Fourier-cosine series expansions. *SIAM Journal on Scientific Computing, 31*(2), 826–848. https://doi.org/10.1137/080718061

### Machine learning and deep learning

- Huge, B., & Savine, A. (2020). Differential machine learning. *arXiv*. https://arxiv.org/abs/2005.02347
- Hutchinson, J. M., Lo, A. W., & Poggio, T. (1994). A nonparametric approach to pricing and hedging derivative securities via learning networks. *The Journal of Finance, 49*(3), 851–889. https://doi.org/10.1111/j.1540-6261.1994.tb00081.x
- Liu, S., Oosterlee, C. W., & Bohte, S. M. (2019). Pricing options and computing implied volatilities using neural networks. *Risks, 7*(1), 16. https://doi.org/10.3390/risks7010016
- Baydin, A. G., Pearlmutter, B. A., Radul, A. A., & Siskind, J. M. (2018). Automatic differentiation in machine learning: A survey. *Journal of Machine Learning Research, 18*(153), 1–43. https://jmlr.org/papers/v18/17-468.html
- Paszke, A., Gross, S., Massa, F., Lerer, A., Bradbury, J., Chanan, G., … Chintala, S. (2019). PyTorch: An imperative style, high-performance deep learning library. *Advances in Neural Information Processing Systems, 32*. https://arxiv.org/abs/1912.01703
