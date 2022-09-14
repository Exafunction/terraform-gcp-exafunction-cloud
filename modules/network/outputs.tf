output "vpc_id" {
  description = "ID of the created VPC."
  value       = google_compute_network.vpc.id
}

output "vpc_name" {
  description = "Name of the created VPC."
  value       = google_compute_network.vpc.name
}

output "vpc_self_link" {
  description = "The URI of the created VPC."
  value       = google_compute_network.vpc.self_link
}

output "region" {
  description = "Region of the created subnet."
  value       = google_compute_subnetwork.subnet.region
}

output "subnet_id" {
  description = "ID of the created subnet."
  value       = google_compute_subnetwork.subnet.id
}

output "subnet_name" {
  description = "Name of the created subnet."
  value       = google_compute_subnetwork.subnet.name
}

output "subnet_self_link" {
  description = "The URI of the created subnet."
  value       = google_compute_subnetwork.subnet.self_link
}

output "pods_secondary_range_name" {
  description = "Name of the secondary IP range in the subnet for pods."
  value       = google_compute_subnetwork.subnet.secondary_ip_range[0].range_name
}

output "services_secondary_range_name" {
  description = "Name of the secondary IP range in the subnet for services."
  value       = google_compute_subnetwork.subnet.secondary_ip_range[1].range_name
}
