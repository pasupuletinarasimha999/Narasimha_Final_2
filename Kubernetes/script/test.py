import psycopg2

# Database connection parameters
connection_params = {
    "dbname": "mydb",
    "user": "postgres",
    "password": "Paster813",
    "host": "terraform-20240531033623139300000006.cxyimaw88ih8.us-east-1.rds.amazonaws.com",
    "port": "5432"
}

# Connect to the database
try:
  conn = psycopg2.connect(**connection_params)
  print("Connected to PostgreSQL database!")
except (Exception, psycopg2.Error) as error:
  print("Error connecting to PostgreSQL database:", error)
finally:
  # Close the connection if it was successful
  if conn:
    conn.close()
    print("Connection closed.")
