terraform {
  backend "gcs" {
    bucket  = "nv30-storage-bucket"
    prefix  = "reddit-app-prod/terraform-state"
  }
}
