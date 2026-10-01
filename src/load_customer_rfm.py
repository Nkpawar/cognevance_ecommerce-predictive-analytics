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

# Load RFM CSV
file_path = "data/processed/customer_rfm_segmented.csv"

df = pd.read_csv(file_path)

print("RFM CSV loaded!")
print("Rows:", len(df))
print("Columns:", df.columns.tolist())

# Rename Customer ID if necessary
df.rename(
    columns={
        "Customer ID": "CustomerID"
    },
    inplace=True
)

# Keep only columns required by MySQL table
columns = [
    "CustomerID",
    "Recency",
    "Frequency",
    "Monetary",
    "R_Score",
    "F_Score",
    "M_Score",
    "RFM_Score",
    "Customer_Segment"
]

df = df[columns]

# Load into MySQL
df.to_sql(
    "customer_rfm",
    con=engine,
    if_exists="append",
    index=False,
    chunksize=1000
)

print("Customer RFM data loaded successfully!")