import pandas as pd
import joblib

print("Loading data...")

# Load RFM data
rfm = pd.read_csv(
    "data/processed/customer_rfm_segmented.csv"
)

# Load customer summary
customer_summary = pd.read_csv(
    "data/processed/customer_summary.csv"
)

# Rename Customer ID if required
rfm.rename(
    columns={"Customer ID": "CustomerID"},
    inplace=True
)

customer_summary.rename(
    columns={"Customer ID": "CustomerID"},
    inplace=True
)

# Merge customer-level features
ml_data = rfm.merge(
    customer_summary,
    on="CustomerID",
    how="left"
)

# Features used when training the model
features = [
    "Recency",
    "Frequency",
    "Total_Quantity",
    "Unique_Products",
    "Average_Order_Value",
    "Total_Orders"
]

# Check required columns
missing_columns = [
    col for col in features
    if col not in ml_data.columns
]

if missing_columns:
    print("Missing columns:", missing_columns)
    raise ValueError("Required ML columns are missing.")

# Load trained model and scaler
model = joblib.load(
    "models/random_forest_customer_model.pkl"
)

scaler = joblib.load(
    "models/customer_feature_scaler.pkl"
)

print("Model loaded!")
print("Scaler loaded!")

# Prepare features
X = ml_data[features]

# Scale data
X_scaled = scaler.transform(X)

# Generate predictions
ml_data["Predicted_High_Value"] = model.predict(X_scaled)

# Probability of being high-value customer
ml_data["High_Value_Probability"] = model.predict_proba(
    X_scaled
)[:, 1]

# Convert probability to percentage
ml_data["High_Value_Probability"] = (
    ml_data["High_Value_Probability"] * 100
).round(2)

# Select useful dashboard columns
predictions = ml_data[
    [
        "CustomerID",
        "Customer_Segment",
        "Recency",
        "Frequency",
        "Monetary",
        "Total_Quantity",
        "Unique_Products",
        "Average_Order_Value",
        "Total_Orders",
        "Predicted_High_Value",
        "High_Value_Probability"
    ]
]

# Save predictions
output_path = (
    "data/processed/customer_predictions.csv"
)

predictions.to_csv(
    output_path,
    index=False
)

print("Predictions generated successfully!")
print("Rows:", len(predictions))
print("Saved to:", output_path)

print("\nPrediction summary:")
print(
    predictions["Predicted_High_Value"]
    .value_counts()
)