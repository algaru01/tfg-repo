resource "google_sql_database" "this" {
  name     = "my-db"
  instance = google_sql_database_instance.this.name
}

resource "google_sql_database_instance" "this" {
  name             = "my-db-instance"
  database_version = "POSTGRES_13"

  settings {
    # Second-generation instance tiers are based on the machine
    # type. See argument reference below.
    tier = "db-f1-micro"
/*     ip_configuration {
      ipv4_enabled = false
      private_network = var.private_network
    } */
  }

  root_password = "password"

  deletion_protection = false
}

resource "google_sql_user" "this" {
  name     = "usuario"
  instance = google_sql_database_instance.this.name
  password = "password"
}