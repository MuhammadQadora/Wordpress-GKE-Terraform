##### to avoid referencing credentials i chose to apply them through gcloud
##### notice that a project resource was greyed out since it caused me to create a new project with each destroy command

provider "google" {
}


##### to interact with the cluster
data "google_client_config" "provider" {
}

####### though using kubectl provider i chose to keep kubernetes provider as well
###### the reason for creating the kubectl is to use manifest.
##### kubernetes provider does not allow for manifest creation before the cluster is up and running.


provider "kubernetes" {
  host  = "https://${google_container_cluster.primary.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    google_container_cluster.primary.master_auth[0].cluster_ca_certificate,
  )
}


terraform {
  required_version = ">= 0.13"

  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

provider "kubectl" {
  host  = "https://${google_container_cluster.primary.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    google_container_cluster.primary.master_auth[0].cluster_ca_certificate,
  )
  load_config_file = false
}

