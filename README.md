# risk-quant-ml-lab

**End-to-end projects applying machine learning and deep learning across finance: risk management, capital markets and investments, fixed income and structured finance.**

![Python](https://img.shields.io/badge/Python-3.12-blue) ![R](https://img.shields.io/badge/R-4.x-276DC3) ![License: MIT](https://img.shields.io/badge/License-MIT-green)

---

**What would a finance team build if it had a modern ML toolkit?** This repository answers that question from several seats: a counterparty-risk desk, a credit-risk team, a market-risk function, a bank treasury, a portfolio manager and a fixed-income trader. Each project starts from a real problem: measuring the potential future exposure of a swap book, pricing a partial credit guarantee, estimating capital for a concentrated emerging-market loan book, hedging a multilateral bank's bond portfolio with SOFR swaps, scoring covered-bond programmes, or spotting a systemic banking crisis before it happens. It then solves the problem end to end, with public data, transparent models and a dashboard a committee could read.

---

## What's inside

| Area | Themes | Examples |
|---|---|---|
| **Risk management** | Counterparty credit risk, credit risk, market risk, bank capital and stress testing, liquidity risk and ALM | Swap exposure (EE, PFE), SA-CCR and XVA, PD scorecards and LGD models, IRB capital and concentration risk, VaR and Expected Shortfall, volatility forecasting, investor sentiment and drawdown forecasts, ICAAP and ILAAP, stress scenarios, LCR, NSFR and IRRBB, bank-failure prediction, covenant headroom and the corporate maturity wall, analyst adjustments for leases, LIFO and pensions, exchange-rate fair value and PPP, sudden stops in capital flows, Taylor rules in Latin America |
| **Capital markets and investments** | Valuation and portfolio management, fixed income and hedging, yield curves | Monte Carlo option pricing, portfolio construction and risk parity, HJM forward-curve models, settlement risk, integrated three-statement models, leveraged buyouts, project finance, comparable-company selection, implied cost of equity, hierarchical revenue forecasts, budget variances, merger models, operating leverage, group consolidation, sum-of-the-parts, IPO underpricing, price elasticity with double ML, capital rationing, working capital, global sensitivity analysis, extended DuPont analysis, cash flow analysis, effective tax rates, capital structure dynamics, index construction and smart beta, insider trading signals, tests of market efficiency, industry life cycles, mutual-fund skill versus luck, hedge-fund 13F clones and fees, chart patterns read by CNNs, technical rules under data-snooping tests, the factor zoo, Treasury auctions, bond math checked against QuantLib, index-futures carry, private-equity PMEs and J-curves, venture-capital exits, REIT valuation from FFO and NAV, commodity futures curves and roll yield, robo-advice risk profiling, GIPS performance measurement, downside-risk portfolios, CAPM and betas, bond risk in QuantLib, asset swap spreads, multi-currency duration hedged with SOFR swaps, cross-currency swaps, SOFR, €STR and EURIBOR curves |
| **Sustainable finance** | Green and sustainability-linked bonds, blended finance, infrastructure and emerging-market lending | The German twin-Bund greenium, the value of an SLB coupon step-up, first-loss sizing from development-bank default data, private infrastructure mobilisation, local-currency lending, environmental and social screening of projects, deforestation detection from satellite images, social-controversy indices from the news, ESG language in 10-K filings against EPA emissions |
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
| [Basel III Endgame Credit Capital for U.S. Banks: the Standardised Approach versus Foundation and Advanced IRB, the 72.5% Output Floor, and How Machine-Learning PDs Move Risk-Weighted Assets](Credit%20Risk%20%26%20Customer%20Analytics/Basel%20III%20Endgame%20Credit%20Capital%20for%20U.S.%20Banks%20-%20the%20Standardised%20Approach%20versus%20Foundation%20and%20Advanced%20IRB%2C%20the%2072.5%25%20Output%20Floor%2C%20and%20How%20Machine-Learning%20PDs%20Move%20Risk-Weighted%20Assets/) 📊 | FDIC call reports 2001–2025 for every U.S. bank, default rates and LGD by loan type, out-of-time persistence vs fractional logit vs LightGBM PD forecasts, U.S. standardised vs Basel III SA-CR vs F-IRB vs A-IRB credit RWA, 72.5% output floor, pro forma CET1, procyclicality of PIT vs TTC PDs |
| [Climate Transition Risk in a Corporate Bond Portfolio: NGFS Phase 5 Scenarios, Reported Emissions and an ML Spread-to-PD Model](Credit%20Risk%20%26%20Customer%20Analytics/Climate%20Transition%20Risk%20in%20a%20Corporate%20Bond%20Portfolio%20-%20NGFS%20Phase%205%20Scenarios%2C%20Reported%20Emissions%20and%20an%20ML%20Spread-to-PD%20Model/) 📊 | NGFS Phase 5 API, EPA GHGRP emissions, SEC XBRL, monotonic LightGBM spread-to-PD, credit VaR |
| [Concentration Risk in an Emerging-Market Corporate Portfolio: Multi-Factor Capital, Granularity and ML-Detected Stress Regimes](Credit%20Risk%20%26%20Customer%20Analytics/Concentration%20Risk%20in%20an%20Emerging-Market%20Corporate%20Portfolio%20-%20Multi-Factor%20Capital%2C%20Granularity%20and%20ML-Detected%20Stress%20Regimes/) | Multi-factor Monte Carlo, granularity adjustment, Gaussian-mixture regimes, Euler allocation |
| [Corporate Bankruptcy Prediction in R: Altman's Z-Score vs Logit, Elastic Net, Random Forests and XGBoost](Credit%20Risk%20%26%20Customer%20Analytics/Corporate%20Bankruptcy%20Prediction%20in%20R%20-%20Altman%27s%20Z-Score%20vs%20Logit%2C%20Elastic%20Net%2C%20Random%20Forests%20and%20XGBoost/) | Altman Z′, logit, glmnet, ranger, xgboost, DeLong tests |
| [Corporate Rating Prediction & Migration Matrices](Credit%20Risk%20%26%20Customer%20Analytics/Corporate%20Rating%20Prediction%20%26%20Migration%20Matrices/) | Ordinal logit, SVM, Markov chains |
| [Credit Card Customer Attrition (Churn)](Credit%20Risk%20%26%20Customer%20Analytics/Credit%20Card%20Customer%20Attrition%20%28Churn%29/) 📊 | Gradient boosting, cost-sensitive learning, SHAP |
| [Credit Curve Construction & Spread Validation](Credit%20Risk%20%26%20Customer%20Analytics/Credit%20Curve%20Construction%20%26%20Spread%20Validation/) | Hazard-rate bootstrapping, Gaussian processes |
| [Downturn LGD When Recoveries Are Scarce: Frye–Jacobs, EBA-Style Downturn Periods, Bayesian Shrinkage and Transfer Learning on Mortgage Recoveries from the 2008 Crisis to 2025](Credit%20Risk%20%26%20Customer%20Analytics/Downturn%20LGD%20When%20Recoveries%20Are%20Scarce%20-%20Frye%E2%80%93Jacobs%2C%20EBA-Style%20Downturn%20Periods%2C%20Bayesian%20Shrinkage%20and%20Transfer%20Learning%20on%20Mortgage%20Recoveries%20from%20the%202008%20Crisis%20to%202025/) 📊 | Fannie Mae 2005–2008 and Freddie Mac 2018–2023 liquidation records, realised LGD with mark-to-market LTV from FRED state HPI, EBA downturn-period identification, default- vs year-weighted long-run LGD, Frye–Jacobs LGD function, empirical-Bayes shrinkage with pooled and informed priors, fractional logit and LightGBM, transfer learning by recalibration and instance weighting with repeated cross-validation, house-price stress scenario |
| [Early Warning of Systemic Banking Crises: 150 Years of Macro-Financial History, Machine Learning and Shapley Values](Credit%20Risk%20%26%20Customer%20Analytics/Early%20Warning%20of%20Systemic%20Banking%20Crises%20-%20150%20Years%20of%20Macro-Financial%20History%2C%20Machine%20Learning%20and%20Shapley%20Values/) 📊 | JST macrohistory, random forest / extra trees / LightGBM / SVM / Keras MLP, recursive OOS, SHAP, usefulness |
| [Estimating an Issuer's CDS, OAS and Market-Implied Rating Gap (Oracle)](Credit%20Risk%20%26%20Customer%20Analytics/Estimating%20an%20Issuer%27s%20CDS%2C%20OAS%20and%20Market-Implied%20Rating%20Gap%20%28Oracle%29/) | Hazard-curve fitting, CreditGrades, monotone LightGBM, market-implied ratings |
| [Estimating Asset Correlation from Forty Years of U.S. Bank Charge-Offs: Vasicek Maximum Likelihood versus the Basel Correlation Formula, the Procyclicality of Capital, and Machine-Learning Macro Default Models](Credit%20Risk%20%26%20Customer%20Analytics/Estimating%20Asset%20Correlation%20from%20Forty%20Years%20of%20U.S.%20Bank%20Charge-Offs%20-%20Vasicek%20Maximum%20Likelihood%20versus%20the%20Basel%20Correlation%20Formula%2C%20the%20Procyclicality%20of%20Capital%2C%20and%20Machine-Learning%20Macro%20Default%20Models/) 📊 | FRED charge-off and delinquency rates of all U.S. commercial banks by loan type 1985–2026, Vasicek one-factor model, method of moments and AR(1)-factor MLE of asset correlation, block bootstrap, Basel IRB correlation functions, 99.9% default rates and return periods, PIT vs TTC capital, rolling-origin linear factor vs LightGBM vs MLP macro default models, residual correlation |
| [Exposure at Default for Revolving Credit: Credit Conversion Factors from Drawn and Undrawn Balances, Fractional Regression versus Gradient Boosting versus a Sequence Model on 100,000 Credit Cards](Credit%20Risk%20%26%20Customer%20Analytics/Exposure%20at%20Default%20for%20Revolving%20Credit%20-%20Credit%20Conversion%20Factors%20from%20Drawn%20and%20Undrawn%20Balances%2C%20Fractional%20Regression%20versus%20Gradient%20Boosting%20versus%20a%20Sequence%20Model%20on%20100%2C000%20Credit%20Cards/) 📊 | Home Credit monthly credit-card balances and application data, technical vs material delinquency definitions, 12-month fixed-horizon CCF, LEQ and EAD/limit, utilisation-band lookup table, fractional logit, LightGBM, GRU sequence model in PyTorch, grouped repeated cross-validation, portfolio EAD bias vs Basel standardised CCFs |
| [Fair Lending Analytics with HMDA: Mortgage Denial and Pricing Disparities, a Machine-Learning Underwriting Model, Proxy Discrimination and the Search for a Less Discriminatory Alternative](Credit%20Risk%20%26%20Customer%20Analytics/Fair%20Lending%20Analytics%20with%20HMDA%20-%20Mortgage%20Denial%20and%20Pricing%20Disparities%2C%20a%20Machine-Learning%20Underwriting%20Model%2C%20Proxy%20Discrimination%20and%20the%20Search%20for%20a%20Less%20Discriminatory%20Alternative/) 📊 | HMDA adverse impact ratios, logit with lender fixed effects, LightGBM underwriting, proxy AUC, LDA search, lender screening |
| [IFRS 9 / CECL Lifetime PD & ECL with Survival Models](Credit%20Risk%20%26%20Customer%20Analytics/IFRS%209%20-%20CECL%20Lifetime%20PD%20%26%20ECL%20with%20Survival%20Models/) | Cox, random survival forest, DeepSurv; crisis back-test and downturn LGD on Fannie Mae 2005–08 loans |
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
| [A Commercial Real Estate Cover Pool: Loan-Level ML Distress Model, VAE Macro Scenarios and Required Overcollateralisation](Securitization%20%26%20Covered%20Bonds/A%20Commercial%20Real%20Estate%20Cover%20Pool%20-%20Loan-Level%20ML%20Distress%20Model%2C%20VAE%20Macro%20Scenarios%20and%20Required%20Overcollateralisation/) 📊 | SEC CMBS loan tapes, monotonic LightGBM distress hazard, Keras VAE scenarios, refinancing stress, required OC |
| [ABS/MBS Waterfall Engine & Tranche Loss Distribution](Securitization%20%26%20Covered%20Bonds/ABS-MBS%20Waterfall%20Engine%20%26%20Tranche%20Loss%20Distribution/) | Monte Carlo, OC/IC tests; factor volatility and severity calibrated on ten vintages including the 2008 crisis |
| [Covered Bond Programme Scoring from the Harmonised Transparency Template: Agency-Style Scorecard and Ordinal ML Market-Implied Tiers](Securitization%20%26%20Covered%20Bonds/Covered%20Bond%20Programme%20Scoring%20from%20the%20Harmonised%20Transparency%20Template%20-%20Agency-Style%20Scorecard%20and%20Ordinal%20ML%20Market-Implied%20Tiers/) | HTT field-code parsing, agency-style scorecard, ordinal logit, LightGBM market tiers, K-means peers |
| [Covered-Bond Cover-Pool Stress & Overcollateralisation with VAE Scenarios](Securitization%20%26%20Covered%20Bonds/Covered-Bond%20Cover-Pool%20Stress%20%26%20Overcollateralisation%20with%20VAE%20Scenarios/) | VAE scenario generation, simulation; crisis-calibrated LTV and unemployment default hazard |
| [European Covered Bond Spreads: Drivers and Forecasts with Machine Learning](Securitization%20%26%20Covered%20Bonds/European%20Covered%20Bond%20Spreads%20-%20Drivers%20and%20Forecasts%20with%20Machine%20Learning/) | Z-spreads over the ECB AAA curve, LightGBM with issuer-grouped CV, SHAP, conformal quantile bands |
| [Mortgage Prepayment (CPR) & Default (CDR) Competing Risks](Securitization%20%26%20Covered%20Bonds/Mortgage%20Prepayment%20%28CPR%29%20%26%20Default%20%28CDR%29%20Competing%20Risks/) | Competing-risks survival, LightGBM, GLM; crisis vs recent S-curves (Fannie Mae 2005–08, Freddie Mac 2018–23) |
| [Securitised Auto-Loan Pool: Early-Warning Indicators](Securitization%20%26%20Covered%20Bonds/Securitised%20Auto-Loan%20Pool%20-%20Early-Warning%20Indicators/) 📊 | Change-point detection, anomaly detection, SQL |

### Market Risk

| Project | Key methods |
|---|---|
| [A Multi-Asset Market Risk Engine in R: EWMA, GARCH, DCC Correlations, Expected Shortfall, Monte Carlo and Machine-Learning VaR](Market%20Risk/A%20Multi-Asset%20Market%20Risk%20Engine%20in%20R%20-%20EWMA%2C%20GARCH%2C%20DCC%20Correlations%2C%20Expected%20Shortfall%2C%20Monte%20Carlo%20and%20Machine-Learning%20VaR/) 📊 | rugarch GJR-GARCH, hand-written DCC, FHS Monte Carlo, ranger / xgboost quantile VaR, Kupiec, Christoffersen, FZ0 |
| [Bayesian Stochastic Volatility vs GARCH vs LSTM in R: Volatility Forecasts and VaR for Stocks, the Euro and Crude Oil](Market%20Risk/Bayesian%20Stochastic%20Volatility%20vs%20GARCH%20vs%20LSTM%20in%20R%20-%20Volatility%20Forecasts%20and%20VaR%20for%20Stocks%2C%20the%20Euro%20and%20Crude%20Oil/) 📊 | stochvol MCMC, hand-written particle filter, rugarch GJR-GARCH-t, torch LSTM, QLIKE, Diebold–Mariano, FHS VaR |
| [Fixed Income Sensitivities: Duration, Convexity, DV01, KRD + Curve PCA](Market%20Risk/Fixed%20Income%20Sensitivities%20-%20Duration%2C%20Convexity%2C%20DV01%2C%20KRD%20%2B%20Curve%20PCA/) | PCA, scenario P&L |
| [Generative Stress Scenarios (VAE / Conditional GAN)](Market%20Risk/Generative%20Stress%20Scenarios%20%28VAE%20-%20Conditional%20GAN%29/) 📊 | Generative deep learning |
| [Intraday Risk Forecasting for a Trading Desk: Hourly Volatility, Conformal Price Ranges and Honest Direction Forecasts across Ten Assets, HAR and GARCH versus LightGBM, an LSTM and a Transformer](Market%20Risk/Intraday%20Risk%20Forecasting%20for%20a%20Trading%20Desk%20-%20Hourly%20Volatility%2C%20Conformal%20Price%20Ranges%20and%20Honest%20Direction%20Forecasts%20across%20Ten%20Assets%2C%20HAR%20and%20GARCH%20versus%20LightGBM%2C%20an%20LSTM%20and%20a%20Transformer/) 📊 | Hourly returns of ten assets, HAR with intraday seasonality, GARCH(1,1) Student-t, LightGBM gamma regression, LSTM and transformer volatility networks trained on QLIKE, Diebold–Mariano and Mincer–Zarnowitz evaluation, Gaussian vs split conformal vs adaptive conformal price ranges, direction classifiers vs majority benchmark with binomial tests and costs |
| [Local-Currency Risk & Hedging: COP vs MXN, BRL, CLP](Market%20Risk/Local-Currency%20Risk%20%26%20Hedging%20-%20COP%20vs%20MXN%2C%20BRL%2C%20CLP/) 📊 | DCC-GARCH, forecasting, hedge optimisation, cross-currency basis |
| [Market Regime Detection & Regime-Conditional VaR](Market%20Risk/Market%20Regime%20Detection%20%26%20Regime-Conditional%20VaR/) | Hidden Markov models, Gaussian mixtures |
| [Option Greeks via Neural Pricers & Automatic Differentiation](Market%20Risk/Option%20Greeks%20via%20Neural%20Pricers%20%26%20Automatic%20Differentiation/) | Neural networks, PyTorch autograd |
| [Quantile Machine Learning for VaR: QRF, LightGBM Quantile, CAViaR](Market%20Risk/Quantile%20Machine%20Learning%20for%20VaR%20-%20QRF%2C%20LightGBM%20Quantile%2C%20CAViaR/) | Quantile regression & trees |
| [VaR & Expected Shortfall Engine with Full Backtesting](Market%20Risk/VaR%20%26%20Expected%20Shortfall%20Engine%20with%20Full%20Backtesting/) 📊 | Filtered historical simulation, GARCH, Kupiec/Christoffersen |
| [VaR / ES with GARCH and Backtesting (R)](Market%20Risk/VaR%20-%20ES%20with%20GARCH%20and%20Backtesting%20%28R%29/) 📊 | quantmod, rugarch, PerformanceAnalytics |

### Valuation & Portfolio Management

| Project | Key methods |
|---|---|
| [A Worst-of-Five Autocallable: Monte Carlo Pricing, Greeks and a Deep-Learning Surrogate Pricer](Valuation%20%26%20Portfolio%20Management/A%20Worst-of-Five%20Autocallable%20-%20Monte%20Carlo%20Pricing%2C%20Greeks%20and%20a%20Deep-Learning%20Surrogate%20Pricer/) 📊 | Correlated Monte Carlo in PyTorch, smile-implied vols, CRN Greeks, Keras surrogate pricer, scenario VaR |
| [American Options: Longstaff–Schwartz vs Deep Optimal Stopping](Valuation%20%26%20Portfolio%20Management/American%20Options%20-%20Longstaff%E2%80%93Schwartz%20vs%20Deep%20Optimal%20Stopping/) | Regression Monte Carlo, deep learning |
| [Backtesting Trading Strategies with vectorbt: Cointegration Pairs Trading with an ML Filter, ML Sector Rotation and Beta Hedging](Valuation%20%26%20Portfolio%20Management/Backtesting%20Trading%20Strategies%20with%20vectorbt%20-%20Cointegration%20Pairs%20Trading%20with%20an%20ML%20Filter%2C%20ML%20Sector%20Rotation%20and%20Beta%20Hedging/) 📊 | vectorbt portfolios, Engle–Granger pairs, LightGBM trade filter and sector rotation, rolling-OLS and Kalman beta hedges |
| [CAPM, the Security Market Line and Betas in R: Rolling OLS, Kalman Filter, Bayesian Shrinkage and Machine Learning](Valuation%20%26%20Portfolio%20Management/CAPM%2C%20the%20Security%20Market%20Line%20and%20Betas%20in%20R%20-%20Rolling%20OLS%2C%20Kalman%20Filter%2C%20Bayesian%20Shrinkage%20and%20Machine%20Learning/) 📊 | GRS and Fama–MacBeth tests, Kalman-filter betas, Vasicek and Blume shrinkage, ranger and xgboost beta forecasts |
| [Deep Hedging with Transaction Costs](Valuation%20%26%20Portfolio%20Management/Deep%20Hedging%20with%20Transaction%20Costs/) | PyTorch policy networks |
| [Global Sensitivity Analysis of a DCF: Tornado Charts versus Sobol Indices and Shapley Effects for Correlated Inputs, with Ranges from Damodaran's Industry Data and a Gaussian-Process Surrogate](Valuation%20%26%20Portfolio%20Management/Global%20Sensitivity%20Analysis%20of%20a%20DCF%20-%20Tornado%20Charts%20versus%20Sobol%20Indices%20and%20Shapley%20Effects%20for%20Correlated%20Inputs%2C%20with%20Ranges%20from%20Damodaran%27s%20Industry%20Data%20and%20a%20Gaussian-Process%20Surrogate/) 📊 | FCFF DCF, tornado and scenario analysis, Sobol indices (Saltelli/Jansen), Shapley effects with a Gaussian copula, Gaussian-process surrogate, Latin hypercube sampling |
| [ML Factor Models with Purged Cross-Validation](Valuation%20%26%20Portfolio%20Management/ML%20Factor%20Models%20with%20Purged%20Cross-Validation/) | Elastic Net, gradient boosting, neural nets |
| [Monte Carlo Pricing Lab: GBM, Heston, Jumps + Variance Reduction](Valuation%20%26%20Portfolio%20Management/Monte%20Carlo%20Pricing%20Lab%20-%20GBM%2C%20Heston%2C%20Jumps%20%2B%20Variance%20Reduction/) | Antithetics, control variates, Sobol QMC |
| [Portfolio Construction: Mean-Variance, Black–Litterman, HRP, CVaR](Valuation%20%26%20Portfolio%20Management/Portfolio%20Construction%20-%20Mean-Variance%2C%20Black%E2%80%93Litterman%2C%20HRP%2C%20CVaR/) 📊 | Convex optimisation, hierarchical clustering |
| [Reinforcement Learning for Asset Allocation (PPO / SAC)](Valuation%20%26%20Portfolio%20Management/Reinforcement%20Learning%20for%20Asset%20Allocation%20%28PPO%20-%20SAC%29/) 📊 | PPO / SAC |
| [Time-Series Momentum and Trend Following Across 33 Futures Markets: Moskowitz–Ooi–Pedersen Signals versus Machine-Learning Position Sizing, Volatility Targeting and Crisis Alpha, 2001–2026](Valuation%20%26%20Portfolio%20Management/Time-Series%20Momentum%20and%20Trend%20Following%20Across%2033%20Futures%20Markets%20-%20Moskowitz%E2%80%93Ooi%E2%80%93Pedersen%20Signals%20versus%20Machine-Learning%20Position%20Sizing%2C%20Volatility%20Targeting%20and%20Crisis%20Alpha%2C%202001%E2%80%932026/) 📊 | Yahoo continuous front-month futures for 33 markets 2000–2026 with a roll-gap filter, MOP time-series momentum with EWMA volatility scaling at 40% per market, 1/3/6/12-month, blended and continuous signals, portfolio volatility targeting, trend smile regression and crisis episodes, sector contributions, walk-forward ridge, LightGBM and a Sharpe-ratio-loss PyTorch network on return, MACD and volatility features, turnover costs, block-bootstrap Sharpe tests |

### Bank Capital & Stress Testing

| Project | Key methods |
|---|---|
| [Systemic Risk of U.S. Financial Institutions: SRISK, ΔCoVaR and Marginal Expected Shortfall with Linear and Gradient-Boosted Quantile Regression, Granger Networks and Eisenberg–Noe Contagion](Bank%20Capital%20%26%20Stress%20Testing/Systemic%20Risk%20of%20U.S.%20Financial%20Institutions%20-%20SRISK%2C%20%CE%94CoVaR%20and%20Marginal%20Expected%20Shortfall%20with%20Linear%20and%20Gradient-Boosted%20Quantile%20Regression%2C%20Granger%20Networks%20and%20Eisenberg%E2%80%93Noe%20Contagion/) 📊 | Yahoo prices and SEC XBRL balance sheets (point in time by filing date) for 32 U.S. banks, broker-dealers, card lenders and insurers, rolling beta, MES and LRMES, SRISK with k = 8%, ΔCoVaR from linear quantile regression vs LightGBM quantile with FRED state variables and out-of-time pinball loss, pairwise Granger networks on volatility-standardised weekly returns, RAS maximum-entropy and random sparse exposure matrices, Eisenberg–Noe and Rogers–Veraart clearing under idiosyncratic and common shocks, episode rank correlations and ridge, KNN and LightGBM rankings of next-year drawdowns |

### Liquidity Risk & ALM

| Project | Key methods |
|---|---|
| [Bank Failure Prediction (Liquidity & Solvency)](Liquidity%20Risk%20%26%20ALM/Bank%20Failure%20Prediction%20%28Liquidity%20%26%20Solvency%29/) | XGBoost, survival, SHAP |
| [Earnings-at-Risk for Colombian Banks: Loan and Deposit Betas through the 2021–2026 Rate Cycle, Machine-Learning Drivers of Pass-Through, and Monte Carlo Net-Interest-Margin Distributions Backtested against the Hikes and Cuts](Liquidity%20Risk%20%26%20ALM/Earnings-at-Risk%20for%20Colombian%20Banks%20-%20Loan%20and%20Deposit%20Betas%20through%20the%202021%E2%80%932026%20Rate%20Cycle%2C%20Machine-Learning%20Drivers%20of%20Pass-Through%2C%20and%20Monte%20Carlo%20Net-Interest-Margin%20Distributions%20Backtested%20against%20the%20Hikes%20and%20Cuts/) 📊 | Bank-by-bank loan, deposit, savings and new-CDT betas over the 2021–2023 hikes and 2023–2025 cuts, pooled distributed-lag pass-through with and without bank-characteristic interactions vs LightGBM out of time with tree SHAP, empirical-Bayes shrunk betas, momentum mean-reverting policy-rate model with bootstrapped residuals, Monte Carlo twelve-month NIM distributions with non-rate residual bootstrap, earnings-at-risk, backtests with forecast and realised rate paths |
| [Funding Stress Early-Warning System](Liquidity%20Risk%20%26%20ALM/Funding%20Stress%20Early-Warning%20System/) 📊 | Logistic regression, XGBoost, survival horizon |
| [IRRBB: EVE & NII Under Basel Shock Scenarios](Liquidity%20Risk%20%26%20ALM/IRRBB%20-%20EVE%20%26%20NII%20Under%20Basel%20Shock%20Scenarios/) 📊 | Repricing gap, simulation |
| [LCR & NSFR Engine with Stressed Outflows](Liquidity%20Risk%20%26%20ALM/LCR%20%26%20NSFR%20Engine%20with%20Stressed%20Outflows/) | Basel III rules, simulation |
| [Market Liquidity Risk: Amihud, Bid-Ask & LVaR](Liquidity%20Risk%20%26%20ALM/Market%20Liquidity%20Risk%20-%20Amihud%2C%20Bid-Ask%20%26%20LVaR/) | Time series, classification |
| [Non-Maturity Deposit Behaviour Modelling](Liquidity%20Risk%20%26%20ALM/Non-Maturity%20Deposit%20Behaviour%20Modelling/) | GAM, survival decay, LSTM |
| [Treasury Cash Forecasting with N-HiTS / TFT](Liquidity%20Risk%20%26%20ALM/Treasury%20Cash%20Forecasting%20with%20N-HiTS%20-%20TFT/) 📊 | neuralforecast vs ARIMA |

### Yield Curves & Volatility Surfaces

| Project | Key methods |
|---|---|
| [Continuous Forward Curves for SOFR, €STR and EURIBOR: Bootstraps, Nelson–Siegel–Svensson, Splines, Gaussian Processes and Neural Networks](Yield%20Curves%20%26%20Volatility%20Surfaces/Continuous%20Forward%20Curves%20for%20SOFR%2C%20%E2%82%ACSTR%20and%20EURIBOR%20-%20Bootstraps%2C%20Nelson%E2%80%93Siegel%E2%80%93Svensson%2C%20Splines%2C%20Gaussian%20Processes%20and%20Neural%20Networks/) 📊 | QuantLib bootstraps (monotone convex), NSS, penalised splines, Gaussian process, PyTorch NN, leave-one-out and locality tests |
| [Nelson–Siegel–Svensson Treasury Curve (R)](Yield%20Curves%20%26%20Volatility%20Surfaces/Nelson%E2%80%93Siegel%E2%80%93Svensson%20Treasury%20Curve%20%28R%29/) 📊 | fredr, ggplot2 |
| [Parametric vs ML Curve Fitting: Nelson–Siegel–Svensson vs Gaussian Process vs Neural Net](Yield%20Curves%20%26%20Volatility%20Surfaces/Parametric%20vs%20ML%20Curve%20Fitting%20-%20Nelson%E2%80%93Siegel%E2%80%93Svensson%20vs%20Gaussian%20Process%20vs%20Neural%20Net/) | Nelson-Siegel-Svensson, GP, MLP |
| [SOFR Curve Built from Public Swap Trade Reports (DTCC)](Yield%20Curves%20%26%20Volatility%20Surfaces/SOFR%20Curve%20Built%20from%20Public%20Swap%20Trade%20Reports%20%28DTCC%29/) 📊 | Trade-data ETL, robust regression, bootstrapping, SQL |
| [SOFR Curve Calibrated from SOFR, Futures & Treasuries](Yield%20Curves%20%26%20Volatility%20Surfaces/SOFR%20Curve%20Calibrated%20from%20SOFR%2C%20Futures%20%26%20Treasuries/) 📊 | QuantLib bootstrapping, interpolation comparison |
| [Volatility Surface Construction: SVI / SSVI + Neural Smoothing](Yield%20Curves%20%26%20Volatility%20Surfaces/Volatility%20Surface%20Construction%20-%20SVI%20-%20SSVI%20%2B%20Neural%20Smoothing/) | Calibration, arbitrage-free networks |
| [Yield Curve Forecasting: Dynamic Nelson–Siegel + Kalman Filter vs Transformer](Yield%20Curves%20%26%20Volatility%20Surfaces/Yield%20Curve%20Forecasting%20-%20Dynamic%20Nelson%E2%80%93Siegel%20%2B%20Kalman%20Filter%20vs%20Transformer/) | State-space models, deep learning |

### Fixed Income & Hedging

| Project | Key methods |
|---|---|
| [A Bond Portfolio in QuantLib: DV01, PV01, CS01, Key-Rate Risk and Mark-to-Market, with an ML Surrogate for Scenario Revaluation](Fixed%20Income%20%26%20Hedging/A%20Bond%20Portfolio%20in%20QuantLib%20-%20DV01%2C%20PV01%2C%20CS01%2C%20Key-Rate%20Risk%20and%20Mark-to-Market%2C%20with%20an%20ML%20Surrogate%20for%20Scenario%20Revaluation/) 📊 | QuantLib bond pricing, DV01 / CS01 / key-rate risk, historical-scenario VaR/ES, LightGBM and Keras revaluation surrogates |
| [Asset Swap Spreads (Par-Par, Proceeds, Z-Spread) vs Benchmark](Fixed%20Income%20%26%20Hedging/Asset%20Swap%20Spreads%20%28Par-Par%2C%20Proceeds%2C%20Z-Spread%29%20vs%20Benchmark/) 📊 | Bond & swap valuation, regression |
| [Callable vs Puttable Bonds: Tree and Monte Carlo Valuation, ML Call Probabilities and Portfolio Optimisation](Fixed%20Income%20%26%20Hedging/Callable%20vs%20Puttable%20Bonds%20-%20Tree%20and%20Monte%20Carlo%20Valuation%2C%20ML%20Call%20Probabilities%20and%20Portfolio%20Optimisation/) | QuantLib trees, LSM Monte Carlo, MLP surrogate, linear programming |
| [Duration and Convexity of a Multi-Currency Treasury Portfolio Hedged with SOFR Swaps: Macaulay, Modified, Fisher–Weil, Key-Rate, Term-Bucket and Floating-Rate Durations, with a Machine-Learning Revaluation Surrogate](Fixed%20Income%20%26%20Hedging/Duration%20and%20Convexity%20of%20a%20Multi-Currency%20Treasury%20Portfolio%20Hedged%20with%20SOFR%20Swaps%20-%20Macaulay%2C%20Modified%2C%20Fisher%E2%80%93Weil%2C%20Key-Rate%2C%20Term-Bucket%20and%20Floating-Rate%20Durations%2C%20with%20a%20Machine-Learning%20Revaluation%20Surrogate/) 📊 | Macaulay, modified, Fisher–Weil, key-rate, term-bucket, spread and FRN durations, OIS bootstrap in 8 currencies, NNLS swap hedge, LightGBM and Keras revaluation |
| [SOFR Swap Spreads: Fair Value, Relative-Value Trading and Hedging with Machine Learning](Fixed%20Income%20%26%20Hedging/SOFR%20Swap%20Spreads%20-%20Fair%20Value%2C%20Relative-Value%20Trading%20and%20Hedging%20with%20Machine%20Learning/) 📊 | DTCC swap trades, ridge / LightGBM fair value, walk-forward RV backtest, Kalman and ML hedge ratios |
| [Spread Duration & CS01 by Asset Class](Fixed%20Income%20%26%20Hedging/Spread%20Duration%20%26%20CS01%20by%20Asset%20Class/) 📊 | Regression, scenario analysis |

### AI, Model Risk & Validation

| Project | Key methods |
|---|---|
| [AI Risk Reporting: FinBERT Sentiment + LLM Risk Memo](AI%2C%20Model%20Risk%20%26%20Validation/AI%20Risk%20Reporting%20-%20FinBERT%20Sentiment%20%2B%20LLM%20Risk%20Memo/) 📊 | NLP, LLM summarisation |
| [News Sentiment for Stocks and Credit: FinBERT vs an Open LLM vs a Finance Word List, and What Headlines Say About Next-Day Returns and Spreads](AI%2C%20Model%20Risk%20%26%20Validation/News%20Sentiment%20for%20Stocks%20and%20Credit%20-%20FinBERT%20vs%20an%20Open%20LLM%20vs%20a%20Finance%20Word%20List%2C%20and%20What%20Headlines%20Say%20About%20Next-Day%20Returns%20and%20Spreads/) 📊 | FinBERT vs Qwen2.5 vs word list on FNSPID/8-K/NYT/Guardian headlines, clustered panel regressions, credit lead–lag |

### Fintech & Digital Assets

| Project | Key methods |
|---|---|
| [Peer-to-Peer Lending: Profit Scoring vs Default Scoring on Matured LendingClub Loans, Out-of-Time Portfolio Selection, and Reject Inference with 27 Million Rejected Applications](Fintech%20%26%20Digital%20Assets/Peer-to-Peer%20Lending%20-%20Profit%20Scoring%20vs%20Default%20Scoring%20on%20Matured%20LendingClub%20Loans%2C%20Out-of-Time%20Portfolio%20Selection%2C%20and%20Reject%20Inference%20with%2027%20Million%20Rejected%20Applications/) 📊 | LendingClub profit vs default scoring, LightGBM / Keras MLP, out-of-time portfolio back-test, reject inference |

---

## Data sources

All data is public and free. Every notebook downloads what it needs from the original source and caches it locally in its own `data/` folder, which is never committed.

| Source | Used for | Access |
|---|---|---|
| [FRED](https://fred.stlouisfed.org/) | SOFR, Treasury yields, credit spreads, exchange rates, macro series, Census retail sales and manufacturers' shipments, industrial production | Free API key |
| [U.S. Treasury](https://home.treasury.gov/resource-center/data-chart-center/interest-rates), [Fiscal Data](https://fiscaldata.treasury.gov/) | Daily par yield curves; auction results for bills, notes and bonds | Open |
| [Yahoo Finance](https://finance.yahoo.com/) via `yfinance` | ETFs, indices, FX, futures, option chains | Open (unofficial API) |
| [iShares](https://www.ishares.com/) fund holdings | Real bond-level portfolios; S&P 500 index members | Open |
| [DTCC Public Price Dissemination](https://pddata.dtcc.com/ppd/cftcdashboard) | Reported swap trades: SOFR, €STR, SONIA and TONA OIS and cross-currency basis swaps | Open |
| [SEC EDGAR](https://www.sec.gov/edgar) | XBRL financials and frames, Financial Statement Data Sets (business segments), debt maturity schedules, going-private filings (Schedule 13E-3), tender offers (Schedule TO-T), IPO prospectuses (S-1, 424B4), accounting enforcement releases, ISDA exhibits, ABS-EE loan tapes, 10-K text, Form 8-K earnings dates, Form 13F holdings, mutual fund and ETF tickers | Open (name + email header) |
| [SEC Insider Transactions Data Sets](https://www.sec.gov/data-research/sec-markets-data/insider-transactions-data-sets) | Form 3, 4 and 5 trades by officers, directors and 10% owners | Open |
| [SEC Fails-to-Deliver data](https://www.sec.gov/data-research/sec-markets-data/fails-deliver-data) | Settlement fails in U.S. equities since 2004 | Open |
| [Kaggle](https://www.kaggle.com/) | Credit default, LGD, ratings, churn, fraud, AML and P2P-lending datasets; Dunnhumby grocery transactions; Crunchbase start-up funding rounds | Free account + token |
| [CalPERS private equity program fund performance](https://www.calpers.ca.gov/investments/about-investment-office/investment-organization/pep-fund-performance-print) | Commitments, cash flows, net IRRs and multiples of about 480 private equity funds | Open |
| [Federal Reserve Survey of Consumer Finances](https://www.federalreserve.gov/econres/scfindex.htm) | Household finances, portfolios and stated risk tolerance (2019 and 2022) | Open |
| [ECB Data Portal](https://data.ecb.europa.eu/) | Euro AAA yield curve, government yields, policy rates, CISS | Open |
| [Covered Bond Label HTT database](https://www.coveredbondlabel.com/htt-database) | Harmonised Transparency Templates of covered bond programmes | Open |
| [Macrohistory Database (Jordà–Schularick–Taylor)](https://www.macrohistory.net/database/) | 150 years of macro-financial data and banking crises | Open |
| [Federal Reserve Board GSW yield curve](https://www.federalreserve.gov/data/nominal-yield-curve.htm) | Zero-coupon Treasury yields since the 1960s | Open |
| [New York Times Archive API](https://developer.nytimes.com/docs/archive-product/1/overview) | Every NYT article since 2005 (headlines, abstracts, location, subject and organization tags) for news-based models | Free API key |
| [The Guardian Open Platform](https://open-platform.theguardian.com/) | Company and country news headlines | Free API key |
| [Kenneth French data library](https://mba.tuck.dartmouth.edu/pages/faculty/ken.french/data_library.html) | Fama–French factors, momentum and portfolios sorted on size, variance and dividend yield | Open |
| [Open Source Asset Pricing](https://www.openassetpricing.com/) | Long–short returns of 212 published stock-return predictors and 114 placebos (Chen and Zimmermann) | Open |
| [Jeffrey Wurgler's sentiment data](https://pages.stern.nyu.edu/~jwurgler/), [FINRA margin statistics](https://www.finra.org/rules-guidance/key-topics/margin-accounts/margin-statistics) | Baker–Wurgler investor sentiment index; margin debt | Open |
| [Hugging Face](https://huggingface.co/) | FNSPID financial-news dataset; open models (FinBERT, Fed-stance RoBERTa, Qwen2.5, BGE, all-MiniLM, Chronos, TabICL) | Open |
| [IMF DataMapper](https://www.imf.org/external/datamapper) | World Economic Outlook government debt, fiscal balances and inflation forecasts | Open |
| [UCI Machine Learning Repository](https://archive.ics.uci.edu/) | Credit-card default and other benchmark datasets | Open |
| [Freddie Mac Single-Family Loan-Level Dataset](https://www.freddiemac.com/research/datasets/sf-loanlevel-dataset), [Fannie Mae Single-Family Loan Performance Data](https://capitalmarkets.fanniemae.com/credit-risk-transfer/single-family-credit-risk-transfer/fannie-mae-single-family-loan-performance-data) | Mortgage originations and monthly loan performance (defaults, prepayments, losses) | Free registration, manual download |
| [CFTC Public Reporting (Commitments of Traders)](https://publicreporting.cftc.gov/) | Speculator and hedger positioning in currency, commodity, rate and equity-index futures | Open |
| [Deutsche Bundesbank](https://www.bundesbank.de/en/statistics) | Daily reference prices of Federal securities (green and twin Bunds), Pfandbrief and Federal yields | Open |
| [Federal Reserve stress-test scenarios](https://www.federalreserve.gov/supervisionreg/dfa-stress-tests-2026.htm) | Supervisory baseline and severely adverse paths | Open |
| [EPA Greenhouse Gas Reporting Program](https://www.epa.gov/ghgreporting/data-sets) | Facility emissions and parent companies | Open |
| [NASA POWER](https://power.larc.nasa.gov/) | Satellite irradiance and temperature for any location since 1984 | Open |
| [EuroSAT](https://zenodo.org/records/7711810), [Global Forest Change](https://glad.earthengine.app/view/global-forest-change) | Labelled Sentinel-2 land-cover images; Landsat composites and annual forest-loss maps | Open |
| [Ministry of Finance Japan](https://www.mof.go.jp/english/policy/jgbs/reference/interest_rate/), [Sveriges Riksbank](https://www.riksbank.se/en-gb/statistics/) | JGB and Swedish government bond yields | Open |
| [Binance public data](https://data.binance.vision/) | Top-of-book quotes and trades of crypto perpetual futures | Open |
| [datos.gov.co (Superintendencia Financiera de Colombia)](https://www.datos.gov.co/) | Colombian banks' supervisory accounts, deposit and money-market rates | Open |
| [Banco de la República statistics portal and SDMX service](https://suameca.banrep.gov.co/estadisticas-economicas/), [Bank of England yield curves](https://www.bankofengland.co.uk/statistics/yield-curves) | Colombian policy rate, IBR, UVR, TRM and TES zero-coupon rates; UK gilt and SONIA curves | Open |
| [CFPB](https://www.consumerfinance.gov/enforcement/actions/) | Enforcement actions and the Consumer Complaint Database | Open |
| [HHS Office for Civil Rights breach portal](https://ocrportal.hhs.gov/ocr/breach/) | Health-data breaches affecting 500 or more people since 2009 | Open |
| [Damodaran Online](https://pages.stern.nyu.edu/~adamodar/) | Country risk premiums, implied equity risk premium, synthetic-rating spreads, marginal tax rates, industry costs of capital, margins and growth | Open |
| [GEMs Consortium](https://www.gemsriskdatabase.org/) | Default and recovery statistics of development lenders' private and public borrowers in emerging markets (published reports) | Open |
| [World Bank](https://data.worldbank.org/), [FDIC](https://api.fdic.gov/banks/docs/), [OFR](https://www.financialresearch.gov/), [Ken French](https://mba.tuck.dartmouth.edu/pages/faculty/ken.french/data_library.html) | Macro, balance-of-payments, exchange-rate and PPP data, governance, World Bank projects and their environmental categories, private participation in infrastructure, bank, stress-index and factor data | Open |

Where a dataset cannot be redistributed (Freddie Mac, Fannie Mae, Kaggle competitions), the notebooks show only aggregated results, never raw records.

A few datasets need a free registration and a manual download: the Freddie Mac and Fannie Mae loan files and the Home Credit data (Kaggle). They go once into `data/` at the repository root (`data/freddie_mac/`, `data/fannie_mae/`, `data/home_credit/`) and are found from any project folder; each project's README says which ones it needs.

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
