output "cloud_sql_address" {
  description = "Address for the CloudSQL instance."
  value       = google_sql_database_instance.default_cloud_sql.private_ip_address
}

output "cloud_sql_instance_name" {
  description = "Name for the CloudSQL instance."
  value       = google_sql_database_instance.default_cloud_sql.name
}

output "cloud_sql_port" {
  description = "Port for the CloudSQL instance."
  value       = 5432
}

output "cloud_sql_username" {
  description = "Username for the CloudSQL instance."
  value       = google_sql_user.cloud_sql_user.name
}

output "cloud_sql_password" {
  description = "Password for the CloudSQL instance."
  sensitive   = true
  value       = google_sql_user.cloud_sql_user.password
}

output "gcs_bucket_name" {
  description = "Name of the GCS bucket."
  value       = google_storage_bucket.module_repository_bucket.name
}

output "gcs_bucket_self_link" {
  description = "The URI for the GCS bucket."
  value       = google_storage_bucket.module_repository_bucket.self_link
}

output "gcs_bucket_url" {
  description = "Base URL of the GCS bucket (gs://<bucket-name>)."
  value       = google_storage_bucket.module_repository_bucket.url
}

output "gcs_service_account_id" {
  description = "ID of the GCS service account."
  value       = google_service_account.gcs.id
}

output "gcs_service_account_name" {
  description = "Name of the GCS service account."
  value       = google_service_account.gcs.name
}

output "gcs_service_account_email" {
  description = "Email address of the GCS service account."
  value       = google_service_account.gcs.email
}

output "gcs_credentials_json" {
  description = "GCP credentials for the GCS service account."
  value       = google_service_account_key.gcs.private_key
  sensitive   = true
}
