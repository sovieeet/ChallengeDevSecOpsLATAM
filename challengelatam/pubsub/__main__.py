from pubsub import pubsub_to_bigquery

def main(event, context):
    pubsub_to_bigquery(event, context)
