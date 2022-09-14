resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "subnet" {
  name          = var.subnet_name
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = var.nodes_ip_range

  secondary_ip_range {
    range_name    = "pod-ip-range"
    ip_cidr_range = var.pods_ip_range
  }

  secondary_ip_range {
    range_name    = "service-ip-range"
    ip_cidr_range = var.services_ip_range
  }
}

resource "google_compute_firewall" "rules" {
  count = var.allow_ssh ? 1 : 0

  name        = "${var.vpc_name}-allow-ssh"
  network     = google_compute_network.vpc.self_link
  description = "Allow SSH to Exafunction instances"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}
