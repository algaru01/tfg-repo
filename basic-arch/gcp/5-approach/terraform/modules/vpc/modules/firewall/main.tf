resource "google_compute_firewall" "allow_server_port" {
  name    = "allow-web-server"
  network = var.network

  direction = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = [var.server_port]
  }
  source_ranges = ["0.0.0.0/0"]
  destination_ranges = [ var.lb_address ]
}

resource "google_compute_firewall" "allow_ssh_to_jumpbox" {
  name    = "allow-ssh-to-jumpbox"
  network = var.network

  direction = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = [22]
  }

  source_ranges = ["0.0.0.0/0"]
  //destination_ranges = [ var.jumpbox_address ]
}

resource "google_compute_firewall" "allow_icmp" {
  name    = "allow-icmp"
  network = var.network

  allow { protocol = "icmp" }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow_internal_traffic" {
  name    = "allow-internal-traffic"
  network = var.network

  allow { protocol = "tcp" }
  allow { protocol = "udp" }
  allow { protocol = "icmp" }
  source_ranges = ["10.128.0.0/9"]
}