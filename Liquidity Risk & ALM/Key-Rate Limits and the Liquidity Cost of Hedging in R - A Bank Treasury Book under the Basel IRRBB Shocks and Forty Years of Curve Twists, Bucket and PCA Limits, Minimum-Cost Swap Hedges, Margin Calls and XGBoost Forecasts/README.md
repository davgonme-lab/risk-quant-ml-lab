# Key-Rate Limits and the Liquidity Cost of Hedging in R: A Bank Treasury Book under the Basel IRRBB Shocks and Forty Years of Curve Twists, Bucket and PCA Limits, Minimum-Cost Swap Hedges, Margin Calls and XGBoost Forecasts

A bank treasury reports a net DV01 of zero after paying fixed on an interest-rate swap, and its aggregate DV01 limit is met. Below the total, the balance sheet is long the 10- to 30-year part of the curve (mortgages and bonds) and short the 1- to 7-year part (core deposits and the hedge). The treasury has three choices: **A**, accept the residual curve risk; **B**, move the hedge to where the risk is; **C**, hedge each key-rate bucket. Each choice has a cost in bid-ask spread and in collateral: swaps are cleared and margined every day, while the loans and deposits they hedge are not.

This notebook puts numbers on that decision for a stylised 10-billion-dollar balance sheet:

1. **key-rate DV01s** of every balance-sheet item, priced on today's Treasury zero curve;
2. the **six Basel IRRBB interest-rate shocks** for US dollars and the supervisory outlier test (a loss of economic value above 15% of Tier 1 capital), against **one-year curve moves since 1986**;
3. three **limit structures** (aggregate DV01, key-rate buckets, principal components) and how each judges the same book;
4. **four hedges**: DV01-neutral with a 5-year swap, DV01-neutral with a 10-year swap, level-and-slope neutral with two swaps, and the **cheapest set of swaps that meets every limit** (a linear programme);
5. the **liquidity cost** of each hedge: initial margin, variation-margin outflows over a month and a quarter, and the buffer needed;
6. **XGBoost quantile forecasts** of next-month margin calls against historical and EWMA benchmarks.

The notebook is written in **R** (data.table, httr2, ggplot2, lpSolve and xgboost).

**Data.** Federal Reserve Board: the Gürkaynak–Sack–Wright Treasury yield curve (daily Svensson parameters); FRED: effective federal funds rate. The balance sheet is synthetic.

**Methods.** Svensson zero curve; cash-flow ladders for loans, mortgages (with constant prepayment), securities, deposits and debt; key-rate (tent) DV01s; economic value of equity (EVE) under the six Basel shocks with the post-shock floor; historical simulation of one-year key-rate moves; principal component analysis; DV01, factor-neutral and linear-programming hedges; initial margin as a 99.7% five-day historical VaR; variation-margin distributions; XGBoost quantile regression with yearly expanding windows; Kupiec and Christoffersen tests; pinball loss.

**Key output.** Key-rate DV01 ladder by item; ΔEVE by Basel shock and hedge; historical ΔEVE quantiles; limit compliance by structure and hedge; swap notionals and transaction cost; initial margin, month and quarter margin outflows and liquidity buffer; forecast coverage and losses.

---

## Why it matters

A bank treasury that pays fixed on a 5-year swap to zero its net DV01 meets its aggregate limit and, just, the Basel IRRBB outlier test, yet still loses 216 million dollars (24% of Tier 1) in the worst 1% of one-year curve moves since 1986. A linear programme finds the cheapest swaps that meet aggregate, bucket, principal-component and Basel limits together, cutting that tail to 46 million for 0.3 million of bid-ask. Every hedge, however, needs a liquidity buffer of about 200 million dollars for initial margin and month-ahead margin calls on swaps that hedge an unmargined book, and XGBoost forecasts of those margin calls are less reliable than EWMA or historical rules.

## How to run

1. Install R 4.3 or later once, then, from an R console, the packages and the Jupyter kernel: `install.packages(c("data.table", "ggplot2", "httr2", "jsonlite", "lpSolve", "xgboost", "patchwork", "scales", "IRkernel"))` and `IRkernel::installspec()`.
2. `.env` at the repository root needs `FRED_API_KEY`.
3. Open the notebook in Jupyter, choose the **R** kernel, **Run All** (about 5 minutes).

## Data sources

| Data | Source |
|---|---|
| Federal Reserve Board: Gürkaynak–Sack–Wright Treasury yield curve (Svensson parameters, daily) | https://www.federalreserve.gov/data/nominal-yield-curve.htm |
| FRED: effective federal funds rate (DFF) | https://fred.stlouisfed.org/series/DFF |
| Basel Committee: Interest rate risk in the banking book (2016) | https://www.bis.org/bcbs/publ/d368.htm |

## Outputs (`outputs/`)

- `01_key_rate_limits_and_liquidity.png`
- `basel_eve_shocks.csv`
- `dashboard.png`
- `hedge_liquidity.csv`
- `hedges.csv`
- `historical_eve.csv`
- `key_rate_ladder.csv`
- `limit_compliance.csv`
- `margin_forecast_evaluation.csv`
- `treasury_decision.csv`
- `xgboost_shap.csv`

## Key assumptions

- Synthetic 10-billion-dollar balance sheet: floating loans to their 3-month reset, 5-year fixed loans, 30-year mortgages at 6.5% with 8% CPR, 2- and 10-year Treasuries; overnight non-core deposits, core deposits running off evenly over 1–7 years, 1-year term deposits and 5-year senior debt; Tier 1 of 900 million; contractual cash flows discounted on the Treasury zero curve.
- Key-rate DV01s with tent shifts at 0.25 to 30 years; the six Basel shocks for US dollars (200/300/150 bp) with the post-shock floor; one-year historical key-rate changes since 1986 repriced exactly; limits of 250,000 dollars per bp (aggregate and each bucket), 250/150/100 thousand on the first three principal components and 15% of Tier 1 for EVE.
- Par swaps priced on the Treasury curve with half bid-ask of 0.10–0.25 bp of DV01; initial margin = 99.7% five-day historical VaR over ten years or 2007–2009; variation margin first order; XGBoost quantile forecasts of 21-day margin outflow retrained each January from 1995 against five-year historical and EWMA (0.97) normal quantiles.

## Suggested commit plan

1. `key-rate-limits-hedge-liquidity: add Treasury curve and synthetic bank balance sheet`
2. `key-rate-limits-hedge-liquidity: add key-rate ladder, swap hedges and minimum-cost linear programme`
3. `key-rate-limits-hedge-liquidity: add Basel shocks, historical scenarios and limit compliance`
4. `key-rate-limits-hedge-liquidity: add initial and variation margin of the hedges`
5. `key-rate-limits-hedge-liquidity: add XGBoost margin forecasts, charts and narrative`

## References

- Board of Governors of the Federal Reserve System. *The U.S. Treasury yield curve: 1961 to the present* (feds200628.csv: Svensson parameters, daily).
- Federal Reserve Bank of St. Louis. *FRED: effective federal funds rate (DFF).*
- Basel Committee on Banking Supervision (2016). *Interest rate risk in the banking book.* Bank for International Settlements.
- Basel Committee on Banking Supervision (2019). *Basel Framework, SRP31: Interest rate risk in the banking book.* Bank for International Settlements.
- European Banking Authority (2022). *Guidelines on the management of interest rate risk and credit spread risk arising from non-trading book activities* (EBA/GL/2022/14).
- Gürkaynak, R. S., B. Sack, and J. H. Wright (2007). The U.S. Treasury yield curve: 1961 to the present. *Journal of Monetary Economics*, 54(8), 2291–2304.
- Ho, T. S. Y. (1992). Key rate durations: Measures of interest rate risks. *Journal of Fixed Income*, 2(2), 29–44.
- Litterman, R., and J. Scheinkman (1991). Common factors affecting bond returns. *Journal of Fixed Income*, 1(1), 54–61.
- Bessis, J. (2015). *Risk Management in Banking*, 4th edition. Wiley.
- Choudhry, M. (2018). *The Moorad Choudhry Anthology: Past, Present and Future Principles of Banking and Finance.* Wiley.
- Basel Committee on Banking Supervision and International Organization of Securities Commissions (2020). *Margin requirements for non-centrally cleared derivatives.* Bank for International Settlements.
- Bank for International Settlements, CPMI (2022). *Review of margining practices.*
- Kupiec, P. H. (1995). Techniques for verifying the accuracy of risk measurement models. *Journal of Derivatives*, 3(2), 73–84.
- Christoffersen, P. F. (1998). Evaluating interval forecasts. *International Economic Review*, 39(4), 841–862.
- Chen, T., and C. Guestrin (2016). XGBoost: A scalable tree boosting system. *Proceedings of the 22nd ACM SIGKDD Conference*, 785–794.
