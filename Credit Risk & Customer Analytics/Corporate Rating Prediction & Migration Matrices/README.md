# Corporate Rating Prediction & Migration Matrices

Many counterparties have no agency rating, yet every credit system needs one to price, limit and provision them. A model that reads financial statements and places a company on the agency scale fills that gap, and migration matrices then say how those ratings tend to move. This notebook builds both and is honest about how well they really work on companies the model has never seen.

**What it does.** It predicts the agency rating of U.S. listed companies from their financial ratios with four models, and shows how much a naive random split overstates accuracy when the same company appears many times. It also measures how far the agencies disagree with each other.

Finally, it estimates one-year rating migration matrices with the cohort and the continuous-time (generator) methods, after cleaning the data for implausible rating reversals.

**Data.** 7,805 ratings of 678 companies by S&P, Moody's, Fitch, Egan-Jones and others, 2010–2016, each with 16 financial ratios from the latest filing (Kaggle `kirtandelwadia/corporate-credit-rating-with-financial-ratios`, built from SEC filings).

**Methods.** Ordinal logit (proportional odds), multinomial logit, an SVM with an RBF kernel and LightGBM, validated with random, company-grouped and out-of-time splits. The scores are exact and within-one-grade accuracy, rank correlation and investment-grade AUC.

Agency disagreement is measured as notch differences between pairs of agencies. Migration matrices use the cohort method and an Aalen–Johansen-style generator with the matrix exponential.

**Key output.** Prediction accuracy under honest validation, the ratios that drive ratings, the size of agency disagreement, and migration matrices with their data-quality caveats.

---

## Why it matters

Shadow ratings and migration matrices sit behind PD masterscales, IFRS 9 staging and portfolio models. On 7,800 agency ratings of 678 U.S. companies, a random split makes LightGBM look 68% accurate; holding out whole companies drops it to 38%, the same as an ordinal logit. Leverage and profitability drive ratings, agencies agree on the exact notch only 16–39% of the time, and cleaned migration matrices show 79–85% one-year stability for A to B grades, with the generator method revealing extra volatility the cohort method misses.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY` (shared setup cell) and Kaggle access: `KAGGLE_API_TOKEN` in `.env` or `~/.kaggle/access_token`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 40 seconds).

## Data sources

| Data | Source |
|---|---|
| Corporate credit ratings with 16 financial ratios, 2010–2016 | Kaggle `kirtandelwadia/corporate-credit-rating-with-financial-ratios` |

## Outputs (`outputs/`)

- `01_accuracy_confusion_migration.png`
- `02_drivers_and_stability.png`
- `agency_agreement.csv`
- `migration_matrix_cohort.csv`
- `migration_matrix_generator.csv`
- `prediction_accuracy_by_split.csv`
- `rating_drivers.csv`
- `rating_stability.csv`

## Key assumptions

- Six ordered target classes (AAA/AA, A, BBB, BB, B, CCC and below); ratios winsorised at 1%/99%; near-duplicate ratios dropped for the linear models.
- Random, company-grouped and out-of-time (2015–16) test sets.
- Migrations from S&P, Moody's and Fitch histories after removing three-notch round trips within a year; cohort years 2011–2015; generator matrix exponentiated with `scipy.linalg.expm`.

## Suggested commit plan

1. `add README and ratings framework`
2. `data download, cleaning and rating scale`
3. `ordinal, multinomial, SVM and LightGBM under three splits`
4. `agency disagreement`
5. `cohort and generator migration matrices and executed outputs`

## References

### Finance and regulation

- Blume, M. E., Lim, F., & MacKinlay, A. C. (1998). The declining credit quality of U.S. corporate debt: Myth or reality? *The Journal of Finance, 53*(4), 1389–1413. https://doi.org/10.1111/0022-1082.00057
- Jarrow, R. A., Lando, D., & Turnbull, S. M. (1997). A Markov model for the term structure of credit risk spreads. *The Review of Financial Studies, 10*(2), 481–523. https://doi.org/10.1093/rfs/10.2.481
- Lando, D., & Skødeberg, T. M. (2002). Analyzing rating transitions and rating drift with continuous observations. *Journal of Banking & Finance, 26*(2–3), 423–444. https://doi.org/10.1016/S0378-4266(01)00228-X
- Lando, D. (2004). *Credit risk modeling: Theory and applications*. Princeton University Press. https://doi.org/10.1515/9781400829194
- International Accounting Standards Board. (2014). *IFRS 9 Financial instruments*. IFRS Foundation. https://www.ifrs.org/issued-standards/list-of-standards/ifrs-9-financial-instruments/

### Machine learning and deep learning

- McCullagh, P. (1980). Regression models for ordinal data. *Journal of the Royal Statistical Society: Series B, 42*(2), 109–127. https://doi.org/10.1111/j.2517-6161.1980.tb01109.x
- Cortes, C., & Vapnik, V. (1995). Support-vector networks. *Machine Learning, 20*(3), 273–297. https://doi.org/10.1007/BF00994018
- Ke, G., Meng, Q., Finley, T., Wang, T., Chen, W., Ma, W., Ye, Q., & Liu, T.-Y. (2017). LightGBM: A highly efficient gradient boosting decision tree. *Advances in Neural Information Processing Systems, 30*. https://proceedings.neurips.cc/paper/2017/hash/6449f44a102fde848669bdd9eb6b76fa-Abstract.html
- Kaufman, S., Rosset, S., Perlich, C., & Stitelman, O. (2012). Leakage in data mining: Formulation, detection, and avoidance. *ACM Transactions on Knowledge Discovery from Data, 6*(4), 1–21. https://doi.org/10.1145/2382577.2382579
