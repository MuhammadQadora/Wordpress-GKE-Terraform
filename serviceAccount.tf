#resource "google_service_account" "pod-sa" {
#  account_id = "pod-sa"
#  display_name = "pod-sa"
#  project = var.wop-project
#  depends_on = [google_project_service.compute-api]
#}
#
#resource "google_project_iam_member" "pod-sa" {
#  member  = "serviceAccount:${google_service_account.pod-sa.email}"
#  project = var.wop-project
#  role    = "roles/cloudsql.editor"
#}
#
#resource "google_service_account_iam_member" "assume" {
#  member             = "serviceAccount:${var.wop-project}.svc.id.goog[default/pod-sa]"
#  role               = "roles/iam.workloadIdentityUser"
#  service_account_id = google_service_account.pod-sa.id
#}

resource "google_storage_bucket_iam_member" "viewer" {
  bucket = google_storage_bucket.my-bucket.name
  role   = "roles/storage.objectViewer"  ###### should be VIEWER
  member = "serviceAccount:${google_sql_database_instance.instance.service_account_email_address}"
}


#resource "kubectl_manifest" "pod-sa" {
#  yaml_body = <<YAML
#
#apiVersion: v1
#kind: ServiceAccount
#metadata:
#  annotations:
#    iam.gke.io/gcp-service-account: ${google_service_account.pod-sa.name}@${var.wop-project}.iam.gserviceaccount.com
#  name: pod-sa
#YAML
#}