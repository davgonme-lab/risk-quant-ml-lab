# Climate Transition Risk in a Corporate Bond Portfolio: NGFS Phase 5 Scenarios, Reported Emissions and an ML Spread-to-PD Model

Supervisors now ask lenders a concrete question: if carbon prices rise and fossil-fuel demand falls, which borrowers get into trouble, and how much does the portfolio lose? Answering it means linking each issuer's real emissions to a scenario and then to its credit quality. This notebook does that, issuer by issuer, for a real U.S. corporate bond portfolio.

**What it does.** It stress-tests a real U.S. corporate bond portfolio for **climate transition risk**. The portfolio is the non-financial issuers held by the two largest investment-grade and high-yield corporate bond ETFs: about 700 issuers, of which about 400 have complete statements and are modelled.

**Data, issuer by issuer:**

- financial statements from SEC XBRL filings;
- **reported direct greenhouse-gas emissions** from the EPA Greenhouse Gas Reporting Program, allocated to parent companies by ownership share;
- market spreads from the bond holdings.

**Model.** A monotonic **LightGBM** model learns how the market prices credit from fundamentals: leverage, interest coverage, margins, size and sector. It maps any balance sheet to a spread and a default probability.

**Scenarios.** The seven **NGFS Phase 5** scenarios, from two integrated assessment models (GCAM and REMIND), give U.S. carbon prices, sector emission paths and energy demand to 2050. Each issuer's EBITDA is hit by three things:

- carbon costs on its remaining emissions;
- abatement costs;
- lower demand for fossil energy, net of cost pass-through.

The ML model re-prices the stressed balance sheet. The output is the PD migration, the expected loss and the credit VaR of the portfolio by scenario and horizon, with sector and issuer attribution.

**Sources.** NGFS Phase 5 Scenario Explorer (IIASA), EPA GHGRP via Envirofacts, SEC EDGAR XBRL frames, iShares LQD and HYG holdings, and FRED Treasury yields and CPI.

**Methods.** Fuzzy entity resolution, LightGBM with monotonic constraints and grouped CV, SHAP, a carbon-cost and demand pass-through model, and a Monte Carlo one-factor credit VaR.

---

## Why it matters

Supervisors now ask banks and investors to quantify how the low-carbon transition affects credit risk. This project stress-tests the US non-financial issuers held by the two largest IG and HY corporate bond ETFs ($23bn modelled) with NGFS Phase 5 scenarios pulled straight from the IIASA API, firm-level Scope 1 emissions from the EPA Greenhouse Gas Reporting Program and financials from SEC XBRL. A monotonic LightGBM maps fundamentals to market spreads (R² 0.50 out of fold, interest coverage first in SHAP), so carbon costs and demand shocks translate into PDs. Expected loss rises from 65 bp today to 76 bp in 2040 and 81–83 bp in 2050 under Net Zero, Low Demand or Delayed Transition; energy is 13% of the exposure but 80% of the extra loss, while utilities are shielded by pass-through. The two NGFS models disagree as much as the scenarios do.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY` and `SEC_USER_AGENT` ("Name email", required by EDGAR).
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 5–10 minutes the first time (EPA and SEC downloads), about 2 minutes afterwards).

## Data sources

| Data | Source |
|---|---|
| NGFS Phase 5 Scenario Explorer (IIASA), US region of GCAM 6.0 and REMIND-MAgPIE 3.3 | https://data.ece.iiasa.ac.at/ngfs/ |
| EPA Greenhouse Gas Reporting Program, 2023 facilities, emissions and parent companies (Envirofacts API) | https://data.epa.gov/efservice |
| SEC EDGAR XBRL frames (revenue, operating income, D&A, interest, debt, assets, cash) | https://data.sec.gov/api/xbrl/frames/ |
| iShares LQD and HYG holdings | https://www.ishares.com/us/products/ |
| Treasury constant-maturity yields and CPI | https://fred.stlouisfed.org |

## Outputs (`outputs/`)

- `01_transition_risk_portfolio.png`
- `credit_var_by_scenario.csv`
- `dashboard.html`
- `dashboard.png`
- `issuer_emissions_and_pd.csv`
- `issuer_matching_audit.csv`
- `ngfs_us_carbon_prices.csv`
- `scenario_results_by_model_year.csv`
- `sector_attribution.csv`
- `spread_model_cv.csv`
- `spread_model_shap.csv`

## Key assumptions

- Static balance sheet: today's financials, debt and business mix are frozen and shocked at 2030, 2035, 2040 and 2050 against Current Policies.
- Sector pass-through of carbon costs (utilities 70%, gas 60%, energy and basic industry 30%, others 50%); abatement cost by the triangle approximation; revenue shocks flow to EBITDA at 1.5× the EBITDA margin (capped at 60%).
- PDs from spreads with 40% recovery and a risk-neutral/physical intensity ratio of 2; one-factor Gaussian copula with ρ = 0.20 for the 99.9% credit VaR.
- Only Scope 1 emissions of GHGRP facilities attributed through parent-company ownership shares; carbon prices converted from 2010 to 2025 dollars with CPI.

## Suggested commit plan

1. `climate-transition-risk: add portfolio from ETF holdings, SEC XBRL financials and issuer matching`
2. `climate-transition-risk: add EPA GHGRP emissions by parent company and the monotonic spread model`
3. `climate-transition-risk: add NGFS Phase 5 scenarios, carbon and demand shocks, credit VaR and dashboard`

## References

### Finance and regulation

- Basel Committee on Banking Supervision. (2021). *Climate-related financial risks – measurement methodologies*. Bank for International Settlements. https://www.bis.org/bcbs/publ/d518.htm
- Battiston, S., Mandel, A., Monasterolo, I., Schütze, F., & Visentin, G. (2017). A climate stress-test of the financial system. *Nature Climate Change, 7*(4), 283–288. https://doi.org/10.1038/nclimate3255
- Bolton, P., & Kacperczyk, M. (2021). Do investors care about carbon risk? *Journal of Financial Economics, 142*(2), 517–549. https://doi.org/10.1016/j.jfineco.2021.05.008
- Seltzer, L. H., Starks, L., & Zhu, Q. (2022). *Climate regulatory risk and corporate bonds* (NBER Working Paper No. 29994). National Bureau of Economic Research. https://doi.org/10.3386/w29994
- Gordy, M. B. (2003). A risk-factor model foundation for ratings-based bank capital rules. *Journal of Financial Intermediation, 12*(3), 199–232. https://doi.org/10.1016/S1042-9573(03)00040-8

### Machine learning and deep learning

- Ke, G., Meng, Q., Finley, T., Wang, T., Chen, W., Ma, W., Ye, Q., & Liu, T.-Y. (2017). LightGBM: A highly efficient gradient boosting decision tree. *Advances in Neural Information Processing Systems, 30*. https://proceedings.neurips.cc/paper/2017/hash/6449f44a102fde848669bdd9eb6b76fa-Abstract.html
- Lundberg, S. M., & Lee, S.-I. (2017). A unified approach to interpreting model predictions. *Advances in Neural Information Processing Systems, 30*. https://arxiv.org/abs/1705.07874
- Christen, P. (2012). *Data matching: Concepts and techniques for record linkage, entity resolution, and duplicate detection*. Springer. https://doi.org/10.1007/978-3-642-31164-2
