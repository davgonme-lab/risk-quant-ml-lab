# Sovereign Credit Outlooks with an Open LLM: Macro Fact Sheets, Newspaper Headlines and Machine Learning, Tested Against Subsequent Bond Spreads

Rating agencies attach an outlook to every sovereign rating, mixing hard numbers with judgement about politics and events. Can an open language model, given the same kind of fact sheet and the year's headlines, form an outlook that tells you anything about where bond spreads go next? This notebook tests that against what actually happened.

**What it does.** It asks an open-weight language model (Qwen2.5-1.5B-Instruct, run locally) to act as a sovereign analyst. For each of 32 countries and each year since 2017, the model reads a short fact sheet and gives a 12-month credit outlook (positive, stable or negative, as rating agencies phrase it). The fact sheet contains:

- the country's debt, deficit, growth, inflation, current account and reserves;
- its 10-year yield spread;
- ten news headlines about its economy that year, from The Guardian and The New York Times.

The outlooks are scored against what happened next: the change in the country's 10-year government bond spread over the following year. They are compared with machine-learning models trained on the same numbers, and the model writes outlook notes for the latest year.

**Data.** FRED (OECD 10-year government bond yields), the IMF World Economic Outlook through the DataMapper API (general government debt and net lending, with FRED and the World Bank as fallbacks), the World Bank WDI API (growth, inflation, current account, reserves), and The Guardian Open Platform and New York Times Archive APIs (headlines).

**Methods.** Prompt-based zero-shot classification from next-token probabilities, walk-forward logistic regression and LightGBM, AUC and rank correlation against realised spread changes, and greedy text generation for outlook notes.

**Key output.** How well LLM outlooks rank countries by subsequent spread widening, compared with ML and simple rules, and outlook notes for today.

---

## Why it matters

An open LLM (Qwen2.5-1.5B) acts as a sovereign analyst for 30 countries (2017–2026): it reads a fact sheet with IMF debt and deficits, World Bank macro data, bond spreads and up to ten country-specific Guardian/NYT headlines, and gives a positive/stable/negative outlook. Tested on 206 country-years against spread widening, headlines lift the LLM from AUC 0.49 to 0.54, while walk-forward ML models fall below chance and a simple debt-deficit-momentum rule is best for the euro area (0.73). Generated outlook notes catch the right themes but contain factual errors — a realistic picture of LLMs in sovereign risk.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`, `NYT_API_KEY`, `GUARDIAN_API_KEY`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 25 minutes on CPU (headlines and LLM outputs are cached)).

## Data sources

| Data | Source |
|---|---|
| 10-year government bond yields (FRED / OECD) | https://fred.stlouisfed.org |
| General government debt and net lending (IMF World Economic Outlook, DataMapper API) | https://www.imf.org/external/datamapper |
| Growth, inflation, current account, reserves (World Bank WDI API) | https://data.worldbank.org |
| The Guardian Open Platform | https://open-platform.theguardian.com |
| New York Times Archive API | https://developer.nytimes.com/docs/archive-product/1/overview |
| Qwen2.5-1.5B-Instruct (Hugging Face) | https://huggingface.co/Qwen/Qwen2.5-1.5B-Instruct |

## Outputs (`outputs/`)

- `01_sovereign_llm_outlooks.png`
- `country_year_panel_and_scores.csv`
- `dashboard.html`
- `dashboard.png`
- `llm_outlook_notes_latest.csv`
- `outlook_accuracy.csv`

## Key assumptions

- Spread over the Bund for euro-area members and over US Treasuries for the others; target: widening of more than 25 bp over the next 12 months.
- Fact sheets use the latest fiscal and macro data published by each year-end; headlines are kept only if they name the country.
- LLM score = P(negative) − P(positive) from single-token answers; ML benchmarks are re-fitted walk-forward each year.

## Suggested commit plan

1. `sovereign-llm-outlooks: add yields, IMF fiscal and World Bank macro panel`
2. `sovereign-llm-outlooks: add country headline collection and relevance filter`
3. `sovereign-llm-outlooks: add LLM outlooks with and without headlines`
4. `sovereign-llm-outlooks: add walk-forward benchmarks, outlook notes and dashboard`

## References

### Finance and regulation

- Cantor, R., & Packer, F. (1996). Determinants and impact of sovereign credit ratings. *Economic Policy Review, 2*(2), 37–53. https://doi.org/10.2139/ssrn.1028774
- Reinhart, C. M., & Rogoff, K. S. (2009). *This time is different: Eight centuries of financial folly*. Princeton University Press. https://doi.org/10.1515/9781400831722
- Afonso, A., Gomes, P., & Rother, P. (2011). Short- and long-run determinants of sovereign debt credit ratings. *International Journal of Finance & Economics, 16*(1), 1–15. https://doi.org/10.1002/ijfe.416
- Longstaff, F. A., Pan, J., Pedersen, L. H., & Singleton, K. J. (2011). How sovereign is sovereign credit risk? *American Economic Journal: Macroeconomics, 3*(2), 75–103. https://doi.org/10.1257/mac.3.2.75
- Baker, S. R., Bloom, N., & Davis, S. J. (2016). Measuring economic policy uncertainty. *The Quarterly Journal of Economics, 131*(4), 1593–1636. https://doi.org/10.1093/qje/qjw024

### Machine learning and deep learning

- Qwen Team. (2024). Qwen2.5 technical report. *arXiv*. https://arxiv.org/abs/2412.15115
- Brown, T., Mann, B., Ryder, N., Subbiah, M., Kaplan, J., Dhariwal, P., … Amodei, D. (2020). Language models are few-shot learners. *Advances in Neural Information Processing Systems, 33*. https://arxiv.org/abs/2005.14165
- Wu, S., Irsoy, O., Lu, S., Dabravolski, V., Dredze, M., Gehrmann, S., … Mann, G. (2023). BloombergGPT: A large language model for finance. *arXiv*. https://arxiv.org/abs/2303.17564
- Ke, G., Meng, Q., Finley, T., Wang, T., Chen, W., Ma, W., Ye, Q., & Liu, T.-Y. (2017). LightGBM: A highly efficient gradient boosting decision tree. *Advances in Neural Information Processing Systems, 30*. https://proceedings.neurips.cc/paper/2017/hash/6449f44a102fde848669bdd9eb6b76fa-Abstract.html
