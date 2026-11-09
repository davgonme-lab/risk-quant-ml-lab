# Downturn LGD When Recoveries Are Scarce: Frye–Jacobs, EBA-Style Downturn Periods, Bayesian Shrinkage and Transfer Learning on Mortgage Recoveries from the 2008 Crisis to 2025

Under the internal-ratings-based approach, the loss given default (LGD) used for capital must reflect an economic downturn. That is easy to say and hard to do: a bank whose recovery data start after 2012 has never seen a downturn in house prices, and a young portfolio may have only a few dozen completed liquidations. The European Banking Authority's guidelines (EBA, 2019) describe three ways forward: estimate LGD on the defaults of an observed downturn, model the link between LGD and the economic factors that define a downturn, or add a margin when neither is possible. Frye and Jacobs (2012) offer a fourth: derive downturn LGD from the PD and the long-run LGD through a single-factor model. This notebook confronts all of them with real recoveries. A data-rich book (Fannie Mae loans of 2005–2008, with about 10,000 liquidations through the crisis) serves as the source; a data-scarce book (Freddie Mac loans of 2018–2023, with about 200 liquidations in a rising housing market) is the target that needs a downturn LGD it has never observed.

**What it does.**

1. It reads origination data and the final liquidation record of every defaulted loan in both books, computes the realised LGD (loss over balance at removal, including expenses and recoveries), and adds the mark-to-market loan-to-value at default from state house-price indices.
2. It identifies the downturn period EBA-style from national house prices and unemployment, and compares long-run average and downturn LGD on the data-rich book.
3. It tests the Frye–Jacobs LGD function against the annual LGDs and default rates the data-rich book actually produced.
4. It estimates segment LGDs on the scarce book by simple averaging and by empirical-Bayes shrinkage toward the pooled mean, and checks which predicts held-out liquidations better.
5. It fits LGD models on the rich book (fractional logit and LightGBM) and transfers them to the scarce book four ways: source only, target only, source recalibrated on the target, and pooled with up-weighted target data. It then uses the best transfer to project a downturn LGD for the scarce book under a 2008-style fall in house prices.

**Data.** Fannie Mae Single-Family Loan Performance Data (2005–2008 acquisitions) and Freddie Mac Single-Family Loan-Level Dataset (2018–2023), samples, downloaded once by hand into `data/` at the repository root; state and national house-price indices and unemployment (FRED).

**Methods.** Realised LGD from liquidation records, EBA downturn-period identification, the Frye–Jacobs LGD function, empirical-Bayes shrinkage, fractional logit regression, LightGBM, recalibration and instance-weighted transfer learning, repeated cross-validation and house-price stress scenarios.

**Key output.** LGD by year of liquidation and by type of disposition; long-run versus downturn LGD; Frye–Jacobs predictions against observed LGD; out-of-sample errors of shrinkage and of each transfer strategy on the scarce book; and the projected downturn LGD of the scarce book.

---

## Why it matters

Capital needs an LGD that reflects a downturn, but young portfolios have never seen one. On 13,300 Fannie Mae liquidations from the 2008 crisis, LGD rose from 24% to 51% and the default-weighted long-run average (46%) already sits close to downturn LGD (48%), while a year-weighted average is 40%. Frye–Jacobs tracks the crisis years but overstates LGD once house prices recover. For a Freddie Mac 2018–2023 book with only 222 liquidations, a model trained on the crisis book and recalibrated with two parameters predicts LGD best; applied unchanged it overstates losses by 5–7 points. The book's downturn LGD ranges from 18% to 27% depending on the method: EBA-style margins, a house-price stress through the model, or Frye–Jacobs.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY` (state and national house prices, unemployment). The Fannie Mae 2005–2008 and Freddie Mac 2018–2023 sample files must be in `data/fannie_mae/sample/` and `data/freddie_mac/` at the repository root (free registration, manual download, never committed).
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 4 minutes on CPU the first time, about a minute afterwards).

## Data sources

| Data | Source |
|---|---|
| Fannie Mae Single-Family Loan Performance Data, 2005–2008 acquisitions (sampled) | https://capitalmarkets.fanniemae.com/credit-risk-transfer/single-family-credit-risk-transfer/fannie-mae-single-family-loan-performance-data |
| Freddie Mac Single-Family Loan-Level Dataset, samples 2018–2023 | https://www.freddiemac.com/research/datasets/sf-loanlevel-dataset |
| State and national house price indices (FHFA) and unemployment rate (BLS), via FRED | https://fred.stlouisfed.org/ |

## Outputs (`outputs/`)

- `01_downturn_lgd.png`
- `dashboard.html`
- `dashboard.png`
- `frye_jacobs_summary.csv`
- `frye_jacobs_vs_observed.csv`
- `lgd_by_disposition.csv`
- `liquidations_summary.csv`
- `rich_book_lgd_by_default_year.csv`
- `rich_book_out_of_time_check.csv`
- `scarce_book_downturn_lgd.csv`
- `segments.csv`
- `shrinkage_cv.csv`
- `transfer_learning_cv.csv`

## Key assumptions

- LGD = reported loss at disposition (third-party sale, short sale, REO, note sale) over removal balance, kept within −10% to 150%; default date = last paid instalment + 3 months; mark-to-market LTV via state HPI.
- Downturn years = falling national HPI and unemployment above its median (2008–2011); Frye–Jacobs with the book's long-run PD and LGD and ρ = 15%.
- Scarce-book evaluation by repeated 5-fold cross-validation; transfer strategies: source only, target only, logit recalibration, pooled with target weights 5–50.
- Stress: house prices 20% lower than at the actual default date and liquidation times at least the rich book's downturn median.

## Suggested commit plan

1. `downturn-lgd-transfer-learning: add liquidation records, realised LGD and mark-to-market LTV`
2. `downturn-lgd-transfer-learning: add downturn-period identification and Frye–Jacobs test`
3. `downturn-lgd-transfer-learning: add empirical-Bayes shrinkage on the scarce book`
4. `downturn-lgd-transfer-learning: add transfer learning and downturn LGD projection, charts, dashboard and narrative`

## References

### Downturn LGD and regulation

- European Banking Authority. (2019). *Guidelines for the estimation of LGD appropriate for an economic downturn ('downturn LGD estimation')* (EBA/GL/2019/03). https://eba.europa.eu/eba-publishes-final-guidelines-on-the-estimation-of-lgd-under-an-economic-downturn
- Frye, J., & Jacobs, M. (2012). Credit loss and systematic loss given default. *The Journal of Credit Risk, 8*(1), 109–140. https://doi.org/10.21314/JCR.2012.138
- Altman, E. I., Brady, B., Resti, A., & Sironi, A. (2005). The link between default and recovery rates: Theory, empirical evidence, and implications. *The Journal of Business, 78*(6), 2203–2228. https://doi.org/10.1086/497044
- Qi, M., & Yang, X. (2009). Loss given default of high loan-to-value residential mortgages. *Journal of Banking & Finance, 33*(5), 788–799. https://doi.org/10.1016/j.jbankfin.2008.09.010

### Methods

- Papke, L. E., & Wooldridge, J. M. (1996). Econometric methods for fractional response variables with an application to 401(k) plan participation rates. *Journal of Applied Econometrics, 11*(6), 619–632. https://doi.org/10.1002/(SICI)1099-1255(199611)11:6<619::AID-JAE418>3.0.CO;2-1
- Pan, S. J., & Yang, Q. (2010). A survey on transfer learning. *IEEE Transactions on Knowledge and Data Engineering, 22*(10), 1345–1359. https://doi.org/10.1109/TKDE.2009.191
- Ke, G., Meng, Q., Finley, T., Wang, T., Chen, W., Ma, W., Ye, Q., & Liu, T.-Y. (2017). LightGBM: A highly efficient gradient boosting decision tree. *Advances in Neural Information Processing Systems, 30*. https://proceedings.neurips.cc/paper/2017/hash/6449f44a102fde848669bdd9eb6b76fa-Abstract.html

### Data

- Fannie Mae. (2026). *Single-Family Loan Performance Data* [Data set]. https://capitalmarkets.fanniemae.com/credit-risk-transfer/single-family-credit-risk-transfer/fannie-mae-single-family-loan-performance-data
- Freddie Mac. (2026). *Single-Family Loan-Level Dataset* [Data set]. https://www.freddiemac.com/research/datasets/sf-loanlevel-dataset
- Federal Housing Finance Agency and U.S. Bureau of Labor Statistics. (2026). *State and national house price indexes; unemployment rate* [Data sets]. Federal Reserve Bank of St. Louis (FRED). https://fred.stlouisfed.org/
