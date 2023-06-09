resource "google_compute_forwarding_rule" "this" {
  name = "my-lb-forwarding-rule"

  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "8080"
  target                = google_compute_region_target_http_proxy.this.id
  network               = var.vpc
  ip_address            = google_compute_address.this.self_link
  network_tier          = "STANDARD"
}

resource "google_compute_region_target_http_proxy" "this" {
  name = "my-lb-proxy"

  url_map = google_compute_region_url_map.this.id
}

resource "google_compute_region_url_map" "this" {
  name = "my-lb-url-map"

  host_rule {
    hosts = ["*"]

    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = google_compute_region_backend_service.products.id

    path_rule {
      paths   = ["/api/v1/products/*"]
      service = google_compute_region_backend_service.products.id
    }

    path_rule {
      paths   = ["/api/v1/auth/*"]
      service = google_compute_region_backend_service.auth.id
    }
  }

  default_service = google_compute_region_backend_service.products.id
}

resource "google_compute_region_backend_service" "products" {
  name                  = "my-lb-products-backend-service"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  //health_checks         = [google_compute_region_health_check.this.id]

  //port_name   = "server-port"
  protocol = "HTTP"
  //timeout_sec = 10

  backend {
    group           = var.products_backend_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }
}

resource "google_compute_region_backend_service" "auth" {
  name                  = "my-lb-auth-backend-service"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  //health_checks         = [google_compute_region_health_check.this.id]

  //port_name   = "server-port"
  protocol = "HTTP"
  //timeout_sec = 10

  backend {
    group           = var.auth_backend_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }
}

/* resource "google_compute_region_health_check" "this" {
  name                = "my-lb-health-check"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10


  http_health_check {
    request_path = "/"
    port         = var.check_port
  }
} */

resource "google_compute_address" "this" {
  name         = "my-lb-public-ip"
  address_type = "EXTERNAL"
  network_tier = "STANDARD"
}