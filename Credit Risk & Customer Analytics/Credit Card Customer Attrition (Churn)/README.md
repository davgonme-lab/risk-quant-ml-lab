# Credit Card Customer Attrition (Churn)

**What it does:** predicts which credit-card customers will close their accounts, explains why with SHAP, and turns the predictions into a retention campaign that maximises expected profit rather than accuracy. It compares a logistic regression and LightGBM, tests cost-sensitive training, chooses whom to contact from each customer's value, and summarises it all in a results dashboard.
**Data:** 10,127 customers of a U.S. card issuer with demographics, product holdings and 12 months of transaction behaviour, 16.1% of whom attrited (Kaggle `sakshigoyal7/credit-card-customers`, "BankChurners").
**Methods:** logistic regression; LightGBM with 5-fold cross-validation; class weights vs value weights (cost-sensitive learning); calibration check; TreeSHAP; a customer-value proxy from revolving interest and interchange; profit-maximising contact rule vs fixed thresholds; Plotly dashboard.
**Key output:** discrimination of the models; the behaviours that precede attrition; the profit curve of the campaign and the optimal number of customers to contact.

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
