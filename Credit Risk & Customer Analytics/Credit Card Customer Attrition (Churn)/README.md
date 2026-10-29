# Credit Card Customer Attrition (Churn)

When a card customer closes an account, the revolving balance and the spending go with them, and replacing that customer is expensive. But not every customer is worth a retention offer. This notebook predicts who will leave and then uses each customer's value to decide whom it actually pays to contact.

**What it does.** It predicts which credit-card customers will close their accounts, explains why with SHAP, and turns the predictions into a retention campaign that maximises expected profit rather than accuracy.

It compares a logistic regression with LightGBM, tests cost-sensitive training, chooses whom to contact from each customer's value, and summarises everything in a results dashboard.

**Data.** 10,127 customers of a U.S. card issuer with demographics, product holdings and 12 months of transaction behaviour, 16.1% of whom left (Kaggle `sakshigoyal7/credit-card-customers`, "BankChurners").

**Methods.** Logistic regression, LightGBM with 5-fold cross-validation, class weights against value weights (cost-sensitive learning), a calibration check and TreeSHAP.

A customer-value proxy is built from revolving interest and interchange, and a profit-maximising contact rule is compared with fixed thresholds in a Plotly dashboard.

**Key output.** How well the models discriminate, the behaviours that come before attrition, the profit curve of the campaign and the best number of customers to contact.

---

## Why it matters

Churn models share the PD toolkit, but the decision is whom to spend money on, so the objective is profit. On 10,127 card customers, LightGBM ranks leavers almost perfectly (AUC 0.99), and the validation note explains why that is suspiciously high. Most leavers carry no balance and are worth little: contacting everyone with p > 50% earns $1,500, contacting only the 7% with positive expected gain earns $5,700, and contacting everyone loses $60,000.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY` (shared setup cell) and Kaggle access: `KAGGLE_API_TOKEN` in `.env` or `~/.kaggle/access_token`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 40 seconds).

## Data sources

| Data | Source |
|---|---|
| Credit card customers (BankChurners) | Kaggle `sakshigoyal7/credit-card-customers` |

## Outputs (`outputs/`)

- `01_drivers_calibration_profit.png`
- `dashboard.html`
- `dashboard.png`
- `campaign_rules.csv`
- `model_performance.csv`
- `shap_importance.csv`

## Key assumptions

- The two Naive Bayes columns shipped with the file (built on the target) are dropped; gender is used only for monitoring.
- Customer value = revolving balance × (20% APR − 8% funding and losses) + 1.8% interchange on spend.
- Campaign: $30 per contact, 30% of would-be leavers saved.

## Suggested commit plan

1. `add README and attrition framework`
2. `data download and value proxy`
3. `logistic and LightGBM with class and value weights`
4. `SHAP drivers and calibration`
5. `campaign optimisation, dashboard and executed outputs`

## References

### Finance and regulation

- Verbeke, W., Dejaeger, K., Martens, D., Hur, J., & Baesens, B. (2012). New insights into churn prediction in the telecommunication sector: A profit driven data mining approach. *European Journal of Operational Research, 218*(1), 211–229. https://doi.org/10.1016/j.ejor.2011.09.031
- Ascarza, E. (2018). Retention futility: Targeting high-risk customers might be ineffective. *Journal of Marketing Research, 55*(1), 80–98. https://doi.org/10.1509/jmr.16.0163
- Gupta, S., Lehmann, D. R., & Stuart, J. A. (2004). Valuing customers. *Journal of Marketing Research, 41*(1), 7–18. https://doi.org/10.1509/jmkr.41.1.7.25084

### Machine learning and deep learning

- Ke, G., Meng, Q., Finley, T., Wang, T., Chen, W., Ma, W., Ye, Q., & Liu, T.-Y. (2017). LightGBM: A highly efficient gradient boosting decision tree. *Advances in Neural Information Processing Systems, 30*. https://proceedings.neurips.cc/paper/2017/hash/6449f44a102fde848669bdd9eb6b76fa-Abstract.html
- Lundberg, S. M., Erion, G., Chen, H., DeGrave, A., Prutkin, J. M., Nair, B., … Lee, S.-I. (2020). From local explanations to global understanding with explainable AI for trees. *Nature Machine Intelligence, 2*(1), 56–67. https://doi.org/10.1038/s42256-019-0138-9
- Niculescu-Mizil, A., & Caruana, R. (2005). Predicting good probabilities with supervised learning. In *Proceedings of the 22nd International Conference on Machine Learning* (pp. 625–632). https://doi.org/10.1145/1102351.1102430
- Brier, G. W. (1950). Verification of forecasts expressed in terms of probability. *Monthly Weather Review, 78*(1), 1–3. https://doi.org/10.1175/1520-0493(1950)078<0001:VOFEIT>2.0.CO;2
