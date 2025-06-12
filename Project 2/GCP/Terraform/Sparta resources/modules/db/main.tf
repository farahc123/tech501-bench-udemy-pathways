resource "google_compute_firewall" "db_vm_firewall" {
  name    = var.firewall_name
  network = var.network

  allow {
    protocol = "tcp"
    ports    = ["22", "27017"]
  }

  source_ranges = var.source_ranges
  direction     = "INGRESS"
  priority      = 1000

  target_tags = [var.vm_tag]
}

resource "google_compute_instance" "db_instance" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    subnetwork    = var.subnetwork
    access_config {} # gives it a public IP
  }

  tags = [var.vm_tag]
}
