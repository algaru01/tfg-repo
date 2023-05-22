output "jumpbox_address" {
  description = "Address of the jumpbox host."
  value       = google_compute_instance.jumpbox_host.network_interface[0].access_config[0].nat_ip
}