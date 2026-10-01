import pandas as pd
from sqlalchemy import create_engine
from sqlalchemy.engine import URL

# MySQL connection
username = "root"
password = "Naveen@1278"
host = "localhost"
port = 3306
database = "ecommerce_analytics"

connection_url = URL.create(
    "mysql+pymysql",
    username=username,
    password=password,
    host=host,
    port=port,
    database=database
)

engine = create_engine(connection_url)

print("MySQL connection created!")

# Load cleaned transactions
df = pd.read_csv(
    "data/processed/cleaned_transactions.csv"
)

print("Transactions loaded!")
print("Rows:", len(df))

# Create product summary
product_summary = (
    df.groupby("StockCode")
    .agg(
        Description=("Description", "first"),
        Total_Quantity=("Quantity", "sum"),
        Total_Revenue=("Revenue", "sum"),
        Unique_Customers=("Customer ID", "nunique")
    )
    .reset_index()
)

print("Product summary created!")
print("Products:", len(product_summary))

# Load into MySQL
product_summary.to_sql(
    "product_summary",
    con=engine,
    if_exists="append",
    index=False,
    chunksize=1000
)

print("Product summary loaded successfully!")