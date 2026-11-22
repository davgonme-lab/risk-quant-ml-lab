# Index Insurance for Colombian Farmers: Area-Yield vs Weather-Index vs Machine-Learning Triggers, Basis Risk and Pricing from Municipal Yields, CHIRPS and NASA POWER

A smallholder who loses a harvest to drought or flooding rarely has insurance: assessing losses farm by farm costs more than the premium a small farmer can pay. Index insurance avoids the visit. It pays when a measured index (rainfall at the farm's location, or the average yield of the area) falls below a threshold, so claims can be settled quickly and cheaply. Its weakness is the same as for any parametric cover: the index may not move with the farmer's loss. This notebook measures that gap for five staple crops in Colombia, with eighteen years of municipal production data and forty years of satellite rainfall.

**What it does.**

1. It builds a panel of production per sown hectare for maize, rice, beans, potatoes and coffee in about a thousand municipalities (2007–2024, Colombia's Municipal Agricultural Evaluations), detrends it and turns shortfalls into the payout of an insurance cover at 80% of expected production.
2. It attaches season-level weather to every municipality: CHIRPS rainfall at 5 km, NASA POWER temperature and root-zone soil moisture, and the El Niño index.
3. It checks where the weather signal is (municipality or department) and compares three triggers for a department-level cover: a classic rainfall deficit-and-excess contract, a soil-moisture contract and a machine-learning weather index (LightGBM and a Keras network), fitted on 2007–2016 and tested on 2017–2024. It then measures how much of each municipality's own loss the department covers, including a department area-yield cover, would reach.
4. It prices the weather-based covers over 1991–2024 and shows how the expected payout changes between El Niño, neutral and La Niña seasons.

**Data.** Evaluaciones Agropecuarias Municipales (Ministry of Agriculture, via datos.gov.co), DIVIPOLA municipal coordinates (DANE), CHIRPS monthly rainfall (Climate Hazards Center, UC Santa Barbara), NASA POWER monthly temperature and soil moisture, the Oceanic Niño Index (NOAA Climate Prediction Center) and FAOSTAT national yields for a cross-check.

**Methods.** Robust (Theil–Sen) detrending of log production per sown hectare, season-specific rainfall, heat and soil-moisture anomalies, aggregation to departments with sown-area weights, fixed-scale rainfall and soil-moisture contracts, isotonic calibration of the machine-learning index, monotone-constrained gradient boosting and a neural network with grouped validation and an out-of-time test, basis-risk measures and burning-cost pricing with ENSO conditioning.

**Key output.** How much of the loss is explained by weather at all, at municipal and department level; how often and how much each trigger pays when production falls, by crop, in and out of sample; how much a department cover reaches the farm; and what a cover costs per year, in average, El Niño and La Niña seasons.

---

## Why it matters

Index insurance is the main way to insure smallholders without visiting every farm, but it only works if the index moves with the farmer's loss. This notebook tests that for maize, rice, beans, potatoes and coffee in 1,087 Colombian municipalities, with eighteen years of production statistics and forty years of satellite rainfall, heat and soil moisture. The weather signal is weak: it is visible at department level for coffee and in big episodes such as the 2015 El Niño drought on the Caribbean coast, but no rainfall, soil-moisture or machine-learning trigger keeps its skill out of sample, and even a perfect department cover would pay only 6% of the municipal shortfalls. Priced over 1991–2024, a rainfall contract costs four to eight times its neutral-year price in El Niño seasons, which matters with the ONI above +2 in 2026.

## How to run

1. `conda activate quant-risk`. `.env` needs `FRED_API_KEY` (only checked by the shared setup cell). No other keys; CHIRPS is read month by month from the Climate Hazards Center and cached in `data/`.
2. Open the notebook, choose the **Python (quant-risk)** kernel, **Run All** (about 10 minutes on CPU the first time (CHIRPS and NASA POWER downloads), under 2 minutes with the cache).

## Data sources

| Data | Source |
|---|---|
| Municipal Agricultural Evaluations 2007–2024 (Ministry of Agriculture, datos.gov.co) | https://www.datos.gov.co |
| DIVIPOLA municipal codes and coordinates (DANE, datos.gov.co) | https://www.datos.gov.co |
| CHIRPS v2.0 monthly rainfall, 0.05° (Climate Hazards Center, UC Santa Barbara) | https://data.chc.ucsb.edu/products/CHIRPS-2.0/ |
| NASA POWER monthly maximum temperature, precipitation and root-zone soil wetness | https://power.larc.nasa.gov |
| Oceanic Niño Index (NOAA Climate Prediction Center) | https://www.cpc.ncep.noaa.gov/data/indices/oni.ascii.txt |
| FAOSTAT crop yields for Colombia | https://www.fao.org/faostat/en/#data/QCL |

## Outputs (`outputs/`)

- `01_index_insurance.png`
- `basis_risk_by_crop.csv`
- `basis_risk_department.csv`
- `caribbean_maize_by_year.csv`
- `dashboard.html`
- `dashboard.png`
- `data_quality_by_crop.csv`
- `department_cover_at_municipal_level.csv`
- `expected_payout_by_enso_phase.csv`
- `faostat_cross_check.csv`
- `loss_frequency_by_crop.csv`
- `ml_index_scores.csv`
- `pure_premium_by_crop.csv`
- `weather_signal_municipality_vs_department.csv`

## Key assumptions

- Loss measure: production per sown hectare against a Theil–Sen trend on its logarithm; cover at 80% of trend; series kept with at least 12 seasons.
- Seasons: A = March–August, B = September–February, Y = calendar year (coffee); weather anomalies against 1991–2020 normals.
- Department units aggregate municipal production and sown area; weather is averaged with sown-area weights; units with at least 3 municipalities.
- Rainfall contract: deficit from 75% of normal (full at 40%) and excess from 140% (full at 200%); soil-moisture contract on the wetness anomaly; one scale factor per crop makes each fair on 2007–2016; no payout below 2% of insured value.
- Machine-learning index: LightGBM with monotone constraints and a Keras network, blended on out-of-fold predictions grouped by year and mapped to payouts with isotonic regression.
- Pricing: burning cost over 1991–2024 with a 50% load; ENSO phases at ONI ±0.5.

## Suggested commit plan

1. `agri-index-insurance: add municipal production panel, detrending and the 80% cover`
2. `agri-index-insurance: add CHIRPS, NASA POWER and ENSO season features`
3. `agri-index-insurance: add municipal vs department signal, three department triggers and basis-risk tests`
4. `agri-index-insurance: add farm-level reach, ENSO pricing, FAOSTAT check and dashboard`

## References

### Finance and regulation

- Miranda, M. J., & Farrin, K. (2012). Index insurance for developing countries. *Applied Economic Perspectives and Policy, 34*(3), 391–427. https://doi.org/10.1093/aepp/pps031
- Carter, M., de Janvry, A., Sadoulet, E., & Sarris, A. (2017). Index insurance for developing country agriculture: A reassessment. *Annual Review of Resource Economics, 9*, 421–438. https://doi.org/10.1146/annurev-resource-100516-053352
- Clarke, D. J. (2016). A theory of rational demand for index insurance. *American Economic Journal: Microeconomics, 8*(1), 283–306. https://doi.org/10.1257/mic.20140103
- Jensen, N. D., Barrett, C. B., & Mude, A. G. (2016). Index insurance quality and basis risk: Evidence from northern Kenya. *American Journal of Agricultural Economics, 98*(5), 1450–1469. https://doi.org/10.1093/ajae/aaw046
- Funk, C., Peterson, P., Landsfeld, M., Pedreros, D., Verdin, J., Shukla, S., Husak, G., Rowland, J., Harrison, L., Hoell, A., & Michaelsen, J. (2015). The climate hazards infrared precipitation with stations—a new environmental record for monitoring extremes. *Scientific Data, 2*, 150066. https://doi.org/10.1038/sdata.2015.66
- Gelaro, R., McCarty, W., Suárez, M. J., Todling, R., Molod, A., Takacs, L., Randles, C. A., Darmenov, A., Bosilovich, M. G., Reichle, R., et al. (2017). The Modern-Era Retrospective Analysis for Research and Applications, Version 2 (MERRA-2). *Journal of Climate, 30*(14), 5419–5454. https://doi.org/10.1175/JCLI-D-16-0758.1

### Machine learning and deep learning

- Biffis, E., & Chavez, E. (2017). Satellite data and machine learning for weather risk management and food security. *Risk Analysis, 37*(8), 1508–1521. https://doi.org/10.1111/risa.12847
- Ke, G., Meng, Q., Finley, T., Wang, T., Chen, W., Ma, W., Ye, Q., & Liu, T.-Y. (2017). LightGBM: A highly efficient gradient boosting decision tree. *Advances in Neural Information Processing Systems, 30*. https://proceedings.neurips.cc/paper/2017/hash/6449f44a102fde848669bdd9eb6b76fa-Abstract.html
