# LCR & NSFR Engine with Stressed Outflows

**What it does:** builds a $120bn U.S. regional bank balance sheet in the shape of the aggregate U.S. banking system. It computes the Basel III Liquidity Coverage Ratio (HQLA by level with haircuts and caps, outflow and inflow rates, the 75% inflow cap) and the Net Stable Funding Ratio (ASF and RSF factors). It then stresses liquidity day by day over 30 days under the regulatory scenario, a Monte Carlo deposit-run model calibrated to 40 years of weekly H.8 deposit data, and an SVB-style run on uninsured deposits.
**Data:** H.8 weekly balance-sheet aggregates of all commercial banks and of small domestically chartered banks (FRED). The bank's balance sheet is synthetic, scaled to those shares.
**Methods:** Basel III LCR (BCBS 238) and NSFR (BCBS 295) rules; HQLA cap adjustment; an AR(1)–GARCH(1,1) model with Student-t errors for weekly deposit growth (arch); Monte Carlo of correlated category run-offs; survival horizon with and without discount-window capacity; LCR sensitivity (tornado) to each run-off assumption.
**Key output:** LCR and NSFR with their components; survival days by scenario; the distribution of 30-day liquidity shortfalls; and the assumptions that move the LCR most.

---

## Why it matters

The LCR is the first liquidity number a counterparty review looks at, but it rests on a few run-off assumptions. For a $120bn bank built in the shape of the U.S. system, the LCR is 202% and the NSFR 117%, and history-calibrated runs are far milder than the Basel scenario. An SVB-style run on uninsured deposits, with a 10% loss on securities, takes 36% of deposits in a month and leaves only $1.9bn of buffer. The LCR is necessary, not sufficient.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (a few seconds).

## Data sources

| Data | Source |
|---|---|
| H.8 assets and liabilities of commercial banks, small-bank deposits | https://fred.stlouisfed.org |

## Outputs (`outputs/`)

- `01_lcr_nsfr_composition.png`
- `02_tornado_and_survival.png`
- `03_monte_carlo_and_deposit_history.png`
- `balance_sheet.csv`
- `lcr_tornado.csv`
- `ratios.csv`
- `scenario_survival.csv`

## Key assumptions

- Balance sheet synthetic: H.8 totals; category splits, run-off, haircut and ASF/RSF factors per BCBS 238/295 and shown in tables.
- AR(1)–GARCH(1,1)-t on weekly small-bank deposit growth 1986–2026; category betas 0.3× (insured) to 3× (uninsured wholesale).
- SVB-style run: 25% of uninsured on day 1, half the rest on day 2, then 10%/day for three days and 2%/day; 10% loss on HQLA securities; discount window at a 25% haircut on loans.

## Suggested commit plan

1. `add README and liquidity framework`
2. `H.8 ETL and synthetic balance sheet`
3. `LCR and NSFR engine`
4. `GARCH deposit-run model and Monte Carlo`
5. `daily stress scenarios, survival horizons, tornado and executed outputs`
