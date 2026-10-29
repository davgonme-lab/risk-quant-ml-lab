# XVA Desk: CVA, DVA, FVA, KVA + Desk Attribution

A swap is never worth just its risk-free price. The bank on the other side can default, the positions have to be funded, and the regulator asks for capital against both. The XVA desk puts a price on each of those costs and decides which trading desk pays for them.

This notebook builds that desk for a multilateral development bank (MDB) that hedges its bond issuance with SOFR swaps traded with five commercial banks.

**What it does.** It prices the credit, debit, funding and capital adjustments of the book and stresses CVA for wrong-way risk. It then splits every adjustment across trades and desks with the Euler and Shapley methods.

Last, it trains a differential neural network that returns CVA and its sensitivities in microseconds.

**Data.** Today's SOFR curve and Treasury volatility (U.S. Treasury, FRED), plus ICE BofA corporate option-adjusted spreads by rating (FRED: AAA, AA, A, BBB), turned into hazard rates.

**Methods.** Hull–White Monte Carlo with pathwise discounting, and CVA, DVA, FCA/FBA and KVA (CCR capital plus BA-CVA) on discounted exposure profiles. Wrong-way risk comes from a default intensity that moves with rates.

The allocation uses Euler and Shapley. The neural pricer follows differential machine learning (Huge & Savine, 2020): it trains on single-path payoffs together with their pathwise derivatives, computed by automatic differentiation in PyTorch.

**Key output.** An XVA table by counterparty and by desk, the wrong-way risk multiplier as a function of correlation, and a comparison of Euler, Shapley and stand-alone allocation.

It also delivers a neural CVA pricer whose rate, vol and credit deltas are checked against brute-force Monte Carlo.

---

## Why it matters

Counterparty risk has a price. The notebook computes CVA, DVA, FVA and KVA for a reference swap book from market credit spreads, shows how much wrong-way risk can inflate CVA, allocates every adjustment to trades and desks (Euler vs Shapley), and trains a differential neural network that returns CVA and its Greeks instantly, validated against brute-force Monte Carlo.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (**about 10 minutes on CPU**, mostly the 20,000-path Monte Carlo test grid and network training. PyTorch is imported first to avoid the macOS OpenMP clash).

## Data sources

| Data | Source |
|---|---|
| Treasury par yield curve | https://home.treasury.gov/resource-center/data-chart-center/interest-rates |
| SOFR, Treasury CMT yields (`DGS1` … `DGS30`) | https://fred.stlouisfed.org |
| ICE BofA US corporate OAS by rating (`BAMLC0A1CAAA`, `BAMLC0A2CAA`, `BAMLC0A3CA`, `BAMLC0A4CBBB`) | https://fred.stlouisfed.org |

## Outputs (`outputs/`)

- `01_credit_spreads_by_rating.png`
- `02_xva_by_counterparty.png`
- `03_wrong_way_risk.png`
- `04_allocation_euler_shapley_desks.png`
- `05_differential_ml_cva_greeks.png`
- `cva_allocation_by_trade.csv`
- `differential_ml_scores.csv`
- `wrong_way_risk_multipliers.csv`
- `xva_by_counterparty.csv`
- `xva_by_desk.csv`

## Key assumptions

- Bank credit spreads proxied by corporate OAS of their rating; flat hazard rates, 40% recovery.
- No collateral; independent defaults for DVA/FVA; MDB funding spread 5 bp over SOFR.
- KVA: standardised CCR capital on an IMM-style EAD plus reduced BA-CVA, 10% hurdle rate.
- Differential ML for one netting set (Bank D) inside a box of shift ±150 bp, vol 50–130 bp, spread 30–300 bp.

## Suggested commit plan

1. `add README and XVA definitions`
2. `credit curves from FRED OAS`
3. `CVA, DVA, FCA/FBA and KVA by counterparty`
4. `wrong-way risk with stochastic intensity`
5. `Euler, Shapley and desk attribution`
6. `differential ML CVA pricer in PyTorch with executed outputs`

## References

### Finance and regulation

- Basel Committee on Banking Supervision. (2014). *The standardised approach for measuring counterparty credit risk exposures*. Bank for International Settlements. https://www.bis.org/publ/bcbs279.htm
- Basel Committee on Banking Supervision. (2020). *Targeted revisions to the credit valuation adjustment risk framework*. Bank for International Settlements. https://www.bis.org/bcbs/publ/d507.htm
- Brigo, D., Morini, M., & Pallavicini, A. (2013). *Counterparty credit risk, collateral and funding: With pricing cases for all asset classes*. Wiley. https://doi.org/10.1002/9781118818589
- Green, A., Kenyon, C., & Dennis, C. (2014). KVA: Capital valuation adjustment by replication. *Risk, 27*(12). https://arxiv.org/abs/1405.0515
- Hull, J., & White, A. (1990). Pricing interest-rate-derivative securities. *The Review of Financial Studies, 3*(4), 573–592. https://doi.org/10.1093/rfs/3.4.573
- Hull, J., & White, A. (2012). CVA and wrong-way risk. *Financial Analysts Journal, 68*(5), 58–69. https://doi.org/10.2469/faj.v68.n5.6
- Tasche, D. (2008). Capital allocation to business units and sub-portfolios: The Euler principle. In A. Resti (Ed.), *Pillar II in the new Basel Accord*. Risk Books. https://arxiv.org/abs/0708.2542

### Machine learning and deep learning

- Huge, B., & Savine, A. (2020). Differential machine learning. *arXiv*. https://arxiv.org/abs/2005.02347
- Paszke, A., Gross, S., Massa, F., Lerer, A., Bradbury, J., Chanan, G., … Chintala, S. (2019). PyTorch: An imperative style, high-performance deep learning library. *Advances in Neural Information Processing Systems, 32*. https://arxiv.org/abs/1912.01703
- Shapley, L. S. (1953). A value for n-person games. In H. W. Kuhn & A. W. Tucker (Eds.), *Contributions to the theory of games II* (pp. 307–317). Princeton University Press. https://doi.org/10.1515/9781400881970-018
