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
    access_config {} # gives it a public IP
  }

  tags = [var.vm_tag]
}
