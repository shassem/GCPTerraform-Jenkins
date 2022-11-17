#Assigning the child modules / Connecting the variables

module "network"{
    source = "./network"
    cluster_subnet=var.cluster_subnet
    management_subnet=var.management_subnet
}