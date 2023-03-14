resource "google_compute_router" "router" {
  name    = "my-router"
  region  = google_compute_subnetwork.private-subnet.region
  network = data.google_compute_network.default.id
  project = var.wop-project
}