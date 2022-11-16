resource "google_compute_instance" "privatevm" {
  name         = "privatevm"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  tags = ["myinst"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    } 
  }

  network_interface {
    network = google_compute_network.myvpc.id
    subnetwork = google_compute_subnetwork.management_subnet.name
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.vm_service_account.email
    scopes = ["cloud-platform"]
  }

#Installing kubectl and dockercli / Connecting to the cluster and creating two namespaces
  metadata = {                                                    
    startup-script = <<-EOF

    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    sudo apt-get update && sudo apt-get install ca-certificates curl gnupg lsb-release && sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update && sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
    sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin

    EOF
  }
# depends_on --> To wait for the cluster to be created so the last commands in the metadata can work
  # depends_on = [
  #       google_container_cluster.primary
  #   ]
}


resource "google_service_account" "vm_service_account" {
  account_id   = "vm-sa-id"
  display_name = "VM Service Account"
}

resource "google_project_iam_binding" "vm_service_account_iam" {
  project = "neat-talent-367811"
  role    = "roles/container.admin"

  members = [
    "serviceAccount:${google_service_account.vm_service_account.email}",
  ]
}


#  1  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  #   2  sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
  #   3  kubectl version
  #   4  kubectl version --client --output=yaml 
  #   5  sudo apt-get update
  #   6  sudo apt-get install     ca-certificates     curl     gnupg     lsb-release
  #   7  sudo mkdir -p /etc/apt/keyrings
  #   8  curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  #   9  echo   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  # $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  #  10  sudo apt-get update
  #  11  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
  # sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin
  # gcloud container clusters get-credentials my-gke-cluster --region us-central1 --project neat-talent-367811