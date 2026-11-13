# Global Sensitivity Analysis of a DCF: Tornado Charts versus Sobol Indices and Shapley Effects for Correlated Inputs, with Ranges from Damodaran's Industry Data and a Gaussian-Process Surrogate

Every valuation memo has a **tornado chart**: each assumption is moved to a low and a high value, one at a time, and the bars show how much the value changes. It is simple and it can mislead. It ignores **interactions** (higher growth matters more when margins are high), it depends on arbitrary low and high values, and it treats inputs as independent when, in reality, the cost of capital and the terminal growth rate both move with interest rates.

**Global sensitivity analysis** asks a better question: if the uncertainty in each input were removed, how much of the **variance** of the value would disappear?

- **Sobol indices** (first-order *S₁* and total *S_T*) split the variance of the output among inputs and their interactions, for independent inputs.
- **Shapley effects** (Owen, 2014; Song, Nelson and Staum, 2016) share the variance fairly among inputs even when they are **correlated**, using the cooperative-game value from economics.
- A **Gaussian-process surrogate**, fitted to a few hundred runs of the model, can stand in for an expensive model (a full three-statement or LBO model in a spreadsheet) and reproduce the indices from far fewer evaluations.

The model is a standard free-cash-flow-to-the-firm DCF of a company with USD 1 billion of revenue. Its eight inputs are given realistic ranges from the **cross-section of U.S. non-financial industries in Aswath Damodaran's data** (operating margins, sales-to-capital ratios, costs of capital, expected growth), and the risk-free rate from FRED caps the terminal growth rate.

**Data.** Damodaran Online (U.S. industry operating margins, cost of capital, sales to invested capital and fundamental growth, January 2026 update); FRED (10-year Treasury yield).

**Methods.** FCFF DCF with margin convergence and reinvestment from sales-to-capital, one-at-a-time sensitivity (tornado), scenario analysis, Sobol first-order and total indices (Saltelli sampling, Jansen estimators, bootstrap intervals), Shapley effects with a Gaussian copula, Gaussian-process regression surrogate.

**Key output.** Which assumptions really drive a DCF value, whether the tornado chart ranks them differently, how much of the variance comes from interactions, how correlation between the discount rate and terminal growth changes the picture, and how many model runs a surrogate needs.

---

## Why it matters

A free-cash-flow DCF of a company with USD 1 billion of revenue gets its input ranges from the spread across U.S. industries in Damodaran's data. The target operating margin explains 68% of the variance of value on its own and 74% with interactions, followed by revenue growth (13%; 21%) and the cost of capital (8%; 10%); five other inputs explain less than 1% each. The tornado chart ranks the inputs correctly here but hides the 9% of variance due to interactions and understates how dominant the margin is. Correlating the cost of capital with terminal growth and growth with margins shifts Shapley credit from the margin and the discount rate to growth. A Gaussian-process surrogate fitted to 50–200 model runs reproduces the full 163,840-run ranking.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY` in `.env`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 2 minutes).

## Data sources

| Data | Source |
|---|---|
| Damodaran Online: U.S. industry margins, cost of capital, sales to capital and growth | https://pages.stern.nyu.edu/~adamodar/ |
| FRED: 10-year Treasury yield | https://fred.stlouisfed.org/ |

## Outputs (`outputs/`)

- `01_global_sensitivity.png`
- `dashboard.html`
- `dashboard.png`
- `gp_surrogate.csv`
- `shapley_effects.csv`
- `sobol_indices.csv`
- `tornado.csv`

## Key assumptions

- FCFF DCF: ten explicit years, growth fading to terminal growth after year 5, linear margin convergence, reinvestment = change in revenue / sales-to-capital, terminal value with return on capital equal to the cost of capital.
- Input ranges = 10th–90th percentile across non-financial industries (terminal growth 1% to the 10-year Treasury yield), uniform marginals; correlations 0.6 (cost of capital, terminal growth) and 0.3 (growth, margin) through a Gaussian copula.
- Sobol indices from 2^14 Saltelli samples with Jansen estimators and 200 bootstraps; Shapley effects from all 256 subsets with 300 × 300 nested Monte Carlo.

## Suggested commit plan

1. `global-sensitivity-dcf: add Damodaran industry ranges and a vectorised DCF`
2. `global-sensitivity-dcf: add tornado chart and scenarios`
3. `global-sensitivity-dcf: add Sobol indices with bootstrap intervals`
4. `global-sensitivity-dcf: add Shapley effects and Gaussian-process surrogate`
5. `global-sensitivity-dcf: add charts, dashboard and narrative`

## References

- Damodaran, A. Damodaran Online: U.S. industry margins, cost of capital, capital expenditures and fundamental growth. https://pages.stern.nyu.edu/~adamodar/
- Federal Reserve Bank of St. Louis. FRED (10-year Treasury yield). https://fred.stlouisfed.org/
- Sobol', I. M. (2001). Global sensitivity indices for nonlinear mathematical models and their Monte Carlo estimates. *Mathematics and Computers in Simulation*, 55(1–3), 271–280.
- Saltelli, A., Annoni, P., Azzini, I., Campolongo, F., Ratto, M., & Tarantola, S. (2010). Variance based sensitivity analysis of model output. *Computer Physics Communications*, 181(2), 259–270.
- Jansen, M. J. W. (1999). Analysis of variance designs for model output. *Computer Physics Communications*, 117(1–2), 35–43.
- Owen, A. B. (2014). Sobol' indices and Shapley value. *SIAM/ASA Journal on Uncertainty Quantification*, 2(1), 245–251.
- Song, E., Nelson, B. L., & Staum, J. (2016). Shapley effects for global sensitivity analysis: Theory and computation. *SIAM/ASA Journal on Uncertainty Quantification*, 4(1), 1060–1083.
- Borgonovo, E., & Plischke, E. (2016). Sensitivity analysis: A review of recent advances. *European Journal of Operational Research*, 248(3), 869–887.
- Rasmussen, C. E., & Williams, C. K. I. (2006). *Gaussian Processes for Machine Learning*. MIT Press.
