output "products_network_endpoint_group_id" {
  description = "Id of the products network enpoint group that contains the prodcut container."
  value = google_compute_region_network_endpoint_group.products.id
}

output "auth_network_endpoint_group_id" {
  description = "Id of the auth network enpoint group that contains the auth container."
  value = google_compute_region_network_endpoint_group.auth.id
}