output "cluster_id" {
  description = "ID of the GKE cluster."
  value       = google_container_cluster.exafunction.id
}

output "cluster_name" {
  description = "Name of the GKE cluster."
  value       = google_container_cluster.exafunction.name
}

output "cluster_self_link" {
  description = "Th server-defined URL for the GKE cluster."
  value       = google_container_cluster.exafunction.self_link
}
