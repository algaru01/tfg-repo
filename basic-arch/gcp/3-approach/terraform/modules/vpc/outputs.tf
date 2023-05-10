output "public_subnets" {
  description = "List of public subnets."
  value       = google_compute_subnetwork.public[*].self_link
}

output "proxy_subnet" {
  value =google_compute_subnetwork.proxy.id
}

output "vpc" {
  value = google_compute_network.this.id
}