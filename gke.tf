resource "google_service_account" "gke_service_account" {
  account_id = "gitlab-runners-gke-sa"
}

resource "google_container_cluster" "gke_cluster" {
  name     = var.gke_cluster_name
  project  = var.project_id
  location = var.gke_cluster_zone

  remove_default_node_pool = true
  initial_node_count       = 1

  depends_on = [google_project_service.kubernetes_engine_api]
}

resource "google_container_node_pool" "default_pool" {
  name       = "default-pool"
  cluster    = google_container_cluster.gke_cluster.name
  node_count = 1
  location   = var.gke_cluster_zone

  autoscaling {
    min_node_count = 1
    max_node_count = 10
  }

  node_config {
    preemptible     = true
    disk_size_gb    = 20
    machine_type    = "e2-small"
    service_account = google_service_account.gke_service_account.email
  }
}

resource "google_container_node_pool" "gitlab_runners_pool" {
  name       = "gitlab-runners-pool"
  cluster    = google_container_cluster.gke_cluster.name
  node_count = 0
  location   = var.gke_cluster_zone

  autoscaling {
    min_node_count = 0
    max_node_count = var.runners_max_nodes
  }

  node_config {
    preemptible     = true
    disk_size_gb    = 50
    disk_type       = "pd-ssd"
    machine_type    = var.runners_machine_type
    service_account = google_service_account.gke_service_account.email

    labels = {
      app = "gitlab-runner"
    }

    taint {
      effect = "NO_EXECUTE"
      key    = "app"
      value  = "gitlab-runner"
    }
  }
}