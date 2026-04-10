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
## 🔁 How to Re-run This Project

To reproduce this project, follow these steps:

1. Launch AWS Learner Lab and ensure all services are active
2. Upload raw NYC 311 datasets to an S3 bucket under a `raw/` folder
3. Use Athena to create tables and run queries (see `sql/athena_to_modeling.sql`)
4. Export the modeling dataset as a CSV file
5. Upload the CSV file to the `modeling/` folder in your S3 bucket
6. Open a SageMaker notebook instance
7. Load the dataset from S3 and run the modeling notebook

## Notes
- Data must be converted to numeric format for modeling
- The target (label) column should be first for SageMaker Linear Learner
- AWS services (S3, Athena, SageMaker) must be configured before running