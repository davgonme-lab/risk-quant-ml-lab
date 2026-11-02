# Terminating Derivatives: Full vs Partial Unwinds, Counterparty Risk and the Termination Market

Ending a swap early sounds like a simple way to reduce risk, but it often is not. Removing a trade that hedges the rest of the book can leave the bank more exposed, half a termination rarely removes half the risk, and the payment owed at termination is itself a credit exposure until it settles. This notebook works through those effects on a realistic netting set and then looks at how the real swap market terminates trades.

**What it does.** On a SOFR swap netting set simulated with a calibrated Hull–White model, it compares **full and partial terminations**, novation and compression.

For each one it measures the cash settled, the bid-offer cost, the CVA release and the change in EE, EPE and peak PFE (terminating a hedge can *increase* exposure). It also measures the counterparty risk during the termination window.

It trains a **machine-learning pre-trade calculator** (LightGBM and a neural network) on thousands of simulated netting sets to predict the exposure impact of a termination instantly, and finds the cheapest mix of partial terminations that brings PFE under a limit.

Finally, it analyses about a year of public **DTCC swap-data reports**: how often SOFR swaps are terminated early or novated, how far off-market they are when terminated, and which market conditions drive termination activity.

**Data.** The DTCC public swap data repository (CFTC Part 43 cumulative rates files, USD SOFR OIS) and FRED (10-year Treasury yield, Fed funds target).

**Methods.** An OIS curve built from same-day DTCC par swap prints, Hull–White one-factor Monte Carlo with exact bond prices, EE/EPE/PFE and unilateral CVA, and termination economics.

The surrogates (LightGBM and an MLP) are validated with grouped cross-validation against a DV01 rule of thumb. The termination plan uses constrained optimisation (exhaustive search for full terminations, differential evolution for partial ones). Daily termination counts are modelled with a Poisson GLM and LightGBM-Poisson, explained with SHAP.

**Key output.** A termination menu for one counterparty (full or partial, trade by trade), the surrogate's accuracy, the cheapest PFE-reducing termination plan, the settlement-window risk, and the market's termination behaviour and its drivers.

---

## Why it matters

Terminating a derivative is a risk decision: on a calibrated Hull–White netting set, terminating a hedge raises EPE, PFE and CVA; half a deep in-the-money swap removes 97% of its EPE effect; and a partial-termination plan meets a 20% tighter PFE limit at half the bid-offer cost of the best full-termination plan. An ML pre-trade calculator learns the exposure impact of a termination on unseen netting sets (R² 0.65 for EPE, against a negative R² for the DV01 rule of thumb). A year of DTCC swap-data reports shows that 81% of SOFR swap early terminations happen within 30 days of the trade's start, that terminated swaps are four times as off-market as new ones, and that termination activity rises with rate moves and Fed decisions and falls at quarter-ends.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 3 minutes once the DTCC files are cached (first run downloads about 250 daily files)).

## Data sources

| Data | Source |
|---|---|
| DTCC public swap data (CFTC Part 43 cumulative rates files, USD SOFR OIS) | https://pddata.dtcc.com/ppd/cftcdashboard |
| 10-year Treasury yield and Fed funds target | https://fred.stlouisfed.org |

## Outputs (`outputs/`)

- `01_termination_menu_surrogate_market.png`
- `compression_example.csv`
- `dtcc_daily_terminations.csv`
- `off_market_terminations.csv`
- `pfe_limit_plans.csv`
- `surrogate_scores.csv`
- `surrogate_shap_pfe.csv`
- `termination_count_models.csv`
- `termination_menu.csv`
- `termination_window_risk.csv`

## Key assumptions

- Hull–White one-factor, a = 0.03, σ matched to the 10-year yield's realised normal volatility; OIS curve from DTCC par prints.
- Uncollateralised netting set; unilateral CVA with a 150 bp counterparty spread and 40% recovery; floating legs at par on a quarterly grid.
- Half bid-offer 0.25–0.75 bp of the fixed rate by tenor; termination at mid.
- DTCC: early termination = action TERM / event ETRM; off-market measured against same-day median par for the nearest tenor bucket.

## Suggested commit plan

1. `add README and termination framework`
2. `DTCC ETL and market OIS curve`
3. `Hull–White exposure engine and netting set`
4. `termination menu, compression and settlement risk`
5. `ML pre-trade surrogate`
6. `PFE-limit optimisation, full vs partial`
7. `termination market analysis`

## References

### Finance and regulation

- Gregory, J. (2020). *The xVA challenge: Counterparty risk, funding, collateral, capital and initial margin* (4th ed.). Wiley. https://doi.org/10.1002/9781119508991
- Hull, J., & White, A. (1990). Pricing interest-rate-derivative securities. *The Review of Financial Studies, 3*(4), 573–592. https://doi.org/10.1093/rfs/3.4.573
- D'Errico, M., & Roukny, T. (2021). Compressing over-the-counter markets. *Operations Research, 69*(6), 1660–1679. https://doi.org/10.1287/opre.2021.2107
- Duffie, D., Scheicher, M., & Vuillemey, G. (2015). Central clearing and collateral demand. *Journal of Financial Economics, 116*(2), 237–256. https://doi.org/10.1016/j.jfineco.2014.12.006
- Basel Committee on Banking Supervision. (2014). *The standardised approach for measuring counterparty credit risk exposures*. Bank for International Settlements. https://www.bis.org/publ/bcbs279.htm

### Machine learning and deep learning

- Ke, G., Meng, Q., Finley, T., Wang, T., Chen, W., Ma, W., Ye, Q., & Liu, T.-Y. (2017). LightGBM: A highly efficient gradient boosting decision tree. *Advances in Neural Information Processing Systems, 30*. https://proceedings.neurips.cc/paper/2017/hash/6449f44a102fde848669bdd9eb6b76fa-Abstract.html
- Storn, R., & Price, K. (1997). Differential evolution: A simple and efficient heuristic for global optimization over continuous spaces. *Journal of Global Optimization, 11*(4), 341–359. https://doi.org/10.1023/A:1008202821328
- Lundberg, S. M., & Lee, S.-I. (2017). A unified approach to interpreting model predictions. *Advances in Neural Information Processing Systems, 30*. https://arxiv.org/abs/1705.07874
- Nelder, J. A., & Wedderburn, R. W. M. (1972). Generalized linear models. *Journal of the Royal Statistical Society: Series A, 135*(3), 370–384. https://doi.org/10.2307/2344614
