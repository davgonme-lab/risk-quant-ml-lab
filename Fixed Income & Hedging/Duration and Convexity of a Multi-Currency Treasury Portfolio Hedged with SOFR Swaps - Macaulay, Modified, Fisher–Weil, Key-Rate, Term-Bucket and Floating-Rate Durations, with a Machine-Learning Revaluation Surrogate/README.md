# Duration and Convexity of a Multi-Currency Treasury Portfolio Hedged with SOFR Swaps: Macaulay, Modified, Fisher–Weil, Key-Rate, Term-Bucket and Floating-Rate Durations, with a Machine-Learning Revaluation Surrogate

A treasury that holds bonds from many issuers and in many currencies cannot describe its interest-rate risk with one number. A Treasury bond, a supranational floater and a Swiss covered bond all react differently when rates move, and each currency's curve moves on its own. This notebook builds the full family of duration and convexity measures for such a portfolio, shows how swaps to SOFR change them, and checks how well each measure predicts the real gain or loss.

**What it does.** It assembles a $5 billion development-bank-style treasury portfolio from the real holdings of iShares bond funds:

- **U.S. dollar fixed rate:** Treasuries, agencies, municipal bonds, corporates and banks, and emerging-market sovereigns;
- **U.S. dollar floating rate:** SOFR-indexed notes of supranationals, agencies and banks;
- **other hard currencies:** sovereign, supranational, agency, covered and corporate bonds in euros, sterling, yen, Canadian and Australian dollars, Swiss francs, and Swedish, Norwegian and Danish crowns and New Zealand dollars.

For every bond and for the portfolio, before and after hedging, it computes:

1. Macaulay and modified duration and convexity at the bond's yield;
2. **term durations** in their three market senses: the Fisher–Weil duration on the term structure, key-rate (partial) durations, and duration by term bucket;
3. effective duration and convexity from curve shifts, and spread duration;
4. for floating-rate notes, the rate duration to the next reset against the spread duration to maturity;
5. DV01 in dollars by currency, issuer type and term bucket.

The fixed-rate bonds are then swapped into floating rate with overnight-index swaps in each currency (SOFR, €STR, SONIA, TONA, CORRA, AONIA, SARON and the New Zealand OIS), and the foreign currency is hedged back into U.S. dollars.

**Data.** iShares fund holdings (GOVT, AGZ, MUB, IGIB, EMB, FLOT and the international aggregate fund IAGG); swap trades reported to the DTCC public repository; FRED U.S. Treasury yields, SOFR and monthly 3-month and 10-year rates for eleven countries; Yahoo Finance fund prices.

**Methods.** Cash-flow schedules by currency convention, OIS bootstrapping, Nelson–Siegel fits, z-spreads, triangular key-rate bumps, least-squares swap hedges, full revaluation under historical curve scenarios, second-order Taylor approximations, and LightGBM and Keras revaluation surrogates. Empirical durations come from fund price regressions.

**Key output.** Duration and convexity by bond, issuer type and currency; the key-rate and term-bucket profile before and after the swaps; the residual spread risk; the accuracy of each approximation against full revaluation; and the empirical durations of the funds.

---

## Why it matters

A $5 billion MDB-style treasury portfolio of 439 real bonds in 11 currencies (Treasuries, agencies, municipal, corporate and EM bonds, SOFR floaters, and foreign sovereign, supranational, agency, covered and corporate bonds) is measured with every standard duration: Macaulay, modified, Fisher–Weil, key-rate, term-bucket, effective, spread and floating-rate reset durations, plus convexity. The portfolio has a rate duration of 4.4 years and a DV01 of $2.2 million per bp; 82 OIS swaps in eight overnight rates bring rate DV01 to $1,500 while the 4.7-year spread duration remains. Over 276 historical curve scenarios, a single duration misses about 30% of the P&L, key-rate durations 3%, and a Keras surrogate 1%.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 3 minutes on CPU).

## Data sources

| Data | Source |
|---|---|
| Fund holdings: GOVT, AGZ, MUB, IGIB, EMB, FLOT, IAGG (iShares) | https://www.ishares.com |
| OIS trades in eight currencies (DTCC public swap data repository) | https://pddata.dtcc.com |
| SOFR, 10-year Treasury yield and OECD 3-month and 10-year rates for eleven countries (FRED) | https://fred.stlouisfed.org |
| Fund prices (Yahoo Finance) | https://finance.yahoo.com |

## Outputs (`outputs/`)

- `01_duration_convexity.png`
- `approximation_errors.csv`
- `base_curves.csv`
- `bond_analytics.csv`
- `dashboard.html`
- `dashboard.png`
- `durations_by_currency.csv`
- `durations_by_issuer.csv`
- `empirical_durations.csv`
- `key_rate_dv01_after_swaps.csv`
- `key_rate_dv01_before.csv`
- `ois_swap_hedges.csv`
- `term_bucket_dv01.csv`

## Key assumptions

- 60% U.S. dollars (45% fixed rate across five issuer types, 15% SOFR floaters) and 40% in ten other currencies; sovereigns capped at 60% of each foreign currency.
- Bullet cash flows by currency convention, full prices on an actual/365 axis; one base curve per currency (OIS where at least five tenors traded, otherwise Nelson–Siegel on government bonds) plus each bond's z-spread.
- Key-rate bumps at 1–30 years; pay-fixed OIS swaps at the same eight tenors sized by non-negative least squares; spreads, FX and cross-currency basis held fixed in scenarios.

## Suggested commit plan

1. `multi-currency-duration-convexity: add fund holdings, portfolio construction and OIS curves`
2. `multi-currency-duration-convexity: add bond duration and convexity engine`
3. `multi-currency-duration-convexity: add portfolio, key-rate and term-bucket measures and OIS swap hedges`
4. `multi-currency-duration-convexity: add historical scenarios, approximation tests, surrogates, empirical durations and dashboard`

## References

### Finance and regulation

- Macaulay, F. R. (1938). *Some theoretical problems suggested by the movements of interest rates, bond yields and stock prices in the United States since 1856*. National Bureau of Economic Research. https://www.nber.org/books/maca38-1
- Fisher, L., & Weil, R. L. (1971). Coping with the risk of interest-rate fluctuations: Returns to bondholders from naïve and optimal strategies. *The Journal of Business, 44*(4), 408–431. https://doi.org/10.1086/295402
- Ho, T. S. Y. (1992). Key rate durations: Measures of interest rate risks. *The Journal of Fixed Income, 2*(2), 29–44. https://doi.org/10.3905/jfi.1992.408049
- Nelson, C. R., & Siegel, A. F. (1987). Parsimonious modeling of yield curves. *The Journal of Business, 60*(4), 473–489. https://doi.org/10.1086/296409
- Reitano, R. R. (1992). Non-parallel yield curve shifts and immunization. *The Journal of Portfolio Management, 18*(3), 36–43. https://doi.org/10.3905/jpm.1992.409410
- Duffie, D., & Stein, J. C. (2015). Reforming LIBOR and other financial market benchmarks. *Journal of Economic Perspectives, 29*(2), 191–212. https://doi.org/10.1257/jep.29.2.191
- Litterman, R., & Scheinkman, J. (1991). Common factors affecting bond returns. *The Journal of Fixed Income, 1*(1), 54–61. https://doi.org/10.3905/jfi.1991.692347

### Machine learning and deep learning

- Ke, G., Meng, Q., Finley, T., Wang, T., Chen, W., Ma, W., Ye, Q., & Liu, T.-Y. (2017). LightGBM: A highly efficient gradient boosting decision tree. *Advances in Neural Information Processing Systems, 30*. https://proceedings.neurips.cc/paper/2017/hash/6449f44a102fde848669bdd9eb6b76fa-Abstract.html
- Huge, B., & Savine, A. (2020). Differential machine learning. *arXiv*. https://arxiv.org/abs/2005.02347
- Hornik, K., Stinchcombe, M., & White, H. (1989). Multilayer feedforward networks are universal approximators. *Neural Networks, 2*(5), 359–366. https://doi.org/10.1016/0893-6080(89)90020-8
