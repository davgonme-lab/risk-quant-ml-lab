# IRRBB: EVE & NII Under Basel Shock Scenarios

A bank's exposure to interest rates shows up in two ways that usually pull against each other: the value of its balance sheet and the income it earns over the next year. For a development bank the key choice is how to invest its own equity, and that choice moves one measure at the expense of the other. This notebook measures both under the Basel shocks and maps the trade-off.

**What it does.** It measures the interest-rate risk in the banking book of a stylised multilateral development bank: a $4bn liquidity portfolio built from real bonds and 80% asset-swapped to SOFR, a $12bn SOFR loan book, $14bn of fixed-rate bonds swapped to floating, and $6bn of equity.

It computes the change in economic value of equity (ΔEVE) under the six Basel IRRBB shocks and the 12-month change in net interest income (ΔNII), and runs 1-year historical curve scenarios.

The risk is then split into level, slope and curvature, and the notebook maps the trade-off between EVE and NII that an MDB's equity-duration policy has to settle.

**Data.** Bond-level holdings of four iShares ETFs for the liquidity portfolio, today's Treasury par curve (U.S. Treasury), ten years of daily Treasury yields (FRED) and an explicit SOFR–Treasury swap-spread assumption.

**Methods.** Cash-flow generation for fixed, floating, amortising and swapped instruments, full revaluation on shocked SOFR curves (BCBS 368 standardised shocks with the zero floor), repricing-gap ΔNII and overlapping 1-year historical curve changes.

PCA factors and an OLS regression of ΔEVE on them explain the risk, and an efficient frontier compares equity-duration strategies.

**Key output.** ΔEVE by scenario and the Basel outlier test (15% of Tier 1), ΔNII under ±200 bp, the distribution of 1-year ΔEVE and EVE-at-risk, factor sensitivities, and the EVE–NII frontier with today's position on it.

---

## Why it matters

IRRBB is where an MDB's main market-risk decision sits: how to invest its equity. On a stylised $36bn MDB balance sheet, the worst Basel shock (+200 bp parallel) costs 9.8% of equity, inside the 15% outlier limit, but the 1-in-100 historical year since 2016 (ending October 2022) costs 15%. Three PCA factors explain the risk (R² 0.998), with the level factor dominant. The equity-duration frontier shows that laddering all equity over-hedges a balance sheet that already holds fixed-rate assets: ladders longer than about two years raise both EVE and multi-year NII risk.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (under a minute).

## Data sources

| Data | Source |
|---|---|
| Bond-level holdings of GOVT, AGZ, IGIB and MUB | iShares (BlackRock) holdings files |
| Daily Treasury par yield curve | https://home.treasury.gov/resource-center/data-chart-center/interest-rates |
| Ten years of daily Treasury constant-maturity yields | https://fred.stlouisfed.org |

## Outputs (`outputs/`)

- `01_basel_eve_nii.png`
- `02_historical_pca_frontier.png`
- `dashboard.html`
- `dashboard.png`
- `basel_eve.csv`
- `equity_duration_frontier.csv`
- `historical_eve_scenarios.csv`
- `nii_sensitivity.csv`

## Key assumptions

- Balance sheet stylised: $4bn liquidity (80% asset-swapped), $12bn loans (20% fixed), $14bn fixed bonds swapped to SOFR, $6bn equity with a 1–5-year receive-fixed ladder.
- SOFR curve = Treasury zero curve plus a constant swap spread; BCBS 368 shock sizes for USD with a zero floor.
- ΔNII on a constant balance sheet with repricing at the next reset; historical scenarios are overlapping 1-year curve changes sampled weekly.

## Suggested commit plan

1. `add README and IRRBB framework`
2. `holdings and Treasury curve ETL`
3. `cash-flow engine for bonds, loans and swaps`
4. `Basel ΔEVE and ΔNII`
5. `historical scenarios, PCA, equity-duration frontier, dashboard and executed outputs`

## References

### Finance and regulation

- Basel Committee on Banking Supervision. (2016). *Interest rate risk in the banking book* (BCBS 368). Bank for International Settlements. https://www.bis.org/bcbs/publ/d368.htm
- English, W. B., Van den Heuvel, S. J., & Zakrajšek, E. (2018). Interest rate risk and bank equity valuations. *Journal of Monetary Economics, 98*, 80–97. https://doi.org/10.1016/j.jmoneco.2018.04.010
- Drechsler, I., Savov, A., & Schnabl, P. (2021). Banking on deposits: Maturity transformation without interest rate risk. *The Journal of Finance, 76*(3), 1091–1143. https://doi.org/10.1111/jofi.13013
- Litterman, R., & Scheinkman, J. (1991). Common factors affecting bond returns. *The Journal of Fixed Income, 1*(1), 54–61. https://doi.org/10.3905/jfi.1991.692347

### Machine learning and deep learning

- Jolliffe, I. T., & Cadima, J. (2016). Principal component analysis: A review and recent developments. *Philosophical Transactions of the Royal Society A, 374*(2065), 20150202. https://doi.org/10.1098/rsta.2015.0202
- Markowitz, H. (1952). Portfolio selection. *The Journal of Finance, 7*(1), 77–91. https://doi.org/10.1111/j.1540-6261.1952.tb01525.x
