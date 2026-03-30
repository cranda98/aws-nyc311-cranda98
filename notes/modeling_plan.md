# NYC 311 Modeling Plan

**Date created:** 2026-03-30

## Business question
Predict the type of complaint (housing, noise, traffic, or sanitation) from the time
and location of a 311 call, to help operators route calls to the right agency faster.

## Data source
- **S3 path:** s3://cmse492-cranda98-nyc311-964165949460-us-east-1-an/modeling/modeling_data.csv
- **Records:** 157,244
- **Athena query:** sql/athena_to_modeling.sql

## Features
- borough (string — 5 NYC boroughs)
- incident_zip (numeric — zip code of complaint, ~570 missing values)
- agency (string — responding agency e.g. NYPD, HPD, DSNY)
- day_of_week (numeric, 1–7)
- hour_of_day (numeric, 0–23)

## Target
- **Name:** complaint_category
- **Type:** Multi-class classification (4 classes)
- **Balance/Distribution:**
    - traffic:    56,813 (36%)
    - housing:    55,794 (35%)
    - noise:      25,195 (16%)
    - sanitation: 19,442 (12%)

## Modeling approach
- **Baseline:** Logistic regression (interpretable, fast to train)
- **Follow-up:** Random Forest (handles categoricals well, provides feature importances)
- **Metrics:** Accuracy, per-class F1-score, confusion matrix
- **Train/test split:** 80/20
- **Class imbalance strategy:** Use class_weight='balanced' to account for
  underrepresented sanitation and noise classes

## Data quality notes
- incident_zip has ~570 null values (~0.4%) — will drop these rows before modeling
- incident_zip read as float64 due to nulls — convert to string/categorical after dropping nulls
- agency is highly correlated with target (HPD → housing, DSNY → sanitation) — 
  include as feature but note this in results

## Next steps
- Drop rows with missing incident_zip
- Encode categorical features (borough, incident_zip, agency) using LabelEncoder
- Train/test split (80/20, stratified on complaint_category)
- Fit baseline logistic regression
- Evaluate with classification_report and confusion matrix
- Fit Random Forest and compare performance
- Plot feature importances
