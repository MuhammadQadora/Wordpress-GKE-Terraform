data "google_compute_network" "default" {
  name       = "default"
  project    = var.wop-project
  depends_on = [google_project_service.compute-api]
}
### private subnet for the cluster
resource "google_compute_subnetwork" "private-subnet" {
  ip_cidr_range            = var.private_subnet_ip_range
  region                   = var.region-name
  name                     = var.private_subnet_name
  network                  = data.google_compute_network.default.id
  project                  = var.wop-project
  depends_on               = [data.google_compute_network.default]
  private_ip_google_access = true
  secondary_ip_range {
    range_name    = var.secondary_ip_range_name_pods ####ip range that will be assigned to the pods
    ip_cidr_range = var.secondary_ip_range_pods
  }
  secondary_ip_range {
    ip_cidr_range = var.secondary_ip_range_services ##### ip range that will be assigned to the services
    range_name    = var.secondary_ip_range_name_services
  }
}
