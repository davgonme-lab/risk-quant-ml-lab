# Bank Customer Churn: Survival & Uplift Modeling

Most churn models answer the wrong question. They rank customers by how likely they are to leave, but a retention budget needs to know whose decision a phone call can actually change. Some customers will leave whatever the bank does, some would have stayed anyway, and some are annoyed into leaving by the call. This notebook separates the two questions and shows what the difference is worth.

**What it does.** It models *when* retail bank customers leave with survival analysis (Kaplan–Meier, Cox proportional hazards and a random survival forest).

It then asks whose churn a campaign can change. Uplift models (S-, T- and X-learners) are trained on a randomised retention campaign simulated on top of the real customers, so the true effect of the offer is known and each model can be graded against it.

**Data.** 10,000 customers of a European retail bank, with credit score, balance, products, activity, complaints and whether they left (Kaggle `radheshyamkollipara/bank-customer-churn`).

**Methods.** A leakage audit, Kaplan–Meier with log-rank tests, Cox PH with Schoenfeld-residual checks, and a random survival forest (`scikit-survival`), scored with the concordance index and the time-dependent Brier score.

The uplift part uses a semi-synthetic randomised trial, S-, T- and X-learners with LightGBM, Qini curves, uplift by decile and policy value.

**Key output.** Survival curves and hazard ratios, the accuracy of the survival models, how well each uplift learner recovers the true treatment effect, and the profit of targeting by uplift rather than by churn risk.

---

## Why it matters

Survival analysis answers when customers leave; uplift modelling answers whose leaving a campaign can change. On 10,000 bank customers the random survival forest beats Cox (C-index 0.79 vs 0.71) because the number of products has a U-shaped effect. On a simulated randomised campaign with known effects, targeting by churn risk only breaks even, while uplift learners earn up to $6,800 on the same budget; the regularised S-learner recovers the true effect best.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY` (shared setup cell) and Kaggle access: `KAGGLE_API_TOKEN` in `.env` or `~/.kaggle/access_token`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 20 seconds).

## Data sources

| Data | Source |
|---|---|
| Bank customer churn records | Kaggle `radheshyamkollipara/bank-customer-churn` |

## Outputs (`outputs/`)

- `01_survival_cox_qini_uplift.png`
- `cox_hazard_ratios.csv`
- `kaplan_meier_segments.csv`
- `survival_model_evaluation.csv`
- `uplift_evaluation.csv`

## Key assumptions

- `Complain` is dropped (99.9% identical to the outcome); tenure in years is the survival time with a mid-year convention.
- The retention campaign is simulated: random 50/50 assignment, true effects by segment (persuadables, sleeping dogs, others) on top of a LightGBM baseline churn probability.
- Economics: $15 per contact, $400 annual margin per avoided churn.

## Suggested commit plan

1. `add README and survival/uplift framework`
2. `data download and leakage audit`
3. `Kaplan–Meier, Cox PH and random survival forest`
4. `semi-synthetic trial and S/T/X-learners`
5. `Qini, policy value and executed outputs`

## References

### Finance and regulation

- Van den Poel, D., & Larivière, B. (2004). Customer attrition analysis for financial services using proportional hazard models. *European Journal of Operational Research, 157*(1), 196–217. https://doi.org/10.1016/S0377-2217(03)00069-9
- Verbeke, W., Dejaeger, K., Martens, D., Hur, J., & Baesens, B. (2012). New insights into churn prediction in the telecommunication sector: A profit driven data mining approach. *European Journal of Operational Research, 218*(1), 211–229. https://doi.org/10.1016/j.ejor.2011.09.031
- Ascarza, E. (2018). Retention futility: Targeting high-risk customers might be ineffective. *Journal of Marketing Research, 55*(1), 80–98. https://doi.org/10.1509/jmr.16.0163

### Machine learning and deep learning

- Kaplan, E. L., & Meier, P. (1958). Nonparametric estimation from incomplete observations. *Journal of the American Statistical Association, 53*(282), 457–481. https://doi.org/10.1080/01621459.1958.10501452
- Cox, D. R. (1972). Regression models and life-tables. *Journal of the Royal Statistical Society: Series B, 34*(2), 187–202. https://doi.org/10.1111/j.2517-6161.1972.tb00899.x
- Ishwaran, H., Kogalur, U. B., Blackstone, E. H., & Lauer, M. S. (2008). Random survival forests. *The Annals of Applied Statistics, 2*(3), 841–860. https://doi.org/10.1214/08-AOAS169
- Künzel, S. R., Sekhon, J. S., Bickel, P. J., & Yu, B. (2019). Metalearners for estimating heterogeneous treatment effects using machine learning. *Proceedings of the National Academy of Sciences, 116*(10), 4156–4165. https://doi.org/10.1073/pnas.1804597116
- Gutierrez, P., & Gérardy, J.-Y. (2017). Causal inference and uplift modelling: A review of the literature. In *Proceedings of the 3rd International Conference on Predictive Applications and APIs* (pp. 1–13). PMLR. https://proceedings.mlr.press/v67/gutierrez17a.html
- Pölsterl, S. (2020). scikit-survival: A library for time-to-event analysis built on top of scikit-learn. *Journal of Machine Learning Research, 21*(212), 1–6. https://jmlr.org/papers/v21/20-729.html
