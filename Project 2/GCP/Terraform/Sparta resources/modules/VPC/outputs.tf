output "vpc_name" {
  value = google_compute_network.sparta_vpc.name
}

output "public_subnet_name" {
  value = google_compute_subnetwork.public.name
}
