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
    ssh-keys = "ubuntu:${file("${path.cwd}/test_asg.pub")}"
  }
}

resource "google_compute_instance_group_manager" "this" {
  name = "my-igm"

  version {
    instance_template = google_compute_instance_template.this.id
  }

  target_pools       = [google_compute_target_pool.this.id]
  base_instance_name = "autoscaler-sample"
}

resource "google_compute_autoscaler" "default" {
  name   = "my-autoscaler"
  target = google_compute_instance_group_manager.this.id

  autoscaling_policy {
    max_replicas    = 4
    min_replicas    = 2
    cooldown_period = 60

/*     metric {
      name                       = "pubsub.googleapis.com/subscription/num_undelivered_messages"
      filter                     = "resource.type = pubsub_subscription AND resource.label.subscription_id = our-subscription"
      single_instance_assignment = 65535
    } */
  }
}


resource "google_compute_target_pool" "this" {
  name = "my-target-pool"
}