resource "google_storage_bucket" "my-bucket" {
  location = var.region-name
  name     = "sql-dump-test-bucket"
  project = var.wop-project
}

resource "google_storage_bucket_object" "myobject" {
  name   = "dump"
  bucket = google_storage_bucket.my-bucket.name
  source = "C:\\Users\\moham\\Downloads\\test-certificate\\wordpress\\your-database-name.sql"
}
