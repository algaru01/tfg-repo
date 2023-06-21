output "db_address" {
  description = "Private IP address of the database."
  value       = google_sql_database_instance.this.private_ip_address
}