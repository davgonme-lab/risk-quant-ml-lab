# Reinforcement Learning for Asset Allocation (PPO / SAC)

Allocation is a sequential problem: today's weights set tomorrow's trading costs, and the right exposure depends on the market. Reinforcement learning promises to learn that policy directly. But twenty years of weekly data is only about a thousand observations, and a deep policy has thousands of parameters. This notebook gives the idea a fair test and asks the questions an investment committee would ask.

**What it does.** It trains PPO and SAC agents to allocate weekly across eight U.S.-listed ETFs plus cash, net of trading costs. It trains on 2008–2018, selects on 2019–2020 and tests on 2021–2026.

The agents are then compared with 1/N, 60/40, minimum variance and trend following, with a bootstrap test of the Sharpe difference.

**Data.** Daily total-return prices of SPY, EFA, EEM, TLT, IEF, LQD, GLD and DBC since 2007 (Yahoo Finance), and the 3-month T-bill, the VIX and the 10y–2y Treasury slope (FRED).

**Methods.** A custom Gymnasium environment (state: momentum, volatility, macro and current weights; action: softmax weights; reward: net log return minus a variance penalty), Stable-Baselines3 PPO and SAC with three seeds each, Ledoit–Wolf minimum variance and a stationary block bootstrap.

**Key output.** Out-of-sample return, volatility, Sharpe ratio, drawdown and turnover by strategy, seed dispersion, the agents' weight paths, how their allocation reacts to the VIX, and the probability that RL beats 1/N.

---

## Why it matters

Reinforcement learning is often sold as the next step in allocation. Trained on 2008–2018 and tested on 2021–2026, PPO and SAC reach Sharpe ratios of 0.55–0.57 against 0.42 for 1/N, but with a 70% bootstrap probability of beating it, seed-to-seed dispersion (SAC −0.10 to 0.55), training Sharpes above 3 (memorisation), 18–20× annual turnover and a learned policy that buys equities when the VIX rises. The notebook is a validation case study as much as an RL one.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (**about 11 minutes** (6 agents are trained)).

## Data sources

| Data | Source |
|---|---|
| 8 ETF total-return prices | Yahoo Finance via `yfinance` |
| T-bill, VIX, 10y–2y slope (`DTB3`, `VIXCLS`, `T10Y2Y`) | https://fred.stlouisfed.org |

## Outputs (`outputs/`)

- `01_test_wealth_and_seeds.png`
- `02_weights_and_vix_response.png`
- `dashboard.html`
- `dashboard.png`
- `seed_results.csv`
- `test_scoreboard.csv`
- `vix_response.csv`

## Key assumptions

- Weekly rebalancing, long-only with cash, softmax weights; 10 bp one-way costs.
- Reward: net log return minus 4·return² (mean–variance utility); random two-year training episodes.
- Train 2008–2018, validation 2019–2020 (seed selection), test 2021–2026; fixed hyper-parameters, three seeds per algorithm.

## Suggested commit plan

1. `add README and RL allocation framework`
2. `weekly data and state features`
3. `Gymnasium environment and rule-based benchmarks`
4. `PPO and SAC training across seeds`
5. `test scoreboard, bootstrap, policy diagnostics, dashboard and executed outputs`

## References

### Finance and regulation

- DeMiguel, V., Garlappi, L., & Uppal, R. (2009). Optimal versus naive diversification: How inefficient is the 1/N portfolio strategy? *The Review of Financial Studies, 22*(5), 1915–1953. https://doi.org/10.1093/rfs/hhm075
- Moskowitz, T. J., Ooi, Y. H., & Pedersen, L. H. (2012). Time series momentum. *Journal of Financial Economics, 104*(2), 228–250. https://doi.org/10.1016/j.jfineco.2011.11.003
- Ledoit, O., & Wolf, M. (2008). Robust performance hypothesis testing with the Sharpe ratio. *Journal of Empirical Finance, 15*(5), 850–859. https://doi.org/10.1016/j.jempfin.2008.03.002
- Politis, D. N., & Romano, J. P. (1994). The stationary bootstrap. *Journal of the American Statistical Association, 89*(428), 1303–1313. https://doi.org/10.1080/01621459.1994.10476870

### Machine learning and deep learning

- Schulman, J., Wolski, F., Dhariwal, P., Radford, A., & Klimov, O. (2017). Proximal policy optimization algorithms. *arXiv*. https://arxiv.org/abs/1707.06347
- Haarnoja, T., Zhou, A., Abbeel, P., & Levine, S. (2018). Soft actor-critic: Off-policy maximum entropy deep reinforcement learning with a stochastic actor. In *Proceedings of the 35th International Conference on Machine Learning*. https://arxiv.org/abs/1801.01290
- Raffin, A., Hill, A., Gleave, A., Kanervisto, A., Ernestus, M., & Dormann, N. (2021). Stable-Baselines3: Reliable reinforcement learning implementations. *Journal of Machine Learning Research, 22*(268), 1–8. https://jmlr.org/papers/v22/20-1364.html
- Henderson, P., Islam, R., Bachman, P., Pineau, J., Precup, D., & Meger, D. (2018). Deep reinforcement learning that matters. In *Proceedings of the AAAI Conference on Artificial Intelligence, 32*. https://arxiv.org/abs/1709.06560
- Hambly, B., Xu, R., & Yang, H. (2023). Recent advances in reinforcement learning in finance. *Mathematical Finance, 33*(3), 437–503. https://doi.org/10.1111/mafi.12382
