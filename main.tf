terraform {
  required_version = ">= 0.14"

  required_providers {
    google = ">= 3.3"
  }
}

provider "google" {
  project = var.project_id
}

provider "kubernetes" {
  host                   = "https://${google_container_cluster.gke_cluster.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.gke_cluster.master_auth[0].cluster_ca_certificate,
  )
}

provider "helm" {
  kubernetes {
    host                   = "https://${google_container_cluster.gke_cluster.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(
      data.google_container_cluster.gke_cluster.master_auth[0].cluster_ca_certificate,
    )
  }
}

data "google_client_config" "default" {}

data "google_container_cluster" "gke_cluster" {
  name     = google_container_cluster.gke_cluster.name
  location = google_container_cluster.gke_cluster.location
}