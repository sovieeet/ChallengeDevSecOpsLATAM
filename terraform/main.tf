provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = var.google_credentials
}

# Pub/Sub Admin
resource "google_project_iam_member" "pubsub_admin" {
  project = var.project_id
  role    = "roles/pubsub.admin"
  member  = "serviceAccount:${var.google_service_account_email}"

  lifecycle {
    ignore_changes = [role, member]
  }
}

# BigQuery Admin
resource "google_project_iam_member" "bigquery_admin" {
  project = var.project_id
  role    = "roles/bigquery.admin"
  member  = "serviceAccount:${var.google_service_account_email}"

  lifecycle {
    ignore_changes = [role, member]
  }
}

# Artifact Registry Admin
resource "google_project_iam_member" "artifact_registry_admin" {
  project = var.project_id
  role    = "roles/artifactregistry.admin"
  member  = "serviceAccount:${var.google_service_account_email}"

  lifecycle {
    ignore_changes = [role, member]
  }
}

# Cloud Run Admin
resource "google_project_iam_member" "cloud_run_admin" {
  project = var.project_id
  role    = "roles/run.admin"
  member  = "serviceAccount:${var.google_service_account_email}"

  lifecycle {
    ignore_changes = [role, member]
  }
}

# Service Usage Admin
resource "google_project_iam_member" "service_usage_admin" {
  project = var.project_id
  role    = "roles/serviceusage.serviceUsageAdmin"
  member  = "serviceAccount:${var.google_service_account_email}"

  lifecycle {
    ignore_changes = [role, member]
  }
}

# Viewer
resource "google_project_iam_member" "viewer" {
  project = var.project_id
  role    = "roles/viewer"
  member  = "serviceAccount:${var.google_service_account_email}"

  lifecycle {
    ignore_changes = [role, member]
  }
}

# Storage Admin
resource "google_project_iam_member" "storage_admin" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${var.google_service_account_email}"

  lifecycle {
    ignore_changes = [role, member]
  }
}

# Cloud Functions Admin
resource "google_project_iam_member" "cloud_functions_admin" {
  project = var.project_id
  role    = "roles/cloudfunctions.admin"
  member  = "serviceAccount:${var.google_service_account_email}"

  lifecycle {
    ignore_changes = [role, member]
  }
}

# Project IAM Admin to give API permissions to the project with the service account
resource "google_project_iam_member" "project_iam_admin" {
  project = var.project_id
  role    = "roles/resourcemanager.projectIamAdmin"
  member  = "serviceAccount:${var.google_service_account_email}"

  lifecycle {
    ignore_changes = [role, member]
  }
}

# BigQuery Dataset
resource "google_bigquery_dataset" "desafio_latam" {
  dataset_id = var.dataset_id
  location   = var.location

  lifecycle {
    prevent_destroy = true
  }
}

# BigQuery Table
resource "google_bigquery_table" "latam1" {
  dataset_id = google_bigquery_dataset.desafio_latam.dataset_id
  table_id   = var.table_id
  schema     = file("${path.module}/schema.json")
}

# Pub/Sub Topic
resource "google_pubsub_topic" "data_ingestion" {
  name = "data-ingestion"

  lifecycle {
    prevent_destroy = true
  }
}

# Cloud Storage Bucket to store the function code
resource "google_storage_bucket" "function_bucket" {
  name     = "${var.project_id}-function-bucket"
  location = var.region
}

# Upload ZIP file of the function to the bucket
resource "google_storage_bucket_object" "function_code" {
  name   = "function.zip"
  bucket = google_storage_bucket.function_bucket.name
  source = "${path.module}/function.zip"
}

# Cloud Function activated with Pub/Sub and writes to BigQuery
resource "google_cloudfunctions_function" "pubsub_to_bigquery" {
  name        = "pubsub-to-bigquery"
  description = "Function to insert Pub/Sub data into BigQuery"
  runtime     = "python39"
  region      = var.region

  # Function settings
  entry_point           = "pubsub_to_bigquery"
  source_archive_bucket = google_storage_bucket.function_bucket.name
  source_archive_object = google_storage_bucket_object.function_code.name

  # Trigger settings
  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = google_pubsub_topic.data_ingestion.id
  }

  # Environment variables
  environment_variables = {
    PROJECT_ID  = var.project_id
    DATASET_ID  = var.dataset_id
    TABLE_ID    = var.table_id
  }

  depends_on = [google_storage_bucket_object.function_code]
}

# Pub/Sub Subscription
resource "google_pubsub_subscription" "data_ingestion_subscription" {
  name  = "data-ingestion-subscription"
  topic = google_pubsub_topic.data_ingestion.id
}
