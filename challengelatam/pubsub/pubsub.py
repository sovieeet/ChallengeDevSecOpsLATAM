import base64
import json
import os
from google.cloud import bigquery
from dotenv import load_dotenv

load_dotenv()

PROJECT_ID = os.getenv("PROJECT_ID")
DATASET_ID = os.getenv("DATASET_ID")
TABLE_ID = os.getenv("TABLE_ID")

def pubsub_to_bigquery(event, context):
    client = bigquery.Client()
    table_id = f"{PROJECT_ID}.{DATASET_ID}.{TABLE_ID}"

    message = base64.b64decode(event['data']).decode('utf-8')
    data = json.loads(message)

    errors = client.insert_rows_json(table_id, [data])
    if errors:
        print(f"Errors: {errors}")
    else:
        print("Mensaje insertado en BigQuery.")
