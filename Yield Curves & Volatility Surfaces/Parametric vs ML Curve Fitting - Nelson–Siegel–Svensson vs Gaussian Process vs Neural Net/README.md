# Parametric vs ML Curve Fitting: Nelson–Siegel–Svensson vs Gaussian Process vs Neural Net

Every valuation, VaR number and hedge starts from a yield curve, and a curve has to do several things at once: fit the bonds, price bonds it has not seen, stay smooth, extrapolate sensibly and not jump when the market barely moves. Flexible models fit better but often generalise worse. This notebook puts the central banks' parametric model against two machine-learning alternatives on real Treasury bonds.

**What it does.** It fits the U.S. Treasury yield curve three ways: the parametric Nelson–Siegel–Svensson model that central banks publish, a Gaussian process and a neural network.

They are compared as a curve desk or model validator would: out-of-sample pricing error, smoothness, forward-curve behaviour, extrapolation, rich/cheap signals and day-to-day stability.

**Data.** The bond-level holdings of the iShares U.S. Treasury Bond ETF (GOVT), about 200 Treasury notes and bonds with yields and maturities, plus this year's daily Treasury par yield curves (U.S. Treasury).

**Methods.** NSS by multi-start non-linear least squares, GP regression with an RBF + noise kernel on log maturity, and an ensemble of small PyTorch MLPs with a curvature penalty, tested with 10-fold cross-validation and leave-one-tenor-out tests through time.

**Key output.** A scorecard (CV error in bp, roughness, wiggles, extrapolation), fitted curves with their implied forwards, the rich and cheap bonds each model flags, and the stability of each fit through 2026.

---

## Why it matters

Every valuation in the portfolio starts from a curve. Fitting the Treasury curve to 226 real bonds shows the bias–variance trade-off concretely. The GP prices best out of sample, but its forwards oscillate and it extrapolates badly. NSS is the robust compromise. A curvature-penalised NN is smooth but underfits.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (**about 7–8 minutes** (cross-validation and monthly refits of the neural net)).

## Data sources

| Data | Source |
|---|---|
| iShares GOVT holdings (bond-level yields) | https://www.ishares.com/us/products/239468/ |
| Daily Treasury par yield curve | https://home.treasury.gov/resource-center/data-chart-center/interest-rates |

## Outputs (`outputs/`)

- `01_fits_forwards_residuals.png`
- `02_stability_leave_one_tenor_out.png`
- `bond_residuals_by_model.csv`
- `curve_fit_scorecard.csv`
- `leave_one_tenor_out_2026.csv`

## Key assumptions

- Yields to maturity are fitted directly (not prices through a discount function).
- Treasury STRIPS excluded (zero-coupon yields are a different curve).
- Hyper-parameters set once (NSS multi-start, GP kernel bounds, NN penalty 3e-3, 5-net ensemble).

## Suggested commit plan

1. `add README and curve-fitting framework`
2. `GOVT holdings ETL and cleaning`
3. `NSS, Gaussian process and neural-net fits`
4. `cross-validation, smoothness and extrapolation scorecard`
5. `rich/cheap agreement and leave-one-tenor-out stability with executed outputs`

## References

### Finance and regulation

- Svensson, L. E. O. (1994). *Estimating and interpreting forward interest rates: Sweden 1992–1994* (NBER Working Paper No. 4871). National Bureau of Economic Research. https://doi.org/10.3386/w4871
- Gürkaynak, R. S., Sack, B., & Wright, J. H. (2007). The U.S. Treasury yield curve: 1961 to the present. *Journal of Monetary Economics, 54*(8), 2291–2304. https://doi.org/10.1016/j.jmoneco.2007.06.029
- Bank for International Settlements. (2005). *Zero-coupon yield curves: Technical documentation* (BIS Papers No. 25). https://www.bis.org/publ/bppdf/bispap25.htm
- Hagan, P. S., & West, G. (2006). Interpolation methods for curve construction. *Applied Mathematical Finance, 13*(2), 89–129. https://doi.org/10.1080/13504860500396032

### Machine learning and deep learning

- Rasmussen, C. E., & Williams, C. K. I. (2006). *Gaussian processes for machine learning*. MIT Press. https://gaussianprocess.org/gpml/
- Filipović, D., Pelger, M., & Ye, Y. (2022). *Stripping the discount curve: A robust machine learning approach*. SSRN. https://doi.org/10.2139/ssrn.4058150
- Lakshminarayanan, B., Pritzel, A., & Blundell, C. (2017). Simple and scalable predictive uncertainty estimation using deep ensembles. *Advances in Neural Information Processing Systems, 30*. https://arxiv.org/abs/1612.01474
- Paszke, A., Gross, S., Massa, F., Lerer, A., Bradbury, J., Chanan, G., … Chintala, S. (2019). PyTorch: An imperative style, high-performance deep learning library. *Advances in Neural Information Processing Systems, 32*. https://arxiv.org/abs/1912.01703
