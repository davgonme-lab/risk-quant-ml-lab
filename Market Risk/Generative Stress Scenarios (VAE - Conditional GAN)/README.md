# Generative Stress Scenarios (VAE / Conditional GAN)

**What it does:** learns the joint monthly distribution of eight U.S. market risk factors (equities, small caps, VIX, 2y and 10y Treasury yields, the Baa credit spread, the dollar and oil). It generates scenarios with a VAE, a VIX-conditional VAE and an equity-conditional Wasserstein GAN. It scores them against historical simulation and Gaussian/Student-t models on 2017–2026 out of sample, then builds reverse stress scenarios ("given equities fall 15%, what else moves?") and their P&L on a treasury-style portfolio.
**Data:** month-end S&P 500, Russell 2000 and dollar index (Yahoo Finance); 2y and 10y Treasury yields, Moody's Baa–10y spread, VIX and WTI oil (FRED), January 1990 onwards; the Federal Reserve's 2026 supervisory scenarios (federalreserve.gov).
**Methods:** historical bootstrap; multivariate Gaussian and Student-t; VAE and conditional VAE (PyTorch); conditional WGAN-GP; energy distance and energy score (proper scoring rules), tail-quantile and tail-dependence checks, VaR exceedance tests; linear-Gaussian and nearest-neighbour analogues as conditional benchmarks.
**Key output:** an out-of-sample scorecard by generator; how well each model captures tails and stress correlations; reverse-stress factor distributions at −8%, −15% and −20% equity moves; the Fed's 2026 severely adverse scenario against the generators; and the portfolio P&L under each.

---

## Why it matters

Stress scenarios need coherent joint moves. On eight monthly U.S. risk factors, deep generators capture the equity–credit tail dependence (0.44 vs 0.45 in the data, against 0.26 for a Gaussian) but do not beat simple models on average. Every generator fails the 2017–2026 VaR backtest because none was trained on a year like 2022. The conditional WGAN extrapolates a Treasury rally that hides portfolio losses: under the Fed 2026 severely adverse path the portfolio loses $239mm in a quarter, against $53mm if the WGAN generates every factor.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 2 minutes).

## Data sources

| Data | Source |
|---|---|
| S&P 500, Russell 2000, dollar index | Yahoo Finance via `yfinance` |
| 2y and 10y yields, Baa spread, VIX, WTI (`DGS2`, `DGS10`, `BAA10Y`, `VIXCLS`, `DCOILWTICO`) | https://fred.stlouisfed.org |
| 2026 supervisory scenarios (historic and severely adverse, domestic and international) | https://www.federalreserve.gov/supervisionreg/dfa-stress-tests-2026.htm |

## Outputs (`outputs/`)

- `01_correlations_calm_vs_stress.png`
- `02_equity_credit_scenarios.png`
- `03_reverse_stress_15pct.png`
- `04_fed_severely_adverse.png`
- `dashboard.html`
- `dashboard.png`
- `conditional_energy_scores.csv`
- `fed_2026_severely_adverse_vs_generators.csv`
- `generator_scorecard.csv`
- `reverse_stress_table.csv`
- `wgan_scenarios_equity_minus15.csv`

## Key assumptions

- Month-end factor changes since 1990; train 1990–2016, test 2017–2026.
- Stylised treasury portfolio with linear sensitivities (equity, rates DV01, credit CS01, FX, oil, VIX).
- Fixed hyper-parameters and one training run per generator; equity shocks of −8%, −15% and −20% as reverse-stress conditions.

## Suggested commit plan

1. `add README and scenario-generation framework`
2. `risk-factor ETL`
3. `bootstrap, Gaussian and Student-t generators`
4. `VAE, conditional VAE and conditional WGAN-GP`
5. `out-of-sample scorecard, reverse stress, dashboard and executed outputs`
