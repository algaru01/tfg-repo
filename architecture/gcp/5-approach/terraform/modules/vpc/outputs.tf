output "public_subnets" {
  description = "List of public subnets."
  value       = google_compute_subnetwork.this[*].self_link
}

output "vpc" {
  description = "ID of the VPC created."
  value       = google_compute_network.this.id
}

output "connector" {
  description = ""
  value       = google_vpc_access_connector.connector.id
}