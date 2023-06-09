resource "google_cloud_run_v2_service" "products" {
  name     = "products-cloudrun-service"
  location = var.location
  ingress  = "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"


  template {
    containers {
      image = "${var.location}-docker.pkg.dev/${var.project_id}/${var.ar_name}/products-micro"

      resources {
        cpu_idle = false
      }

      ports {
        container_port = var.products_port
      }

      env {
        name  = "DATABASE_ADDRESS"
        value = var.db_address
      }
      env {
        name  = "DATABASE_PORT"
        value = var.db_port
      }
      env {
        name  = "DATABASE_USER"
        value = var.db_user
      }
      env {
        name = "DATABASE_PASSWORD"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.secret_db_password.secret_id
            version = "1"
          }
        }
      }
      env {
        name  = "AUTH_URL"
        value = google_cloud_run_v2_service.auth.uri
      }
    }

    vpc_access {
      connector = var.connector
      egress    = "ALL_TRAFFIC"
    }
  }

  depends_on = [google_secret_manager_secret_version.this, google_secret_manager_secret_iam_member.this]
}

resource "google_cloud_run_v2_service" "auth" {
  name     = "auth-cloudrun-service"
  location = var.location
  ingress  = "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"

  template {
    containers {
      image = "${var.location}-docker.pkg.dev/${var.project_id}/${var.ar_name}/auth-micro"

      resources {
        cpu_idle = false
      }

      ports {
        container_port = var.auth_port
      }

      env {
        name  = "DATABASE_ADDRESS"
        value = var.db_address
      }
      env {
        name  = "DATABASE_PORT"
        value = var.db_port
      }
      env {
        name  = "DATABASE_USER"
        value = var.db_user
      }
      env {
        name = "DATABASE_PASSWORD"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.secret_db_password.secret_id
            version = "1"
          }
        }
      }
    }

    vpc_access {
      connector = var.connector
      egress    = "ALL_TRAFFIC"
    }
  }

  depends_on = [google_secret_manager_secret_version.this, google_secret_manager_secret_iam_member.this]
}

resource "google_secret_manager_secret" "secret_db_password" {
  secret_id = "secret-db-password"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "this" {
  secret      = google_secret_manager_secret.secret_db_password.name
  secret_data = var.db_password
}

data "google_project" "this" {
}

resource "google_secret_manager_secret_iam_member" "this" {
  secret_id  = google_secret_manager_secret.secret_db_password.id
  role       = "roles/secretmanager.secretAccessor"
  member     = "serviceAccount:${data.google_project.this.number}-compute@developer.gserviceaccount.com"
  depends_on = [google_secret_manager_secret.secret_db_password]
}

resource "google_cloud_run_v2_service_iam_binding" "products" {
  location = google_cloud_run_v2_service.products.location
  name     = google_cloud_run_v2_service.products.name
  role     = "roles/run.invoker"
  members = [
    "allUsers"
  ]
}

resource "google_cloud_run_v2_service_iam_binding" "auth" {
  location = google_cloud_run_v2_service.auth.location
  name     = google_cloud_run_v2_service.auth.name
  role     = "roles/run.invoker"
  members = [
    "allUsers"
  ]
}

resource "google_compute_region_network_endpoint_group" "products" {
  name                  = "pr-serverless-neg"
  network_endpoint_type = "SERVERLESS"
  region                = google_cloud_run_v2_service.products.location
  cloud_run {
    service = google_cloud_run_v2_service.products.name
  }
}

resource "google_compute_region_network_endpoint_group" "auth" {
  name                  = "serverless-neg"
  network_endpoint_type = "SERVERLESS"
  region                = google_cloud_run_v2_service.auth.location
  cloud_run {
    service = google_cloud_run_v2_service.auth.name
  }
}