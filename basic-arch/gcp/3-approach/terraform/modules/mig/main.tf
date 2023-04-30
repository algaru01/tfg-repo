data "google_service_account" "this" {
  account_id   = var.service_email //"terraform@basic-arch-384210.iam.gserviceaccount.com"
}

resource "google_compute_instance_template" "this" {
  name           = "my-instance-template"
  machine_type   = "e2-micro"

  disk {
    source_image = "ubuntu-os-cloud/ubuntu-1804-lts"
  }

  network_interface {
    subnetwork = var.subnet
    access_config {
    }
  }

  metadata_startup_script = templatefile("${path.cwd}/../scripts/init-script.sh", {server_port = var.server_port})

  metadata = {
    ssh-keys = "ubuntu:${file("${path.cwd}/../../ssh-keys/gcp_keys.pub")}"
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = data.google_service_account.this.email
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_instance_group_manager" "this" {
  name = "my-igm"

  version {
    instance_template = google_compute_instance_template.this.id
  }

  base_instance_name = "autoscaler-sample"

  auto_healing_policies {
    health_check      = google_compute_health_check.this.id
    initial_delay_sec = 300
  }

}

resource "google_compute_autoscaler" "default" {
  name   = "my-autoscaler"
  target = google_compute_instance_group_manager.this.id

  autoscaling_policy {
    max_replicas    = 4
    min_replicas    = 2
    cooldown_period = 60
  }
}

resource "google_compute_health_check" "this" {
  name                = "autohealing-health-check"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10 # 50 seconds

  http_health_check {
    request_path = "/"
    port         = var.server_port
  }
}