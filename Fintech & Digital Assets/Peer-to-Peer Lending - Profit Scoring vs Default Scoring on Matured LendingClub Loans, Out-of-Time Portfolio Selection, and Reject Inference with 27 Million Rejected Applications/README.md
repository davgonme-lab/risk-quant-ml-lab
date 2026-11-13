# Peer-to-Peer Lending: Profit Scoring vs Default Scoring on Matured LendingClub Loans, Out-of-Time Portfolio Selection, and Reject Inference with 27 Million Rejected Applications

A lender usually trains its model to predict who defaults. An investor in loans cares about something else: the return after interest, prepayments and recoveries. And every lender learns only from the loans it approved, never from the ones it turned down. This notebook uses the full LendingClub history to test both problems on loans followed to maturity.

**What it does.** It uses the public LendingClub history (2007–2018), the largest U.S. marketplace lender of its time, to answer two questions that matter for any fintech lender or loan investor.

1. **What should a model predict?** A classic **default score**, or the loan's **realised return**, which also reflects the interest rate, early prepayment and recoveries (profit scoring, Serrano-Cinca and Gutiérrez-Nieto, 2016)? Both are trained on loans issued in 2012–2014 and used to pick portfolios from 2015 loans, which are then followed to maturity.
2. **Does it matter that the lender only sees outcomes for approved applications?** The 27 million rejected applications are used to model the approval decision. Rejection is then simulated inside the accepted book to measure the bias, and three **reject-inference** fixes are tested: reweighting, fuzzy augmentation and parcelling.

**Data.** LendingClub accepted and rejected loan files, 2007–2018Q4 (Kaggle `wordsforthewise/lending-club`).

**Methods.** A matured-loan sample, logistic regression, LightGBM and a Keras MLP for default, and LightGBM regression for annualised return, with an out-of-time portfolio back-test. The approval model uses accepted and rejected applications together, with inverse-propensity reweighting, fuzzy augmentation and parcelling.

---

## Why it matters

On 589,000 matured LendingClub loans, default models barely match LendingClub's own sub-grade (AUC 0.66 vs 0.68). A LightGBM model that predicts the realised return directly picks the best-performing fifth of 2015 loans (3.2% a year against 1.7% at random), while buying the highest-rate fifth loses money. Using 2.9 million rejected applications and a simulated stricter policy, an accepts-only model is almost as good as one that sees every outcome when rejection depends on observed variables. Reweighting adds variance, and augmentation or parcelling only move calibration in the direction of their assumption.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`, `KAGGLE_API_TOKEN`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 5 minutes (first run reads the 1.6 GB and 1.8 GB files in chunks)).

## Data sources

| Data | Source |
|---|---|
| LendingClub accepted and rejected loans 2007–2018Q4 (Kaggle) | https://www.kaggle.com/datasets/wordsforthewise/lending-club |

## Outputs (`outputs/`)

- `01_p2p_lending.png`
- `by_grade.csv`
- `dashboard.html`
- `dashboard.png`
- `default_auc_2015.csv`
- `feature_gain.csv`
- `portfolio_selection_2015.csv`
- `reject_inference.csv`
- `vintages.csv`

## Key assumptions

- 36-month loans issued 2012–2015, final status only; train 2012–2014 (2014 for early stopping), test 2015.
- Realised return = (total received / funded)^(1/τ) − 1, τ = loan life (+6 months of collections for charge-offs).
- Pseudo-reject policy: approval probability 1/(1+exp((q−0.6)/0.08)) on a scorecard risk percentile q.

## Suggested commit plan

1. `p2p-profit-scoring: add chunked LendingClub loading, matured-loan sample and realised returns`
2. `p2p-profit-scoring: add default and profit models and out-of-time portfolio selection`
3. `p2p-profit-scoring: add approval model on rejected applications, reject-inference experiment and dashboard`

## References

### Finance and regulation

- Serrano-Cinca, C., & Gutiérrez-Nieto, B. (2016). The use of profit scoring as an alternative to credit scoring systems in peer-to-peer (P2P) lending. *Decision Support Systems, 89*, 113–122. https://doi.org/10.1016/j.dss.2016.06.014
- Hand, D. J., & Henley, W. E. (1993). Can reject inference ever work? *IMA Journal of Management Mathematics, 5*(1), 45–55. https://doi.org/10.1093/imaman/5.1.45
- Banasik, J., & Crook, J. (2007). Reject inference, augmentation, and sample selection. *European Journal of Operational Research, 183*(3), 1582–1594. https://doi.org/10.1016/j.ejor.2006.06.072
- Morse, A. (2015). Peer-to-peer crowdfunding: Information and the potential for disruption in consumer lending. *Annual Review of Financial Economics, 7*, 463–482. https://doi.org/10.1146/annurev-financial-111914-041939
- Emekter, R., Tu, Y., Jirasakuldech, B., & Lu, M. (2015). Evaluating credit risk and loan performance in online peer-to-peer (P2P) lending. *Applied Economics, 47*(1), 54–70. https://doi.org/10.1080/00036846.2014.962222
- Heckman, J. J. (1979). Sample selection bias as a specification error. *Econometrica, 47*(1), 153–161. https://doi.org/10.2307/1912352

### Machine learning and deep learning

- Ke, G., Meng, Q., Finley, T., Wang, T., Chen, W., Ma, W., Ye, Q., & Liu, T.-Y. (2017). LightGBM: A highly efficient gradient boosting decision tree. *Advances in Neural Information Processing Systems, 30*. https://proceedings.neurips.cc/paper/2017/hash/6449f44a102fde848669bdd9eb6b76fa-Abstract.html
- Zadrozny, B. (2004). Learning and evaluating classifiers under sample selection bias. In *Proceedings of the 21st International Conference on Machine Learning*. https://doi.org/10.1145/1015330.1015425
- Shimodaira, H. (2000). Improving predictive inference under covariate shift by weighting the log-likelihood function. *Journal of Statistical Planning and Inference, 90*(2), 227–244. https://doi.org/10.1016/S0378-3758(00)00115-4
