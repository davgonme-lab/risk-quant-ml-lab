# Credit Curve Construction & Spread Validation

Most borrowers and counterparties have no traded bonds or CDS, so the credit curve used to value their loans, swaps or guarantees is built from indices and interpolated. Every number downstream depends on that proxy being sensible. This notebook builds the curves and runs the checks an independent validation team would apply to them.

**What it does.** It builds U.S. corporate credit curves by rating and maturity from the ICE BofA option-adjusted spread indices, and bootstraps risk-neutral hazard rates and default probabilities from them.

A Gaussian process smooths and extends the maturity curve with uncertainty bands. Then come the checks an independent price-verification or model-validation team applies to credit curves: rating monotonicity, term-structure shape, PCA of the spread history and anomaly detection on daily moves, with a 40-year context from Moody's Baa spreads.

**Data.** ICE BofA U.S. corporate and high-yield OAS by rating (AAA to CCC) and by maturity bucket (1–3 to 15+ years) over the last three years, Moody's Aaa and Baa yields since 1986, and the Treasury curve (all FRED).

**Methods.** The credit-triangle approximation and exact piecewise-constant hazard bootstrapping (CDS-style premium and protection legs, quarterly, 40% recovery), and Gaussian-process regression with an RBF + white-noise kernel.

The validation uses rating-order and shape tests, PCA of log spreads and an Isolation Forest on daily spread changes.

**Key output.** Today's credit curves and implied default probabilities by rating, the GP curve with its uncertainty, the data-quality and validation flags, and where today's spreads sit in history.

---

## Why it matters

Every CVA, fair value and proxy spread starts from a credit curve. Built from the ICE BofA OAS indices, the curves pass the rating-order test on all 784 days, the Gaussian process puts a ±6–7 bp band inside the observed maturities and ±16–30 bp at the extrapolated ends, and the anomaly screen flags only market-wide events (the 2024 carry unwind, the April 2025 tariff shock), not bad inputs. Investment-grade spreads sit at the 3rd percentile since 1986 while CCC is at a three-year high. The main validation finding is against the proxy method itself: it gives distressed credits an upward-sloping curve.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 15 seconds).

## Data sources

| Data | Source |
|---|---|
| ICE BofA U.S. corporate and high-yield OAS by rating and maturity bucket | https://fred.stlouisfed.org |
| Moody's seasoned Aaa and Baa yields, Treasury yields | https://fred.stlouisfed.org |

## Outputs (`outputs/`)

- `01_curves_gp_pd_history.png`
- `02_anomaly_scores.png`
- `anomaly_flags.csv`
- `gp_curve_check_points.csv`
- `hazard_rates_and_pds.csv`
- `long_history_context.csv`
- `proxy_curves_by_rating_bp.csv`
- `rating_monotonicity.csv`

## Key assumptions

- OAS used as a proxy for CDS spreads; recovery 40%; quarterly premium and protection legs; Treasury par yields as zero rates.
- Rating curves = index level × IG maturity shape (proxy construction, criticised in the notebook).
- GP: RBF + white noise on log maturity around a linear trend, fitted on the last 20 business days; Isolation Forest with 1% contamination.

## Suggested commit plan

1. `add README and credit-curve framework`
2. `FRED ETL for OAS and Moody's spreads`
3. `hazard-rate bootstrapping and implied PDs`
4. `Gaussian-process curve with uncertainty`
5. `validation checks, anomaly detection and executed outputs`

## References

### Finance and regulation

- O'Kane, D. (2008). *Modelling single-name and multi-name credit derivatives*. Wiley. https://doi.org/10.1002/9781118673331
- Hull, J., Predescu, M., & White, A. (2004). The relationship between credit default swap spreads, bond yields, and credit rating announcements. *Journal of Banking & Finance, 28*(11), 2789–2811. https://doi.org/10.1016/j.jbankfin.2004.06.010
- Elton, E. J., Gruber, M. J., Agrawal, D., & Mann, C. (2001). Explaining the rate spread on corporate bonds. *The Journal of Finance, 56*(1), 247–277. https://doi.org/10.1111/0022-1082.00324
- Huang, J.-Z., & Huang, M. (2012). How much of the corporate-treasury yield spread is due to credit risk? *The Review of Asset Pricing Studies, 2*(2), 153–202. https://doi.org/10.1093/rapstu/ras011
- Basel Committee on Banking Supervision. (2009). *Supervisory guidance for assessing banks' financial instrument fair value practices*. Bank for International Settlements. https://www.bis.org/publ/bcbs153.htm
- Litterman, R., & Scheinkman, J. (1991). Common factors affecting bond returns. *The Journal of Fixed Income, 1*(1), 54–61. https://doi.org/10.3905/jfi.1991.692347

### Machine learning and deep learning

- Rasmussen, C. E., & Williams, C. K. I. (2006). *Gaussian processes for machine learning*. MIT Press. https://gaussianprocess.org/gpml/
- Liu, F. T., Ting, K. M., & Zhou, Z.-H. (2008). Isolation forest. In *Proceedings of the 2008 Eighth IEEE International Conference on Data Mining* (pp. 413–422). https://doi.org/10.1109/ICDM.2008.17
- Jolliffe, I. T., & Cadima, J. (2016). Principal component analysis: A review and recent developments. *Philosophical Transactions of the Royal Society A, 374*(2065), 20150202. https://doi.org/10.1098/rsta.2015.0202
