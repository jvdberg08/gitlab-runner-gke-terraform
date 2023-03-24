variable "project_id" {
  default = "<project_id_here>"
}

variable "gke_cluster_zone" {
  default = "europe-west4-a"
}

variable "gke_cluster_name" {
  default = "gitlab-runners"
}

variable "gcs_location" {
  default = "EU"
}

variable "runners_max_nodes" {
  default = 10
}

variable "runners_machine_type" {
  default = "c2-standard-4"
}

variable "gitlab_url" {
  default = "https://gitlab.com"
}

variable "gitlab_registration_token" {
  default = "<token_here>"
}
