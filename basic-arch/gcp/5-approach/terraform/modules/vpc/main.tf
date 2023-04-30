resource "google_compute_network" "this" {
  name = "my-vpc"

  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "public" {
  count = var.public_subnets != null ? length(var.public_subnets) : 0

  name    = "my-public-subnet-${count.index}"
  network = google_compute_network.this.self_link

  ip_cidr_range = var.public_subnets[count.index]
}

module "firewall" {
  source = "./modules/firewall"

  network = google_compute_network.this.self_link

  server_port = var.server_port
  lb_address = var.lb_address
  jumpbox_address = var.jumpbox_address
}