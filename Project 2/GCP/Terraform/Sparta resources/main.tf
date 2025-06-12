provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

terraform {
  backend "gcs" {
    bucket = "sparta-app-terraform-state"
    prefix = "sparta-app-resources"
  }
}

data "google_compute_image" "ubuntu" {
  family  = "ubuntu-minimal-2204-lts"
  project = "ubuntu-os-cloud"
}

module "VPC" {
  source              = "./modules/VPC"
  vpc_name            = var.vpc_name
  region              = var.region
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
}

module "db" {
  source        = "./modules/db"
  firewall_name = "db-vm-firewall"
  network       = module.VPC.vpc_name           # output from VPC module
  subnetwork    = module.VPC.public_subnet_name # output from VPC module
  zone          = var.zone
  instance_name = "db-vm"
  machine_type  = "e2-medium"
  image         = data.google_compute_image.ubuntu.self_link
}
module "asg" {
  source      = "./modules/asg"
  network = var.vpc_name
  machine_type = var.machine_type
  region      = var.region
  subnet_name = module.VPC.public_subnet_name # output from VPC module
}