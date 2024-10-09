from fastapi import FastAPI, HTTPException
from google.cloud import bigquery
from dotenv import load_dotenv
import os

load_dotenv()

PROJECT_ID = os.getenv("PROJECT_ID")
DATASET_ID = os.getenv("DATASET_ID")
TABLE_ID = os.getenv("TABLE_ID")

app = FastAPI()
client = bigquery.Client()

@app.get("/data")
async def get_data():
    query = f"""
    SELECT * FROM `{PROJECT_ID}.{DATASET_ID}.{TABLE_ID}`
    LIMIT 10
    """
    query_job = client.query(query)
    
    results = [dict(row) for row in query_job]
    if not results:
        raise HTTPException(status_code=404, detail="No data found")
    
    return results
