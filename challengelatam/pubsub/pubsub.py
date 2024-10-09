import base64
import json
from google.cloud import bigquery

PROJECT_ID = "pruebalatam-438117"
DATASET_ID = "desafio_latam"
TABLE_ID = "latam"

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
