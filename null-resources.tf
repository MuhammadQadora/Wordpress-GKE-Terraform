
resource "null_resource" "uplaod-to-wp" {
  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${google_container_cluster.primary.name} --region ${var.region-name} --project ${var.wop-project}"
  }
  depends_on = [null_resource.import_db]
}


resource "null_resource" "import_db" {
  provisioner "local-exec" {
    command = "gcloud sql import sql ${google_sql_database_instance.instance.name} gs://${google_storage_bucket.my-bucket.name}/${google_storage_bucket_object.myobject.name} --database=${google_sql_database.database.name}"
  }
  depends_on = [google_storage_bucket_iam_member.viewer,google_project_service.sql-admin]
}

#resource "null_resource" "wp-cli" {
#  provisioner "local-exec" {
#    command = "kubectl exec $(kubectl get pods -o jsonpath='{range.items[0]}{@.metadata.name}{end}') -- wp search-replace http://localhost http://${kubernetes_service.test.status.0.load_balancer.0.ingress.0.ip} --allow-root "
#  }
#}