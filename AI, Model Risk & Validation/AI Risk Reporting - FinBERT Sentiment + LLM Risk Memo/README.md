# AI Risk Reporting: FinBERT Sentiment + LLM Risk Memo

A credit officer who monitors bank counterparties reads far more words than numbers, and most of those words are boilerplate. This notebook asks whether text analytics can find the part that matters: what changed in a bank's own description of its risks, and how its language compares with its peers'.

**What it does.** It reads the *Risk Factors* section (Item 1A) of six years of 10-K filings for 15 large U.S. banks, plus every FOMC statement since 2015. Tone is scored with the Loughran–McDonald dictionary and with FinBERT, risk themes are mapped with topic modelling, and the notebook measures how much each bank's risk disclosure changes from one year to the next.

It then checks whether the language carried any warning before the March 2023 regional-bank stress. Finally, it drafts a one-page risk memo for senior management from a deterministic template, so every sentence can be traced to a number.

**Data.** SEC EDGAR 10-K filings (submissions API and archives), FOMC statements from federalreserve.gov, bank share prices (Yahoo Finance), the 2-year Treasury yield (FRED) and the Loughran–McDonald master dictionary (shipped with `pysentiment2`).

**Methods.** HTML-to-text ETL and Item 1A extraction, dictionary tone, sentence-level FinBERT (`ProsusAI/finbert`), TF-IDF + NMF topics and year-on-year cosine similarity ("lazy prices", Cohen, Malloy & Nguyen, 2020). Market outcomes are compared through rank correlations.

**Key output.** Tone and theme trends by bank and year, the disclosure changes that came before March 2023, the agreement between the dictionary and FinBERT, FOMC tone against 2-year yield reactions, a dashboard and a Markdown risk memo.

---

## Why it matters

Credit officers read more text than numbers. On 90 bank 10-K risk-factor sections and 100 FOMC statements, FinBERT and the Loughran–McDonald dictionary agree on rankings (ρ 0.68) and the text tracks the risk agenda closely (pandemic out, AI and digital assets in). But disclosure lags risk: not one of 15 banks mentioned uninsured deposits two weeks before SVB, and no text signal predicted the March 2023 drawdown. The memo turns the metrics into a traceable one-pager for senior management.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (**about 40 minutes** on a CPU (FinBERT scores 14,400 sentences; the first run also downloads the 438 MB model and ~90 10-K filings) `.env` also needs `SEC_USER_AGENT="Your Name your@email"` (SEC fair-access policy). `pip install pysentiment2==0.1.1` provides the Loughran–McDonald dictionary).

## Data sources

| Data | Source |
|---|---|
| 10-K filings (Item 1A risk factors) | https://www.sec.gov/edgar |
| Filing lists | https://data.sec.gov/submissions/ |
| FOMC statements | https://www.federalreserve.gov/monetarypolicy/fomccalendars.htm |
| FinBERT (`ProsusAI/finbert`) | https://huggingface.co/ProsusAI/finbert |
| Loughran–McDonald master dictionary | `pysentiment2` package (University of Notre Dame SRAF) |
| Bank prices; 2y Treasury (`DGS2`) | Yahoo Finance · https://fred.stlouisfed.org |

## Outputs (`outputs/`)

- `01_tone_topics_emerging.png`
- `02_disclosure_change_and_2023.png`
- `03_fomc_tone.png`
- `dashboard.html`
- `dashboard.png`
- `filing_metrics.csv`
- `fomc_tone.csv`
- `march_2023_signal_test.csv`
- `risk_memo.md`
- `risk_memo_facts.json`
- `topic_mix_by_filing.csv`

## Key assumptions

- 15 banks with standard 10-K layouts (C, WFC, MS, BNY and USB excluded: risk factors incorporated by reference).
- FinBERT on a fixed-seed sample of 160 sentences per filing; tone = share negative minus share positive.
- NMF topics labelled by keyword rules; March 2023 test uses FY2022 10-Ks filed before 10 March 2023; memo built only from computed facts.

## Suggested commit plan

1. `add README and NLP risk-reporting framework`
2. `EDGAR 10-K ETL and Item 1A extraction`
3. `Loughran–McDonald and FinBERT tone`
4. `topics, emerging-risk phrases and disclosure change`
5. `March 2023 test and FOMC tone vs 2y yield`
6. `risk memo, dashboard and executed outputs`

## References

### Finance and regulation

- Cohen, L., Malloy, C., & Nguyen, Q. (2020). Lazy prices. *The Journal of Finance, 75*(3), 1371–1415. https://doi.org/10.1111/jofi.12885
- Loughran, T., & McDonald, B. (2011). When is a liability not a liability? Textual analysis, dictionaries, and 10-Ks. *The Journal of Finance, 66*(1), 35–65. https://doi.org/10.1111/j.1540-6261.2010.01625.x
- Loughran, T., & McDonald, B. (2016). Textual analysis in accounting and finance: A survey. *Journal of Accounting Research, 54*(4), 1187–1230. https://doi.org/10.1111/1475-679X.12123
- Hansen, S., & McMahon, M. (2016). Shocking language: Understanding the macroeconomic effects of central bank communication. *Journal of International Economics, 99*, S114–S133. https://doi.org/10.1016/j.jinteco.2015.12.008
- Gentzkow, M., Kelly, B., & Taddy, M. (2019). Text as data. *Journal of Economic Literature, 57*(3), 535–574. https://doi.org/10.1257/jel.20181020

### Machine learning and deep learning

- Araci, D. (2019). FinBERT: Financial sentiment analysis with pre-trained language models. *arXiv*. https://arxiv.org/abs/1908.10063
- Devlin, J., Chang, M.-W., Lee, K., & Toutanova, K. (2019). BERT: Pre-training of deep bidirectional transformers for language understanding. In *Proceedings of NAACL-HLT 2019*. https://doi.org/10.18653/v1/N19-1423
- Lee, D. D., & Seung, H. S. (1999). Learning the parts of objects by non-negative matrix factorization. *Nature, 401*(6755), 788–791. https://doi.org/10.1038/44565
- Malo, P., Sinha, A., Korhonen, P., Wallenius, J., & Takala, P. (2014). Good debt or bad debt: Detecting semantic orientations in economic texts. *Journal of the Association for Information Science and Technology, 65*(4), 782–796. https://doi.org/10.1002/asi.23062
