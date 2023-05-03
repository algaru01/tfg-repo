resource "google_compute_forwarding_rule" "this" {
  name = "website-forwarding-rule"

  backend_service = google_compute_region_backend_service.this.self_link

  ip_protocol = "TCP"
  ip_address  = google_compute_address.this.self_link
  port_range  = var.check_port
}

resource "google_compute_region_health_check" "this" {
  name                = "autohealing-health-check"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10


  http_health_check {
    request_path = "/"
    port         = var.check_port
  }
}

resource "google_compute_region_backend_service" "this" {
  name                  = "my-lb-backend-service"
  load_balancing_scheme = "EXTERNAL"
  health_checks         = [google_compute_region_health_check.this.id]

  port_name   = "http"
  protocol    = "TCP"
  timeout_sec = 10

  backend {
    group = var.instance_group_backend
  }
}




resource "google_compute_address" "this" {
  name         = "my-lb-ip"
  address_type = "EXTERNAL"
}