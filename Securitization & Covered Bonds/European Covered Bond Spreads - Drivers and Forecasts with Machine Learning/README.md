# European Covered Bond Spreads: Drivers and Forecasts with Machine Learning

Covered bonds are the main long-term funding of European banks and a large high-grade asset class for central banks, development banks and insurers. Their spreads over government bonds move with the issuer, the country, the legal framework and, for almost a decade, the ECB's own buying. This notebook builds ten years of bond-level spreads and asks what explains them and whether their next move can be forecast.

**What it does.** It builds a ten-year monthly panel of euro covered bonds from the month-end holdings of the iShares € Covered Bond ETF: about 900 bonds a month and 116,000 bond-months since 2016, from 25 countries and around 150 issuers. Each bond's **z-spread over the ECB AAA euro-area government curve** is computed from its price, coupon and maturity.

The notebook then asks two questions:

- **What explains the cross-section of spreads?** Country, issuer, maturity, coupon and the macro-financial state, measured with gradient boosting and SHAP.
- **Can next quarter's spread change be forecast?** The market-wide move and each bond's relative move are forecast separately, walk-forward, against a random walk and against mean reversion to the bond's peer group.

**Data.** iShares € Covered Bond UCITS ETF holdings (monthly, February 2016 to September 2026), and from the ECB Statistical Data Warehouse the Svensson parameters of the AAA euro-area government yield curve, ten-year government bond yields by country, the deposit facility rate and the Composite Indicator of Systemic Stress (CISS).

**Methods.** Z-spread bootstrapping, LightGBM with issuer-grouped cross-validation and SHAP, and walk-forward forecasts of the common and the relative spread move (ridge, LightGBM, information coefficients, Diebold–Mariano tests). Conformalised quantile regression gives spread-risk bands.

**Key output.** Spread history by country through the end of the ECB covered bond purchase programme, the drivers of spreads with their marginal effects, and forecast skill against the benchmarks.

---

## Why it matters

Covered bonds are the second-largest European bond market after sovereigns, and their spreads drive funding costs for every mortgage bank. Using ten years of month-end prices of the euro benchmark covered bonds held by an index ETF, spreads are computed over the ECB AAA curve and explained bond by bond: a LightGBM model cross-validated by issuer explains 86% of the cross-section (4 bp error) against 75% for country medians, with market stress, the curve and the sovereign spread as the main drivers. The forecasting result is honest: the market-wide move does not beat a random walk, while peer mean reversion gives a small but very consistent relative-value signal (IC 0.10). Conformal bands reach 87% coverage, except in the 2022 regime shift.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY` (checked at start-up; the data itself needs no key).
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 4 minutes the first time (122 monthly holdings files), seconds afterwards).

## Data sources

| Data | Source |
|---|---|
| iShares € Covered Bond UCITS ETF month-end holdings | https://www.ishares.com/ch/professionals/en/products/251842/ |
| ECB AAA euro-area yield curve (Svensson parameters), 10-year government yields, deposit facility rate, CISS | https://data.ecb.europa.eu |

## Outputs (`outputs/`)

- `01_covered_bond_spreads.png`
- `bond_month_spreads.csv.gz`
- `common_move_forecast_scores.csv`
- `cross_section_model_scores.csv`
- `cross_section_shap_importance.csv`
- `forecast_quintile_sort.csv`
- `information_coefficient_by_year.csv`
- `issuer_residuals.csv`
- `median_spread_by_country_month.csv`
- `quantile_band_coverage.csv`
- `relative_value_forecast_scores.csv`

## Key assumptions

- Z-spreads over the AAA government zero curve with annual coupons; bonds identified by issuer, coupon and maturity (the file has no ISIN).
- The ETF universe stands in for the euro benchmark covered bond market.
- Forecast horizon one quarter; conformal bands calibrated on the previous twelve months.

## Suggested commit plan

1. `covered-bond-spreads: add covered bond spread panel from ETF holdings and the ECB AAA curve`
2. `covered-bond-spreads: add cross-sectional LightGBM with issuer-grouped CV and SHAP`
3. `covered-bond-spreads: add common and relative spread forecasts and conformal bands`

## References

### Finance and regulation

- Prokopczuk, M., Siewert, J. B., & Vonhoff, V. (2013). Credit risk in covered bonds. *Journal of Empirical Finance, 21*, 102–120. https://doi.org/10.1016/j.jempfin.2012.12.003
- Packer, F., Stever, R., & Upper, C. (2007). The covered bond market. *BIS Quarterly Review*, September, 43–55. https://www.bis.org/publ/qtrpdf/r_qt0709f.htm
- Hollo, D., Kremer, M., & Lo Duca, M. (2012). *CISS – A composite indicator of systemic stress in the financial system* (ECB Working Paper No. 1426). European Central Bank. https://doi.org/10.2139/ssrn.2018792
- Svensson, L. E. O. (1994). *Estimating and interpreting forward interest rates: Sweden 1992–1994* (NBER Working Paper No. 4871). National Bureau of Economic Research. https://doi.org/10.3386/w4871
- Diebold, F. X., & Mariano, R. S. (1995). Comparing predictive accuracy. *Journal of Business & Economic Statistics, 13*(3), 253–263. https://doi.org/10.1080/07350015.1995.10524599

### Machine learning and deep learning

- Ke, G., Meng, Q., Finley, T., Wang, T., Chen, W., Ma, W., Ye, Q., & Liu, T.-Y. (2017). LightGBM: A highly efficient gradient boosting decision tree. *Advances in Neural Information Processing Systems, 30*. https://proceedings.neurips.cc/paper/2017/hash/6449f44a102fde848669bdd9eb6b76fa-Abstract.html
- Lundberg, S. M., & Lee, S.-I. (2017). A unified approach to interpreting model predictions. *Advances in Neural Information Processing Systems, 30*. https://arxiv.org/abs/1705.07874
- Romano, Y., Patterson, E., & Candès, E. (2019). Conformalized quantile regression. *Advances in Neural Information Processing Systems, 32*. https://arxiv.org/abs/1905.03222
