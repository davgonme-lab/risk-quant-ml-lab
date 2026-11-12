# American Options: Longstaff–Schwartz vs Deep Optimal Stopping

An option that can be exercised early is hard to price by simulation, because the decision to exercise depends on what the option would be worth if kept, and that is itself unknown. The industry answer since 2001 is a regression trick; a newer answer lets a neural network learn the exercise decision directly. This notebook compares the two against exact benchmarks, from one asset to many.

**What it does.** It prices early-exercise options by Monte Carlo two ways: the industry-standard Longstaff–Schwartz regression (LSM), and Deep Optimal Stopping (DOS), where a neural network learns the exercise decision directly.

One case is a classic American put, checked against an exact Bermudan binomial tree. The other is a multi-asset Bermudan max-call, checked against published reference values.

**Data.** Synthetic, under standard textbook parameters, so every number can be checked against known benchmarks.

**Methods.** A CRR binomial tree with exercise restricted to the Bermudan dates, LSM with polynomial and payoff basis functions, and DOS (Becker, Cheridito & Jentzen, 2019) with one sigmoid network per exercise date, trained by backward induction in PyTorch. Lower bounds are measured out of sample on independent paths with confidence intervals.

**Key output.** Prices and errors against benchmarks, the learned exercise boundary of the put, and accuracy against compute time as the number of assets grows.

---

## Why it matters

Callable bonds, Bermudan swaptions and prepayment options all need early-exercise pricing on simulated paths. Against an exact Bermudan tree, Longstaff–Schwartz prices the American put within 0.6 cents in a second, and Deep Optimal Stopping is 2.3 cents low after 30 seconds. On a 5-asset max-call both land within 0.6% of the published references. LSM is the practical default; neural stopping pays off only in high dimension.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (**about 8 minutes** (Deep Optimal Stopping trains one network per exercise date)).

## Data sources

| Data | Source |
|---|---|
| Synthetic GBM paths under textbook parameters | Longstaff & Schwartz (2001), Becker, Cheridito & Jentzen (2019) reference values |

## Outputs (`outputs/`)

- `01_put_exercise_boundary.png`
- `02_accuracy_vs_benchmarks.png`
- `bermudan_maxcall_results.csv`
- `bermudan_put_results.csv`

## Key assumptions

- Bermudan exercise (50 dates for the put, 9 for the max-call); lower bounds only, on independent evaluation paths.
- LSM with polynomial + payoff basis on in-the-money paths; DOS with one sigmoid network per date.
- Modest training budgets so the notebook runs on a laptop CPU.

## Suggested commit plan

1. `add README and optimal-stopping framework`
2. `Bermudan binomial benchmark`
3. `Longstaff–Schwartz regression pricer`
4. `Deep Optimal Stopping in PyTorch`
5. `accuracy vs compute comparison and executed outputs`

## References

### Finance and regulation

- Longstaff, F. A., & Schwartz, E. S. (2001). Valuing American options by simulation: A simple least-squares approach. *The Review of Financial Studies, 14*(1), 113–147. https://doi.org/10.1093/rfs/14.1.113
- Cox, J. C., Ross, S. A., & Rubinstein, M. (1979). Option pricing: A simplified approach. *Journal of Financial Economics, 7*(3), 229–263. https://doi.org/10.1016/0304-405X(79)90015-1
- Andersen, L., & Broadie, M. (2004). Primal-dual simulation algorithm for pricing multidimensional American options. *Management Science, 50*(9), 1222–1234. https://doi.org/10.1287/mnsc.1040.0258
- Glasserman, P. (2004). *Monte Carlo methods in financial engineering*. Springer. https://doi.org/10.1007/978-0-387-21617-1

### Machine learning and deep learning

- Becker, S., Cheridito, P., & Jentzen, A. (2019). Deep optimal stopping. *Journal of Machine Learning Research, 20*(74), 1–25. https://jmlr.org/papers/v20/18-232.html
- Becker, S., Cheridito, P., Jentzen, A., & Welti, T. (2021). Solving high-dimensional optimal stopping problems using deep learning. *European Journal of Applied Mathematics, 32*(3), 470–514. https://doi.org/10.1017/S0956792521000073
- Paszke, A., Gross, S., Massa, F., Lerer, A., Bradbury, J., Chanan, G., … Chintala, S. (2019). PyTorch: An imperative style, high-performance deep learning library. *Advances in Neural Information Processing Systems, 32*. https://arxiv.org/abs/1912.01703
