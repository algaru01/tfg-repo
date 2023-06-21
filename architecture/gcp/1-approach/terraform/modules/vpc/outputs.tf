output "subnets" {
  description = "List of subnets created."
  value       = google_compute_subnetwork.this[*].self_link
}