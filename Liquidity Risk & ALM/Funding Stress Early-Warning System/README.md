# Funding Stress Early-Warning System

In 2008 and again in March 2020, the problem was not that assets lost value but that short-term funding disappeared within days. A liquidity coverage ratio tells a treasury how long it can survive a run; an early-warning system tells it when to start preparing. This notebook builds a weekly warning signal for U.S. dollar funding stress and tests it strictly in real time.

**What it does.** It builds a weekly early-warning system for U.S. dollar funding stress. Episodes are defined from the funding sub-index of the OFR Financial Stress Index, and the system predicts the start of a new episode in the next 13 weeks.

It compares a Kaminsky-style single-indicator signal, logistic regression and LightGBM in a strict walk-forward test from 2007, and turns the probability into a traffic-light dashboard for a treasury or liquidity committee.

**Data.** The OFR Financial Stress Index and its five sub-indices (daily since 2000, financialresearch.gov), and from FRED commercial-paper, Treasury-bill, fed funds, Baa and term spreads, the VIX, reserves, discount-window borrowing and the Chicago Fed adjusted NFCI.

**Methods.** An episode definition that merges short gaps, 24 weekly indicators (levels and changes), signal extraction by noise-to-signal ratio (Kaminsky, Lizondo & Reinhart, 1998), L2 logistic regression and LightGBM.

Models are refitted every year on an expanding window, alarm thresholds are set on training data only, and AUC uncertainty comes from a stationary block bootstrap. TreeSHAP explains the drivers.

**Key output.** Walk-forward AUC, hit rate, lead time and false alarms per year by model, the probability history with episodes, today's indicator traffic lights, and the drivers of today's reading.

---

## Why it matters

An early-warning system tells a treasury when to start preparing for funding stress. Walked forward from 2007, the best single indicator (since 2015, the fed funds – T-bill spread) reaches an AUC of 0.79 and flags 3 of 5 episodes about a quarter ahead; logistic regression and LightGBM do worse with seven episodes to learn from. The system did not see March 2023, a reminder that bank-specific deposit monitoring is still needed.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 40 seconds).

## Data sources

| Data | Source |
|---|---|
| OFR Financial Stress Index and sub-indices | https://www.financialresearch.gov/financial-stress-index/ |
| CP, T-bill, fed funds, Baa, term spread, VIX, reserves, discount window, ANFCI | https://fred.stlouisfed.org |

## Outputs (`outputs/`)

- `01_probability_history.png`
- `dashboard.html`
- `dashboard.png`
- `funding_stress_episodes.csv`
- `indicator_traffic_lights.csv`
- `walk_forward_probabilities.csv`
- `walk_forward_scoreboard.csv`

## Key assumptions

- Stress week: OFR funding sub-index above 0.75; episodes merged across gaps of fewer than 8 weeks; target is an episode onset within 13 weeks.
- Annual expanding-window refits from 2007, labels lagged 13 weeks; alarm threshold set for a 20% false-alarm rate on training weeks.
- Traffic lights from each indicator's percentile since 2000, oriented so red always means more stress.

## Suggested commit plan

1. `add README and early-warning framework`
2. `OFR FSI and FRED ETL`
3. `episode definition and indicators`
4. `signal approach, logistic and LightGBM walk-forward`
5. `evaluation, today's traffic lights, dashboard and executed outputs`

## References

### Finance and regulation

- Kaminsky, G., Lizondo, S., & Reinhart, C. M. (1998). Leading indicators of currency crises. *IMF Staff Papers, 45*(1), 1–48. https://doi.org/10.2307/3867328
- Monin, P. J. (2019). The OFR Financial Stress Index. *Risks, 7*(1), 25. https://doi.org/10.3390/risks7010025
- Brunnermeier, M. K. (2009). Deciphering the liquidity and credit crunch 2007–2008. *Journal of Economic Perspectives, 23*(1), 77–100. https://doi.org/10.1257/jep.23.1.77
- Basel Committee on Banking Supervision. (2013). *Basel III: The liquidity coverage ratio and liquidity risk monitoring tools*. Bank for International Settlements. https://www.bis.org/publ/bcbs238.htm
- Politis, D. N., & Romano, J. P. (1994). The stationary bootstrap. *Journal of the American Statistical Association, 89*(428), 1303–1313. https://doi.org/10.1080/01621459.1994.10476870

### Machine learning and deep learning

- Ke, G., Meng, Q., Finley, T., Wang, T., Chen, W., Ma, W., Ye, Q., & Liu, T.-Y. (2017). LightGBM: A highly efficient gradient boosting decision tree. *Advances in Neural Information Processing Systems, 30*. https://proceedings.neurips.cc/paper/2017/hash/6449f44a102fde848669bdd9eb6b76fa-Abstract.html
- Lundberg, S. M., Erion, G., Chen, H., DeGrave, A., Prutkin, J. M., Nair, B., … Lee, S.-I. (2020). From local explanations to global understanding with explainable AI for trees. *Nature Machine Intelligence, 2*(1), 56–67. https://doi.org/10.1038/s42256-019-0138-9
- Holopainen, M., & Sarlin, P. (2017). Toward robust early-warning models: A horse race, ensembles and model uncertainty. *Quantitative Finance, 17*(12), 1933–1963. https://doi.org/10.1080/14697688.2017.1357972
