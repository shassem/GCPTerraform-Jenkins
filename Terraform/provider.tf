provider "google" {
  project = "neat-talent-367811"
  region  = "us-central1"
}

#To let the team work on the same terraform.tfstate file + state locking
#First create a bucket manually from the GUI
terraform {
  backend "gcs" {
    bucket = "shereef-bucket"
    prefix = "terraform/state"
  }
}