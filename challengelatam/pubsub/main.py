import base64
import json
from google.cloud import bigquery
import logging
from config.config import PROJECT_ID, DATASET_ID, TABLE_ID

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def pubsub_to_bigquery(event, context):
    client = bigquery.Client(project=PROJECT_ID)
    table_id = f"{PROJECT_ID}.{DATASET_ID}.{TABLE_ID}"

    logger.info("Pub/Sub received message: %s", event)

    try:
        message = base64.b64decode(event['data']).decode('utf-8')
        data = json.loads(message)
        logger.info("Decodified message: %s", data)
    except Exception as e:
        logger.error("Error with the message decodification: %s", e)
        return

    required_fields = {"id", "name", "timestamp"}
    if not required_fields.issubset(data):
        logger.warning("Message doesn't contain the required fields: %s", required_fields)
        return

    errors = client.insert_rows_json(table_id, [data])
    if errors:
        logger.error("BigQuery insertion error: %s", errors)
    else:
        logger.info("Message correctly inserted in BigQuery.")

