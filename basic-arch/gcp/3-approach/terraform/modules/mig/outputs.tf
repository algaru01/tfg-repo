output "instance_group" {
  description = "Group of instances created."
  value       = google_compute_instance_group_manager.this.instance_group
}