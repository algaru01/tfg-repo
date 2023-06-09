resource "google_sql_database" "this" {
  name     = "my-db"
  instance = google_sql_database_instance.this.name

}

resource "google_sql_database" "student" {
  name     = "student"
  instance = google_sql_database_instance.this.name
}

resource "google_compute_global_address" "this" {
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = var.vpc
}

resource "google_service_networking_connection" "this" {
  network                 = var.vpc
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.this.name]
}

resource "google_sql_database_instance" "this" {
  name             = "my-db-instance"
  database_version = "POSTGRES_13"

  settings {
    tier = "db-g1-small"

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.vpc
      //enable_private_path_for_google_cloud_services = true
    }
  }

  root_password = "password" //Var

  deletion_protection = false

  depends_on = [google_service_networking_connection.this]
}

resource "google_sql_user" "this" {
  name     = var.db_user
  instance = google_sql_database_instance.this.name
  password = var.db_password
}