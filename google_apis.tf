resource "google_project_service" "kubernetes_engine_api" {
  service = "container.googleapis.com"
  disable_on_destroy = true
}