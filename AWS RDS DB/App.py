import sqlalchemy as sal
import pymysql
from sqlalchemy import create_engine, text

# Create engine
engine = create_engine('mysql+pymysql://admin:Ajay2609@database-1.cwlmuey4m9ho.us-east-1.rds.amazonaws.com/myflixdb')

# Create connection
connection = engine.connect()

# Execute query
query = text("select * from movies")
result_proxy = connection.execute(query)

# Fetch all rows
data = result_proxy.fetchall()

# Close connection
connection.close()

# Print fetched data
for item in data:
    print(item)