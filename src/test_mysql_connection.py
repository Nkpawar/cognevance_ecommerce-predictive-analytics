from sqlalchemy import create_engine, text
from sqlalchemy.engine import URL

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

try:
    with engine.connect() as connection:
        result = connection.execute(text("SELECT DATABASE();"))
        print("Connected database:", result.scalar())
        print("MySQL connection successful!")

except Exception as e:
    print("MySQL connection failed!")
    print(e)