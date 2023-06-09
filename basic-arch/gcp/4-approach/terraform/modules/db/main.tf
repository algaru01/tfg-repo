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
  name             = "my-db-instance2"
  database_version = "POSTGRES_13"


  settings {
    tier      = "db-f1-micro"
    disk_size = 10

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.vpc
    }
  }

  root_password = "password"

  deletion_protection = false

  depends_on = [google_service_networking_connection.this]
}

resource "google_sql_user" "this" {
  name     = var.db_user
  instance = google_sql_database_instance.this.name
  password = var.db_password
}