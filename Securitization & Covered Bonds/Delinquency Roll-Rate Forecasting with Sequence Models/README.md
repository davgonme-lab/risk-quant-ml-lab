# Delinquency Roll-Rate Forecasting with Sequence Models

Servicers, collections teams and securitisation analysts all track how loans move between "current", "30 days late", "60 days late" and worse. The classic tool assumes only this month's bucket matters, but a loan that just cured from 60 days late behaves very differently from one that has always paid. This notebook tests how much a loan's payment history adds, with sequence models that read it directly, in calm years and in the 2008–2010 housing crisis.

**What it does.** It forecasts how mortgages move between delinquency states (current, 30, 60, 90+ days, paid off) one and six months ahead, on Fannie Mae loans originated in 2005–08 and Freddie Mac loans originated in 2018–23.

It compares the classic first-order Markov roll-rate matrix, a Markov model with covariates (multinomial logit), and an LSTM and a small Transformer that read each loan's last 12 months of payment history.

The forecasts are aggregated to the pool level, which is what a securitisation surveillance desk or a servicer's collections plan needs, and every model is put through a regime test: trained on data to 2007, asked to forecast the crisis.

**Data.** Fannie Mae Single-Family Loan Performance data (2005–2008 acquisitions) and the Freddie Mac Single-Family Loan-Level Dataset (vintages 2018–2023), monthly performance to March 2026.

**Methods.** Monthly state sequences with forbearance flags, empirical transition matrices and their powers, multinomial logit, and LSTM and Transformer encoders (PyTorch) with class-balanced sampling and importance weights.

One-step and six-step forecasts are scored out of time on log-loss, accuracy for delinquent loans, roll-rate calibration and pool-level state-share errors.

**Key output.** Roll-rate matrices, the accuracy of each model by starting state, how much payment history adds beyond the current state, and pool delinquency forecasts against what happened, out of time in 2024–25 and in the crisis.

---

## Why it matters


Collections, servicing and securitisation surveillance all run on roll rates. On Fannie Mae 2005–08 and Freddie Mac 2018–23 loans, payment history matters enormously: loans current today but 60+ days late within the last year are 26 times as likely to be late again, which a Markov chain cannot see and the LSTM and Transformer recover. Sequence models also forecast the 2024–25 pool best (0.28–0.30 point error against 0.86 for Markov). But trained on data to 2007, no model came close to the 2008–10 crisis (5.1% of loans 60+ days late against forecasts of 1.4–2.7%): roll-rate models learned in calm years need macro inputs or stressed matrices.

## How to run


1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY` (shared setup), plus the Freddie Mac sample zips in `data/freddie_mac/` and the Fannie Mae quarterly files 2005Q1–2008Q4 in `data/fannie_mae/` at the repo root (see the root README). The first run builds a 200,000-loan Fannie Mae sample in `data/fannie_mae/sample/` (about 20–30 minutes, once).
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 6 minutes after the first run).

## Data sources


| Data | Source |
|---|---|
| Fannie Mae Single-Family Loan Performance Data, 2005–2008 acquisitions | https://capitalmarkets.fanniemae.com |
| Freddie Mac Single-Family Loan-Level Dataset, sample files 2018–2023 | https://www.freddiemac.com/research/datasets/sf-loanlevel-dataset |

## Outputs (`outputs/`)


- `01_states_rollrates_history_pool.png`
- `crisis_test_2008_2010.csv`
- `crisis_test_pool_path.csv`
- `markov_roll_rate_matrix.csv`
- `out_of_time_evaluation.csv`
- `path_dependence_test.csv`
- `pool_forecast_60plus.csv`

## Key assumptions

- States: current, 30, 60, 90+, prepaid, default; prepayments kept rather than censored.
- Sequence models see the last 12 months of status; out-of-time evaluation on anchors January 2024 – September 2025, and a crisis test (trained to December 2007, tested July 2008 – June 2010).
- One loan in six enters the sequences; Fannie Mae sample: loans whose identifier modulo 1000 is below 80, then 12,500 drawn at random per acquisition quarter.
- Markov with covariates = multinomial logit on current state, age and loan characteristics.

## Suggested commit plan

1. `add README and delinquency states`
2. `Markov roll-rate matrices`
3. `LSTM and Transformer sequence models`
4. `path-dependence test`
5. `pool forecasts, crisis regime test and charts`

## References

### Finance and regulation

- Grimshaw, S. D., & Alexander, W. P. (2011). Markov chain models for delinquency: Transition matrix estimation and forecasting. *Applied Stochastic Models in Business and Industry, 27*(3), 267–279. https://doi.org/10.1002/asmb.827
- Thomas, L. C., Crook, J., & Edelman, D. (2017). *Credit scoring and its applications* (2nd ed.). SIAM. https://doi.org/10.1137/1.9781611974560
- Sirignano, J., Sadhwani, A., & Giesecke, K. (2021). Deep learning for mortgage risk. *Journal of Financial Econometrics, 19*(2), 313–368. https://doi.org/10.1093/jjfinec/nbaa025
- Jarrow, R. A., Lando, D., & Turnbull, S. M. (1997). A Markov model for the term structure of credit risk spreads. *The Review of Financial Studies, 10*(2), 481–523. https://doi.org/10.1093/rfs/10.2.481
- Fannie Mae. (2026). *Single-Family Loan Performance Data* [Data set]. https://capitalmarkets.fanniemae.com/credit-risk-transfer/single-family-credit-risk-transfer/fannie-mae-single-family-loan-performance-data

### Machine learning and deep learning

- Hochreiter, S., & Schmidhuber, J. (1997). Long short-term memory. *Neural Computation, 9*(8), 1735–1780. https://doi.org/10.1162/neco.1997.9.8.1735
- Vaswani, A., Shazeer, N., Parmar, N., Uszkoreit, J., Jones, L., Gomez, A. N., Kaiser, Ł., & Polosukhin, I. (2017). Attention is all you need. *Advances in Neural Information Processing Systems, 30*. https://arxiv.org/abs/1706.03762
- Paszke, A., Gross, S., Massa, F., Lerer, A., Bradbury, J., Chanan, G., … Chintala, S. (2019). PyTorch: An imperative style, high-performance deep learning library. *Advances in Neural Information Processing Systems, 32*. https://arxiv.org/abs/1912.01703
