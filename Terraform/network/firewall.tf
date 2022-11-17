resource "google_compute_firewall" "allow_ssh" {
  name        = "allow-ssh"
  network     = google_compute_network.myvpc.id
  description = "Creates firewall rule to allow ssh and HTTP"
  direction = "INGRESS"
  source_ranges = ["35.235.240.0/20"]       #IAP CIDR

  allow {
    protocol  = "tcp"
    ports     = ["22", "80"]
  }

#   source_tags = ["myinst"]
}