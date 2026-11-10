# News Sentiment for Stocks and Credit: FinBERT vs an Open LLM vs a Finance Word List, and What Headlines Say About Next-Day Returns and Spreads

Every trading desk now has some kind of news-sentiment score. The useful question is not whether headlines sound positive or negative, but whether that tone tells you anything you did not already see in the price. This notebook measures sentiment three ways on almost nine years of headlines and checks what each version is actually worth.

**What it does.** It collects the news headlines on ten large U.S. companies since 2018 from four sources: the **FNSPID** financial-news dataset, the companies' own **SEC 8-K** press releases, the complete **New York Times** archive and **The Guardian**. Their sentiment is measured three ways:

1. a **finance word list** in the spirit of Loughran and McDonald;
2. **FinBERT**, a BERT model fine-tuned on financial text;
3. an open instruction-tuned **LLM** (Qwen2.5-1.5B-Instruct), asked zero-shot whether each headline is good or bad news for the company's stock.

It then asks how closely sentiment tracks same-day returns, whether it predicts next-day abnormal returns, and whether aggregate corporate news sentiment leads high-yield credit.

**Data.** FNSPID (Hugging Face), SEC EDGAR 8-K filings, the New York Times Archive API, The Guardian Open Platform API (headlines with timestamps), Yahoo Finance (stock, SPY and HYG/IEF prices) and FRED (ICE BofA US High Yield OAS).

**Methods.** Hugging Face `transformers` pipelines (ProsusAI/finbert), zero-shot LLM scoring from next-token probabilities, and agreement statistics (Cohen's κ, correlations).

The return tests are daily panel regressions with date-clustered errors and quintile event studies of abnormal returns; the credit test is a set of lead–lag regressions on spreads.

**Key output.** How often the three measures agree, how they relate to same-day and next-day returns, and the credit signal.

---

## Why it matters

75,342 headlines on ten US mega-caps (2018–2026) from FNSPID, SEC 8-K press releases, the New York Times and The Guardian are scored by FinBERT, an open LLM (Qwen2.5-1.5B) and a finance word list. The models agree on direction (rank correlation 0.63) and the LLM reads market-wrap headlines that FinBERT gets wrong. Same-day sentiment explains returns strongly (FinBERT 27 bp per s.d., t ≈ 12), but next-day predictability is small (3 bp, t = 1.6) and a sentiment index does not forecast high-yield credit — news on large stocks is priced within the day.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`, `NYT_API_KEY`, `GUARDIAN_API_KEY`, `SEC_USER_AGENT`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 2 hours the first time on CPU (headlines, FinBERT and LLM scores are cached)).

## Data sources

| Data | Source |
|---|---|
| FNSPID financial news (Hugging Face) | https://huggingface.co/datasets/sabareesh88/FNSPID_nasdaq |
| SEC EDGAR 8-K filings | https://www.sec.gov/edgar/search/ |
| New York Times Archive API | https://developer.nytimes.com/docs/archive-product/1/overview |
| The Guardian Open Platform | https://open-platform.theguardian.com |
| Stock, SPY, HYG and IEF prices (Yahoo Finance) | https://finance.yahoo.com |
| ICE BofA US High Yield OAS (FRED) | https://fred.stlouisfed.org/series/BAMLH0A0HYM2 |

## Outputs (`outputs/`)

- `01_news_sentiment_finbert_llm.png`
- `credit_lead_lag.csv`
- `daily_company_sentiment.csv`
- `dashboard.html`
- `dashboard.png`
- `label_crosstab.csv`
- `model_agreement.csv`
- `quintile_returns.csv`
- `return_regressions_all.csv`
- `return_regressions_common_sample.csv`

## Key assumptions

- Headlines published after 16:00 New York time or at weekends belong to the next trading day; returns are market-adjusted with SPY.
- FinBERT scores every headline; the LLM scores a stratified sample of 4,000 (400 per company) with single-token answers.
- Panel regressions with company fixed effects and standard errors clustered by date; credit tests with Newey–West errors.

## Suggested commit plan

1. `news-sentiment-stocks-credit: add FNSPID, 8-K, NYT and Guardian headline collection`
2. `news-sentiment-stocks-credit: add FinBERT, LLM and word-list sentiment`
3. `news-sentiment-stocks-credit: add agreement statistics and same/next-day return regressions`
4. `news-sentiment-stocks-credit: add credit lead–lag tests, dashboard and reading`

## References

### Finance and regulation

- Tetlock, P. C. (2007). Giving content to investor sentiment: The role of media in the stock market. *The Journal of Finance, 62*(3), 1139–1168. https://doi.org/10.1111/j.1540-6261.2007.01232.x
- Loughran, T., & McDonald, B. (2011). When is a liability not a liability? Textual analysis, dictionaries, and 10-Ks. *The Journal of Finance, 66*(1), 35–65. https://doi.org/10.1111/j.1540-6261.2010.01625.x
- Fama, E. F. (1970). Efficient capital markets: A review of theory and empirical work. *The Journal of Finance, 25*(2), 383–417. https://doi.org/10.2307/2325486
- Ke, Z. T., Kelly, B. T., & Xiu, D. (2019). *Predicting returns with text data* (NBER Working Paper No. 26186). National Bureau of Economic Research. https://doi.org/10.3386/w26186
- Lopez-Lira, A., & Tang, Y. (2023). Can ChatGPT forecast stock price movements? Return predictability and large language models. *arXiv*. https://arxiv.org/abs/2304.07619

### Machine learning and deep learning

- Araci, D. (2019). FinBERT: Financial sentiment analysis with pre-trained language models. *arXiv*. https://arxiv.org/abs/1908.10063
- Dong, Z., Fan, X., & Peng, Z. (2024). FNSPID: A comprehensive financial news dataset in time series. *arXiv*. https://arxiv.org/abs/2402.06698
- Wolf, T., Debut, L., Sanh, V., Chaumond, J., Delangue, C., Moi, A., … Rush, A. M. (2020). Transformers: State-of-the-art natural language processing. In *Proceedings of EMNLP 2020: System Demonstrations*. https://doi.org/10.18653/v1/2020.emnlp-demos.6
- Qwen Team. (2024). Qwen2.5 technical report. *arXiv*. https://arxiv.org/abs/2412.15115
- Cohen, J. (1960). A coefficient of agreement for nominal scales. *Educational and Psychological Measurement, 20*(1), 37–46. https://doi.org/10.1177/001316446002000104
