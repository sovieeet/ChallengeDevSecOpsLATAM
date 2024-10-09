variable "project_id" {
  description = "ID of the project"
  type        = string
  default     = "pruebalatam-438117"
}

variable "google_credentials" {
  description = "Google Cloud credentials JSON"
  type        = string
  sensitive   = true
}


variable "region" {
  description = "Region of project"
  type        = string
  default     = "us-central1"
}

variable "dataset_id" {
  description = "Bigquery dataset ID"
  type        = string
  default     = "desafio_latam"
}

variable "location" {
  description = "Bigquery dataset location"
  type        = string
  default     = "US"
}

variable "table_id" {
    description = "Bigquery table ID"
    type        = string
    default     = "latam"
}

variable "google_service_account_email" {
  description = "Service account email"
  type        = string
  default     = "sa-project@pruebalatam-438117.iam.gserviceaccount.com"
}
