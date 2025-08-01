provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

data "google_compute_image" "ubuntu" {
  family  = "ubuntu-2404-lts-amd64"
  project = "ubuntu-os-cloud"
}

resource "google_compute_instance" "sonarqube_instance" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu.self_link
    }
  }

  network_interface {
    access_config {} # assigns a public IP
    network = "default"
  }

  metadata_startup_script = file("sonarqube-setup.sh")

  tags = [var.vm_tag]
}
