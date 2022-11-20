variable "management_subnet" {
  type = string
}

variable "cluster_subnet" {
  type = string
}

variable "cluster_svrole" {
  type        = string
  description = "The cluster roles"
}

variable "vm_svrole" {
  type        = string
  description = "The VM roles"
}

variable "controlplane_cidr" {
  type        = string
  description = "CIDR for the GKE Control Plane"
}

variable "cluster_cidr" {
  type        = string
  description = "CIDR for the working nodes"
}

variable "service_cidr" {
  type        = string
  description = "CIDR for the services IPs"
}

variable "work_nodes_no" {
  type        = number
  description = "Number of working nodes in GKE"
}

variable "vm_image" {
  type        = string
  description = "VM Instance OS Image"
}

variable "vmprivateip" {
  type        = string          # Assigned value to be always connected with the cluster even if \                                        
  description = "VM Private IP" # the VM is individually down and up again
}