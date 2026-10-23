# IRS Exposure Engine: EE, EPE, PFE, EEPE

**What it does:** simulates thousands of future interest-rate scenarios and revalues a book of SOFR swaps with five bank counterparties on each one, producing the exposure profiles a counterparty-risk desk monitors against credit limits.
**Data:** today's SOFR discount curve (FRED SOFR, U.S. Treasury par curve and an explicit swap-spread term structure) and three years of Treasury yields (FRED) for volatility calibration.
**Methods:** Hull–White 1F calibrated to the historical term structure of volatility, exact Monte Carlo with analytic swap revaluation, netting by counterparty, Basel IMM metrics, plus LSM-regression and PyTorch neural-network pricing surrogates.
**Key output:** EE / PFE / ENE profiles and netting benefits per counterparty, peak PFE vs limits with traffic lights, and a speed/accuracy comparison of the surrogates.

---

## Why it matters

PFE is the number credit limits are set on, and EEPE drives Basel IMM exposure-at-default (`EAD = 1.4 × EEPE`). This engine is the core of counterparty-risk monitoring: simulate the market, revalue the trades, net them by ISDA agreement, and read the tail. Collateral, XVA, PFE sensitivity and pre-trade checks all start from an engine like this one.

## Metrics produced

| Metric | Definition |
|---|---|
| EE(t) | `E[max(V_t, 0)]` |
| PFE(t) | 97.5% quantile of `max(V_t, 0)` |
| ENE(t) | `E[min(V_t, 0)]` |
| EPE | average EE over the first year |
| EEPE | average non-decreasing EE over the first year |
| EAD (IMM) | `1.4 × EEPE` |

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 2–3 minutes; the neural network trains on the CPU by default — set `USE_MPS = True` in the setup cell to try the Apple GPU).
3. Raise `N_PATHS` in the setup cell for smoother tails (10,000+).

**If Jupyter says "the kernel crashed" on the first cell (macOS):** PyTorch and NumPy each load their own OpenMP runtime. The setup cell already sets `KMP_DUPLICATE_LIB_OK=TRUE` and imports `torch` first to avoid it. If it still happens, restart the kernel (stale processes keep the old libraries loaded) and check that `python -c "import torch, numpy"` works in the `quant-risk` environment.

## Data sources

| Data | Link |
|---|---|
| Treasury par yield curve | https://home.treasury.gov/resource-center/data-chart-center/interest-rates |
| SOFR, Treasury CMT yields (`DGS1` … `DGS30`) | https://fred.stlouisfed.org |

The swap book is synthetic, since real trade books are confidential. All rates are set from today's market curve.

## Outputs (`outputs/`)

| File | Content |
|---|---|
| `01_hw_calibration.png` | Realised vol term structure vs the Hull–White fit |
| `02_short_rate_fan.png` | Fan chart of simulated SOFR |
| `03_exposure_profiles.png` | EE, PFE, ENE and limit per netting set |
| `04_netting_benefit.png` | Peak EE stand-alone vs netted |
| `05_surrogate_accuracy.png` | LSM and MLP vs exact pricing |
| `dashboard.html` / `.png` | Counterparty exposure dashboard |
| `counterparty_exposure_summary.csv`, `exposure_profiles.csv` | Scorecard and profiles |

## Changelog

- **19-Oct-2026 · floating-leg fix.** The compounded-SOFR leg is now valued as *(SOFR accrued so far) − P(t, T_n)*. The earlier version multiplied the accrued factor by P(t, T_next), which under-valued the running coupon by up to one period and made exposures jump on payment dates. Par rates for seasoned trades use the same corrected formula. Limit statuses are unchanged (Bank D still breaches, A and E on watch). Total IMM EAD is now about 65mm, down from 87mm, and the surrogates still track PFE within about 2%.
- Suggested commit: `fix compounded-SOFR floating-leg valuation`

## Suggested commit plan

1. `add README and exposure-metric definitions`
2. `SOFR curve and historical volatility data`
3. `Hull–White calibration to realised vol`
4. `synthetic SOFR swap book`
5. `exact Monte Carlo simulation with martingale check`
6. `swap revaluation and netting-set exposure metrics`
7. `LSM and neural-network pricing surrogates`
8. `counterparty dashboard and executed outputs`
