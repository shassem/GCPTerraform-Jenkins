resource "google_service_account" "vm_service_account" {
  account_id   = "vm-sa-id"
  display_name = "VM Service Account"
}

resource "google_project_iam_binding" "vm_service_account_iam" {
  project = "neat-talent-367811"
  role    = var.vm_svrole

  members = [
    "serviceAccount:${google_service_account.vm_service_account.email}",
  ]
}

resource "google_service_account" "cluster-sv" {
  account_id   = "cluster-sv-id"
  display_name = "Cluster Service Account"
}

# resource "google_project_iam_binding" "cluster_service_account_iam" {
#   project = "neat-talent-367811"
#   role    = var.cluster_svrole

#   members = [
#     "serviceAccount:${google_service_account.cluster-sv.email}",
#   ]
# }