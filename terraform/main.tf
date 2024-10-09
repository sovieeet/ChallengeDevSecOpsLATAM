provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_bigquery_dataset" "desafio_latam" {
  dataset_id = var.dataset_id
  location   = var.location
}

resource "google_bigquery_table" "latam1" {
  dataset_id = google_bigquery_dataset.desafio_latam.dataset_id
  table_id   = var.table_id
  schema     = file("${path.module}/schema.json")
}
