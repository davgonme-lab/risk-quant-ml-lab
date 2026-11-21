# Technical Indicators under Test: Moving Averages, Channel Breakouts, Bollinger Bands, RSI, Stochastics and MACD on the S&P 500 since 1950 and Six ETFs, with White's Reality Check, Hansen's SPA Test and a Machine-Learning Combination

The CFA curriculum's technical-analysis reading describes the standard indicators: **moving averages** and their crossovers, **Bollinger bands**, momentum oscillators such as the **relative strength index (RSI)**, **stochastics** and **MACD**, and price channels. Each has parameters (window lengths, thresholds), and trying many combinations on the same history almost guarantees that one looks profitable. Brock, Lakonishok and LeBaron (1992) found that simple rules predicted the Dow Jones index in 1897–1986; Sullivan, Timmermann and White (1999) then showed how to test the **best of thousands of rules** honestly with **White's (2000) Reality Check**, and Hansen (2005) sharpened it into the **Superior Predictive Ability (SPA)** test.

This notebook applies them to:

- the **S&P 500 index since 1950**, split into 1950–1989 (the era of the early studies) and 1990–2026;
- six **ETFs since 2004–2007**: S&P 500, Nasdaq-100, Russell 2000, developed markets, long Treasuries and gold.

Steps:
1. **552 rules** in nine families, each turned into a daily long-or-flat position (traded on the next day's close, 5 bp per trade).
2. **The best rule and how good it looks** in each market and period, against buy-and-hold.
3. **Data-snooping tests:** Bonferroni and Holm corrections of the individual *t*-statistics, and the Reality Check and SPA *p*-values from 1,000 stationary-bootstrap resamples, which ask whether the *best* rule beats the benchmark once the search over all rules is accounted for.
4. **Machine learning:** LightGBM combining all indicator values to decide each day whether to hold the market, trained on earlier years and tested out of time.

**Data.** Yahoo Finance (S&P 500 index since 1950; SPY, QQQ, IWM, EFA, TLT, GLD); FRED (3-month Treasury bill rate, for cash returns).

**Methods.** Trading-rule backtests with costs, Sharpe ratios, Bonferroni and Holm corrections, White's Reality Check, Hansen's SPA test, the Politis–Romano stationary bootstrap, LightGBM classification with walk-forward retraining.

**Key output.** How many rules beat buy-and-hold before and after correcting for data snooping, in each period and market, and whether a machine-learning combination does better.

---

## Why it matters

552 technical rules (moving-average crossovers, channels, filters, Bollinger bands, RSI, stochastics, MACD, calendar rules, long-only and long–short) are tested on the S&P 500 index since 1950 and on six ETFs, net of 5 bp per trade. In 1950–1989 a 0.5% filter rule earned 17.7% a year against 7.5% and survives Hansen's SPA test (p = 0.006), as the early literature found. Since 1990 only 7 rules beat buy-and-hold on the index and no best rule is significant after White's Reality Check or SPA in any market (SPA p 0.49–1.00). A LightGBM model combining all indicators earns less than buy-and-hold but cuts the worst drawdown.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY` in `.env`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 10 minutes (daily prices since 1950, 552 rules in eight markets and 16,000 bootstrap resamples)).

## Data sources

| Data | Source |
|---|---|
| Yahoo Finance: S&P 500 index and ETF daily prices | https://finance.yahoo.com/ |
| FRED: 3-month Treasury bill rate | https://fred.stlouisfed.org/series/DTB3 |

## Outputs (`outputs/`)

- `01_technical_rules.png`
- `dashboard.html`
- `dashboard.png`
- `data_snooping_tests.csv`
- `data_snooping_tests_risk_scaled.csv`
- `lightgbm_timing.csv`
- `rule_annual_means.csv`

## Key assumptions

- Signals at each close, positions at the next close, 5 bp per change of position; out of the market = Treasury bills; long–short versions short the asset instead.
- Benchmark = buy-and-hold of the same asset; White's Reality Check and Hansen's SPA (consistent version) with 1,000 stationary-bootstrap resamples, mean block length 10 days; risk-adjusted version scales excess returns to buy-and-hold volatility.
- LightGBM predicts whether the index beats bills over the next five days from all indicator values, retrained every January, tested 1990–2026.

## Suggested commit plan

1. `technical-rules-data-snooping: add daily price data and 552 trading rules`
2. `technical-rules-data-snooping: add backtests with costs`
3. `technical-rules-data-snooping: add Reality Check, SPA and multiple-testing corrections`
4. `technical-rules-data-snooping: add LightGBM indicator combination`
5. `technical-rules-data-snooping: add charts, dashboard and narrative`

## References

- Yahoo Finance. S&P 500 index (^GSPC) and ETF daily prices. https://finance.yahoo.com/
- Federal Reserve Bank of St. Louis. FRED: 3-month Treasury bill rate (DTB3). https://fred.stlouisfed.org/series/DTB3
- CFA Institute. CFA Program Level I curriculum, Technical Analysis; Quantitative Methods: Hypothesis Testing.
- Brock, W., Lakonishok, J., & LeBaron, B. (1992). Simple technical trading rules and the stochastic properties of stock returns. *Journal of Finance*, 47(5), 1731–1764.
- Sullivan, R., Timmermann, A., & White, H. (1999). Data-snooping, technical trading rule performance, and the bootstrap. *Journal of Finance*, 54(5), 1647–1691. https://doi.org/10.1111/0022-1082.00163
- White, H. (2000). A reality check for data snooping. *Econometrica*, 68(5), 1097–1126. https://doi.org/10.1111/1468-0262.00152
- Hansen, P. R. (2005). A test for superior predictive ability. *Journal of Business & Economic Statistics*, 23(4), 365–380. https://doi.org/10.1198/073500105000000063
- Politis, D. N., & Romano, J. P. (1994). The stationary bootstrap. *Journal of the American Statistical Association*, 89(428), 1303–1313.
- Holm, S. (1979). A simple sequentially rejective multiple test procedure. *Scandinavian Journal of Statistics*, 6(2), 65–70.
- Ke, G., et al. (2017). LightGBM: A highly efficient gradient boosting decision tree. *Advances in Neural Information Processing Systems*, 30.
