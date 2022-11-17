
variable "management_subnet" {
    type = string
}

variable "cluster_subnet" {
    type = string
}

variable "cluster_svrole" {
    type = string
} 

variable "vm_svrole" {
    type = string
}

variable "controlplane_cidr" {
    type = string
}

variable "cluster_cidr" {
    type = string
}

variable "service_cidr" {
    type = string
}

variable "work_nodes_no" {
    type = number
}

variable "vm_image" {
    type = string
}
