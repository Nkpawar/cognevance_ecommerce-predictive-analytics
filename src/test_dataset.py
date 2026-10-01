import pandas as pd

# Location of the dataset
file_path = "data/raw/online_retail_II.xlsx"

# Load Excel dataset
df = pd.read_excel(file_path)

# Basic information
print("Dataset loaded successfully!")
print("Rows:", len(df))
print("Columns:", len(df.columns))

print("\nColumn Names:")
print(df.columns.tolist())

print("\nFirst 5 Rows:")
print(df.head())