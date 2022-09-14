output "egress_peering_id" {
  description = "ID of the network peering from Exafunction VPC to peer VPC."
  value       = google_compute_network_peering.exafunction_to_peer.id
}

output "ingress_peering_id" {
  description = "ID of the network peering from peer VPC to Exafunction VPC."
  value       = google_compute_network_peering.peer_to_exafunction.id
}

output "ingress_firewall_id" {
  description = "ID of the firewall rule allowing ingress from peer VPC to Exafunction VPC."
  value       = google_compute_firewall.ingress.id
}

output "ingress_firewall_self_link" {
  description = "URI of the firewall rule allowing ingress from peer VPC to Exafunction VPC."
  value       = google_compute_firewall.ingress.self_link
}
