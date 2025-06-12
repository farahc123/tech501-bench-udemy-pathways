data "google_compute_image" "ubuntu" {
  family  = "ubuntu-minimal-2204-lts"
  project = "ubuntu-os-cloud"
}

resource "google_compute_firewall" "app_vm_firewall" {
  name    = var.firewall_name
  network = var.network

  direction    = "INGRESS"
  priority     = 1000
  target_tags  = ["app"]

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "3000"]
  }

  source_ranges = ["0.0.0.0/0"]
}


resource "google_compute_health_check" "app_health_check" {
  name                = "${var.app_instance_name}-hc"
  check_interval_sec  = 30
  timeout_sec         = 10
  healthy_threshold   = 3
  unhealthy_threshold = 3

  http_health_check {
    port         = 80
    request_path = "/"
  }
}

resource "google_compute_instance_template" "app_template" {
  name_prefix  = "${var.app_instance_name}-template-"
  machine_type = var.machine_type

  disk {
    boot         = true
    auto_delete  = true
    source_image = data.google_compute_image.ubuntu.self_link
  }

  network_interface {
    subnetwork    = var.subnet_name
    access_config {} # ephemeral public IP
  }

  tags = ["app"]

}

resource "google_compute_region_instance_group_manager" "app_mig" {
  name               = "${var.app_instance_name}-mig"
  region             = var.region
  base_instance_name = var.app_instance_name

  version {
    instance_template = google_compute_instance_template.app_template.self_link
  }

  target_size = var.mig_target_size

  auto_healing_policies {
    health_check      = google_compute_health_check.app_health_check.self_link
    initial_delay_sec = 300
  }

  named_port {
    name = "http"
    port = 80
  }
}

resource "google_compute_region_autoscaler" "app_autoscaler" {
  name   = "${var.app_instance_name}-autoscaler"
  region = var.region
  target = google_compute_region_instance_group_manager.app_mig.id

  autoscaling_policy {
    min_replicas    = var.min_replicas
    max_replicas    = var.max_replicas
    cooldown_period = 60

    cpu_utilization {
      target = 0.6
    }
  }
}


