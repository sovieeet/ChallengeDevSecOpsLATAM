# Desafio Técnicos DevSecOps/SRE
 El desafio consiste en un sistema para ingestar y almacenar datos en una base de datos para analizarlos y luego deben ser expuestos por una API para que puedan ser consumidos.

## 1. Infraestructura e IaC

Para esta infraestructura la dividiremos en 3 partes:

- Ingesta de datos (Esquema Pub/Sub): Para esto se usará Google Cloud Pub/Sub junto a un Cloud Function que se activará cada vez que se reciba un mensaje.

- Base de datos: Para esto se usara BigQuery con su respectivo esquema

- Exposición de datos mediate una API: Se levantará la API usando Cloud Run, permitiendo que terceros accedan a los datos almacenados.

Esta infraestructura se levantará usando terraform.