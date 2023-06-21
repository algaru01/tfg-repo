resource "google_sql_database_instance" "this" {
  name             = "my-db-instance"
  
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
}

resource "google_sql_database" "student" {
  name     = "student"
  
  instance = google_sql_database_instance.this.name
}

resource "google_sql_user" "this" {
  name     = var.db_user
  password = var.db_password

  instance = google_sql_database_instance.this.name
}