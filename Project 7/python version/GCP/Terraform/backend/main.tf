provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_storage_bucket" "tf_state" {
  name          = var.bucket_name
  location      = var.region
  force_destroy = true

  versioning {
    enabled = true
  }

  uniform_bucket_level_access = true

  labels = {
    name = var.bucket_labels["name"]
  }
}
