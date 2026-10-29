# Portfolio Credit Risk: Vasicek / IRB Capital & CreditMetrics

The regulatory capital formula treats every loan as if it sat in an endlessly diversified portfolio. A development lender's book is nothing like that: a few large names, shared sectors, and defaults that cluster in a crisis. This notebook builds a real loan book and compares the regulatory number with an economic capital model that sees those concentrations.

**What it does.** It builds a $7bn corporate loan book on 60 real U.S. companies and estimates each obligor's PD with a Merton (KMV-style) model from its equity price and balance sheet. Asset correlations come from a PCA factor model of equity returns.

It then compares Basel IRB capital with Monte Carlo economic capital, in default mode (Gaussian and Student-t copulas) and in mark-to-market (CreditMetrics-style) mode, and splits the tail risk by obligor and sector to show where concentration sits.

**Data.** Three years of daily prices (Yahoo Finance), total and current liabilities and shares outstanding from each company's latest 10-K/10-Q (SEC EDGAR XBRL API), and the 1-year Treasury yield (FRED).

**Methods.** The Merton structural model solved for asset value and volatility, distance to default, a PCA factor model with systematic R², and Basel IRB (ASRF/Vasicek) risk weights with maturity adjustment.

The simulations use multi-factor Gaussian and t-copula Monte Carlo with stochastic LGD, Merton-consistent rating migration and loan revaluation, expected-shortfall (Euler) risk contributions and HHI concentration.

**Key output.** Obligor PDs and correlations, IRB capital against economic capital under each model, the loss distribution, and the obligors and sectors that drive the tail.

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

## References

### Finance and regulation

- Gordy, M. B. (2003). A risk-factor model foundation for ratings-based bank capital rules. *Journal of Financial Intermediation, 12*(3), 199–232. https://doi.org/10.1016/S1042-9573(03)00040-8
- Merton, R. C. (1974). On the pricing of corporate debt: The risk structure of interest rates. *The Journal of Finance, 29*(2), 449–470. https://doi.org/10.1111/j.1540-6261.1974.tb03058.x
- Basel Committee on Banking Supervision. (2005). *An explanatory note on the Basel II IRB risk weight functions*. Bank for International Settlements. https://www.bis.org/bcbs/irbriskweight.htm
- Frey, R., & McNeil, A. J. (2003). Dependent defaults in models of portfolio credit risk. *Journal of Risk, 6*(1), 59–92. https://doi.org/10.21314/JOR.2003.089
- Bharath, S. T., & Shumway, T. (2008). Forecasting default with the Merton distance to default model. *The Review of Financial Studies, 21*(3), 1339–1369. https://doi.org/10.1093/rfs/hhn044

### Machine learning and deep learning

- Glasserman, P. (2004). *Monte Carlo methods in financial engineering*. Springer. https://doi.org/10.1007/978-0-387-21617-1
- Jolliffe, I. T., & Cadima, J. (2016). Principal component analysis: A review and recent developments. *Philosophical Transactions of the Royal Society A, 374*(2065), 20150202. https://doi.org/10.1098/rsta.2015.0202
- Demarta, S., & McNeil, A. J. (2005). The t copula and related copulas. *International Statistical Review, 73*(1), 111–129. https://doi.org/10.1111/j.1751-5823.2005.tb00254.x
