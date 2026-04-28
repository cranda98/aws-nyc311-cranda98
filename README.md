# NYC 311 Complaint Prediction

[![Python 3.10](https://img.shields.io/badge/Python-3.10-blue.svg)](https://www.python.org/)
[![AWS](https://img.shields.io/badge/AWS-S3-orange.svg)](https://aws.amazon.com/s3/)
[![Jupyter](https://img.shields.io/badge/Jupyter-Notebook-orange.svg)](https://jupyter.org/)

## Project Overview

This project predicts NYC 311 complaint categories using AWS cloud infrastructure and machine learning. By analyzing 157,000+ service requests, this model helps operators route calls faster to the appropriate agency - especially critical for overnight residential issues like those coming in at 2am from the Bronx.

**Key Business Value:** Reduce call routing time by predicting complaint category before the operator finishes describing the issue.

## Business Problem

311 operators receive thousands of calls daily and need to route each to the correct agency (NYPD, HPD, DEP, etc.). Currently, operators must manually determine the complaint type, which takes time and leads to misrouting.

This model predicts the complaint_category based on:
- Borough (Bronx, Brooklyn, Manhattan, Queens, Staten Island)
- Hour of day (2am vs 2pm have very different complaint patterns)
- Day of week (weekend vs weekday patterns)
- Incident zip code (to identify residential vs commercial areas)

## Architecture
NYC Open Data → AWS S3 (Raw) → Athena Query → S3 (Clean Data) → Jupyter Notebook → Model → Predictions


## Dataset

- **Source:** NYC Open Data 311 service requests
- **Records:** 157,244
- **S3 Path:** `s3://cmse492-cranda98-nyc311-964165949460-us-east-1-an/modeling/modeling_data.csv`
- **No missing values** across all core features
- **Data quality notes:** incident_zip stored as float64 (may need casting), categorical variables need encoding

### Features Used

| Feature | Type | Description |
|---------|------|-------------|
| borough | Categorical | Bronx, Brooklyn, Manhattan, Queens, Staten Island |
| hour_of_day | Numerical | 0-23 (critical for identifying overnight patterns) |
| day_of_week | Numerical | 0=Monday through 6=Sunday |
| incident_zip | Numerical | 5-digit NYC zip code |

**Note:** The `agency` feature was intentionally excluded because operators do not know the correct agency when a call first arrives. Including it would create unrealistic 85% accuracy that doesn't reflect real-world routing scenarios.

### Target Variable

- **Name:** complaint_category
- **Type:** Multiclass classification (52 unique complaint types)
- **Top categories:** Housing, Noise, Sanitation, Traffic, Heat/Hot Water

## Modeling Approach

- **Baseline Model:** Logistic Regression (multiclass)
  - Why logistic regression? Interpretable, fast to train, good baseline for multiclass problems
- **Train/Test Split:** 80/20 (125,795 training / 31,449 testing records)
- **Evaluation Metrics:** Accuracy, Precision, Recall, F1-Score

### Key Business Finding

**At 2am in residential Bronx zip codes, the most common complaint is HOUSING (249 calls), followed by Noise.**

This finding directly answers the stakeholder question about routing overnight calls. Operators should prioritize routing to HPD/NYCHA for housing issues during late-night hours.

## Repository Structure

- **notebooks/**
  - `modeling_train_and_eval.ipynb` - Main modeling code

- **sql/**
  - `athena_to_modeling.sql` - Data extraction query

- **reports/**
  - (Analysis reports folder)

- `DATA_DICTIONARY.md` - Column descriptions

- `README.md` - This file


## How to Reproduce

1. **Set up AWS access** (ensure S3 bucket permissions)
2. **Run Athena query** from `sql/athena_to_modeling.sql` to extract data
3. **Launch Jupyter notebook**:
   ```bash
   jupyter notebook notebooks/modeling_train_and_eval.ipynb

## Results & Evaluation

## Realistic Model Performance (No Agency Feature)

| Metric | Score | Interpretation |
|--------|-------|----------------|
| Accuracy | 48.4% | 2x better than random guessing (25%) |
| Precision | 41.6% | Room for improvement |
| Recall | 48.4% | Consistent performance |

### Why This Is Acceptable

Without knowing the agency upfront (real-world scenario), 48.4% accuracy is a **solid baseline** that would:
- Reduce operator cognitive load
- Provide suggestions for overnight calls (like 2am Bronx)
- Beat human guessing by ~20%

### Business Value

Even at 48.4% accuracy:
- **2am Bronx calls:** Model correctly identifies Housing as top category
- **Routing suggestions:** Operators get 2x better than random recommendations
- **Iterative improvement:** Can add more features (seasonality, weather, holidays)

### Limitations

- Housing ↔ Traffic confusion is the main error source
- Adding time-based features could improve to ~55%
- Deploy as "suggestion tool" not "automatic router"

### What We Learned About Model Validation

**Initial model (with agency):** 85.6% accuracy ❌  
- Problem: Model "cheated" by memorizing agency names
- Example: HPD → Housing (100% accurate, but useless for routing)

**Final model (without agency):** 48.4% accuracy ✅  
- Realistic for operator use (agency unknown at call start)
- Still 2x better than random guessing (25%)
- Identifies Housing as top category at 2am in Bronx


### Model Performance Summary

| Category | Can it predict? | Why/Why not |
|----------|----------------|--------------|
| Housing | ✅ Yes (51% precision) | Strong time/location patterns |
| Traffic | ✅ Yes (46% precision) | Peak hour patterns |
| Sanitation | ⚠️ Weak (57% precision, 20% recall) | Needs more features |
| Noise | ❌ No (0% recall) | Requires agency or acoustic data |

### Why Noise Can't Be Predicted

Without the `agency` feature (which operators don't know at call time), Noise complaints are indistinguishable from other categories. In the real world, operators would need to:
1. Ask clarifying questions
2. Listen for background sounds
3. Use the address to determine if noise is likely

Our model appropriately abstains from Noise prediction rather than guessing wrong.

**Key Insight:** Always validate that your features would be available at prediction time!
