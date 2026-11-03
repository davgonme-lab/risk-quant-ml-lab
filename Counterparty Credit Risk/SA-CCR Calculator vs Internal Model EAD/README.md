# SA-CCR Calculator vs Internal Model EAD

Even a bank with its own exposure model has to compute the regulator's standard formula, because that formula sets capital floors, leverage exposure and large-exposure limits. The gap between the two numbers decides which trades are expensive in capital. This notebook builds the standard formula from the rulebook, proves it reproduces the Basel Committee's own examples, and maps where it is most punitive compared with a Monte Carlo model.

**What it does.** It implements the Basel standardised approach for counterparty credit risk (SA-CCR, CRE52) for all five asset classes and validates it against the Basel Committee's worked examples.

It then compares it with an internal-model (IMM) EAD from Monte Carlo on 1,500 interest-rate and FX netting sets.

**Data.** Today's SOFR curve and Treasury volatility (U.S. Treasury, FRED), and USD/EUR, USD/GBP and USD/JPY exchange rates with €STR, SONIA and Japanese 3-month rates (FRED). The multi-asset trade portfolio is synthetic.

**Methods.** A Basel rule engine (supervisory duration, delta, maturity factor, hedging-set aggregation, multiplier, margined and unmargined replacement cost, leverage-ratio exposure).

The IMM side is EEPE from Hull–White rates and correlated GBM FX simulation with the Classical+ collateral model. A linear quantile regression explains the SA-CCR/IMM ratio.

**Key output.** Exact reproduction of the Basel examples (EAD 569, 381 and 5,406), an EAD breakdown by asset class for six netting sets, and a map of when SA-CCR is most conservative compared with the internal model.

---

## Why it matters

SA-CCR sets regulatory EAD, the output floor and the leverage ratio exposure even for banks with internal models. The engine reproduces the Basel Committee's three worked examples exactly, then shows on 1,500 netting sets where SA-CCR is most conservative relative to an internal Monte Carlo model: hedged books and FX.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 1 minute).

## Data sources

| Data | Source |
|---|---|
| Treasury par yield curve | https://home.treasury.gov/resource-center/data-chart-center/interest-rates |
| SOFR, Treasury CMT yields (`DGS1` … `DGS30`) | https://fred.stlouisfed.org |
| USD/EUR, USD/GBP, USD/JPY (`DEXUSEU`, `DEXUSUK`, `DEXJPUS`); €STR, SONIA, JPY 3M rates | https://fred.stlouisfed.org |
| Basel worked examples (BCBS 279, Annex 4) | https://www.bis.org/publ/bcbs279.htm |

## Outputs (`outputs/`)

- `01_saccr_ead_breakdown.png`
- `02_saccr_vs_imm_scatter.png`
- `03_quantile_regression_ratio.png`
- `saccr_basel_validation.csv`
- `saccr_multi_asset_ead.csv`
- `saccr_vs_imm_designs.csv`

## Key assumptions

- SA-CCR as in CRE52, without the negative-rate shift in option deltas, basis/volatility trades or CDO tranches.
- IMM side: Hull–White rates and correlated GBM FX, independent of each other; EEPE over min(1y, maturity).
- Margined comparison: zero-threshold CSA, MTA 0.5mm, 10-day MPoR, Classical+ model.
- Deep out-of-the-money netting sets (IMM ≈ 0) are reported separately because the ratio is undefined.

## Suggested commit plan

1. `add README and SA-CCR formulas`
2. `SA-CCR engine (trade level, hedging sets, multiplier, RC)`
3. `validation against BCBS worked examples`
4. `multi-asset netting sets and leverage-ratio exposure`
5. `IMM engine for rates and FX`
6. `SA-CCR vs IMM comparison and quantile regression with executed outputs`

## References

### Finance and regulation

- Basel Committee on Banking Supervision. (2014). *The standardised approach for measuring counterparty credit risk exposures*. Bank for International Settlements. https://www.bis.org/publ/bcbs279.htm
- Basel Committee on Banking Supervision. (2014). *Foundations of the standardised approach for measuring counterparty credit risk exposures* (Working Paper No. 26). Bank for International Settlements. https://www.bis.org/publ/bcbs_wp26.htm
- Basel Committee on Banking Supervision. (2017). *Basel III: Finalising post-crisis reforms*. Bank for International Settlements. https://www.bis.org/bcbs/publ/d424.htm
- Andersen, L., Pykhtin, M., & Sokol, A. (2017). Rethinking the margin period of risk. *Journal of Credit Risk, 13*(1), 1–45. https://doi.org/10.21314/JCR.2016.218
- Gregory, J. (2020). *The xVA challenge: Counterparty risk, funding, collateral, capital and initial margin* (4th ed.). Wiley. https://doi.org/10.1002/9781119508991
- Hull, J., & White, A. (1990). Pricing interest-rate-derivative securities. *The Review of Financial Studies, 3*(4), 573–592. https://doi.org/10.1093/rfs/3.4.573

### Machine learning and deep learning

- Koenker, R., & Bassett, G. (1978). Regression quantiles. *Econometrica, 46*(1), 33–50. https://doi.org/10.2307/1913643
- Koenker, R., & Hallock, K. F. (2001). Quantile regression. *Journal of Economic Perspectives, 15*(4), 143–156. https://doi.org/10.1257/jep.15.4.143
- Glasserman, P. (2004). *Monte Carlo methods in financial engineering*. Springer. https://doi.org/10.1007/978-0-387-21617-1
