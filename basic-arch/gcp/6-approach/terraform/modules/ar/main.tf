resource "google_artifact_registry_repository" "my-repo" {
  location      = "europe-southwest1"
  repository_id = "my-repository"
  description   = "example docker repository"
  format        = "DOCKER"
}