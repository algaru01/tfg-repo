resource "google_project_service" "this" {
  count = length(var.services)

  service = var.services[count.index]

  disable_dependent_services = false
  disable_on_destroy         = false
}