# Early Warning of Systemic Banking Crises: 150 Years of Macro-Financial History, Machine Learning and Shapley Values

Banking crises are rare, very expensive and surprisingly alike: most follow years of fast credit growth. Supervisors want to see the next one coming early enough to raise capital buffers in time. This notebook asks whether machine learning can give that warning, using 150 years of history, and how far its signals can be trusted.

**What it does.** It predicts systemic banking crises one to two years ahead in 18 advanced economies from 1870 to 2020, using the Jordà–Schularick–Taylor Macrohistory Database (88 crises).

**Models.** Six model families use the same macro-financial indicators: logistic regression, random forest, extremely randomised trees, LightGBM, an RBF support vector machine and a Keras neural network.

The indicators are credit growth, the yield-curve slope, house and equity prices, the current account, the debt service burden, and their **global** counterparts.

**Validation, two ways:**

- **leave-one-country-out**, so a country's own history never helps predict its own crises;
- a **recursive pseudo-real-time** exercise that, for every year from 1980, trains only on the past.

Shapley values open the black box, in particular the interaction between **credit booms and a flat yield curve**. A policy-loss threshold turns probabilities into warnings with known false-alarm rates.

**Data.** Jordà–Schularick–Taylor Macrohistory Database, release 6 (macrohistory.net).

**Methods.** Early-warning target design (pre-crisis window, removal of post-crisis bias), logistic regression, random forest, extra trees, LightGBM, SVM and an MLP (Keras 3), with bootstrap AUC intervals, SHAP and signal-extraction thresholds (usefulness).

---

## Why it matters

Early-warning models inform when to raise the countercyclical capital buffer. On the Jordà–Schularick–Taylor database (18 economies, 1870–2020, 88 crises), six model families predict a crisis one to two years ahead: random forests reach AUC 0.84 leave-one-country-out, against 0.68 for credit-to-GDP growth alone. In a pseudo-real-time test from 1980 the advantage shrinks (0.75 vs 0.72) and flexible models such as the SVM and the neural network overfit, which is the honest lesson. SHAP shows that the global and domestic yield-curve slopes and credit growth drive the warnings, and policy-loss thresholds turn scores into signals with known miss and false-alarm rates.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY` (checked at start-up; the data itself needs no key).
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 15 minutes (57 rounds of six models)).

## Data sources

| Data | Source |
|---|---|
| Jordà–Schularick–Taylor Macrohistory Database, release 6 | https://www.macrohistory.net/database/ |

## Outputs (`outputs/`)

- `01_crisis_early_warning.png`
- `auc_leave_one_country_out.csv`
- `auc_recursive_out_of_sample.csv`
- `country_year_scores.csv`
- `dashboard.html`
- `dashboard.png`
- `shap_importance.csv`
- `warning_thresholds_usefulness.csv`

## Key assumptions

- Target: a systemic crisis (crisisJST) starting in t+1 or t+2; crisis year and the four following years removed; 1914–1919 and 1939–1947 excluded.
- Indicators winsorised at the 1st/99th percentiles; missing values imputed with the training median (LightGBM uses them natively).
- Warning threshold minimises θ·missed + (1−θ)·false alarms with θ = 0.5, chosen on leave-one-country-out scores.

## Suggested commit plan

1. `crisis-early-warning: add JST download, indicators and pre-crisis target`
2. `crisis-early-warning: add six-model leave-one-country-out and recursive validation`
3. `crisis-early-warning: add SHAP, warning thresholds and dashboard`

## References

### Finance and regulation

- Schularick, M., & Taylor, A. M. (2012). Credit booms gone bust: Monetary policy, leverage cycles, and financial crises, 1870–2008. *American Economic Review, 102*(2), 1029–1061. https://doi.org/10.1257/aer.102.2.1029
- Jordà, Ò., Schularick, M., & Taylor, A. M. (2017). Macrofinancial history and the new business cycle facts. *NBER Macroeconomics Annual, 31*, 213–263. https://doi.org/10.1086/690241
- Bluwstein, K., Buckmann, M., Joseph, A., Kapadia, S., & Şimşek, Ö. (2023). Credit growth, the yield curve and financial crisis prediction: Evidence from a machine learning approach. *Journal of International Economics, 145*, 103773. https://doi.org/10.1016/j.jinteco.2023.103773
- Alessi, L., & Detken, C. (2011). Quasi real time early warning indicators for costly asset price boom/bust cycles: A role for global liquidity. *European Journal of Political Economy, 27*(3), 520–533. https://doi.org/10.1016/j.ejpoleco.2011.01.003
- Laeven, L., & Valencia, F. (2018). *Systemic banking crises revisited* (IMF Working Paper No. 18/206). International Monetary Fund. https://doi.org/10.5089/9781484376379.001
- Basel Committee on Banking Supervision. (2010). *Guidance for national authorities operating the countercyclical capital buffer*. Bank for International Settlements. https://www.bis.org/publ/bcbs187.htm

### Machine learning and deep learning

- Lundberg, S. M., & Lee, S.-I. (2017). A unified approach to interpreting model predictions. *Advances in Neural Information Processing Systems, 30*. https://arxiv.org/abs/1705.07874
- Geurts, P., Ernst, D., & Wehenkel, L. (2006). Extremely randomized trees. *Machine Learning, 63*(1), 3–42. https://doi.org/10.1007/s10994-006-6226-1
- Breiman, L. (2001). Random forests. *Machine Learning, 45*(1), 5–32. https://doi.org/10.1023/A:1010933404324
- Ke, G., Meng, Q., Finley, T., Wang, T., Chen, W., Ma, W., Ye, Q., & Liu, T.-Y. (2017). LightGBM: A highly efficient gradient boosting decision tree. *Advances in Neural Information Processing Systems, 30*. https://proceedings.neurips.cc/paper/2017/hash/6449f44a102fde848669bdd9eb6b76fa-Abstract.html
