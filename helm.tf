resource "kubernetes_secret" "gitlab_runners_cache_secret" {
  metadata {
    name = "google-application-credentials"
  }
  binary_data = {
    gcs_cred = google_service_account_key.gcs_service_account_key.private_key
  }
}

resource "helm_release" "gitlab_runners_release" {
  name       = "gitlab-runners-release"
  repository = "https://charts.gitlab.io"
  chart      = "gitlab-runner"
  version    = "0.48.1"
  values     = [
    templatefile("values.yml", {
      gitlabUrl   = var.gitlab_url,
      gitlabToken = var.gitlab_registration_token,
      concurrent  = var.runners_max_nodes,
      bucketName  = google_storage_bucket.gcs_bucket_cache.name
    })
  ]

  depends_on = [
    kubernetes_secret.gitlab_runners_cache_secret,
    google_container_node_pool.default_pool,
    google_container_node_pool.gitlab_runners_pool
  ]
}