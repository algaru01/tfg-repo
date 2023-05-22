output "network_endpoint_group_id" {
  description = "Id of the network enpoint group that contains this container."
  value = google_compute_region_network_endpoint_group.serverless_neg.id
}