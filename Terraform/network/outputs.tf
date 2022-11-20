output "vpc_id" {
  value = google_compute_network.myvpc.id
}

output "management_subnet_id" {
  value = google_compute_subnetwork.management_subnet.id
}
output "restricted_subnet_id" {
  value = google_compute_subnetwork.restricted_subnet.id
}
