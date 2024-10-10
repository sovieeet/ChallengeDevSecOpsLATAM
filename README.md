# Desafio Técnicos DevSecOps/SRE
 El desafio consiste en un sistema para ingestar y almacenar datos en una base de datos para analizarlos y luego deben ser expuestos por una API para que puedan ser consumidos.

## 1. Infraestructura e IaC

Para esta infraestructura la dividiremos en 3 partes:

- Ingesta de datos (Esquema Pub/Sub): Para esto se usará Google Cloud Pub/Sub junto a un Cloud Function que se activará cada vez que se reciba un mensaje.

- Base de datos: Para esto se usara BigQuery con su respectivo esquema

- Exposición de datos mediate una API: Se levantará la API usando Cloud Run, permitiendo que terceros accedan a los datos almacenados mediante un endpoint.

Esta infraestructura se levantará usando terraform.

## 2. Aplicaciones y flujo CI/CD

En este caso como CI/CD se usó Git Actions, dividido en el levantamiento de toda la infraestructura que incluye los permisos de la service account correspondiente,
el dataset y la base de datos, junto con el Pub/Sub Topic, el Bucket, la Cloud Function creada con el Pub/Sub junto a sus respectivos triggers y suscripción.
La API se levantó en otro CI/CD mediante Docker usando Cloud Run para mayor facilidad y rápidez de levantamiento.

El flujo de datos se compone de la siguiente manera:

1. Los datos se envían como mensajes a un tópico de Pub/Sub de Google Cloud, que es el punto de entrada de los datos. Los datos se envian en formato JSON como en el siguiente ejemplo:

```json
{
  "id": "123",
  "name": "Test Name",
  "timestamp": "2024-10-10T10:00:00Z"
}
```
Además, desde el PubSub es posible visualizar los mensajes enviados, sean erróneos o no:

![Diagrama del flujo de la data](challengelatam/assets/data_ingestion.png)

2. Google Cloud Pub/Sub recibe estos mensajes y los distribuye a las suscripciones correspondientes (en este caso llamado `data-ingestion-subscription` creado mediante un modulo de Terraform)
3. La cloud functión está suscrita al tópico de Pub/Sub y se triggerea automáticamente cada vez que llega un mensaje:
    - La función decodifica el mensaje, lo procesa, y prepara los datos para el almacenamiento.
    - La función contiene validaciones para asegurar que el mensaje cumple con el formato requerido.
![Cloud Function](challengelatam/assets/cf.png)

4. La cloud function ingresa los datos a una tabla en BigQuery llamada `latam`, que contiene las columnas `id`, `name` y `timestamp`, almacenandose en tiempo real.
![Cloud Function](challengelatam/assets/tabla.png)

5. Los datos se exponen mediante una API con la url `https://fastapi-app-213520764589.us-central1.run.app` en la cual usando un GET al endpoint `/data`, es posible obtener toda la información contenida en la tabla de BigQuery.

![API](challengelatam/assets/api.png)

El diagrama muestra el flujo de la data:

![Diagrama del flujo de la data](challengelatam/assets/Diagram.png)