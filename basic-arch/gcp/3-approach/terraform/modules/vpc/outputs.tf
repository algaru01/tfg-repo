output "public_subnets" {
  description = "List of public subnets."
  value       = google_compute_subnetwork.public[*].self_link
}