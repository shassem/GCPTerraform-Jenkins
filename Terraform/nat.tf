resource "google_compute_router" "router" {
  name    = "irouter"
  region  = google_compute_subnetwork.management_subnet.region
  network = google_compute_network.myvpc.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat" {
  name                               = "inat"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

    # subnetwork {
    #     name                    = google_compute_subnetwork.management_subnet.id
    #     source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
    # }
}