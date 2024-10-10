import base64
import json
from main import pubsub_to_bigquery

def test_pubsub_to_bigquery():
    data = {
        "id": "6",
        "name": "Test PubSub",
        "timestamp": "2023-10-05T10:00:00Z"
    }

    event = {
        "data": base64.b64encode(json.dumps(data).encode("utf-8")).decode("utf-8")
    }
    context = {}

    pubsub_to_bigquery(event, context)

test_pubsub_to_bigquery()