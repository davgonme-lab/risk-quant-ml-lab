# IRS Exposure Engine: EE, EPE, PFE, EEPE

A swap that is worth nothing today can be worth a lot tomorrow, and if the bank on the other side defaults on that day, the value is lost. Counterparty-risk desks therefore look at the whole range of values a swap book could take in the future. This notebook builds the engine that produces those exposure profiles.

**What it does.** It simulates thousands of future interest-rate scenarios and revalues a book of SOFR swaps with five bank counterparties on each one. The result is the set of exposure profiles a counterparty-risk desk monitors against credit limits.

**Data.** Today's SOFR discount curve, built from FRED SOFR, the U.S. Treasury par curve and an explicit swap-spread term structure, plus three years of Treasury yields (FRED) to calibrate rate volatility.

**Methods.** A Hull–White one-factor model calibrated to the historical term structure of volatility, exact Monte Carlo simulation with analytic swap revaluation, netting by counterparty, and the Basel IMM metrics (EE, EPE, EEPE, PFE at 97.5%).

Two fast-pricing surrogates are tested against the exact engine: a Longstaff–Schwartz regression and a PyTorch neural network.

**Key output.** Exposure profiles and netting benefits per counterparty, PFE against limits with a traffic-light view of limit use, and a comparison of the surrogates' speed and accuracy.

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

## References

### Finance and regulation

- Basel Committee on Banking Supervision. (2005). *The application of Basel II to trading activities and the treatment of double default effects*. Bank for International Settlements. https://www.bis.org/publ/bcbs116.htm
- Gregory, J. (2020). *The xVA challenge: Counterparty risk, funding, collateral, capital and initial margin* (4th ed.). Wiley. https://doi.org/10.1002/9781119508991
- Hull, J., & White, A. (1990). Pricing interest-rate-derivative securities. *The Review of Financial Studies, 3*(4), 573–592. https://doi.org/10.1093/rfs/3.4.573
- Brigo, D., & Mercurio, F. (2006). *Interest rate models: Theory and practice* (2nd ed.). Springer. https://doi.org/10.1007/978-3-540-34604-3
- Cesari, G., Aquilina, J., Charpillon, N., Filipović, Z., Lee, G., & Manda, I. (2009). *Modelling, pricing, and hedging counterparty credit exposure: A technical guide*. Springer. https://doi.org/10.1007/978-3-642-04454-0

### Machine learning and deep learning

- Longstaff, F. A., & Schwartz, E. S. (2001). Valuing American options by simulation: A simple least-squares approach. *The Review of Financial Studies, 14*(1), 113–147. https://doi.org/10.1093/rfs/14.1.113
- Hornik, K., Stinchcombe, M., & White, H. (1989). Multilayer feedforward networks are universal approximators. *Neural Networks, 2*(5), 359–366. https://doi.org/10.1016/0893-6080(89)90020-8
- Paszke, A., Gross, S., Massa, F., Lerer, A., Bradbury, J., Chanan, G., … Chintala, S. (2019). PyTorch: An imperative style, high-performance deep learning library. *Advances in Neural Information Processing Systems, 32*. https://arxiv.org/abs/1912.01703
- Kingma, D. P., & Ba, J. (2015). Adam: A method for stochastic optimization. In *Proceedings of the 3rd International Conference on Learning Representations*. https://arxiv.org/abs/1412.6980
