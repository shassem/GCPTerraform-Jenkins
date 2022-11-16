resource "google_compute_firewall" "allow_ssh" {
  name        = "allow-ssh"
  network     = google_compute_network.myvpc.id
  description = "Creates firewall rule to allow ssh and HTTP"
  direction = "INGRESS"
  source_ranges = ["35.235.240.0/20"]

  allow {
    protocol  = "tcp"
    ports     = ["22", "80"]
  }

#   source_tags = ["myinst"]
}

# resource "google_compute_firewall" "deny_internet" {
#   name        = "stop-internet"
#   network     = google_compute_network.myvpc.id
#   description = "Creates firewall rule to disallow internet access"
#   direction = "EGRESS"
#   destination_ranges = ["0.0.0.0/0"]

#   deny {
#     protocol  = "all"
#   }

# #   target_tags = ["web"]
# }

# resource "google_compute_firewall" "allow_internet" {
#   name        = "internet-for-vm"
#   network     = google_compute_network.myvpc.id
#   description = "Creates firewall rule to allow internet access for the VM"
#   direction = "EGRESS"
#   priority = "800"
#   destination_ranges = ["0.0.0.0/0"]

#   allow {
#     protocol  = "tcp"
#     ports     = ["22"]
#   }

#   target_tags = ["myinst"]
# }