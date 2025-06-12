resource "google_compute_network" "sparta_vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "public" {
  name          = "public-subnet"
  ip_cidr_range = var.public_subnet_cidr
  region        = var.region
  network       = google_compute_network.sparta_vpc.id
}

resource "google_compute_subnetwork" "private" {
  name          = "private-subnet"
  ip_cidr_range = var.private_subnet_cidr
  region        = var.region
  network       = google_compute_network.sparta_vpc.id
}

resource "google_compute_route" "default_internet" {
  name                   = "default-internet-route"
  next_hop_gateway       = "default-internet-gateway"
  network                = google_compute_network.sparta_vpc.name
  dest_range      = "0.0.0.0/0"
  priority               = 1000
}