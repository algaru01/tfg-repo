resource "google_compute_network" "this" {
  name = "my-vpc"

  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "this" {
  count = length(var.subnets)

  name    = "my-subnet-${count.index}"
  network = google_compute_network.this.self_link

  ip_cidr_range = var.subnets[count.index]
}

module "firewall" {
  source = "./modules/firewall"

  network = google_compute_network.this.self_link

  server_port = var.server_port
}