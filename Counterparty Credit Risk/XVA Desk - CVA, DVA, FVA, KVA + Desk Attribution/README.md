# XVA Desk: CVA, DVA, FVA, KVA + Desk Attribution

**What it does:** prices the valuation adjustments of a reference book of SOFR swaps with five banks (credit, debit, funding and capital), stresses CVA for wrong-way risk, allocates every adjustment to trades and trading desks with Euler and Shapley methods, and trains a differential neural network that delivers CVA and its sensitivities in microseconds.
**Data:** today's SOFR curve and Treasury volatility (U.S. Treasury, FRED), and ICE BofA corporate option-adjusted spreads by rating (FRED: AAA, AA, A, BBB), converted into hazard rates.
**Methods:** Hull–White Monte Carlo with pathwise discounting; CVA, DVA, FCA/FBA and KVA (CCR capital + BA-CVA) on discounted exposure profiles; a stochastic-intensity wrong-way-risk model correlated with rates; Euler and Shapley allocation; differential machine learning (Huge & Savine, 2020) trained on single-path payoffs with their automatic-differentiation pathwise derivatives in PyTorch.
**Key output:** an XVA table by counterparty and by desk, the wrong-way risk multiplier as a function of correlation, Euler vs Shapley vs stand-alone allocation, and a neural CVA pricer whose rate, vol and credit deltas are checked against brute-force Monte Carlo.

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
