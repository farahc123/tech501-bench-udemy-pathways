provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

terraform {
  backend "gcs" {
    bucket = "sparta-terraform-state-bucket"
    prefix = "ansible-controller"
  }
}

data "google_compute_image" "ubuntu" {
  family  = "ubuntu-minimal-2204-lts"
  project = "ubuntu-os-cloud"
}

resource "google_compute_firewall" "ansible_firewall" {
  name    = var.ansible_firewall_name
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }

  source_ranges = var.all_cidr_blocks
  direction     = "INGRESS"
  priority      = 1000
}

resource "google_compute_instance" "ansible_controller" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu.self_link
    }
  }

  network_interface {
    network = "default"
    access_config {} # this allocates a public IP
  }

  metadata_startup_script = file("/scripts/prov-ansible.sh")

  tags = [var.ansible_firewall_name]
}
