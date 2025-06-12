variable "project_id" {
  description = "The GCP project ID where the Terraform resources will be created."
  type        = string
  default     = "sparta-app-462710"
}

variable "region" {
  description = "The GCP region where resources will be deployed."
  type        = string
  default     = "europe-west2"
}

variable "bucket_name" {
  description = "The globally unique name of the GCS bucket used for storing Terraform state."
  type        = string
  default     = "sparta-app-terraform-state"
}

variable "bucket_labels" {
  description = "Labels to apply to the GCS bucket."
  type = object({
    name        = string
    environment = string
  })
  default = {
    name        = "terraform-state"
    environment = "dev"
  }
}
