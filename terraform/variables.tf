variable "project_id" {
  description = "ID of the project"
  type        = string
  default     = "pruebalatam-438117"
}

variable "google_credentials" {
  description = "Google Cloud credentials JSON"
  type        = string
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