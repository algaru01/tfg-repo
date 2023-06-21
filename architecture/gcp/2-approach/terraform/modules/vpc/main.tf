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

resource "google_compute_subnetwork" "proxy" {
  count = var.proxy_subnets != null ? length(var.proxy_subnets) : 0

  name          = "my-proxy-subnet-${count.index}"
  ip_cidr_range = var.proxy_subnets[count.index]
  network       = google_compute_network.this.id
  purpose       = "REGIONAL_MANAGED_PROXY"
  role          = "ACTIVE"
}

module "firewall" {
  source = "./modules/firewall"

  network = google_compute_network.this.self_link

  server_port = var.server_port
}