# Portfolio Credit Risk: Vasicek / IRB Capital & CreditMetrics

**What it does:** builds a $7bn corporate loan book on 60 real U.S. companies, estimates each obligor's PD with a Merton (KMV-style) model from its equity price and balance sheet, estimates asset correlations with a PCA factor model of equity returns, and compares Basel IRB capital with Monte Carlo economic capital in default mode (Gaussian and Student-t copulas) and in mark-to-market (CreditMetrics-style) mode. It decomposes the tail risk by obligor and sector to show where concentration sits.
**Data:** three years of daily prices (Yahoo Finance); total and current liabilities and shares outstanding from each company's latest 10-K/10-Q (SEC EDGAR XBRL API); the 1-year Treasury yield (FRED).
**Methods:** Merton structural model solved for asset value and volatility; distance to default; PCA factor model and systematic R²; Basel IRB (ASRF/Vasicek) risk weights with maturity adjustment; multi-factor Gaussian and t-copula Monte Carlo with stochastic LGD; Merton-consistent rating migration and loan revaluation; expected-shortfall (Euler) risk contributions; HHI concentration.
**Key output:** obligor PDs and correlations; IRB capital vs economic capital under each model; the loss distribution; and the obligors and sectors that drive the tail.

---

## Why it matters

The IRB formula assumes an infinitely granular book and one Gaussian factor; a lender's real book has large tickets and correlated sectors. On a $7.1bn book of 60 U.S. companies with Merton PDs and PCA correlations, IRB capital is $171mm. Granularity alone lifts economic capital to 1.3× IRB, observed correlations to 1.5×, a t-copula to 3.0× and mark-to-market migration to 3.3×. Duke Energy (8% of the book) and the airline and cruise names drive the tail: travel and leisure is 10% of exposure but 27% of expected shortfall.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY` and `SEC_USER_AGENT` (`Name email@domain`, required by the SEC API).
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 1 minute).

## Data sources

| Data | Source |
|---|---|
| Daily prices of 60 U.S. companies (3 years) | Yahoo Finance via `yfinance` |
| Current and total liabilities, shares outstanding | SEC EDGAR XBRL company facts (`data.sec.gov`) |
| 1-year Treasury yield (DGS1) | https://fred.stlouisfed.org |

## Outputs (`outputs/`)

- `01_loss_tail_obligors_sectors.png`
- `capital_comparison.csv`
- `obligors_pd_correlation_capital.csv`
- `sector_risk_contributions.csv`

## Key assumptions

- Merton model with a one-year horizon and KMV default point (current + ½ long-term liabilities); PDs floored at 5 bp.
- Asset correlations = systematic R² of weekly equity returns on three PCA factors (capped at 95%).
- Synthetic lognormal exposures; senior unsecured, 3-year maturity, LGD mean 40% (Beta, sd 20%); 400,000 scenarios per run.

## Suggested commit plan

1. `add README and portfolio-credit framework`
2. `price, SEC XBRL and FRED ETL`
3. `Merton PDs and PCA factor model`
4. `IRB capital and Monte Carlo runs (Gaussian, t-copula, mark-to-market)`
5. `risk contributions, concentration charts and executed outputs`
