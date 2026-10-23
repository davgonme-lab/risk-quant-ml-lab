# Credit Curve Construction & Spread Validation

**What it does:** builds U.S. corporate credit curves by rating and maturity from the ICE BofA option-adjusted spread indices, bootstraps risk-neutral hazard rates and default probabilities from them, smooths and extends the maturity curve with a Gaussian process (with uncertainty bands), and runs the checks an independent price-verification or model-validation team applies to credit curves: rating monotonicity, term-structure shape, PCA of the spread history and anomaly detection on daily moves, plus a 40-year context from Moody's Baa spreads.
**Data:** ICE BofA U.S. corporate and high-yield OAS by rating (AAA to CCC) and by maturity bucket (1–3 to 15+ years), last three years; Moody's Aaa and Baa yields since 1986 and the Treasury curve (all FRED).
**Methods:** credit-triangle approximation and exact piecewise-constant hazard bootstrapping (CDS-style premium and protection legs, quarterly, 40% recovery); Gaussian-process regression with an RBF + white-noise kernel; rating-order and shape tests; PCA of log spreads; Isolation Forest on daily spread changes.
**Key output:** today's credit curves and implied default probabilities by rating; the GP curve with its uncertainty; the data-quality and validation flags; and where today's spreads sit in history.

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
