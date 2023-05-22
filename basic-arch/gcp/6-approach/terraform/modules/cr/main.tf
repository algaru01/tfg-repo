resource "google_cloud_run_v2_service" "this" {
  name     = "cloudrun-service"
  location = var.location
  ingress = "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"


  template {
    containers {
      image = "${var.location}-docker.pkg.dev/${data.google_project.project.project_id}/${var.ar_name}/java-app"

      env {
        name = "DATABASE_ADDRESS"
        value = var.db_address
      }
      env {
        name = "DATABASE_PORT"
        value = var.db_port
      }
      env {
        name = "DATABASE_USER"
        value = var.db_user
      }
      env {
        name = "DATABASE_PASSWORD"
        value_source {
          secret_key_ref {
            secret = google_secret_manager_secret.secret_db_password.secret_id
            version = "1"
          }
        }
      }
    }

    vpc_access {
      connector = var.connector
      egress = "ALL_TRAFFIC"
    }
  }

  depends_on = [ google_secret_manager_secret_version.this, google_secret_manager_secret_iam_member.this ]
}

data "google_project" "project" {
}

resource "google_secret_manager_secret" "secret_db_password" {
  secret_id = "secret-db-password"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "this" {
  secret = google_secret_manager_secret.secret_db_password.name
  secret_data = var.db_password
}

resource "google_secret_manager_secret_iam_member" "this" {
  secret_id = google_secret_manager_secret.secret_db_password.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
  depends_on = [google_secret_manager_secret.secret_db_password]
}

resource "google_cloud_run_v2_service_iam_binding" "this" {
  location = google_cloud_run_v2_service.this.location
  name     = google_cloud_run_v2_service.this.name
  role     = "roles/run.invoker"
  members  = [
    "allUsers"
  ]
}

resource "google_compute_region_network_endpoint_group" "serverless_neg" {
  name                  = "serverless-neg"
  network_endpoint_type = "SERVERLESS"
  region                = google_cloud_run_v2_service.this.location
  cloud_run {
    service = google_cloud_run_v2_service.this.name
  }
}