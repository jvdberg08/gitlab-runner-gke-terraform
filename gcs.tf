resource "google_service_account" "gcs_service_account" {
  account_id = "gitlab-runners-cache-sa"
}

resource "google_service_account_key" "gcs_service_account_key" {
  service_account_id = google_service_account.gcs_service_account.name
}

resource "google_project_iam_member" "gcs_service_account_role" {
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.gcs_service_account.email}"
  project = var.project_id
}

resource "random_string" "gcs_bucket_prefix" {
  length = 8
  special = false
  upper = false
}

resource "google_storage_bucket" "gcs_bucket_cache" {
  name                        = "${random_string.gcs_bucket_prefix.result}-gitlab-runners-cache"
  location                    = var.gcs_location
  force_destroy               = true
  uniform_bucket_level_access = true
}
