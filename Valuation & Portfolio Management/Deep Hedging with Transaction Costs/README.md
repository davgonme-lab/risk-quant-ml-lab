# Deep Hedging with Transaction Costs

Black–Scholes says an option can be hedged perfectly by trading continuously. Real trading is discrete and every trade costs money, so a dealer has to decide how much risk each trade is worth. Deep hedging lets a neural network learn that decision by minimising the losses in the bad scenarios directly. This notebook trains one and compares it with the textbook hedges.

**What it does.** It trains a neural network to hedge a short one-month SPY call with daily trading and proportional transaction costs, minimising tail risk (CVaR) instead of replicating Black–Scholes.

It is compared with no hedge, the Black–Scholes delta and the Whalley–Wilmott no-trade band, under Black–Scholes and Heston dynamics.

**Data.** SPY daily prices (Yahoo Finance) set the volatility, the Heston variant uses illustrative parameters consistent with SPY, and Treasury yields (FRED) give the rate.

**Methods.** Deep Hedging (Buehler, Gonon, Teichmann & Wood, 2019) with a recurrent policy (the previous position is an input) in PyTorch, trained on 200,000 simulated paths to minimise the CVaR₉₅ of the hedged loss.

The strategies are evaluated out of sample on fresh paths, and the CVaR-optimal value is read as an indifference price.

**Key output.** P&L distributions, CVaR and turnover by strategy and cost level, the learned hedge ratio showing a data-driven no-trade band, and the price a seller should charge to cover costs and tail risk.

---

## Why it matters

Hedging an option book costs money every time it trades, and the risk that matters is the tail, not the variance. A network trained to minimise CVaR95 with costs inside the objective beats the daily delta and a properly tuned Whalley–Wilmott band in every case: with 20 bp costs, CVaR falls from 1.18% to 0.95% of spot and the indifference price from 2.82% to 2.59%. It learns a flattened, position-aware hedge ratio that a desk would recognise.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (**about 15 minutes** (8 deep-hedging policies are trained)).

## Data sources

| Data | Source |
|---|---|
| SPY 3-year daily prices (volatility calibration) | Yahoo Finance via `yfinance` |
| 1-month Treasury yield (`DGS1MO`) | https://fred.stlouisfed.org |

## Outputs (`outputs/`)

- `01_loss_distribution_and_frontier.png`
- `02_learned_no_trade_band.png`
- `hedging_results.csv`

## Key assumptions

- Short one-month ATM call on SPY, daily rebalancing, proportional costs of 0, 5, 20 and 50 bp.
- Black–Scholes volatility from 1-year realised SPY volatility; Heston with illustrative κ, ξ, ρ and long-run variance matched to it.
- Deep hedge minimises CVaR95 (Rockafellar–Uryasev); the Whalley–Wilmott λ is tuned on separate paths for the same objective.

## Suggested commit plan

1. `add README and deep-hedging framework`
2. `SPY calibration and path simulators`
3. `benchmark strategies (delta, Whalley–Wilmott)`
4. `CVaR-trained hedging network in PyTorch`
5. `out-of-sample comparison, learned no-trade band and executed outputs`

## References

### Finance and regulation

- Black, F., & Scholes, M. (1973). The pricing of options and corporate liabilities. *Journal of Political Economy, 81*(3), 637–654. https://doi.org/10.1086/260062
- Whalley, A. E., & Wilmott, P. (1997). An asymptotic analysis of an optimal hedging model for option pricing with transaction costs. *Mathematical Finance, 7*(3), 307–324. https://doi.org/10.1111/1467-9965.00034
- Leland, H. E. (1985). Option pricing and replication with transactions costs. *The Journal of Finance, 40*(5), 1283–1301. https://doi.org/10.1111/j.1540-6261.1985.tb02383.x
- Heston, S. L. (1993). A closed-form solution for options with stochastic volatility with applications to bond and currency options. *The Review of Financial Studies, 6*(2), 327–343. https://doi.org/10.1093/rfs/6.2.327
- Rockafellar, R. T., & Uryasev, S. (2000). Optimization of conditional value-at-risk. *Journal of Risk, 2*(3), 21–41. https://doi.org/10.21314/JOR.2000.038

### Machine learning and deep learning

- Buehler, H., Gonon, L., Teichmann, J., & Wood, B. (2019). Deep hedging. *Quantitative Finance, 19*(8), 1271–1291. https://doi.org/10.1080/14697688.2019.1571683
- Paszke, A., Gross, S., Massa, F., Lerer, A., Bradbury, J., Chanan, G., … Chintala, S. (2019). PyTorch: An imperative style, high-performance deep learning library. *Advances in Neural Information Processing Systems, 32*. https://arxiv.org/abs/1912.01703
- Hochreiter, S., & Schmidhuber, J. (1997). Long short-term memory. *Neural Computation, 9*(8), 1735–1780. https://doi.org/10.1162/neco.1997.9.8.1735
