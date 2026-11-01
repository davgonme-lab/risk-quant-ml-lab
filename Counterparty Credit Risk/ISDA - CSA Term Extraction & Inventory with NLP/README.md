# ISDA / CSA Term Extraction & Inventory with NLP

The collateral terms that decide how much a bank can lose on its swaps are buried in legal documents: thresholds, minimum transfer amounts, rating triggers. In many institutions they live in PDFs and a spreadsheet kept by hand, so simple questions take days to answer. This notebook turns a library of real collateral agreements into a searchable inventory, with every number linked to the clause it came from.

**What it does.** It downloads real ISDA Credit Support Annexes filed as exhibits on SEC EDGAR and extracts the terms a credit officer needs: thresholds, minimum transfer amounts, independent amounts, rounding, valuation agent, eligible collateral and rating triggers.

The terms go into a SQL inventory where every value points back to its source clause.

**Data.** 30 public EDGAR exhibits: 25 development documents (24 CSAs and one blank form) and a held-out set of 5 (4 CSAs and one exhibit that is not a CSA). Filer names come from the EDGAR submissions API.

**Methods.** HTML cleaning and clause segmentation, rule-based extraction of Paragraph 13 elections with party resolution and Paragraph 12 defaults, and spaCy NER for counterparty names.

A weakly supervised clause classifier (TF-IDF + logistic regression against a small Transformer encoder trained from scratch in PyTorch, with the trigger words masked) acts as a safety net. DuckDB holds the inventory.

**Key output.** A CSA inventory with evidence, field-level accuracy against values checked by an analyst on development and held-out documents, a clause classifier that finds terms from context alone, and inventory queries (threshold structures, MTAs, dependence on rating triggers).

---

## Why it matters

CSA terms decide how much exposure is collateralised. The notebook turns real EDGAR CSA exhibits into a SQL inventory with evidence for every value, and is honest about accuracy: 99% on the documents the rules were written on, 63% on held-out documents. Those numbers are the argument for a review queue and a clause classifier as a safety net.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (**about 4 minutes** (mostly the Transformer cross-validation). `.env` also needs `SEC_USER_AGENT="Your Name your@email"` (SEC fair-access policy). The first run downloads spaCy's `en_core_web_sm` automatically (or run `python -m spacy download en_core_web_sm`)).

## Data sources

| Data | Source |
|---|---|
| 30 ISDA/CSA exhibits (25 development, 5 held-out) | https://www.sec.gov/edgar |
| Filer names | https://data.sec.gov/submissions/ |

## Outputs (`outputs/`)

- `01_clause_classifier.png`
- `02_inventory_overview.png`
- `clause_classifier_cv.csv`
- `csa_evidence.csv`
- `csa_inventory.csv`
- `extraction_validation.csv`

## Key assumptions

- EDGAR exhibits stand in for a confidential CSA library; mostly structured-finance and corporate CSAs.
- Gold values for threshold and MTA (both parties) verified by hand from the clause text; held-out documents collected after the rules were frozen.
- Clause classifier trained on weak labels with trigger words masked; evaluated with GroupKFold by document.

## Suggested commit plan

1. `add README and CSA term definitions`
2. `EDGAR ETL with fair-access headers`
3. `rule-based Paragraph 13 extraction with evidence`
4. `validation on development and held-out documents`
5. `weakly-supervised clause classifier (TF-IDF vs Transformer)`
6. `DuckDB inventory, charts and executed outputs`

## References

### Finance and regulation

- Basel Committee on Banking Supervision & International Organization of Securities Commissions. (2020). *Margin requirements for non-centrally cleared derivatives*. Bank for International Settlements. https://www.bis.org/bcbs/publ/d499.htm
- Gregory, J. (2020). *The xVA challenge: Counterparty risk, funding, collateral, capital and initial margin* (4th ed.). Wiley. https://doi.org/10.1002/9781119508991
- Chalkidis, I., Androutsopoulos, I., & Michos, A. (2017). Extracting contract elements. In *Proceedings of the 16th International Conference on Artificial Intelligence and Law*. https://doi.org/10.1145/3086512.3086515

### Machine learning and deep learning

- Chalkidis, I., Fergadiotis, M., Malakasiotis, P., Aletras, N., & Androutsopoulos, I. (2020). LEGAL-BERT: The muppets straight out of law school. In *Findings of EMNLP 2020*. https://doi.org/10.18653/v1/2020.findings-emnlp.261
- Hendrycks, D., Burns, C., Chen, A., & Ball, S. (2021). CUAD: An expert-annotated NLP dataset for legal contract review. *arXiv*. https://arxiv.org/abs/2103.06268
- Ratner, A., Bach, S. H., Ehrenberg, H., Fries, J., Wu, S., & Ré, C. (2017). Snorkel: Rapid training data creation with weak supervision. *Proceedings of the VLDB Endowment, 11*(3), 269–282. https://doi.org/10.14778/3157794.3157797
- Vaswani, A., Shazeer, N., Parmar, N., Uszkoreit, J., Jones, L., Gomez, A. N., Kaiser, Ł., & Polosukhin, I. (2017). Attention is all you need. *Advances in Neural Information Processing Systems, 30*. https://arxiv.org/abs/1706.03762
- Salton, G., & Buckley, C. (1988). Term-weighting approaches in automatic text retrieval. *Information Processing & Management, 24*(5), 513–523. https://doi.org/10.1016/0306-4573(88)90021-0
