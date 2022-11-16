resource "google_service_account" "cluster-sv" {
  account_id   = "cluster-sv-id"
  display_name = "Cluster Service Account"
}

resource "google_project_iam_binding" "cluster_service_account_iam" {
  project = "neat-talent-367811"
  role    = "roles/storage.admin"

  members = [
    "serviceAccount:${google_service_account.cluster-sv.email}",
  ]
}

resource "google_container_cluster" "primary" {
  name     = "my-gke-cluster"
  location = "us-central1"

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1
  network = google_compute_network.myvpc.id
  subnetwork = google_compute_subnetwork.restricted_subnet.id

  private_cluster_config {
    enable_private_nodes = true
    enable_private_endpoint = true
    master_ipv4_cidr_block = "172.16.0.0/28"
  }

  ip_allocation_policy {
    cluster_ipv4_cidr_block = "192.168.0.0/21"
    services_ipv4_cidr_block = "192.168.8.0/27"
  }
  # JENKINS
  master_authorized_networks_config {
    cidr_blocks {
        cidr_block = "${google_compute_instance.privatevm.network_interface.0.network_ip}/32"        #Private VM Only / If activated delete dependencies from the instance 
        # cidr_block = "10.0.1.0/24"      #Management Subnet Only 
        display_name = "private-subnet-for-jenkins"
    }
  }

}

resource "google_container_node_pool" "primary_nodes" {
  name       = "my-node-pool"
  cluster    = google_container_cluster.primary.id
  node_count = 1
  max_pods_per_node = 30

  node_config {
    preemptible  = false
    machine_type = "e2-medium"

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.cluster-sv.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
#   management {
#     auto_repair = true
#     auto_upgrade = true
#   }
#   autoscaling {
#     min_node_count = 0
#     max_node_count = 6
#   }

}