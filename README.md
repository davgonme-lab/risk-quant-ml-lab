# risk-quant-ml-lab

**end-to-end projects applying machine learning and deep learning to credit, counterparty, market and liquidity risk, fraud, insurance and fintech.**

![Python](https://img.shields.io/badge/Python-3.12-blue) ![R](https://img.shields.io/badge/R-4.x-276DC3) ![License: MIT](https://img.shields.io/badge/License-MIT-green)

---

**What would a risk desk build if it had a modern ML toolkit?** This repository answers that question with a growing set of self-contained projects. Each one starts from a real risk problem: measuring the potential future exposure of a swap book, hedging a multilateral bank's bond portfolio with SOFR swaps, stress-testing a mortgage pool, or forecasting when a funding market is about to crack. It then solves the problem end to end, with public data, transparent models and a dashboard a risk committee could read. Classic models (Hull-White, Vasicek, GARCH, Nelson-Siegel) sit side by side with gradient boosting, survival analysis, transformers, GNNs and reinforcement learning, so you can see exactly where ML adds value and where it doesn't.

---

## How every project is built

Projects are grouped in thematic folders. Each project lives in its own folder and is **fully self-contained**: one notebook, one README and an `outputs/` folder with the charts and dashboards it produces. No project imports code from, or refers to, another one. Clone the repo, open any notebook, run it top to bottom.

Every notebook follows the same path:

1. **Summary.** Why the problem matters, what the notebook does, the data, the methods and the key output.
2. **Business context.** Why a risk team cares.
3. **Theory.** The intuition first, then the math that matters.
4. **Data & ETL.** Downloaded live from the original source, with exact links.
5. **Exploratory analysis**
6. **Modelling**
7. **Validation & backtesting**
8. **Results dashboard & risk interpretation.** What the numbers mean for a decision.
9. **Limitations & extensions**
10. **References.** Six to ten sources in APA style with a DOI or link, split into finance and regulation, and machine learning and deep learning.

**Market focus.** US markets: SOFR, Treasuries, US ETFs and indices. Several projects use a multilateral-development-bank-style treasury portfolio built from real bond holdings of sovereigns, supranationals and agencies, sub-sovereigns, banks and corporates, hedged with SOFR swaps. Local-currency risk is covered with COP, MXN, BRL and CLP.

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
| [Climate Transition Risk in a Corporate Bond Portfolio: NGFS Phase 5 Scenarios, Reported Emissions and an ML Spread-to-PD Model](Credit%20Risk%20%26%20Customer%20Analytics/Climate%20Transition%20Risk%20in%20a%20Corporate%20Bond%20Portfolio%20-%20NGFS%20Phase%205%20Scenarios%2C%20Reported%20Emissions%20and%20an%20ML%20Spread-to-PD%20Model/) 📊 | NGFS Phase 5 API, EPA GHGRP emissions, SEC XBRL, monotonic LightGBM spread-to-PD, credit VaR |
| [Concentration Risk in an Emerging-Market Corporate Portfolio: Multi-Factor Capital, Granularity and ML-Detected Stress Regimes](Credit%20Risk%20%26%20Customer%20Analytics/Concentration%20Risk%20in%20an%20Emerging-Market%20Corporate%20Portfolio%20-%20Multi-Factor%20Capital%2C%20Granularity%20and%20ML-Detected%20Stress%20Regimes/) | Multi-factor Monte Carlo, granularity adjustment, Gaussian-mixture regimes, Euler allocation |
| [Corporate Bankruptcy Prediction in R: Altman's Z-Score vs Logit, Elastic Net, Random Forests and XGBoost](Credit%20Risk%20%26%20Customer%20Analytics/Corporate%20Bankruptcy%20Prediction%20in%20R%20-%20Altman%27s%20Z-Score%20vs%20Logit%2C%20Elastic%20Net%2C%20Random%20Forests%20and%20XGBoost/) | Altman Z′, logit, glmnet, ranger, xgboost, DeLong tests |
| [Corporate Rating Prediction & Migration Matrices](Credit%20Risk%20%26%20Customer%20Analytics/Corporate%20Rating%20Prediction%20%26%20Migration%20Matrices/) | Ordinal logit, SVM, Markov chains |
| [Credit Card Customer Attrition (Churn)](Credit%20Risk%20%26%20Customer%20Analytics/Credit%20Card%20Customer%20Attrition%20%28Churn%29/) 📊 | Gradient boosting, cost-sensitive learning, SHAP |
| [Credit Curve Construction & Spread Validation](Credit%20Risk%20%26%20Customer%20Analytics/Credit%20Curve%20Construction%20%26%20Spread%20Validation/) | Hazard-rate bootstrapping, Gaussian processes |
| [Early Warning of Systemic Banking Crises: 150 Years of Macro-Financial History, Machine Learning and Shapley Values](Credit%20Risk%20%26%20Customer%20Analytics/Early%20Warning%20of%20Systemic%20Banking%20Crises%20-%20150%20Years%20of%20Macro-Financial%20History%2C%20Machine%20Learning%20and%20Shapley%20Values/) 📊 | JST macrohistory, random forest / extra trees / LightGBM / SVM / Keras MLP, recursive OOS, SHAP, usefulness |
| [Estimating an Issuer's CDS, OAS and Market-Implied Rating Gap (Oracle)](Credit%20Risk%20%26%20Customer%20Analytics/Estimating%20an%20Issuer%27s%20CDS%2C%20OAS%20and%20Market-Implied%20Rating%20Gap%20%28Oracle%29/) | Hazard-curve fitting, CreditGrades, monotone LightGBM, market-implied ratings |
| [Fair Lending Analytics with HMDA: Mortgage Denial and Pricing Disparities, a Machine-Learning Underwriting Model, Proxy Discrimination and the Search for a Less Discriminatory Alternative](Credit%20Risk%20%26%20Customer%20Analytics/Fair%20Lending%20Analytics%20with%20HMDA%20-%20Mortgage%20Denial%20and%20Pricing%20Disparities%2C%20a%20Machine-Learning%20Underwriting%20Model%2C%20Proxy%20Discrimination%20and%20the%20Search%20for%20a%20Less%20Discriminatory%20Alternative/) 📊 | HMDA adverse impact ratios, logit with lender fixed effects, LightGBM underwriting, proxy AUC, LDA search, lender screening |
| [Flood Risk in a Mortgage Portfolio: FEMA Flood Claims, Freddie Mac Loan Performance and an ML Physical-Risk Stress Test](Credit%20Risk%20%26%20Customer%20Analytics/Flood%20Risk%20in%20a%20Mortgage%20Portfolio%20-%20FEMA%20Flood%20Claims%2C%20Freddie%20Mac%20Loan%20Performance%20and%20an%20ML%20Physical-Risk%20Stress%20Test/) 📊 | OpenFEMA NFIP claims, Freddie Mac loans, DiD event study, monotonic LightGBM, SHAP, flood-year replay stress test |
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
| [Delinquency Roll-Rate Forecasting with Sequence Models](Securitization%20%26%20Covered%20Bonds/Delinquency%20Roll-Rate%20Forecasting%20with%20Sequence%20Models/) | LSTM / Transformer vs Markov roll rates; 2008–10 crisis regime test |
| [European Covered Bond Spreads: Drivers and Forecasts with Machine Learning](Securitization%20%26%20Covered%20Bonds/European%20Covered%20Bond%20Spreads%20-%20Drivers%20and%20Forecasts%20with%20Machine%20Learning/) | Z-spreads over the ECB AAA curve, LightGBM with issuer-grouped CV, SHAP, conformal quantile bands |
| [Mortgage Prepayment (CPR) & Default (CDR) Competing Risks](Securitization%20%26%20Covered%20Bonds/Mortgage%20Prepayment%20%28CPR%29%20%26%20Default%20%28CDR%29%20Competing%20Risks/) | Competing-risks survival, LightGBM, GLM; crisis vs recent S-curves (Fannie Mae 2005–08, Freddie Mac 2018–23) |
| [Securitised Auto-Loan Pool: Early-Warning Indicators](Securitization%20%26%20Covered%20Bonds/Securitised%20Auto-Loan%20Pool%20-%20Early-Warning%20Indicators/) 📊 | Change-point detection, anomaly detection, SQL |

### Market Risk

| Project | Key methods |
|---|---|
| [A Multi-Asset Market Risk Engine in R: EWMA, GARCH, DCC Correlations, Expected Shortfall, Monte Carlo and Machine-Learning VaR](Market%20Risk/A%20Multi-Asset%20Market%20Risk%20Engine%20in%20R%20-%20EWMA%2C%20GARCH%2C%20DCC%20Correlations%2C%20Expected%20Shortfall%2C%20Monte%20Carlo%20and%20Machine-Learning%20VaR/) 📊 | rugarch GJR-GARCH, hand-written DCC, FHS Monte Carlo, ranger / xgboost quantile VaR, Kupiec, Christoffersen, FZ0 |
| [A Real-Time Market Monitor in Streamlit: Intraday Volatility and Direction Forecasts with LightGBM and an LSTM](Market%20Risk/A%20Real-Time%20Market%20Monitor%20in%20Streamlit%20-%20Intraday%20Volatility%20and%20Direction%20Forecasts%20with%20LightGBM%20and%20an%20LSTM/) 📊 | Hourly-bar features, HAR, LightGBM point / quantile / direction models, Keras LSTM, Streamlit app with headless tests |
| [Bayesian Stochastic Volatility vs GARCH vs LSTM in R: Volatility Forecasts and VaR for Stocks, the Euro and Crude Oil](Market%20Risk/Bayesian%20Stochastic%20Volatility%20vs%20GARCH%20vs%20LSTM%20in%20R%20-%20Volatility%20Forecasts%20and%20VaR%20for%20Stocks%2C%20the%20Euro%20and%20Crude%20Oil/) 📊 | stochvol MCMC, hand-written particle filter, rugarch GJR-GARCH-t, torch LSTM, QLIKE, Diebold–Mariano, FHS VaR |
| [Fixed Income Sensitivities: Duration, Convexity, DV01, KRD + Curve PCA](Market%20Risk/Fixed%20Income%20Sensitivities%20-%20Duration%2C%20Convexity%2C%20DV01%2C%20KRD%20%2B%20Curve%20PCA/) | PCA, scenario P&L |
| [Generative Stress Scenarios (VAE / Conditional GAN)](Market%20Risk/Generative%20Stress%20Scenarios%20%28VAE%20-%20Conditional%20GAN%29/) 📊 | Generative deep learning |
| [Local-Currency Risk & Hedging: COP vs MXN, BRL, CLP](Market%20Risk/Local-Currency%20Risk%20%26%20Hedging%20-%20COP%20vs%20MXN%2C%20BRL%2C%20CLP/) 📊 | DCC-GARCH, forecasting, hedge optimisation, cross-currency basis |
| [Market Regime Detection & Regime-Conditional VaR](Market%20Risk/Market%20Regime%20Detection%20%26%20Regime-Conditional%20VaR/) | Hidden Markov models, Gaussian mixtures |
| [Oil and Gold: Futures Curves, Convenience Yields and Deep-Learning Price Forecasts with Temporal Fusion Transformers and LSTMs](Market%20Risk/Oil%20and%20Gold%20-%20Futures%20Curves%2C%20Convenience%20Yields%20and%20Deep-Learning%20Price%20Forecasts%20with%20Temporal%20Fusion%20Transformers%20and%20LSTMs/) 📊 | Futures-implied convenience yields and lease rates, AutoARIMA, Keras LSTM, Temporal Fusion Transformer, Diebold–Mariano |
| [Option Greeks via Neural Pricers & Automatic Differentiation](Market%20Risk/Option%20Greeks%20via%20Neural%20Pricers%20%26%20Automatic%20Differentiation/) | Neural networks, PyTorch autograd |
| [Quantile Machine Learning for VaR: QRF, LightGBM Quantile, CAViaR](Market%20Risk/Quantile%20Machine%20Learning%20for%20VaR%20-%20QRF%2C%20LightGBM%20Quantile%2C%20CAViaR/) | Quantile regression & trees |
| [VaR & Expected Shortfall Engine with Full Backtesting](Market%20Risk/VaR%20%26%20Expected%20Shortfall%20Engine%20with%20Full%20Backtesting/) 📊 | Filtered historical simulation, GARCH, Kupiec/Christoffersen |
| [VaR / ES with GARCH and Backtesting (R)](Market%20Risk/VaR%20-%20ES%20with%20GARCH%20and%20Backtesting%20%28R%29/) 📊 | quantmod, rugarch, PerformanceAnalytics |
| [Volatility Forecasting: GARCH vs HAR vs LSTM vs Transformer](Market%20Risk/Volatility%20Forecasting%20-%20GARCH%20vs%20HAR%20vs%20LSTM%20vs%20Transformer/) | Econometrics vs deep learning |
| [What Drives Colombia's TRM? PCA, Regularised Regressions and ML Forecasts (R)](Market%20Risk/What%20Drives%20Colombia%27s%20TRM%20-%20PCA%2C%20Regularised%20Regressions%20and%20ML%20Forecasts%20%28R%29/) | PCA, glmnet, ranger, xgboost, cointegration (urca), Diebold–Mariano |

### Valuation & Portfolio Management

| Project | Key methods |
|---|---|
| [A Horse Race for Stock Return Prediction: OLS, Random Forests, SVMs, CNNs, LSTMs and Transformers on the Same Data](Valuation%20%26%20Portfolio%20Management/A%20Horse%20Race%20for%20Stock%20Return%20Prediction%20-%20OLS%2C%20Random%20Forests%2C%20SVMs%2C%20CNNs%2C%20LSTMs%20and%20Transformers%20on%20the%20Same%20Data/) 📊 | OLS, random forest, RBF SVR, Keras Conv1D / LSTM / Transformer, rank IC with Newey–West, quintile long–short with costs |
| [A Machine-Learning-Enhanced DCF: Forecasting Growth and Margins from SEC Filings, Monte Carlo Valuation and a Test Against Market Prices](Valuation%20%26%20Portfolio%20Management/A%20Machine-Learning-Enhanced%20DCF%20-%20Forecasting%20Growth%20and%20Margins%20from%20SEC%20Filings%2C%20Monte%20Carlo%20Valuation%20and%20a%20Test%20Against%20Market%20Prices/) 📊 | SEC XBRL fundamentals, LightGBM quantile and Keras growth / margin forecasts, Blume betas, Monte Carlo DCF, rank IC |
| [A Worst-of-Five Autocallable: Monte Carlo Pricing, Greeks and a Deep-Learning Surrogate Pricer](Valuation%20%26%20Portfolio%20Management/A%20Worst-of-Five%20Autocallable%20-%20Monte%20Carlo%20Pricing%2C%20Greeks%20and%20a%20Deep-Learning%20Surrogate%20Pricer/) 📊 | Correlated Monte Carlo in PyTorch, smile-implied vols, CRN Greeks, Keras surrogate pricer, scenario VaR |
| [American Options: Longstaff–Schwartz vs Deep Optimal Stopping](Valuation%20%26%20Portfolio%20Management/American%20Options%20-%20Longstaff%E2%80%93Schwartz%20vs%20Deep%20Optimal%20Stopping/) | Regression Monte Carlo, deep learning |
| [Automated Valuation Models for Housing: Gradient Boosting and a Neural Network on Twelve Years of King County Sales, a Real-Time Price Index, IAAO Ratio Standards and Conformal Value Ranges](Valuation%20%26%20Portfolio%20Management/Automated%20Valuation%20Models%20for%20Housing%20-%20Gradient%20Boosting%20and%20a%20Neural%20Network%20on%20Twelve%20Years%20of%20King%20County%20Sales%2C%20a%20Real-Time%20Price%20Index%2C%20IAAO%20Ratio%20Standards%20and%20Conformal%20Value%20Ranges/) 📊 | Repeat-sales index, OLS vs LightGBM vs embedding MLP, IAAO ratio study (COD, PRD), Mondrian conformal value ranges |
| [Backtesting Trading Strategies with vectorbt: Cointegration Pairs Trading with an ML Filter, ML Sector Rotation and Beta Hedging](Valuation%20%26%20Portfolio%20Management/Backtesting%20Trading%20Strategies%20with%20vectorbt%20-%20Cointegration%20Pairs%20Trading%20with%20an%20ML%20Filter%2C%20ML%20Sector%20Rotation%20and%20Beta%20Hedging/) 📊 | vectorbt portfolios, Engle–Granger pairs, LightGBM trade filter and sector rotation, rolling-OLS and Kalman beta hedges |
| [CAPM, the Security Market Line and Betas in R: Rolling OLS, Kalman Filter, Bayesian Shrinkage and Machine Learning](Valuation%20%26%20Portfolio%20Management/CAPM%2C%20the%20Security%20Market%20Line%20and%20Betas%20in%20R%20-%20Rolling%20OLS%2C%20Kalman%20Filter%2C%20Bayesian%20Shrinkage%20and%20Machine%20Learning/) 📊 | GRS and Fama–MacBeth tests, Kalman-filter betas, Vasicek and Blume shrinkage, ranger and xgboost beta forecasts |
| [DaveTrend-X: a Long–Short Strategy Combining Machine-Learning Technical Signals with Language-Model News Sentiment, Backtested with vectorbt at Any Rebalancing Frequency](Valuation%20%26%20Portfolio%20Management/DaveTrend-X%20-%20a%20Long%E2%80%93Short%20Strategy%20Combining%20Machine-Learning%20Technical%20Signals%20with%20Language-Model%20News%20Sentiment%2C%20Backtested%20with%20vectorbt%20at%20Any%20Rebalancing%20Frequency/) 📊 | Walk-forward LightGBM / Keras MLP technical signals, FinBERT news score, vectorbt long–short at eight frequencies |
| [Deep Hedging with Transaction Costs](Valuation%20%26%20Portfolio%20Management/Deep%20Hedging%20with%20Transaction%20Costs/) | PyTorch policy networks |
| [Equity Options with Black–Scholes and Machine Learning: Portfolio Greeks, Learned Volatility Smiles and SVM Liquidity Classification](Valuation%20%26%20Portfolio%20Management/Equity%20Options%20with%20Black%E2%80%93Scholes%20and%20Machine%20Learning%20-%20Portfolio%20Greeks%2C%20Learned%20Volatility%20Smiles%20and%20SVM%20Liquidity%20Classification/) 📊 | Black-76 on parity forwards, book Greeks and scenario grid, LightGBM / Keras smile models, RBF SVM classifier |
| [ETF Portfolios with Machine-Learning Expected Returns: PyPortfolioOpt, the Efficient Frontier and Black–Litterman with ML Views](Valuation%20%26%20Portfolio%20Management/ETF%20Portfolios%20with%20Machine-Learning%20Expected%20Returns%20-%20PyPortfolioOpt%2C%20the%20Efficient%20Frontier%20and%20Black%E2%80%93Litterman%20with%20ML%20Views/) 📊 | PyPortfolioOpt mean–variance and efficient frontier, LightGBM / Keras expected returns, Black–Litterman with ML views |
| [Forecasting Dividends from SEC Filings: Lintner's Model, Logistic Regression, Gradient Boosting and Neural Networks for Growth and Cuts](Valuation%20%26%20Portfolio%20Management/Forecasting%20Dividends%20from%20SEC%20Filings%20-%20Lintner%27s%20Model%2C%20Logistic%20Regression%2C%20Gradient%20Boosting%20and%20Neural%20Networks%20for%20Growth%20and%20Cuts/) 📊 | SEC XBRL dividends, Lintner partial adjustment, logit, LightGBM, Keras MLP, cut-probability calibration |
| [Fundamental Valuation from SEC XBRL Financials](Valuation%20%26%20Portfolio%20Management/Fundamental%20Valuation%20from%20SEC%20XBRL%20Financials/) 📊 | ETL, regression, SQL |
| [ML Factor Models with Purged Cross-Validation](Valuation%20%26%20Portfolio%20Management/ML%20Factor%20Models%20with%20Purged%20Cross-Validation/) | Elastic Net, gradient boosting, neural nets |
| [Monte Carlo Pricing Lab: GBM, Heston, Jumps + Variance Reduction](Valuation%20%26%20Portfolio%20Management/Monte%20Carlo%20Pricing%20Lab%20-%20GBM%2C%20Heston%2C%20Jumps%20%2B%20Variance%20Reduction/) | Antithetics, control variates, Sobol QMC |
| [Portfolio Construction: Mean-Variance, Black–Litterman, HRP, CVaR](Valuation%20%26%20Portfolio%20Management/Portfolio%20Construction%20-%20Mean-Variance%2C%20Black%E2%80%93Litterman%2C%20HRP%2C%20CVaR/) 📊 | Convex optimisation, hierarchical clustering |
| [Real Options in an Oil Field Development: When to Invest and When to Abandon, with Trees, Least-Squares Monte Carlo and Deep Learning](Valuation%20%26%20Portfolio%20Management/Real%20Options%20in%20an%20Oil%20Field%20Development%20-%20When%20to%20Invest%20and%20When%20to%20Abandon%2C%20with%20Trees%2C%20Least-Squares%20Monte%20Carlo%20and%20Deep%20Learning/) 📊 | OU calibration to WTI futures, trinomial tree, Longstaff–Schwartz, neural LSM, deep optimal stopping, Schwartz–Smith |
| [Reinforcement Learning for Asset Allocation (PPO / SAC)](Valuation%20%26%20Portfolio%20Management/Reinforcement%20Learning%20for%20Asset%20Allocation%20%28PPO%20-%20SAC%29/) 📊 | PPO / SAC |

### Liquidity Risk & ALM

| Project | Key methods |
|---|---|
| [Bank Failure Prediction (Liquidity & Solvency)](Liquidity%20Risk%20%26%20ALM/Bank%20Failure%20Prediction%20%28Liquidity%20%26%20Solvency%29/) | XGBoost, survival, SHAP |
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
| [Hedge Effectiveness Testing (Dollar-Offset & Regression)](Fixed%20Income%20%26%20Hedging/Hedge%20Effectiveness%20Testing%20%28Dollar-Offset%20%26%20Regression%29/) | Regression, simulation |
| [Matrix Pricing of Illiquid High-Yield Bonds with Machine Learning: Issuer Curves, Sector Grids, Gradient Boosting and Conformal Price Ranges](Fixed%20Income%20%26%20Hedging/Matrix%20Pricing%20of%20Illiquid%20High-Yield%20Bonds%20with%20Machine%20Learning%20-%20Issuer%20Curves%2C%20Sector%20Grids%2C%20Gradient%20Boosting%20and%20Conformal%20Price%20Ranges/) 📊 | Issuer curves, sector × maturity grids, KNN, LightGBM, Keras MLP, adaptive split conformal ranges |
| [PCA-Based Hedging of an MDB Treasury Portfolio with SOFR Swaps](Fixed%20Income%20%26%20Hedging/PCA-Based%20Hedging%20of%20an%20MDB%20Treasury%20Portfolio%20with%20SOFR%20Swaps/) 📊 | PCA, key-rate DV01, constrained least squares |
| [SOFR Swap Spreads: Fair Value, Relative-Value Trading and Hedging with Machine Learning](Fixed%20Income%20%26%20Hedging/SOFR%20Swap%20Spreads%20-%20Fair%20Value%2C%20Relative-Value%20Trading%20and%20Hedging%20with%20Machine%20Learning/) 📊 | DTCC swap trades, ridge / LightGBM fair value, walk-forward RV backtest, Kalman and ML hedge ratios |
| [Spread Duration & CS01 by Asset Class](Fixed%20Income%20%26%20Hedging/Spread%20Duration%20%26%20CS01%20by%20Asset%20Class/) 📊 | Regression, scenario analysis |
| [Tracking Error & Risk Attribution vs Benchmark](Fixed%20Income%20%26%20Hedging/Tracking%20Error%20%26%20Risk%20Attribution%20vs%20Benchmark/) 📊 | Factor model, PCA, SQL |
| [Treasury Bond Risk Premia from Macro Data: Forward Rates, Factor Models, Random Forests, Boosting and Neural Networks](Fixed%20Income%20%26%20Hedging/Treasury%20Bond%20Risk%20Premia%20from%20Macro%20Data%20-%20Forward%20Rates%2C%20Factor%20Models%2C%20Random%20Forests%2C%20Boosting%20and%20Neural%20Networks/) 📊 | GSW forward rates, Cochrane–Piazzesi, macro factors, elastic net, random forest, LightGBM, Keras ensemble, Clark–West, CER |

### AI, Model Risk & Validation

| Project | Key methods |
|---|---|
| [A Retrieval-Augmented LLM Analyst for 10-K Filings: Measuring Accuracy, Hallucination and Abstention Against XBRL Ground Truth](AI%2C%20Model%20Risk%20%26%20Validation/A%20Retrieval-Augmented%20LLM%20Analyst%20for%2010-K%20Filings%20-%20Measuring%20Accuracy%2C%20Hallucination%20and%20Abstention%20Against%20XBRL%20Ground%20Truth/) 📊 | BM25 + BGE hybrid retrieval, cross-encoder re-ranking, Qwen2.5 RAG, XBRL-graded accuracy, hallucination and abstention |
| [AI Risk Reporting: FinBERT Sentiment + LLM Risk Memo](AI%2C%20Model%20Risk%20%26%20Validation/AI%20Risk%20Reporting%20-%20FinBERT%20Sentiment%20%2B%20LLM%20Risk%20Memo/) 📊 | NLP, LLM summarisation |
| [Conformal Prediction for Credit and Market Risk: Distribution-Free Intervals for PDs and Guaranteed-Coverage VaR](AI%2C%20Model%20Risk%20%26%20Validation/Conformal%20Prediction%20for%20Credit%20and%20Market%20Risk%20-%20Distribution-Free%20Intervals%20for%20PDs%20and%20Guaranteed-Coverage%20VaR/) | Venn–Abers, conformal prediction sets, Mondrian, CQR, adaptive conformal inference |
| [Counterparty Contagion Network with GNNs](AI%2C%20Model%20Risk%20%26%20Validation/Counterparty%20Contagion%20Network%20with%20GNNs/) 📊 | GNN, DebtRank |
| [Lazy Prices in Risk Disclosures: Year-over-Year Changes in 10-K Risk Factors, Sentence Embeddings for New Risks, and What They Predict for Returns and Volatility](AI%2C%20Model%20Risk%20%26%20Validation/Lazy%20Prices%20in%20Risk%20Disclosures%20-%20Year-over-Year%20Changes%20in%2010-K%20Risk%20Factors%2C%20Sentence%20Embeddings%20for%20New%20Risks%2C%20and%20What%20They%20Predict%20for%20Returns%20and%20Volatility/) 📊 | 10-K Item 1A extraction, cosine/Jaccard change measures, BGE embeddings for new risks, calendar portfolios, LightGBM rank IC |
| [Model Validation & MLOps Capstone for a PD Model](AI%2C%20Model%20Risk%20%26%20Validation/Model%20Validation%20%26%20MLOps%20Capstone%20for%20a%20PD%20Model/) | MLflow, PSI drift, model card |
| [News Sentiment for Stocks and Credit: FinBERT vs an Open LLM vs a Finance Word List, and What Headlines Say About Next-Day Returns and Spreads](AI%2C%20Model%20Risk%20%26%20Validation/News%20Sentiment%20for%20Stocks%20and%20Credit%20-%20FinBERT%20vs%20an%20Open%20LLM%20vs%20a%20Finance%20Word%20List%2C%20and%20What%20Headlines%20Say%20About%20Next-Day%20Returns%20and%20Spreads/) 📊 | FinBERT vs Qwen2.5 vs word list on FNSPID/8-K/NYT/Guardian headlines, clustered panel regressions, credit lead–lag |
| [Nowcasting US Inflation with an Open LLM Reading the News: New York Times Headlines, Qwen2.5 Scores and Machine-Learning Forecasts](AI%2C%20Model%20Risk%20%26%20Validation/Nowcasting%20US%20Inflation%20with%20an%20Open%20LLM%20Reading%20the%20News%20-%20New%20York%20Times%20Headlines%2C%20Qwen2.5%20Scores%20and%20Machine-Learning%20Forecasts/) 📊 | NYT archive, Qwen2.5 inflation-pressure scores, walk-forward ridge / LightGBM nowcasts, Diebold–Mariano |
| [Reading the Fed with Language Models: Hawkish-Dovish Scores of FOMC Statements, Treasury Yield Reactions and Forecasts of the Next Policy Decision](AI%2C%20Model%20Risk%20%26%20Validation/Reading%20the%20Fed%20with%20Language%20Models%20-%20Hawkish-Dovish%20Scores%20of%20FOMC%20Statements%2C%20Treasury%20Yield%20Reactions%20and%20Forecasts%20of%20the%20Next%20Policy%20Decision/) 📊 | Fed-stance RoBERTa, Qwen2.5 zero-shot scoring, event-study yield regressions (HAC), next-decision logit / LightGBM |
| [Synthetic Data for Low-Default Portfolios: Conditional WGAN-GP (CTGAN-style), TVAE, Gaussian Copula and SMOTE, Tested for Utility, Fidelity and Privacy](AI%2C%20Model%20Risk%20%26%20Validation/Synthetic%20Data%20for%20Low-Default%20Portfolios%20-%20Conditional%20WGAN-GP%20%28CTGAN-style%29%2C%20TVAE%2C%20Gaussian%20Copula%20and%20SMOTE%2C%20Tested%20for%20Utility%2C%20Fidelity%20and%20Privacy/) | CTGAN-style WGAN-GP, TVAE, Gaussian copula, SMOTE, TSTR, DCR |
| [Tabular Foundation Models for Credit Scoring: In-Context Learning with TabICL vs Gradient Boosting and Logistic Regression, from 250 to 20,000 Borrowers](AI%2C%20Model%20Risk%20%26%20Validation/Tabular%20Foundation%20Models%20for%20Credit%20Scoring%20-%20In-Context%20Learning%20with%20TabICL%20vs%20Gradient%20Boosting%20and%20Logistic%20Regression%2C%20from%20250%20to%2020%2C000%20Borrowers/) 📊 | TabICL in-context learning vs XGBoost / LightGBM / CatBoost / logit, learning curves, ECE calibration |
| [Time-Series Foundation Models for Finance: Zero-Shot Chronos-2 and Chronos-Bolt vs ARIMA, Exponential Smoothing and Gradient Boosting on Macroeconomic and Market Series](AI%2C%20Model%20Risk%20%26%20Validation/Time-Series%20Foundation%20Models%20for%20Finance%20-%20Zero-Shot%20Chronos-2%20and%20Chronos-Bolt%20vs%20ARIMA%2C%20Exponential%20Smoothing%20and%20Gradient%20Boosting%20on%20Macroeconomic%20and%20Market%20Series/) 📊 | Chronos-2 and Chronos-Bolt zero-shot, AutoARIMA, AutoETS, global LightGBM, rolling-origin MASE and quantile loss |

### Fraud & Financial Crime

| Project | Key methods |
|---|---|
| [Account-Opening Fraud and Fairness: Gradient Boosting at a Fixed False-Positive Rate and a Bias Audit by Age on the Bank Account Fraud Dataset](Fraud%20%26%20Financial%20Crime/Account-Opening%20Fraud%20and%20Fairness%20-%20Gradient%20Boosting%20at%20a%20Fixed%20False-Positive%20Rate%20and%20a%20Bias%20Audit%20by%20Age%20on%20the%20Bank%20Account%20Fraud%20Dataset/) 📊 | Class-weighted LightGBM at fixed FPR, predictive-equality audit, reweighting and post-processing mitigation, expected cost |
| [Anti-Money Laundering with Graph Machine Learning: Graph Neural Networks on Bitcoin Transactions and Network Features for Bank Transfers](Fraud%20%26%20Financial%20Crime/Anti-Money%20Laundering%20with%20Graph%20Machine%20Learning%20-%20Graph%20Neural%20Networks%20on%20Bitcoin%20Transactions%20and%20Network%20Features%20for%20Bank%20Transfers/) 📊 | Elliptic and IBM AML graphs, GCN and GraphSAGE (PyTorch Geometric), LightGBM on graph features, recall by typology |
| [Credit Card Fraud Detection Under Extreme Class Imbalance: Cost-Sensitive Gradient Boosting, Autoencoders and Alert Thresholds Set by Fraud Losses](Fraud%20%26%20Financial%20Crime/Credit%20Card%20Fraud%20Detection%20Under%20Extreme%20Class%20Imbalance%20-%20Cost-Sensitive%20Gradient%20Boosting%2C%20Autoencoders%20and%20Alert%20Thresholds%20Set%20by%20Fraud%20Losses/) 📊 | Time-ordered splits, class weights vs SMOTE, isotonic calibration, cost-based thresholds, rank-averaged LightGBM/XGBoost ensembles |
| [Insurance Claims Fraud: Explainable Gradient Boosting, a Budgeted Investigation Queue and SHAP Reason Codes for Auto Claims](Fraud%20%26%20Financial%20Crime/Insurance%20Claims%20Fraud%20-%20Explainable%20Gradient%20Boosting%2C%20a%20Budgeted%20Investigation%20Queue%20and%20SHAP%20Reason%20Codes%20for%20Auto%20Claims/) 📊 | CatBoost with native categoricals, budgeted investigation queue, SHAP explanations, score differences by sex and age |
| [Mobile-Money Fraud Detection: Transaction-Sequence Features, Gradient Boosting vs an LSTM, and a Real-Time Alert Queue](Fraud%20%26%20Financial%20Crime/Mobile-Money%20Fraud%20Detection%20-%20Transaction-Sequence%20Features%2C%20Gradient%20Boosting%20vs%20an%20LSTM%2C%20and%20a%20Real-Time%20Alert%20Queue/) 📊 | Causal account-history features, class-weighted LightGBM, Keras LSTM on transaction sequences, capacity-constrained alerting |

### Insurance, Pensions & Actuarial Science

| Project | Key methods |
|---|---|
| [Claims Reserving in R: Chain Ladder, Mack and Bootstrap vs Pooled Machine Learning and a Recurrent Neural Network on 200 Insurers' Schedule P Triangles](Insurance%2C%20Pensions%20%26%20Actuarial%20Science/Claims%20Reserving%20in%20R%20-%20Chain%20Ladder%2C%20Mack%20and%20Bootstrap%20vs%20Pooled%20Machine%20Learning%20and%20a%20Recurrent%20Neural%20Network%20on%20200%20Insurers%27%20Schedule%20P%20Triangles/) 📊 | ChainLadder (Mack, bootstrap), pooled gradient boosting and GRU on development triangles, reserve-range coverage |
| [Discounting Pension Liabilities and Liability-Driven Investing: the High-Quality Corporate Curve vs Treasuries, Key-Rate Hedges and Machine-Learned Hedge Ratios](Insurance%2C%20Pensions%20%26%20Actuarial%20Science/Discounting%20Pension%20Liabilities%20and%20Liability-Driven%20Investing%20-%20the%20High-Quality%20Corporate%20Curve%20vs%20Treasuries%2C%20Key-Rate%20Hedges%20and%20Machine-Learned%20Hedge%20Ratios/) 📊 | HQM curve valuation, key-rate durations, segment rates, analytic / rolling OLS / ridge / Keras hedges |
| [Funding U.S. State and Local Pension Plans: Assumed Returns versus Market Discount Rates, Contribution Discipline and Machine-Learning Drivers of Funded Ratios in 250 Public Plans, 2001–2025](Insurance%2C%20Pensions%20%26%20Actuarial%20Science/Funding%20U.S.%20State%20and%20Local%20Pension%20Plans%20-%20Assumed%20Returns%20versus%20Market%20Discount%20Rates%2C%20Contribution%20Discipline%20and%20Machine-Learning%20Drivers%20of%20Funded%20Ratios%20in%20250%20Public%20Plans%2C%202001%E2%80%932025/) 📊 | Public Plans Database API, Treasury-basis remeasurement, within-plan drivers with smoothing lags, LightGBM/Keras five-year funded-ratio forecasts, stochastic projection under two contribution rules |
| [Glide Paths for Defined-Contribution Retirement Plans: Target-Date Rules vs Optimised and Deep-Learning Glide Paths on Seventy Years of Bootstrapped U.S. Returns](Insurance%2C%20Pensions%20%26%20Actuarial%20Science/Glide%20Paths%20for%20Defined-Contribution%20Retirement%20Plans%20-%20Target-Date%20Rules%20vs%20Optimised%20and%20Deep-Learning%20Glide%20Paths%20on%20Seventy%20Years%20of%20Bootstrapped%20U.S.%20Returns/) 📊 | Block-bootstrapped returns, SCF salary profile, optimised and PyTorch glide paths, regime and cohort tests |
| [Hedging Pension Longevity Risk: Lee–Carter, Cairns–Blake–Dowd and an LSTM for U.S. Mortality, and the Price of a Longevity Swap versus a Buy-In](Insurance%2C%20Pensions%20%26%20Actuarial%20Science/Hedging%20Pension%20Longevity%20Risk%20-%20Lee%E2%80%93Carter%2C%20Cairns%E2%80%93Blake%E2%80%93Dowd%20and%20an%20LSTM%20for%20U.S.%20Mortality%2C%20and%20the%20Price%20of%20a%20Longevity%20Swap%20versus%20a%20Buy-In/) 📊 | SSA life tables, Lee–Carter, CBD and LSTM back-tests, Trustees comparison, trend/basis/idiosyncratic risk, Wang and cost-of-capital swap pricing, buy-in, index-swap hedge |
| [IFRS 17 for a Life and Annuity Book: Fulfilment Cash Flows, the Risk Adjustment and the Contractual Service Margin Quarter by Quarter, with Polynomial, Gradient-Boosting and Neural-Network Proxies for Fast Revaluation](Insurance%2C%20Pensions%20%26%20Actuarial%20Science/IFRS%2017%20for%20a%20Life%20and%20Annuity%20Book%20-%20Fulfilment%20Cash%20Flows%2C%20the%20Risk%20Adjustment%20and%20the%20Contractual%20Service%20Margin%20Quarter%20by%20Quarter%2C%20with%20Polynomial%2C%20Gradient-Boosting%20and%20Neural-Network%20Proxies%20for%20Fast%20Revaluation/) 📊 | Nelson–Siegel curves with illiquidity premium, SOA tables, BEL, cost-of-capital RA and CSM roll-forward, assumption review, polynomial vs LightGBM vs Keras proxies, RA confidence level |
| [Index Insurance for Colombian Farmers: Area-Yield vs Weather-Index vs Machine-Learning Triggers, Basis Risk and Pricing from Municipal Yields, CHIRPS and NASA POWER](Insurance%2C%20Pensions%20%26%20Actuarial%20Science/Index%20Insurance%20for%20Colombian%20Farmers%20-%20Area-Yield%20vs%20Weather-Index%20vs%20Machine-Learning%20Triggers%2C%20Basis%20Risk%20and%20Pricing%20from%20Municipal%20Yields%2C%20CHIRPS%20and%20NASA%20POWER/) 📊 | EVA municipal yields, CHIRPS and NASA POWER season features, municipal vs department signal, rainfall, soil-moisture and LightGBM/Keras triggers, basis risk, ENSO-conditioned pricing |
| [Mortality Forecasting for Life Insurance and Annuities in R: Lee–Carter, Cairns–Blake–Dowd and Age-Period-Cohort Models vs an LSTM, and What Longevity Risk Does to Annuity Prices](Insurance%2C%20Pensions%20%26%20Actuarial%20Science/Mortality%20Forecasting%20for%20Life%20Insurance%20and%20Annuities%20in%20R%20-%20Lee%E2%80%93Carter%2C%20Cairns%E2%80%93Blake%E2%80%93Dowd%20and%20Age-Period-Cohort%20Models%20vs%20an%20LSTM%2C%20and%20What%20Longevity%20Risk%20Does%20to%20Annuity%20Prices/) 📊 | StMoMo Lee–Carter, CBD, M7 and APC, ARIMA index forecasts, torch-for-R LSTM, bootstrap annuity factors |
| [Mortality Improvement for Pension Plans: Forecasting How Fast Death Rates Fall with Gradient Boosting and Neural Networks on a Century of Social Security Data, Tested on 2007–2023](Insurance%2C%20Pensions%20%26%20Actuarial%20Science/Mortality%20Improvement%20for%20Pension%20Plans%20-%20Forecasting%20How%20Fast%20Death%20Rates%20Fall%20with%20Gradient%20Boosting%20and%20Neural%20Networks%20on%20a%20Century%20of%20Social%20Security%20Data%2C%20Tested%20on%202007%E2%80%932023/) 📊 | SSA mortality 1900–2023, MP-style blend, LightGBM and Keras improvement forecasts, out-of-time test, annuity impact |
| [Motor Insurance Pricing with Machine Learning: Poisson and Gamma GLMs vs Gradient Boosting vs a Combined Actuarial Neural Network on French Motor Claims](Insurance%2C%20Pensions%20%26%20Actuarial%20Science/Motor%20Insurance%20Pricing%20with%20Machine%20Learning%20-%20Poisson%20and%20Gamma%20GLMs%20vs%20Gradient%20Boosting%20vs%20a%20Combined%20Actuarial%20Neural%20Network%20on%20French%20Motor%20Claims/) 📊 | Poisson/Gamma GLMs, LightGBM Tweedie-style objectives, CANN in Keras with embeddings, Lorenz curves, Gini, double-lift |
| [Parametric Catastrophe Insurance for Hurricanes and Earthquakes in Latin America and the Caribbean: Cat-in-a-Box vs Modelled-Loss Triggers vs a Machine-Learning Trigger, Basis Risk and Pricing from HURDAT2 and USGS](Insurance%2C%20Pensions%20%26%20Actuarial%20Science/Parametric%20Catastrophe%20Insurance%20for%20Hurricanes%20and%20Earthquakes%20in%20Latin%20America%20and%20the%20Caribbean%20-%20Cat-in-a-Box%20vs%20Modelled-Loss%20Triggers%20vs%20a%20Machine-Learning%20Trigger%2C%20Basis%20Risk%20and%20Pricing%20from%20HURDAT2%20and%20USGS/) 📊 | HURDAT2 Holland wind fields, USGS intensity prediction, EM-DAT basis risk, cat-in-a-box vs modelled-loss vs LightGBM and Keras triggers, track-perturbation and Gutenberg–Richter catalogue, layer pricing |
| [Pension Fund Asset-Liability Management: an Economic Scenario Generator, Liability-Driven Investing and a Reinforcement-Learning Investment Policy for a Defined-Benefit Plan](Insurance%2C%20Pensions%20%26%20Actuarial%20Science/Pension%20Fund%20Asset-Liability%20Management%20-%20an%20Economic%20Scenario%20Generator%2C%20Liability-Driven%20Investing%20and%20a%20Reinforcement-Learning%20Investment%20Policy%20for%20a%20Defined-Benefit%20Plan/) 📊 | VAR(1) economic scenario generator, LDI and glide-path rules, PPO (stable-baselines3) in a Gymnasium environment, CVaR |
| [Sovereign Disaster Risk Financing for Latin America and the Caribbean: Filling Missing Losses with Gradient Boosting and a Neural Network, Loss-Exceedance Curves, and Layering Reserves, Contingent Credit and Catastrophe Bonds](Insurance%2C%20Pensions%20%26%20Actuarial%20Science/Sovereign%20Disaster%20Risk%20Financing%20for%20Latin%20America%20and%20the%20Caribbean%20-%20Filling%20Missing%20Losses%20with%20Gradient%20Boosting%20and%20a%20Neural%20Network%2C%20Loss-Exceedance%20Curves%2C%20and%20Layering%20Reserves%2C%20Contingent%20Credit%20and%20Catastrophe%20Bonds/) 📊 | EM-DAT, LightGBM and Keras damage imputation, conformal intervals, multiple imputation, gamma-Poisson and GPD-tailed severity, loss-exceedance curves, layer optimisation |
| [Spending in Retirement: the 4% Rule, Guardrails, Annuities and a Deep-Learning Withdrawal Policy on Ninety-Eight Years of U.S. Returns](Insurance%2C%20Pensions%20%26%20Actuarial%20Science/Spending%20in%20Retirement%20-%20the%204%25%20Rule%2C%20Guardrails%2C%20Annuities%20and%20a%20Deep-Learning%20Withdrawal%20Policy%20on%20Ninety-Eight%20Years%20of%20U.S.%20Returns/) 📊 | 4% rule, guardrails, actuarial spending, annuities, PyTorch spending and allocation policy, historical retirements |
| [The Three Pillars of U.S. Retirement Income: Social Security, Employer Plans and Personal Savings for Households Approaching Retirement, with Gradient Boosting, SHAP and Household Segments](Insurance%2C%20Pensions%20%26%20Actuarial%20Science/The%20Three%20Pillars%20of%20U.S.%20Retirement%20Income%20-%20Social%20Security%2C%20Employer%20Plans%20and%20Personal%20Savings%20for%20Households%20Approaching%20Retirement%2C%20with%20Gradient%20Boosting%2C%20SHAP%20and%20Household%20Segments/) 📊 | SCF 2022 households, Social Security PIA, annuitised DC/IRA balances, LightGBM with SHAP, k-means segments |
| [Valuing a Defined-Benefit Pension Plan: Pri-2012 Mortality with Scale MP-2021, the HQM Discount Curve and a Neural-Network Surrogate Valuer](Insurance%2C%20Pensions%20%26%20Actuarial%20Science/Valuing%20a%20Defined-Benefit%20Pension%20Plan%20-%20Pri-2012%20Mortality%20with%20Scale%20MP-2021%2C%20the%20HQM%20Discount%20Curve%20and%20a%20Neural-Network%20Surrogate%20Valuer/) 📊 | Projected unit credit, Pri-2012 with MP-2021, HQM and IRS segment discounting, Keras surrogate valuer |

### Market Microstructure & Execution

| Project | Key methods |
|---|---|
| [Deep Learning on the Order Book: Order-Flow Imbalance, Gradient Boosting and a DeepLOB-Style CNN-LSTM for Ten-Second Price Moves in Crypto Futures](Market%20Microstructure%20%26%20Execution/Deep%20Learning%20on%20the%20Order%20Book%20-%20Order-Flow%20Imbalance%2C%20Gradient%20Boosting%20and%20a%20DeepLOB-Style%20CNN-LSTM%20for%20Ten-Second%20Price%20Moves%20in%20Crypto%20Futures/) 📊 | Order-flow imbalance, Keras Conv1D + LSTM on limit-order-book events, macro-F1, taker P&L after fees |
| [Optimal Trade Execution: Almgren-Chriss Schedules vs TWAP, VWAP and a Reinforcement-Learning Agent on Real Bitcoin Order Flow](Market%20Microstructure%20%26%20Execution/Optimal%20Trade%20Execution%20-%20Almgren-Chriss%20Schedules%20vs%20TWAP%2C%20VWAP%20and%20a%20Reinforcement-Learning%20Agent%20on%20Real%20Bitcoin%20Order%20Flow/) 📊 | Almgren–Chriss schedules, TWAP/VWAP, square-root impact, implementation shortfall, PPO execution agent |

### Fintech & Digital Assets

| Project | Key methods |
|---|---|
| [Crypto Portfolio Risk: Value-at-Risk and Expected Shortfall with GARCH, Extreme-Value Theory, Quantile Gradient Boosting and an LSTM, Backtested Through Terra, FTX and the ETF Era](Fintech%20%26%20Digital%20Assets/Crypto%20Portfolio%20Risk%20-%20Value-at-Risk%20and%20Expected%20Shortfall%20with%20GARCH%2C%20Extreme-Value%20Theory%2C%20Quantile%20Gradient%20Boosting%20and%20an%20LSTM%2C%20Backtested%20Through%20Terra%2C%20FTX%20and%20the%20ETF%20Era/) 📊 | FHS, GARCH-t, GARCH-EVT, LightGBM quantile and LSTM (FZ0) VaR/ES, Kupiec, Christoffersen, Gaussian HMM regimes |
| [Learning Credit-Limit Policies with Contextual Bandits: LinUCB, Thompson Sampling and a NeuralLinear Bandit on a Credit-Card Simulator, with Off-Policy Evaluation](Fintech%20%26%20Digital%20Assets/Learning%20Credit-Limit%20Policies%20with%20Contextual%20Bandits%20-%20LinUCB%2C%20Thompson%20Sampling%20and%20a%20NeuralLinear%20Bandit%20on%20a%20Credit-Card%20Simulator%2C%20with%20Off-Policy%20Evaluation/) 📊 | LinUCB, Thompson sampling, NeuralLinear bandits for credit limits, IPS/SNIPS/DR off-policy evaluation |
| [Liquidation Risk in DeFi Lending: a Structural Cascade Model of Aave V3 on Ethereum, Filtered Historical Simulation of Crypto Crashes, and Gradient-Boosting and Neural-Network Models of Deleveraging](Fintech%20%26%20Digital%20Assets/Liquidation%20Risk%20in%20DeFi%20Lending%20-%20a%20Structural%20Cascade%20Model%20of%20Aave%20V3%20on%20Ethereum%2C%20Filtered%20Historical%20Simulation%20of%20Crypto%20Crashes%2C%20and%20Gradient-Boosting%20and%20Neural-Network%20Models%20of%20Deleveraging/) 📊 | DefiLlama Aave V3 balance sheet, synthetic borrowers, liquidation cascade with square-root impact, crash-day calibration, GARCH-t FHS, LightGBM/Keras hybrid deleveraging models |
| [Open-Banking Cash-Flow Underwriting and Customer Lifetime Value: Scoring Loans from a Million Bank Transactions, and Predicting Which Customers Are Worth Keeping](Fintech%20%26%20Digital%20Assets/Open-Banking%20Cash-Flow%20Underwriting%20and%20Customer%20Lifetime%20Value%20-%20Scoring%20Loans%20from%20a%20Million%20Bank%20Transactions%2C%20and%20Predicting%20Which%20Customers%20Are%20Worth%20Keeping/) 📊 | Open-banking transaction features, logit / LightGBM / Keras GRU underwriting, RFM and customer-lifetime-value models |
| [Peer-to-Peer Lending: Profit Scoring vs Default Scoring on Matured LendingClub Loans, Out-of-Time Portfolio Selection, and Reject Inference with 27 Million Rejected Applications](Fintech%20%26%20Digital%20Assets/Peer-to-Peer%20Lending%20-%20Profit%20Scoring%20vs%20Default%20Scoring%20on%20Matured%20LendingClub%20Loans%2C%20Out-of-Time%20Portfolio%20Selection%2C%20and%20Reject%20Inference%20with%2027%20Million%20Rejected%20Applications/) 📊 | LendingClub profit vs default scoring, LightGBM / Keras MLP, out-of-time portfolio back-test, reject inference |
| [Stablecoin Depeg Risk: Early-Warning Models with Gradient Boosting and a GRU, Extreme-Value Tails by Design, and the March 2023 USDC Run Minute by Minute](Fintech%20%26%20Digital%20Assets/Stablecoin%20Depeg%20Risk%20-%20Early-Warning%20Models%20with%20Gradient%20Boosting%20and%20a%20GRU%2C%20Extreme-Value%20Tails%20by%20Design%2C%20and%20the%20March%202023%20USDC%20Run%20Minute%20by%20Minute/) 📊 | Calm-day depeg labels, LightGBM and Keras GRU early warning, PR-AUC and lead times, peaks-over-threshold GPD |

---

## Data sources

All data is public and free. Every notebook downloads what it needs from the original source and caches it locally in its own `data/` folder, which is never committed. A few hand-downloaded datasets sit once at the repo root and are found from any project folder: the Freddie Mac loan files (`data/freddie_mac/`), the Fannie Mae loan performance files for 2005–2008 (`data/fannie_mae/`, sampled on first use into `data/fannie_mae/sample/`), the SEC ABS-EE auto-loan tapes (`data/absee_cart20224/`), the EM-DAT disaster table (`data/emdat/`), the Social Security period life tables (`data/ssa_life_tables/`) and the Aave risk parameters (`data/aave/`).

| Source | Used for | Access |
|---|---|---|
| [FRED](https://fred.stlouisfed.org/) | SOFR, Treasury yields, credit spreads, macro series | Free API key |
| [U.S. Treasury](https://home.treasury.gov/resource-center/data-chart-center/interest-rates) | Daily par yield curves | Open |
| [Treasury Fiscal Data](https://fiscaldata.treasury.gov/) | Daily Treasury Statement (cash balances) | Open |
| [Yahoo Finance](https://finance.yahoo.com/) via `yfinance` | ETFs, indices, FX, futures, option chains | Open (unofficial API) |
| [iShares](https://www.ishares.com/) fund holdings | Real bond-level portfolios | Open |
| [DTCC Public Price Dissemination](https://pddata.dtcc.com/ppd/cftcdashboard) | Reported SOFR swap trades | Open |
| [SEC EDGAR](https://www.sec.gov/edgar) | XBRL financials, ISDA exhibits, ABS-EE loan tapes, 10-K text | Open (name + email header) |
| [Kaggle](https://www.kaggle.com/) | Credit default, LGD, ratings, churn, fraud, AML and P2P-lending datasets | Free account + token |
| [Freddie Mac SFLLD](https://www.freddiemac.com/research/datasets/sf-loanlevel-dataset) | Loan-level mortgage performance | Free registration, manual download |
| [Fannie Mae Single-Family Loan Performance Data](https://capitalmarkets.fanniemae.com/credit-risk-transfer/single-family-credit-risk-transfer/fannie-mae-single-family-loan-performance-data) | Loan-level mortgage performance through the 2008 crisis (2005–2008 acquisitions) | Free registration, manual download |
| [ECB Data Portal](https://data.ecb.europa.eu/) | Euro AAA yield curve, government yields, policy rates, CISS | Open |
| [Covered Bond Label HTT database](https://www.coveredbondlabel.com/htt-database) | Harmonised Transparency Templates of covered bond programmes | Open |
| [Macrohistory Database (Jordà–Schularick–Taylor)](https://www.macrohistory.net/database/) | 150 years of macro-financial data and banking crises | Open |
| [NGFS Scenario Explorer (IIASA)](https://data.ece.iiasa.ac.at/ngfs/) | NGFS Phase 5 climate transition scenarios | Open (guest token) |
| [EPA GHGRP / Envirofacts](https://www.epa.gov/ghgreporting) | Facility-level greenhouse-gas emissions and parent companies | Open |
| [Federal Reserve Board GSW yield curve](https://www.federalreserve.gov/data/nominal-yield-curve.htm) | Zero-coupon Treasury yields since the 1960s | Open |
| [OpenFEMA](https://www.fema.gov/about/openfema/data-sets) | NFIP flood insurance claims and penetration rates | Open |
| [New York Times Archive API](https://developer.nytimes.com/docs/archive-product/1/overview) | Every NYT article since 2015 (headlines, abstracts) for news-based models | Free API key |
| [The Guardian Open Platform](https://open-platform.theguardian.com/) | Company and country news headlines | Free API key |
| [Hugging Face](https://huggingface.co/) | FNSPID financial-news dataset; open models (FinBERT, Fed-stance RoBERTa, Qwen2.5, BGE, Chronos, TabICL) | Open |
| [Federal Reserve FOMC statements](https://www.federalreserve.gov/monetarypolicy/fomccalendars.htm) | Policy statements since 2000 | Open |
| [CFPB / FFIEC HMDA](https://ffiec.cfpb.gov/data-browser/) | Loan-level mortgage applications for fair-lending analysis | Open |
| [IMF DataMapper](https://www.imf.org/external/datamapper) | World Economic Outlook government debt and fiscal balances | Open |
| [Binance public data](https://data.binance.vision/), [DefiLlama](https://defillama.com/), [blockchain.com](https://www.blockchain.com/explorer/charts) | Crypto order flow, funding, stablecoin supply, on-chain activity | Open |
| [King County Assessor](https://info.kingcounty.gov/assessor/DataDownload/default.aspx) | Real-property sales and residential characteristics | Open |
| [Human Mortality Database](https://www.mortality.org/) (via `StMoMo`), [CAS loss reserving database](https://www.casact.org/publications-research/research/research-resources/loss-reserving-data-pulled-naic-schedule-p) (via `insurance`) | Mortality surfaces; NAIC Schedule P loss triangles | Open (R packages) |
| [UCI Machine Learning Repository](https://archive.ics.uci.edu/) | Credit-card default and other benchmark datasets | Open |
| [Survey of Consumer Finances](https://www.federalreserve.gov/econres/scfindex.htm) | Household income, pensions and retirement balances (2022) | Open |
| [SOA mortality table repository](https://mort.soa.org/) | Pri-2012, 2012 IAM, MP-2021 and historical SSA death rates | Open |
| [Social Security Office of the Chief Actuary](https://www.ssa.gov/oact/) | Wage index, benefit bend points, taxable maximum, period life tables | Open |
| [Public Plans Database](https://publicplansdata.org/) (CRR at Boston College, MissionSquare Research Institute, NASRA) | Assets, liabilities, assumptions, contributions and membership of about 250 U.S. state and local pension plans since 2001 | Open API |
| [IRS segment rates](https://www.irs.gov/retirement-plans/minimum-present-value-segment-rates) | Minimum present value segment rates for pension lump sums | Open |
| [Damodaran historical returns](https://pages.stern.nyu.edu/~adamodar/New_Home_Page/datafile/histretSP.html) | Annual U.S. stock, bond, bill and inflation returns since 1928 | Open |
| [EM-DAT](https://public.emdat.be/) (CRED, UCLouvain) | Natural disasters since 1990: people affected, deaths, damage; downloaded by hand into `data/emdat/` after free registration, never committed | Free registration |
| [NOAA HURDAT2](https://www.nhc.noaa.gov/data/#hurdat), [USGS ComCat](https://earthquake.usgs.gov/fdsnws/event/1/), [Natural Earth](https://github.com/nvkelso/natural-earth-vector) | Hurricane best tracks since 1851, earthquake catalogue since 1900, populated places and land polygons | Open |
| [datos.gov.co](https://www.datos.gov.co/) (Ministry of Agriculture, DANE) | Colombian municipal crop production (EVA) and municipal codes | Open |
| [CHIRPS](https://www.chc.ucsb.edu/data/chirps), [NASA POWER](https://power.larc.nasa.gov/), [NOAA CPC ONI](https://www.cpc.ncep.noaa.gov/products/analysis_monitoring/ensostuff/ONI_v5.php), [FAOSTAT](https://www.fao.org/faostat/) | Satellite rainfall, temperature and soil moisture, the El Niño index and national crop yields | Open |
| [Aave parameter dashboard](https://aave.com/docs/resources/parameters) | Loan-to-value, liquidation thresholds and bonuses of Aave V3 on Ethereum, saved in `data/aave/` | Open |
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

**David Andrés González Medina**. Risk, treasury and quantitative finance.
LinkedIn: *add link here*

## License

[MIT](LICENSE). Free to use and adapt with attribution.
