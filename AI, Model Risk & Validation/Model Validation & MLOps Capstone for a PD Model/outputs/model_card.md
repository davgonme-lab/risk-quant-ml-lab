# Model card — Home Credit application PD (champion)

**Model:** LightGBM, 22 features, 12 monotonic constraints, Platt-calibrated. Registered as `home_credit_pd` v1 (alias `champion`) in MLflow.
**Purpose:** probability of default on a new consumer-loan application, for approval decisions and pricing.
**Data:** 307,511 historical applications (default rate 8.07%); random 60/20/20 split for training, calibration and test.
**Owner / validator:** model developer (portfolio team) / independent model validation. Validation date: 2026-10-19.

## Performance (test sample)
- Gini 0.536 (95% CI 0.522–0.550); logistic challenger 0.485.
- Mean PD 8.09% vs default rate 8.07%; ECE 0.40 pp; Brier 0.0672.

## Stability and monitoring
- Score PSI to the first production population: 0.0016; largest CSI 1.6374 (credit_term_proxy).
- Monitoring triggers: PSI ≥ 0.10 (review), ≥ 0.25 (redevelop); Gini below 0.40 on matured cohorts; ECE above 1 pp.

## Limitations
- No application dates: no out-of-time test; production PSI uses an unlabelled population.
- External bureau scores (EXT_SOURCE_1–3) are third-party inputs whose methodology must be documented and monitored.
- Gender is excluded from the inputs; the adverse-impact ratio at an 80% approval rate is 0.92.

## Validation summary
- **Discrimination: test Gini:** 0.536 — GREEN
- **Discrimination: worst segment Gini:** 0.459 (income_type = Pensioner) — GREEN
- **Benchmark: Gini gain over logistic challenger:** +0.051 — GREEN
- **Calibration: ECE (pp):** 0.40 — GREEN
- **Calibration: Hosmer–Lemeshow p:** 0.002 — AMBER
- **Stability: score PSI to production:** 0.0016 — GREEN
- **Stability: worst characteristic CSI:** 1.6374 (credit_term_proxy) — RED
- **Conceptual soundness: largest monotonicity reversal (pp):** 0.063 (0.7% of applicants) — GREEN
- **Fairness: adverse-impact ratio by gender:** 0.922 — GREEN
- **Governance: model logged, registered and reloaded identically:** home_credit_pd v1 — GREEN
