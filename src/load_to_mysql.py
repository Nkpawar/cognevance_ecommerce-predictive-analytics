import pandas as pd
from sqlalchemy import create_engine
from sqlalchemy.engine import URL

# MySQL connection details
username = "root"
password = "Naveen@1278"
host = "localhost"
port = 3306
database = "ecommerce_analytics"

# Create secure connection URL
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

print("CSV loaded!")
print("Rows:", len(df))

# Match CSV column name with MySQL column name
df.rename(columns={
    "Customer ID": "CustomerID"
}, inplace=True)

# Convert date
df["InvoiceDate"] = pd.to_datetime(
    df["InvoiceDate"]
)

# Load data into MySQL
df.to_sql(
    "transactions",
    con=engine,
    if_exists="append",
    index=False,
    chunksize=5000
)

print("Transactions loaded successfully!")