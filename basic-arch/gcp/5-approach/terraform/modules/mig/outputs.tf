output "instance_group" {
  description = "Instance group to use as backend in LB."
  value       = google_compute_instance_group_manager.this.instance_group
}

output "named_port" {
  description = "Name of the port where distribute traffic."
  value       = one(google_compute_instance_group_manager.this.named_port)["name"]
}