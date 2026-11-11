# Systemic Risk of U.S. Financial Institutions: SRISK, ΔCoVaR and Marginal Expected Shortfall with Linear and Gradient-Boosted Quantile Regression, Granger Networks and Eisenberg–Noe Contagion

Microprudential supervision asks whether each bank can survive its own losses. Systemic risk asks a different question: how much does a firm add to the danger that the *financial system as a whole* fails to supply credit and payments, through its size, its exposure to common shocks and its links to other firms. After 2008, regulators built that question into the G-SIB capital surcharges, the stress tests and the designation of systemically important insurers, and academics proposed measures that can be computed from public data every day.

This notebook computes the main ones for 32 U.S. banks, broker-dealers, card lenders and insurers, and puts them to the test:

- **MES and SRISK** (Acharya, Engle and Richardson; Brownlees and Engle): how much a firm's equity falls when the market crashes, and how much capital it would then need.
- **ΔCoVaR** (Adrian and Brunnermeier): how much the financial system's value-at-risk rises when the firm is in distress. It is estimated with linear quantile regression and with a gradient-boosted quantile model, compared out of time.
- **Granger-causality networks** (Billio, Getmansky, Lo and Pelizzon): whose returns lead whose, and how dense the web of links becomes before and during crises.
- **Eisenberg–Noe clearing** with Rogers–Veraart default costs. It runs on two estimated exposure networks: a maximum-entropy matrix built from the balance sheets, and sparse alternatives. The question is how much one failure or a common shock spreads.
- **Do the measures work?** Rank correlations with realised losses in four stress episodes, and cross-sectional models (ridge, k-nearest neighbours, LightGBM) that predict each firm's maximum drawdown over the next year, out of time.

**Data.** Yahoo Finance (daily prices, dividends and splits); SEC EDGAR XBRL company facts (total assets, total liabilities, shares outstanding, with their filing dates); FRED (VIX, 3-month Treasury bill, 10-year minus 3-month spread, Baa corporate spread).

**Methods.** Rolling betas and tail expectations, long-run MES from a 40% six-month market decline, SRISK with an 8% prudential capital ratio, linear quantile regression and LightGBM quantile regression, pinball loss, pairwise Granger tests on volatility-standardised weekly returns, RAS (iterative proportional fitting) for maximum-entropy matrices, random sparse networks, Eisenberg–Noe and Rogers–Veraart clearing vectors, Spearman rank correlation, ridge, k-nearest-neighbour and LightGBM regression on cross-sectional ranks.

**Key output.** The capital shortfall of the U.S. financial system since 2009 and its largest contributors today; ΔCoVaR rankings and their out-of-time fit; network density over time; contagion losses under each network and cost assumption; and how well each measure ranks the firms that later lost most.

---

## Why it matters

For 32 U.S. financial institutions, aggregate SRISK peaked at USD 797 bn in September 2020 and stands near USD 250 bn today, with Citigroup, Goldman Sachs, Bank of America, Prudential and MetLife carrying all of it. ΔCoVaR from linear quantile regression halves the out-of-time pinball loss of an unconditional quantile, and gradient boosting adds nothing and is worse calibrated. Contagion through estimated exposure networks is small unless the network is sparse and defaults are costly. Leverage-based measures ranked the losers of 2011 and 2020 but missed the 2023 deposit run, and plain volatility predicts next-year drawdowns best.

## How to run

1. `conda activate quant-risk`. `.env` needs `SEC_USER_AGENT` and `FRED_API_KEY` in `.env`; Yahoo Finance needs no key.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 1 minute with cached data; the first download takes a few minutes).

## Data sources

| Data | Source |
|---|---|
| Yahoo Finance daily prices, dividends and splits (yfinance) | https://finance.yahoo.com/ |
| SEC EDGAR XBRL company facts API (assets, liabilities, shares outstanding) | https://www.sec.gov/edgar/sec-api-documentation |
| FRED: VIX, 3-month Treasury bill, 10-year minus 3-month spread, Baa spread | https://fred.stlouisfed.org/ |

## Outputs (`outputs/`)

- `01_systemic_risk_overview.png`
- `02_granger_network.png`
- `aggregate_srisk_monthly.csv`
- `contagion_common_shock.csv`
- `contagion_idiosyncratic_failures.csv`
- `covar_pinball_out_of_time.csv`
- `dashboard.html`
- `dashboard.png`
- `drawdown_prediction_out_of_time.csv`
- `episode_rank_correlations.csv`
- `granger_density_quarterly.csv`
- `systemic_importance_latest.csv`

## Key assumptions

- 32 firms listed today (survivors only); market = SPY; beta and MES over 252 trading days at month-ends; LRMES = 1 − exp(β · ln 0.6); SRISK with k = 8% on total book liabilities; balance sheets used from their filing date.
- ΔCoVaR at 5% on weekly returns, system = equal-weighted return of the other 31 firms, state variables lagged one week; quantile models trained up to 2018 and tested from 2019; Granger tests at 5% on two-year windows of volatility-standardised weekly returns.
- Exposure network: θ = 10% of liabilities owed inside the network (5–30% as sensitivity), claims proportional to assets, maximum-entropy RAS or random sparse links with probability 0.2; Rogers–Veraart recovery 90%; idiosyncratic failure = loss of half the firm's external assets.

## Suggested commit plan

1. `systemic-risk-srisk-covar-networks: add prices, XBRL balance sheets and state variables`
2. `systemic-risk-srisk-covar-networks: add MES, LRMES and SRISK`
3. `systemic-risk-srisk-covar-networks: add linear and gradient-boosted ΔCoVaR`
4. `systemic-risk-srisk-covar-networks: add Granger networks and Eisenberg–Noe contagion`
5. `systemic-risk-srisk-covar-networks: add episode tests, drawdown models, charts and narrative`

## References

- Acharya, V. V., Pedersen, L. H., Philippon, T., & Richardson, M. (2017). Measuring systemic risk. *Review of Financial Studies*, 30(1), 2–47. https://doi.org/10.1093/rfs/hhw088
- Acharya, V., Engle, R., & Richardson, M. (2012). Capital shortfall: A new approach to ranking and regulating systemic risks. *American Economic Review*, 102(3), 59–64.
- Adrian, T., & Brunnermeier, M. K. (2016). CoVaR. *American Economic Review*, 106(7), 1705–1741. https://doi.org/10.1257/aer.20120555
- Billio, M., Getmansky, M., Lo, A. W., & Pelizzon, L. (2012). Econometric measures of connectedness and systemic risk in the finance and insurance sectors. *Journal of Financial Economics*, 104(3), 535–559.
- Brownlees, C., & Engle, R. F. (2017). SRISK: A conditional capital shortfall measure of systemic risk. *Review of Financial Studies*, 30(1), 48–79. https://doi.org/10.1093/rfs/hhw060
- Eisenberg, L., & Noe, T. H. (2001). Systemic risk in financial systems. *Management Science*, 47(2), 236–249.
- Glasserman, P., & Young, H. P. (2015). How likely is contagion in financial networks? *Journal of Banking & Finance*, 50, 383–399.
- Koenker, R., & Bassett, G. (1978). Regression quantiles. *Econometrica*, 46(1), 33–50.
- Ke, G., Meng, Q., Finley, T., Wang, T., Chen, W., Ma, W., Ye, Q., & Liu, T.-Y. (2017). LightGBM: A highly efficient gradient boosting decision tree. In *Advances in Neural Information Processing Systems 30*.
- Mistrulli, P. E. (2011). Assessing financial contagion in the interbank market: Maximum entropy versus observed interbank lending patterns. *Journal of Banking & Finance*, 35(5), 1114–1127.
- Rogers, L. C. G., & Veraart, L. A. M. (2013). Failure and rescue in an interbank network. *Management Science*, 59(4), 882–898.
- Upper, C. (2011). Simulation methods to assess the danger of contagion in interbank markets. *Journal of Financial Stability*, 7(3), 111–125.
- NYU Stern Volatility Lab. *SRISK methodology* (LRMES = 1 − exp(log(1 − d) · β), d = 40%, k = 8%). https://vlab.stern.nyu.edu/srisk
- U.S. Securities and Exchange Commission. *EDGAR XBRL company facts API*. https://www.sec.gov/edgar/sec-api-documentation
