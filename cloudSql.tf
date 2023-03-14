resource "google_compute_global_address" "private_ip_address" {
  project = var.wop-project
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"          ##### this creates an internal static ip
  prefix_length = 16
  network       = data.google_compute_network.default.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  provider = google-beta
  network                 = data.google_compute_network.default.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}


resource "google_sql_database_instance" "instance" {
  provider = google-beta
  project = var.wop-project
  name             = var.mysql-db-name
  region           = var.region-name
  database_version = "MYSQL_8_0"
   root_password = var.root-pass
  deletion_protection = false

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = "db-f1-micro"
    availability_type = "ZONAL"
    ip_configuration {
      ipv4_enabled                                  = false
      private_network                               = data.google_compute_network.default.id
      enable_private_path_for_google_cloud_services = true
    }
  }
}

resource "google_sql_database" "database" {
  project = var.wop-project
  name     = "wp-db"
  instance = google_sql_database_instance.instance.name
  depends_on = [google_sql_database_instance.instance]
}

resource "google_sql_user" "users" {
  project = var.wop-project
  name     = var.db_user      ######### Should be in an env variable
  instance = google_sql_database_instance.instance.name
  password = var.db_password ######### Should be in an env variable in a TF_VAR_password variable
}