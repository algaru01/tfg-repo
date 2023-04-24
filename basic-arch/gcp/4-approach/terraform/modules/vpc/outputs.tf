output "public_subnets" {
  description = "List of public subnets."
  value       = google_compute_subnetwork.public[*].self_link
}

output "public_subnets_url" {
  description = "List of public subnets."
  value       = google_compute_subnetwork.public[*].id
}