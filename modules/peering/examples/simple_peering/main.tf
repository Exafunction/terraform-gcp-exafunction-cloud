provider "google" {
  project = "exafunction"
  region  = "us-west1"
}

resource "google_compute_network" "exafunction_vpc" {
  name                    = "exafunction-vpc-simple"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "exafunction_subnet" {
  name          = "exafunction-subnet-simple"
  region        = "us-west1"
  network       = google_compute_network.exafunction_vpc.name
  ip_cidr_range = "10.253.0.0/20"

  secondary_ip_range {
    range_name    = "pod-ip-range"
    ip_cidr_range = "10.254.0.0/16"
  }

  secondary_ip_range {
    range_name    = "service-ip-range"
    ip_cidr_range = "10.255.0.0/20"
  }
}

resource "google_compute_network" "peer_vpc" {
  name                    = "peer-vpc-simple"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "peer_subnet" {
  name          = "peer-subnet-simple"
  region        = "us-west1"
  network       = google_compute_network.peer_vpc.name
  ip_cidr_range = "10.0.0.0/20"

  secondary_ip_range {
    range_name    = "pod-ip-range"
    ip_cidr_range = "10.1.0.0/16"
  }

  secondary_ip_range {
    range_name    = "service-ip-range"
    ip_cidr_range = "10.2.0.0/20"
  }
}

module "exafunction_peering" {
  source = "../.."

  unique_suffix      = "simple"
  vpc_self_link      = google_compute_network.exafunction_vpc.self_link
  peer_vpc_self_link = google_compute_network.peer_vpc.self_link
  peer_subnet_ip_ranges = concat([google_compute_subnetwork.peer_subnet.ip_cidr_range],
  google_compute_subnetwork.peer_subnet.secondary_ip_range[*].ip_cidr_range)
}
