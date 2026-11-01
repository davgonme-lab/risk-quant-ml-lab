# A Bond Portfolio in QuantLib: DV01, PV01, CS01, Key-Rate Risk and Mark-to-Market, with an ML Surrogate for Scenario Revaluation

DV01, CS01 and key-rate risk are the daily language of a bond desk and of treasury risk teams. Computing them exactly means repricing every bond for every bump, and a VaR run needs thousands of scenarios on top of that. This notebook does the exact work on a real $1 billion portfolio and then trains machine-learning surrogates that give nearly the same answer much faster.

**What it does.** It prices a real $1 billion portfolio bond by bond in **QuantLib**: about 3,000 bonds from the holdings of the largest investment-grade corporate bond ETF and the broad Treasury ETF. Each bond is valued on a Treasury zero curve built from today's par yields, with its own z-spread calibrated to its market price.

**Risk measures** for every bond and for the portfolio:

- **DV01** (curve), **PV01** (one basis point of running coupon) and **CS01** (credit spread);
- **key-rate DV01s** and convexity.

**Scenario revaluation.** Thousands of historical 10-day scenarios of the Treasury curve and the IG credit spread are applied. Full QuantLib revaluation is the benchmark, against a second-order Taylor expansion and **machine-learning surrogates** (LightGBM and a Keras neural network) trained on a few hundred full revaluations.

The surrogate gives the portfolio's 99% VaR and expected shortfall at a fraction of the cost.

**Data.** iShares LQD and GOVT holdings, and FRED (Treasury constant-maturity yields, ICE BofA US Corporate index OAS).

**Methods.** QuantLib bond pricing, curve bootstrapping and z-spread calibration, bump-and-reprice sensitivities, historical scenario generation, LightGBM and Keras 3 surrogates, and VaR/ES.

---

## Why it matters

DV01, CS01 and key-rate risk are the daily language of a bond desk and of treasury risk teams. A $1bn portfolio of 3,410 real bonds (the holdings of the iShares LQD and GOVT funds, 60/40) is priced bond by bond in QuantLib off a Treasury zero curve with a z-spread per bond. It has a DV01 of $713k, CS01 of −$712k and most key-rate risk at 10 years. Historical rate and spread moves give a 10-day 99% VaR of $26.8mm. Full revaluation is cheap here, so the ML surrogates are tested against it: a neural network reproduces portfolio P&L within 0.23% of its standard deviation, LightGBM 0.57% and a delta-gamma Taylor expansion 1.3%.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 10 minutes).

## Data sources

| Data | Source |
|---|---|
| iShares LQD and GOVT holdings (BlackRock) | https://www.ishares.com |
| Treasury constant-maturity yields, Moody's Baa spread, ICE BofA US Corporate OAS (FRED) | https://fred.stlouisfed.org |

## Outputs (`outputs/`)

- `01_quantlib_bond_portfolio_risk.png`
- `bond_level_risk.csv`
- `dashboard.html`
- `dashboard.png`
- `portfolio_risk_summary.csv`
- `surrogate_accuracy.csv`
- `var_es_by_method.csv`

## Key assumptions

- Each bond is priced on the Treasury zero curve plus its own z-spread, solved from the fund's clean price.
- Scenarios: 10-day changes in 2/5/10/30Y yields and the Baa spread since 2000, spread moves rescaled to today's IG OAS; 5,000 scenarios, all revalued in full.
- Surrogates trained on 250 scenarios and tested on 500; fixed-rate bullets only, no callables or floaters.

## Suggested commit plan

1. `quantlib-bond-portfolio: add QuantLib pricing of LQD and GOVT holdings`
2. `quantlib-bond-portfolio: add DV01, PV01, CS01 and key-rate risk`
3. `quantlib-bond-portfolio: add scenario VaR/ES and ML revaluation surrogates`

## References

### Finance and regulation

- Ho, T. S. Y. (1992). Key rate durations: Measures of interest rate risks. *The Journal of Fixed Income, 2*(2), 29–44. https://doi.org/10.3905/jfi.1992.408049
- Tuckman, B., & Serrat, A. (2022). *Fixed income securities: Tools for today's markets* (4th ed.). Wiley. https://doi.org/10.1002/9781119835622
- Basel Committee on Banking Supervision. (2019). *Minimum capital requirements for market risk*. Bank for International Settlements. https://www.bis.org/bcbs/publ/d457.htm
- Ballotta, L., & Fusai, G. (2017). A gentle introduction to value at risk. *SSRN Electronic Journal*. https://doi.org/10.2139/ssrn.2942138

### Machine learning and deep learning

- Ballabio, L. (2020). *Implementing QuantLib*. Leanpub. https://leanpub.com/implementingquantlib
- Ke, G., Meng, Q., Finley, T., Wang, T., Chen, W., Ma, W., Ye, Q., & Liu, T.-Y. (2017). LightGBM: A highly efficient gradient boosting decision tree. *Advances in Neural Information Processing Systems, 30*. https://proceedings.neurips.cc/paper/2017/hash/6449f44a102fde848669bdd9eb6b76fa-Abstract.html
- Ferguson, R., & Green, A. (2018). Deeply learning derivatives. *arXiv*. https://arxiv.org/abs/1809.02233
- Hornik, K., Stinchcombe, M., & White, H. (1989). Multilayer feedforward networks are universal approximators. *Neural Networks, 2*(5), 359–366. https://doi.org/10.1016/0893-6080(89)90020-8
