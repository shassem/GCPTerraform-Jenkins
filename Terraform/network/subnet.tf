resource "google_compute_subnetwork" "restricted_subnet" {
  name          = "clust-sub"
  ip_cidr_range = var.cluster_subnet
  region        = "us-central1"
  network       = google_compute_network.myvpc.id

}


resource "google_compute_subnetwork" "management_subnet" {
  name          = "mng-sub"
  ip_cidr_range = var.management_subnet
  region        = "us-central1"
  network       = google_compute_network.myvpc.id

}