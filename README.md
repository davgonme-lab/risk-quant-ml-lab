# risk-quant-ml-lab

**End-to-end projects applying machine learning and deep learning across finance: risk management, capital markets and investments, fixed income and structured finance.**

![Python](https://img.shields.io/badge/Python-3.12-blue) ![R](https://img.shields.io/badge/R-4.x-276DC3) ![License: MIT](https://img.shields.io/badge/License-MIT-green)

---

**What would a finance team build if it had a modern ML toolkit?** This repository answers that question from several seats: a counterparty-risk desk, a credit-risk team, a market-risk function, a bank treasury, a portfolio manager and a fixed-income trader. Each project starts from a real problem: measuring the potential future exposure of a swap book, pricing a partial credit guarantee, estimating capital for a concentrated emerging-market loan book, hedging a multilateral bank's bond portfolio with SOFR swaps, scoring covered-bond programmes, or spotting a systemic banking crisis before it happens. It then solves the problem end to end, with public data, transparent models and a dashboard a committee could read.

---

## What's inside

| Area | Themes | Examples |
|---|---|---|
| **Risk management** | Counterparty credit risk, credit risk, market risk, liquidity risk and ALM | Swap exposure (EE, PFE), SA-CCR and XVA, PD scorecards and LGD models, IRB capital and concentration risk, VaR and Expected Shortfall, stress scenarios, LCR, NSFR and IRRBB, bank-failure prediction |
| **Capital markets and investments** | Valuation and portfolio management, fixed income and hedging, yield curves | Monte Carlo option pricing, portfolio construction, CAPM and betas, bond risk in QuantLib, asset swap spreads, multi-currency duration hedged with SOFR swaps, SOFR, €STR and EURIBOR curves |
| **Structured finance** | Covered bonds | Cover-pool transparency data scored like a rating agency, covered-bond spreads |

The folders in the project index below follow these themes.

---

## How every project is built

Projects are grouped in thematic folders. Each project lives in its own folder and is **fully self-contained**: one notebook, one README and an `outputs/` folder with the charts and dashboards it produces. No project imports code from, or refers to, another one. Clone the repo, open any notebook, run it top to bottom.

Every notebook follows the same path:

1. **Summary.** Why the problem matters, what the notebook does, the data, the methods and the key output.
2. **Business context.** Why the team that owns the problem (risk, treasury, trading or investment) cares.
3. **Theory.** The intuition first, then the math that matters.
4. **Data & ETL.** Downloaded live from the original source, with exact links.
5. **Exploratory analysis**
6. **Modelling**
7. **Validation & backtesting**
8. **Results dashboard & interpretation.** What the numbers mean for a decision.
9. **Limitations & extensions**
10. **References.** Six to ten sources in APA style with a DOI or link, split into finance and regulation, and machine learning and deep learning.

**Market focus.** Mostly US markets and institutions: SOFR, Treasuries, US ETFs and indices, SEC filings and US bank data. Several projects use a multilateral-development-bank-style treasury portfolio built from real bond holdings of sovereigns, supranationals and agencies, sub-sovereigns, banks and corporates, hedged with SOFR swaps. Others cover Europe (covered bonds, €STR and EURIBOR curves) and emerging markets (sovereign credit, emerging-market corporate portfolios and blended finance).

**Code style.** Python code follows PEP 8 with a 79-character line limit, enforced with `black` and `ruff` (settings in `pyproject.toml`); R code is formatted with `styler`.

---

## Project index

Projects are grouped by theme. Each folder is named after the project. Legend: 📊 = includes a results dashboard; (R) = written in R.

### Counterparty Credit Risk

| Project | Key methods |
|---|---|
| [IRS Exposure Engine: EE, EPE, PFE, EEPE](Counterparty%20Credit%20Risk/IRS%20Exposure%20Engine%20-%20EE%2C%20EPE%2C%20PFE%2C%20EEPE/) 📊 | Hull-White Monte Carlo, Longstaff-Schwartz regression, neural pricing surrogate |
| [ISDA / CSA Term Extraction & Inventory with NLP](Counterparty%20Credit%20Risk/ISDA%20-%20CSA%20Term%20Extraction%20%26%20Inventory%20with%20NLP/) | Regex, spaCy, transformers, SQL |
| [Netting Sets & CSA Collateral Modeling](Counterparty%20Credit%20Risk/Netting%20Sets%20%26%20CSA%20Collateral%20Modeling/) | Collateral simulation with MPoR, XGBoost + SHAP |
| [PFE Behaviour Under Market Moves](Counterparty%20Credit%20Risk/PFE%20Behaviour%20Under%20Market%20Moves/) 📊 | Gaussian-process surrogate, stress scenarios |
| [Pre-Trade Incremental PFE & Limit Utilization](Counterparty%20Credit%20Risk/Pre-Trade%20Incremental%20PFE%20%26%20Limit%20Utilization/) 📊 | LightGBM approximation, SQL |
| [SA-CCR Calculator vs Internal Model EAD](Counterparty%20Credit%20Risk/SA-CCR%20Calculator%20vs%20Internal%20Model%20EAD/) | Basel SA-CCR rules, quantile regression |
| [System Migration Reconciliation (legacy engine → new platform, simulated)](Counterparty%20Credit%20Risk/System%20Migration%20Reconciliation%20%28legacy%20engine%20%E2%86%92%20new%20platform%2C%20simulated%29/) 📊 | Isolation Forest, autoencoder, SQL |
| [Terminating Derivatives: Full vs Partial Unwinds, Counterparty Risk and the Termination Market](Counterparty%20Credit%20Risk/Terminating%20Derivatives%20-%20Full%20vs%20Partial%20Unwinds%2C%20Counterparty%20Risk%20and%20the%20Termination%20Market/) | Hull–White Monte Carlo, MLP surrogate, Poisson GLM / LightGBM on DTCC trades |
| [XVA Desk: CVA, DVA, FVA, KVA + Desk Attribution](Counterparty%20Credit%20Risk/XVA%20Desk%20-%20CVA%2C%20DVA%2C%20FVA%2C%20KVA%20%2B%20Desk%20Attribution/) | Monte Carlo, differential machine learning, Euler/Shapley allocation |

### Credit Risk & Customer Analytics

| Project | Key methods |
|---|---|
| [Bank Customer Churn: Survival & Uplift Modeling](Credit%20Risk%20%26%20Customer%20Analytics/Bank%20Customer%20Churn%20-%20Survival%20%26%20Uplift%20Modeling/) | Time-to-churn survival, T/X-learner uplift |
| [Concentration Risk in an Emerging-Market Corporate Portfolio: Multi-Factor Capital, Granularity and ML-Detected Stress Regimes](Credit%20Risk%20%26%20Customer%20Analytics/Concentration%20Risk%20in%20an%20Emerging-Market%20Corporate%20Portfolio%20-%20Multi-Factor%20Capital%2C%20Granularity%20and%20ML-Detected%20Stress%20Regimes/) | Multi-factor Monte Carlo, granularity adjustment, Gaussian-mixture regimes, Euler allocation |
| [Corporate Bankruptcy Prediction in R: Altman's Z-Score vs Logit, Elastic Net, Random Forests and XGBoost](Credit%20Risk%20%26%20Customer%20Analytics/Corporate%20Bankruptcy%20Prediction%20in%20R%20-%20Altman%27s%20Z-Score%20vs%20Logit%2C%20Elastic%20Net%2C%20Random%20Forests%20and%20XGBoost/) | Altman Z′, logit, glmnet, ranger, xgboost, DeLong tests |
| [Corporate Rating Prediction & Migration Matrices](Credit%20Risk%20%26%20Customer%20Analytics/Corporate%20Rating%20Prediction%20%26%20Migration%20Matrices/) | Ordinal logit, SVM, Markov chains |
| [Credit Card Customer Attrition (Churn)](Credit%20Risk%20%26%20Customer%20Analytics/Credit%20Card%20Customer%20Attrition%20%28Churn%29/) 📊 | Gradient boosting, cost-sensitive learning, SHAP |
| [Credit Curve Construction & Spread Validation](Credit%20Risk%20%26%20Customer%20Analytics/Credit%20Curve%20Construction%20%26%20Spread%20Validation/) | Hazard-rate bootstrapping, Gaussian processes |
| [Early Warning of Systemic Banking Crises: 150 Years of Macro-Financial History, Machine Learning and Shapley Values](Credit%20Risk%20%26%20Customer%20Analytics/Early%20Warning%20of%20Systemic%20Banking%20Crises%20-%20150%20Years%20of%20Macro-Financial%20History%2C%20Machine%20Learning%20and%20Shapley%20Values/) 📊 | JST macrohistory, random forest / extra trees / LightGBM / SVM / Keras MLP, recursive OOS, SHAP, usefulness |
| [LGD Modeling: Two-Stage, Beta & Fractional Regression](Credit%20Risk%20%26%20Customer%20Analytics/LGD%20Modeling%20-%20Two-Stage%2C%20Beta%20%26%20Fractional%20Regression/) | Beta / fractional regression, trees |
| [ML PD Model: Monotonic Constraints, SHAP & Calibration](Credit%20Risk%20%26%20Customer%20Analytics/ML%20PD%20Model%20-%20Monotonic%20Constraints%2C%20SHAP%20%26%20Calibration/) | Gradient boosting, SHAP, isotonic calibration |
| [PD Scorecard: WoE / IV + Logistic Regression](Credit%20Risk%20%26%20Customer%20Analytics/PD%20Scorecard%20-%20WoE%20-%20IV%20%2B%20Logistic%20Regression/) | Logistic regression, Gini, KS |
| [PD Scorecard in R](Credit%20Risk%20%26%20Customer%20Analytics/PD%20Scorecard%20in%20R/) | scorecard, pROC |
| [Peer Groups and Proxy Credit Spreads for Unquoted Emerging-Market Names (K-means & KNN)](Credit%20Risk%20%26%20Customer%20Analytics/Peer%20Groups%20and%20Proxy%20Credit%20Spreads%20for%20Unquoted%20Emerging-Market%20Names%20%28K-means%20%26%20KNN%29/) | K-means peer groups, learned-metric KNN, ridge, CVA proxy bias |
| [Portfolio Credit Risk: Vasicek / IRB Capital & CreditMetrics](Credit%20Risk%20%26%20Customer%20Analytics/Portfolio%20Credit%20Risk%20-%20Vasicek%20-%20IRB%20Capital%20%26%20CreditMetrics/) | Copula simulation, PCA factor model |
| [Pricing Partial Credit Guarantees for Blended Finance: ML Default Curves and a Keras Surrogate of the Monte Carlo Pricer](Credit%20Risk%20%26%20Customer%20Analytics/Pricing%20Partial%20Credit%20Guarantees%20for%20Blended%20Finance%20-%20ML%20Default%20Curves%20and%20a%20Keras%20Surrogate%20of%20the%20Monte%20Carlo%20Pricer/) | Monte Carlo guarantee pricer, LightGBM sovereign spreads, Keras surrogate, SHAP |
| [Small-Business Lending with Public Credit Guarantees: Default Models for 900,000 SBA Loans, a Great-Recession Out-of-Time Test and the Economics of the Guarantee](Credit%20Risk%20%26%20Customer%20Analytics/Small-Business%20Lending%20with%20Public%20Credit%20Guarantees%20-%20Default%20Models%20for%20900%2C000%20SBA%20Loans%2C%20a%20Great-Recession%20Out-of-Time%20Test%20and%20the%20Economics%20of%20the%20Guarantee/) 📊 | SBA 7(a) loans, out-of-time LightGBM with entity embeddings, LGD by size band, guarantee-adjusted expected loss and pricing |
| [Sovereign Credit Outlooks with an Open LLM: Macro Fact Sheets, Newspaper Headlines and Machine Learning, Tested Against Subsequent Bond Spreads](Credit%20Risk%20%26%20Customer%20Analytics/Sovereign%20Credit%20Outlooks%20with%20an%20Open%20LLM%20-%20Macro%20Fact%20Sheets%2C%20Newspaper%20Headlines%20and%20Machine%20Learning%2C%20Tested%20Against%20Subsequent%20Bond%20Spreads/) 📊 | Qwen2.5 sovereign outlooks from IMF/World Bank fact sheets and headlines, walk-forward logit / LightGBM, AUC |
| [Sovereign Low-Default Portfolio: Bayesian Hierarchical PD](Credit%20Risk%20%26%20Customer%20Analytics/Sovereign%20Low-Default%20Portfolio%20-%20Bayesian%20Hierarchical%20PD/) | PyMC hierarchical model |

### Securitization & Covered Bonds

| Project | Key methods |
|---|---|
| [Covered Bond Programme Scoring from the Harmonised Transparency Template: Agency-Style Scorecard and Ordinal ML Market-Implied Tiers](Securitization%20%26%20Covered%20Bonds/Covered%20Bond%20Programme%20Scoring%20from%20the%20Harmonised%20Transparency%20Template%20-%20Agency-Style%20Scorecard%20and%20Ordinal%20ML%20Market-Implied%20Tiers/) | HTT field-code parsing, agency-style scorecard, ordinal logit, LightGBM market tiers, K-means peers |
| [European Covered Bond Spreads: Drivers and Forecasts with Machine Learning](Securitization%20%26%20Covered%20Bonds/European%20Covered%20Bond%20Spreads%20-%20Drivers%20and%20Forecasts%20with%20Machine%20Learning/) | Z-spreads over the ECB AAA curve, LightGBM with issuer-grouped CV, SHAP, conformal quantile bands |

### Market Risk

| Project | Key methods |
|---|---|
| [A Multi-Asset Market Risk Engine in R: EWMA, GARCH, DCC Correlations, Expected Shortfall, Monte Carlo and Machine-Learning VaR](Market%20Risk/A%20Multi-Asset%20Market%20Risk%20Engine%20in%20R%20-%20EWMA%2C%20GARCH%2C%20DCC%20Correlations%2C%20Expected%20Shortfall%2C%20Monte%20Carlo%20and%20Machine-Learning%20VaR/) 📊 | rugarch GJR-GARCH, hand-written DCC, FHS Monte Carlo, ranger / xgboost quantile VaR, Kupiec, Christoffersen, FZ0 |
| [Fixed Income Sensitivities: Duration, Convexity, DV01, KRD + Curve PCA](Market%20Risk/Fixed%20Income%20Sensitivities%20-%20Duration%2C%20Convexity%2C%20DV01%2C%20KRD%20%2B%20Curve%20PCA/) | PCA, scenario P&L |
| [Generative Stress Scenarios (VAE / Conditional GAN)](Market%20Risk/Generative%20Stress%20Scenarios%20%28VAE%20-%20Conditional%20GAN%29/) 📊 | Generative deep learning |
| [Market Regime Detection & Regime-Conditional VaR](Market%20Risk/Market%20Regime%20Detection%20%26%20Regime-Conditional%20VaR/) | Hidden Markov models, Gaussian mixtures |

### Valuation & Portfolio Management

| Project | Key methods |
|---|---|
| [CAPM, the Security Market Line and Betas in R: Rolling OLS, Kalman Filter, Bayesian Shrinkage and Machine Learning](Valuation%20%26%20Portfolio%20Management/CAPM%2C%20the%20Security%20Market%20Line%20and%20Betas%20in%20R%20-%20Rolling%20OLS%2C%20Kalman%20Filter%2C%20Bayesian%20Shrinkage%20and%20Machine%20Learning/) 📊 | GRS and Fama–MacBeth tests, Kalman-filter betas, Vasicek and Blume shrinkage, ranger and xgboost beta forecasts |
| [Monte Carlo Pricing Lab: GBM, Heston, Jumps + Variance Reduction](Valuation%20%26%20Portfolio%20Management/Monte%20Carlo%20Pricing%20Lab%20-%20GBM%2C%20Heston%2C%20Jumps%20%2B%20Variance%20Reduction/) | Antithetics, control variates, Sobol QMC |
| [Portfolio Construction: Mean-Variance, Black–Litterman, HRP, CVaR](Valuation%20%26%20Portfolio%20Management/Portfolio%20Construction%20-%20Mean-Variance%2C%20Black%E2%80%93Litterman%2C%20HRP%2C%20CVaR/) 📊 | Convex optimisation, hierarchical clustering |

### Liquidity Risk & ALM

| Project | Key methods |
|---|---|
| [Bank Failure Prediction (Liquidity & Solvency)](Liquidity%20Risk%20%26%20ALM/Bank%20Failure%20Prediction%20%28Liquidity%20%26%20Solvency%29/) | XGBoost, survival, SHAP |
| [IRRBB: EVE & NII Under Basel Shock Scenarios](Liquidity%20Risk%20%26%20ALM/IRRBB%20-%20EVE%20%26%20NII%20Under%20Basel%20Shock%20Scenarios/) 📊 | Repricing gap, simulation |
| [LCR & NSFR Engine with Stressed Outflows](Liquidity%20Risk%20%26%20ALM/LCR%20%26%20NSFR%20Engine%20with%20Stressed%20Outflows/) | Basel III rules, simulation |

### Yield Curves & Volatility Surfaces

| Project | Key methods |
|---|---|
| [Continuous Forward Curves for SOFR, €STR and EURIBOR: Bootstraps, Nelson–Siegel–Svensson, Splines, Gaussian Processes and Neural Networks](Yield%20Curves%20%26%20Volatility%20Surfaces/Continuous%20Forward%20Curves%20for%20SOFR%2C%20%E2%82%ACSTR%20and%20EURIBOR%20-%20Bootstraps%2C%20Nelson%E2%80%93Siegel%E2%80%93Svensson%2C%20Splines%2C%20Gaussian%20Processes%20and%20Neural%20Networks/) 📊 | QuantLib bootstraps (monotone convex), NSS, penalised splines, Gaussian process, PyTorch NN, leave-one-out and locality tests |
| [Nelson–Siegel–Svensson Treasury Curve (R)](Yield%20Curves%20%26%20Volatility%20Surfaces/Nelson%E2%80%93Siegel%E2%80%93Svensson%20Treasury%20Curve%20%28R%29/) 📊 | fredr, ggplot2 |
| [Yield Curve Forecasting: Dynamic Nelson–Siegel + Kalman Filter vs Transformer](Yield%20Curves%20%26%20Volatility%20Surfaces/Yield%20Curve%20Forecasting%20-%20Dynamic%20Nelson%E2%80%93Siegel%20%2B%20Kalman%20Filter%20vs%20Transformer/) | State-space models, deep learning |

### Fixed Income & Hedging

| Project | Key methods |
|---|---|
| [A Bond Portfolio in QuantLib: DV01, PV01, CS01, Key-Rate Risk and Mark-to-Market, with an ML Surrogate for Scenario Revaluation](Fixed%20Income%20%26%20Hedging/A%20Bond%20Portfolio%20in%20QuantLib%20-%20DV01%2C%20PV01%2C%20CS01%2C%20Key-Rate%20Risk%20and%20Mark-to-Market%2C%20with%20an%20ML%20Surrogate%20for%20Scenario%20Revaluation/) 📊 | QuantLib bond pricing, DV01 / CS01 / key-rate risk, historical-scenario VaR/ES, LightGBM and Keras revaluation surrogates |
| [Asset Swap Spreads (Par-Par, Proceeds, Z-Spread) vs Benchmark](Fixed%20Income%20%26%20Hedging/Asset%20Swap%20Spreads%20%28Par-Par%2C%20Proceeds%2C%20Z-Spread%29%20vs%20Benchmark/) 📊 | Bond & swap valuation, regression |
| [Duration and Convexity of a Multi-Currency Treasury Portfolio Hedged with SOFR Swaps: Macaulay, Modified, Fisher–Weil, Key-Rate, Term-Bucket and Floating-Rate Durations, with a Machine-Learning Revaluation Surrogate](Fixed%20Income%20%26%20Hedging/Duration%20and%20Convexity%20of%20a%20Multi-Currency%20Treasury%20Portfolio%20Hedged%20with%20SOFR%20Swaps%20-%20Macaulay%2C%20Modified%2C%20Fisher%E2%80%93Weil%2C%20Key-Rate%2C%20Term-Bucket%20and%20Floating-Rate%20Durations%2C%20with%20a%20Machine-Learning%20Revaluation%20Surrogate/) 📊 | Macaulay, modified, Fisher–Weil, key-rate, term-bucket, spread and FRN durations, OIS bootstrap in 8 currencies, NNLS swap hedge, LightGBM and Keras revaluation |

---

## Data sources

All data is public and free. Every notebook downloads what it needs from the original source and caches it locally in its own `data/` folder, which is never committed.

| Source | Used for | Access |
|---|---|---|
| [FRED](https://fred.stlouisfed.org/) | SOFR, Treasury yields, credit spreads, macro series | Free API key |
| [U.S. Treasury](https://home.treasury.gov/resource-center/data-chart-center/interest-rates) | Daily par yield curves | Open |
| [Yahoo Finance](https://finance.yahoo.com/) via `yfinance` | ETFs, indices, FX, futures, option chains | Open (unofficial API) |
| [iShares](https://www.ishares.com/) fund holdings | Real bond-level portfolios | Open |
| [DTCC Public Price Dissemination](https://pddata.dtcc.com/ppd/cftcdashboard) | Reported SOFR swap trades | Open |
| [SEC EDGAR](https://www.sec.gov/edgar) | XBRL financials, ISDA exhibits, ABS-EE loan tapes, 10-K text | Open (name + email header) |
| [Kaggle](https://www.kaggle.com/) | Credit default, LGD, ratings, churn, fraud, AML and P2P-lending datasets | Free account + token |
| [ECB Data Portal](https://data.ecb.europa.eu/) | Euro AAA yield curve, government yields, policy rates, CISS | Open |
| [Covered Bond Label HTT database](https://www.coveredbondlabel.com/htt-database) | Harmonised Transparency Templates of covered bond programmes | Open |
| [Macrohistory Database (Jordà–Schularick–Taylor)](https://www.macrohistory.net/database/) | 150 years of macro-financial data and banking crises | Open |
| [Federal Reserve Board GSW yield curve](https://www.federalreserve.gov/data/nominal-yield-curve.htm) | Zero-coupon Treasury yields since the 1960s | Open |
| [New York Times Archive API](https://developer.nytimes.com/docs/archive-product/1/overview) | Every NYT article since 2015 (headlines, abstracts) for news-based models | Free API key |
| [The Guardian Open Platform](https://open-platform.theguardian.com/) | Company and country news headlines | Free API key |
| [Hugging Face](https://huggingface.co/) | FNSPID financial-news dataset; open models (FinBERT, Fed-stance RoBERTa, Qwen2.5, BGE, Chronos, TabICL) | Open |
| [IMF DataMapper](https://www.imf.org/external/datamapper) | World Economic Outlook government debt and fiscal balances | Open |
| [UCI Machine Learning Repository](https://archive.ics.uci.edu/) | Credit-card default and other benchmark datasets | Open |
| [World Bank](https://data.worldbank.org/), [FDIC](https://api.fdic.gov/banks/docs/), [OFR](https://www.financialresearch.gov/), [Ken French](https://mba.tuck.dartmouth.edu/pages/faculty/ken.french/data_library.html) | Macro, bank, stress-index and factor data | Open |

Where a dataset cannot be redistributed (Freddie Mac, Fannie Mae, Kaggle competitions), the notebooks show only aggregated results, never raw records.

---
## Getting started

```bash
git clone https://github.com/<your-user>/risk-quant-ml-lab.git
cd risk-quant-ml-lab

conda create -n quant-risk python=3.12 -y
conda activate quant-risk
conda install -c conda-forge ecos -y
pip install -r requirements.txt
python -m ipykernel install --user --name quant-risk --display-name "Python (quant-risk)"

cp .env.example .env      # then add your FRED key and SEC user agent
```

Then open `00_connection_check.ipynb` and run it. It tests every data source and tells you exactly what to fix. Full step-by-step instructions are in [SETUP.md](SETUP.md).

---

## Author

**David Andrés González Medina**. Risk, treasury, quantitative finance and actuarial analytics.
LinkedIn: *add link here*

## License

[MIT](LICENSE). Free to use and adapt with attribution.
