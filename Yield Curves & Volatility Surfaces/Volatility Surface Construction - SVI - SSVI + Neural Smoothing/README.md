# Volatility Surface Construction: SVI / SSVI + Neural Smoothing

Greeks, XVA volatilities and stress scenarios all read volatility from a surface, not from individual quotes. Quotes are noisy and sparse, so the surface is a model, and a careless one creates free money on paper and breaks the Monte Carlo engines built on it. This notebook builds the SPY surface three ways, checks each for arbitrage, and derives the local-volatility surface a pricing engine would use.

**What it does.** It builds the SPY implied-volatility surface from today's option chain three ways, checks each for static arbitrage, and derives the local-volatility surface a pricing or XVA engine would use.

1. Raw **SVI**, slice by slice.
2. **SSVI**, one global surface that is arbitrage-free by construction.
3. **SSVI + a neural correction**: a small network that bends SSVI towards the quotes, with arbitrage penalties enforced by automatic differentiation.

**Data.** An SPY option chain snapshot across expiries from one week to two years (Yahoo Finance), with forwards implied from put–call parity and Treasury discounting (FRED).

**Methods.** Gatheral's SVI parameterisation, Gatheral–Jacquier SSVI with a power-law φ, Durrleman's butterfly condition and calendar monotonicity in total variance, and Dupire local volatility from total variance.

The neural correction is a PyTorch MLP with soft no-arbitrage constraints, and held-out strikes measure the out-of-sample error.

**Key output.** In-sample and held-out IV errors per model, arbitrage-violation counts, smiles per expiry, and the implied and local volatility surfaces.

---

## Why it matters

Pricing and risk engines read volatilities from a surface, not from quotes. On today's SPY chain, per-slice SVI fits best but has calendar and butterfly arbitrage and breaks local vol. SSVI is arbitrage-free but too rigid for short-dated skew. A neural correction to SSVI with hinge arbitrage penalties gets 0.9 vol pts with zero violations. Its local vol still shows why 'arbitrage-free' is not enough.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 1.5 minutes).

## Data sources

| Data | Source |
|---|---|
| SPY option chain snapshot | Yahoo Finance via `yfinance` |
| Treasury yields, rates | https://fred.stlouisfed.org |

## Outputs (`outputs/`)

- `01_smiles_by_expiry.png`
- `02_surfaces_local_vol_arbitrage.png`
- `spy_otm_quotes_iv.csv`
- `ssvi_parameters.csv`
- `surface_scorecard.csv`
- `svi_parameters_by_expiry.csv`

## Key assumptions

- One intraday snapshot (cached 24h); forwards from put–call parity; American options treated as European.
- Every 5th strike per expiry held out for testing.
- Arbitrage checked on a 41×30 (k, T) grid with numerical tolerance 1e-4.

## Suggested commit plan

1. `add README and no-arbitrage conditions`
2. `SPY chain ETL, implied forwards and IV`
3. `per-slice SVI`
4. `global SSVI`
5. `SSVI + neural correction with arbitrage penalties`
6. `scorecard, smiles, local-vol surfaces and executed outputs`

## References

### Finance and regulation

- Gatheral, J., & Jacquier, A. (2014). Arbitrage-free SVI volatility surfaces. *Quantitative Finance, 14*(1), 59–71. https://doi.org/10.1080/14697688.2013.819986
- Breeden, D. T., & Litzenberger, R. H. (1978). Prices of state-contingent claims implicit in option prices. *The Journal of Business, 51*(4), 621–651. https://doi.org/10.1086/296025
- Fengler, M. R. (2009). Arbitrage-free smoothing of the implied volatility surface. *Quantitative Finance, 9*(4), 417–428. https://doi.org/10.1080/14697680802595585

### Machine learning and deep learning

- Ackerer, D., Tagasovska, N., & Vatter, T. (2020). Deep smoothing of the implied volatility surface. *Advances in Neural Information Processing Systems, 33*. https://arxiv.org/abs/1906.05065
- Paszke, A., Gross, S., Massa, F., Lerer, A., Bradbury, J., Chanan, G., … Chintala, S. (2019). PyTorch: An imperative style, high-performance deep learning library. *Advances in Neural Information Processing Systems, 32*. https://arxiv.org/abs/1912.01703
- Baydin, A. G., Pearlmutter, B. A., Radul, A. A., & Siskind, J. M. (2018). Automatic differentiation in machine learning: A survey. *Journal of Machine Learning Research, 18*(153), 1–43. https://jmlr.org/papers/v18/17-468.html
