resource "google_compute_network" "this" {
  name = "my-vpc"

  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "this" {
  count = var.subnets != null ? length(var.subnets) : 0

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

resource "google_compute_global_address" "this" {
  name          = "reserved-private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.this.id
}

resource "google_service_networking_connection" "this" {
  network                 = google_compute_network.this.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.this.name]
}

resource "google_compute_subnetwork" "connector" {
  name = "connector-subnet"

  network       = google_compute_network.this.id
  ip_cidr_range = "10.3.0.0/28"

  private_ip_google_access = true
}

resource "google_vpc_access_connector" "connector" {
  name = "vpc-con"

  subnet {
    name = google_compute_subnetwork.connector.name
  }
}

module "firewall" {
  source = "./modules/firewall"

  network = google_compute_network.this.self_link

  server_port = var.server_port
}