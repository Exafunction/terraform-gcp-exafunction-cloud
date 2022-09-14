###############################################################################
# CloudSQL                                                                    #
###############################################################################

resource "google_compute_global_address" "cloud_sql_address" {
  name          = "cloud-sql-address-${var.exadeploy_id}"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 20
  network       = var.vpc_id
}

resource "google_service_networking_connection" "cloud_sql_connection" {
  network                 = var.vpc_id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.cloud_sql_address.name]
}

resource "google_sql_database_instance" "default_cloud_sql" {
  depends_on = [google_service_networking_connection.cloud_sql_connection]

  name                = "cloud-sql-${var.exadeploy_id}"
  database_version    = var.postgres_version
  region              = var.region
  deletion_protection = false

  settings {
    tier = var.db_machine_type
    ip_configuration {
      ipv4_enabled       = false
      private_network    = var.vpc_id
      allocated_ip_range = google_compute_global_address.cloud_sql_address.name
    }
  }
}

resource "random_password" "cloud_sql_password" {
  length           = 64
  special          = true
  override_special = "!#$%^&*()-_=+[]{}<>:?"
}

resource "google_sql_user" "cloud_sql_user" {
  name     = var.db_username
  instance = google_sql_database_instance.default_cloud_sql.name
  password = random_password.cloud_sql_password.result
}

###############################################################################
# GCS                                                                         #
###############################################################################

resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "google_storage_bucket" "module_repository_bucket" {
  name          = "module-repo-${var.exadeploy_id}-${random_string.bucket_suffix.result}"
  location      = var.region
  force_destroy = true

  uniform_bucket_level_access = true
}

resource "google_service_account" "gcs" {
  account_id   = "gcs-sa-${var.exadeploy_id}"
  display_name = "Service Account to access GCS"
}

resource "google_service_account_key" "gcs" {
  service_account_id = google_service_account.gcs.name
}

resource "google_storage_bucket_iam_member" "service_account_member" {
  bucket = google_storage_bucket.module_repository_bucket.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.gcs.email}"
}
