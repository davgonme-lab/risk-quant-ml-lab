# Exposure at Default for Revolving Credit: Credit Conversion Factors from Drawn and Undrawn Balances, Fractional Regression versus Gradient Boosting versus a Sequence Model on 100,000 Credit Cards

For a loan, exposure at default is roughly the outstanding balance. For a credit card or a credit line it is not: borrowers in trouble draw on their unused limits before they default, so the exposure at default (EAD) is usually larger than today's balance. Regulatory models express this with a **credit conversion factor** (CCF): the share of today's undrawn limit that will have been drawn by the time of default. The estimate needs defaulted accounts observed a fixed period before default, which makes the data scarce and noisy; observed CCFs are often negative (the borrower repaid) or above one (the limit was raised), and their distribution is U-shaped. This notebook builds 12-month CCFs from the monthly card histories in the Home Credit data, compares the statistical properties of the CCF with those of alternative EAD targets, and models the CCF with a regulatory-style lookup table, a fractional logit, LightGBM and a recurrent neural network that reads the account's 12 monthly statements before the reference date.

**What it does.**

1. It reads 3.8 million monthly statements of 104,000 credit cards, shows why the choice between technical and material delinquency decides whether there is any exposure to model, finds each card's first month more than 30 days past due on a material amount, and takes the reference date 12 months earlier (the fixed-horizon approach).
2. It computes the realised CCF, the loan-equivalent factor, the utilisation at default and the ratio of EAD to the limit, and shows how they are distributed.
3. It builds features from the account's limit, balance, payments, drawings and delinquency at and before the reference date, and from the customer's application.
4. It models the CCF with a lookup table by utilisation band, a fractional logit, LightGBM and a GRU sequence model, evaluated by repeated cross-validation, and reports the error on CCF and on EAD, and the bias of portfolio EAD.
5. It checks how the CCF depends on the horizon (3, 6 and 12 months before default) and compares modelled EAD with Basel's standardised 10% and 40% conversion factors.

**Data.** Home Credit Default Risk: monthly credit-card balances and application data (Kaggle; downloaded by hand into `data/home_credit/` at the repository root).

**Methods.** Fixed-horizon CCF estimation, the loan-equivalent approach, lookup tables, fractional logit regression, LightGBM, gated recurrent units in PyTorch, grouped repeated cross-validation, and portfolio EAD bias.

**Key output.** The distribution of realised CCFs, out-of-sample errors of each model on CCF and EAD, feature importance, CCF by horizon, and portfolio EAD under each approach.

---

## Why it matters

For credit cards, borrowers in trouble draw on their unused limits before they default. In 104,000 Home Credit cards, counting days past due on any amount produces 1,787 'defaults' with almost no balance; with a materiality threshold only 27 reach 90 days, and 377 reach 30 days owing slightly more than their limit. On the 100 with a valid 12-month reference date, realised conversion factors are U-shaped (37% negative, 42% above one) and borrowers drew 60% of their headroom. A GRU on monthly statements and LightGBM cut the CCF error by about a fifth versus a constant; Basel's standardised 10% and 40% factors understate EAD by 27% and 10%.

## How to run

1. `conda activate quant-risk`. `.env` needs None. The Home Credit files `credit_card_balance.csv.zip` and `application_train.csv.zip` must be in `data/home_credit/` at the repository root (Kaggle competition data, free account, accept the rules, manual download, never committed).
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about a minute on CPU).

## Data sources

| Data | Source |
|---|---|
| Home Credit Default Risk: credit_card_balance and application_train (Kaggle) | https://www.kaggle.com/competitions/home-credit-default-risk/data |

## Outputs (`outputs/`)

- `01_ead_ccf.png`
- `ccf_by_horizon.csv`
- `ccf_by_utilisation.csv`
- `ccf_distribution_summary.csv`
- `dashboard.html`
- `dashboard.png`
- `default_definitions.csv`
- `lightgbm_feature_importance.csv`
- `model_comparison.csv`

## Key assumptions

- Event = first month more than 30 days past due on a material amount (SK_DPD_DEF > 30, balance > 0); reference date 12 months earlier, active, no material arrears and at least 5% of the limit undrawn.
- CCF = (EAD − B) / (L − B) with EAD the balance at the event; models predict CCF capped to [0, 1]; EAD = B + CCF × U.
- Cross-validation: 5 folds grouped by customer, repeated 3 times; GRU on the last 12 statements (utilisation, payment ratio, drawings, ATM share, 30-day arrears flag) plus static features.

## Suggested commit plan

1. `ead-ccf-revolving-credit: add card histories, default definitions and fixed-horizon CCFs`
2. `ead-ccf-revolving-credit: add reference-date and application features and 12-month sequences`
3. `ead-ccf-revolving-credit: add lookup, fractional logit, LightGBM and GRU CCF models with cross-validation`
4. `ead-ccf-revolving-credit: add horizon and utilisation analysis, charts, dashboard and narrative`

## References

### Exposure at default

- Basel Committee on Banking Supervision. (2017). *Basel III: Finalising post-crisis reforms*. Bank for International Settlements. https://www.bis.org/bcbs/publ/d424.htm
- Tong, E. N. C., Mues, C., Brown, I., & Thomas, L. C. (2016). Exposure at default models with and without the credit conversion factor. *European Journal of Operational Research, 252*(3), 910–920. https://doi.org/10.1016/j.ejor.2016.01.054
- Leow, M., & Crook, J. (2016). A new mixture model for the estimation of credit card exposure at default. *European Journal of Operational Research, 249*(2), 487–497. https://doi.org/10.1016/j.ejor.2015.10.001

### Methods

- Papke, L. E., & Wooldridge, J. M. (1996). Econometric methods for fractional response variables with an application to 401(k) plan participation rates. *Journal of Applied Econometrics, 11*(6), 619–632. https://doi.org/10.1002/(SICI)1099-1255(199611)11:6<619::AID-JAE418>3.0.CO;2-1
- Cho, K., van Merriënboer, B., Gulcehre, C., Bahdanau, D., Bougares, F., Schwenk, H., & Bengio, Y. (2014). Learning phrase representations using RNN encoder–decoder for statistical machine translation. In *Proceedings of the 2014 Conference on Empirical Methods in Natural Language Processing* (pp. 1724–1734). https://doi.org/10.3115/v1/D14-1179
- Ke, G., Meng, Q., Finley, T., Wang, T., Chen, W., Ma, W., Ye, Q., & Liu, T.-Y. (2017). LightGBM: A highly efficient gradient boosting decision tree. *Advances in Neural Information Processing Systems, 30*. https://proceedings.neurips.cc/paper/2017/hash/6449f44a102fde848669bdd9eb6b76fa-Abstract.html

### Data

- Home Credit Group. (2018). *Home Credit Default Risk* [Data set]. Kaggle. https://www.kaggle.com/competitions/home-credit-default-risk/data
