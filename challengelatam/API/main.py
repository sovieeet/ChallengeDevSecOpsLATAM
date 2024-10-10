from fastapi import FastAPI, HTTPException
from google.cloud import bigquery

PROJECT_ID = "pruebalatam-438117"
DATASET_ID = "desafio_latam"
TABLE_ID = "latam"

app = FastAPI()
client = bigquery.Client(project=PROJECT_ID)

@app.get("/health")
async def health_check():
    return {"status": "ok"}

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
