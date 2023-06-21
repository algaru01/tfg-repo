output "subnets" {
  description = "List of public subnets."
  value       = google_compute_subnetwork.this[*].self_link
}

output "vpc" {
  description = "ID of the VPC created."
  value       = google_compute_network.this.id
}