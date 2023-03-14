resource "google_container_cluster" "primary" {
  name             = var.cluster_name
  location         = var.region-name
  project          = var.wop-project
  networking_mode  = "VPC_NATIVE"
  network          = data.google_compute_network.default.self_link
  subnetwork       = google_compute_subnetwork.private-subnet.self_link
  enable_autopilot = true

  addons_config {
    http_load_balancing {
      disabled = false
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
  }
  release_channel {
    channel = "REGULAR"
  }
  private_cluster_config {
    enable_private_endpoint = false                      ### only needed if you use bastion host to connect to the nodes keep false to access from my laptop
    enable_private_nodes    = true                       ####to give private ip's only
    master_ipv4_cidr_block  = var.control_plane_ip_range ### google will manage the control plane by creating a peering connection with my vpc
  }
  ip_allocation_policy {
    cluster_secondary_range_name  = var.secondary_ip_range_name_pods
    services_secondary_range_name = var.secondary_ip_range_name_services
  }
}
