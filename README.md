# NYC 311 Modeling Plan

**Date created:** March 30, 2026

## Business question
Predict the complaint_category of a 311 service request based on borough, agency, day of week, and hour of day.

## Data source
- **S3 path:** s3://cmse492-cranda98-nyc311-964165949460-us-east-1-an/modeling/modeling_data.csv
- **Records:** 157,244
- **Athena query:** sql/athena_to_modeling.sql

## Features
- borough (string/object)
- incident_zip (float64)
- agency (string/object)
- day_of_week (int64)
- hour_of_day (int64)

## Target
- **Name:** complaint_category
- **Type:** Classification (multiclass — predicting complaint type)
- **Balance/Distribution:** [paste results from your target variable distribution check]

## Modeling approach
- **Baseline:** Logistic regression (interpretable, fast to train)
- **Metrics:** Accuracy, precision, recall
- **Train/test split:** 80/20

## Data quality notes
- No missing values across all 6 columns
- incident_zip stored as float64 — may need casting or binning
- borough and agency need label encoding or one-hot encoding before modeling

## Next steps
- Train/test split
- Encode categorical variables (borough, agency)
- Fit baseline logistic regression on complaint_category
- Evaluate and interpret results
