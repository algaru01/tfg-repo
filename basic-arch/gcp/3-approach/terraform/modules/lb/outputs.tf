output "lb_address" {
  description = "Address of the load balancer."
  value       = google_compute_address.this.address
}