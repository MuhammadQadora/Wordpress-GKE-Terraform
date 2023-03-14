variable "region-name" {
  type    = string
  default = "us-west1"
}

variable "zone-name" {
  type    = string
  default = "us-west1-a"
}

variable "wop-project" {
  type    = string
  default = "wideopsproject-379714"
}

variable "apis" {
  type    = list(string)
  default = ["file.googleapis.com","container.googleapis.com", "compute.googleapis.com", "iam.googleapis.com", "networkmanagement.googleapis.com", "certificatemanager.googleapis.com", "servicenetworking.googleapis.com"]
}

variable "private_subnet_ip_range" {
  type    = string
  default = "10.11.0.0/16"
}
variable "private_subnet_name" {
  type    = string
  default = "private-subnet-2"
}

variable "cluster_name" {
  type    = string
  default = "wop-cluster"
}
variable "control_plane_ip_range" {
  type    = string
  default = "172.16.0.0/28"
}

variable "main-node-name" {
  type    = string
  default = "main-node"
}
variable "disk_size" {
  type    = number
  default = 100
}

variable "primary_ip_subnet_range" {
  type    = string
  default = "10.0.0.0/16"
}
variable "secondary_ip_range_name_pods" {
  type    = string
  default = "k8s-pods"
}
variable "secondary_ip_range_name_services" {
  type    = string
  default = "k8s-services"
}

variable "secondary_ip_range_pods" {
  type    = string
  default = "10.30.0.0/17"
}


variable "secondary_ip_range_services" {
  type    = string
  default = "10.31.0.0/18"
}

variable "mysql-db-name" {
  type = string
  default = "mysql-instance"
}

variable "root-pass" {
  type = string ########## this should be an env variable
  default = "root"
}

variable "path-to-wp" {
  type = string
  default = "./word-press"
}

variable "db_user" {
  type = string
  sensitive = true
}

variable "db_password" {
  type = string
  sensitive = true
}