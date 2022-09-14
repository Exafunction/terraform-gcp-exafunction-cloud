provider "google" {
  project = var.project
  region  = var.region
}

module "exafunction_network" {
  source = "./modules/network"

  vpc_name    = "exafunction-vpc-${var.suffix}"
  subnet_name = "exafunction-subnet-${var.suffix}"
  region      = var.region

  nodes_ip_range    = "10.253.0.0/20"
  pods_ip_range     = "10.254.0.0/16"
  services_ip_range = "10.255.0.0/20"

  allow_ssh = true
}

module "exafunction_cluster" {
  source = "./modules/cluster"

  cluster_name = "exafunction-cluster-${var.suffix}"
  region       = var.region

  vpc_name                      = module.exafunction_network.vpc_name
  subnet_name                   = module.exafunction_network.subnet_name
  pods_secondary_range_name     = "pod-ip-range"
  services_secondary_range_name = "service-ip-range"

  runner_pools = [
    {
      suffix            = "cpu"
      machine_type      = "n2-standard-4"
      capacity_type     = "SPOT"
      disk_size         = 100
      min_size          = 1
      max_size          = 2
      accelerator_count = 0
      accelerator_type  = ""
      node_zones        = []
      additional_taints = []
      additional_labels = {}
    },
    {
      suffix            = "gpu"
      machine_type      = "n1-standard-4"
      capacity_type     = "ON_DEMAND"
      disk_size         = 100
      min_size          = 0
      max_size          = 3
      accelerator_count = 1
      accelerator_type  = "nvidia-tesla-t4"
      node_zones        = ["us-west1-a", "us-west1-b"]
      additional_taints = []
      additional_labels = {}
    }
  ]
}

module "exafunction_module_repo_backend" {
  source = "./modules/module_repo_backend"

  exadeploy_id = "exa-mrbe-${var.suffix}"

  vpc_id = module.exafunction_network.vpc_id
  region = "us-west1"

  postgres_version = "POSTGRES_13"
  db_username      = "exafunction"
  db_machine_type  = "db-f1-micro"
}

resource "google_compute_network" "peer_vpc" {
  name                    = "peer-vpc-${var.suffix}"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "peer_subnet" {
  name          = "peer-subnet-${var.suffix}"
  region        = var.region
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

resource "google_compute_firewall" "rules" {
  name        = "${google_compute_network.peer_vpc.name}-allow-ssh"
  network     = google_compute_network.peer_vpc.self_link
  description = "Allow SSH to peer network instances"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

module "exafunction_peering" {
  source = "./modules/peering"

  unique_suffix      = var.suffix
  vpc_self_link      = module.exafunction_network.vpc_self_link
  peer_vpc_self_link = google_compute_network.peer_vpc.self_link
  peer_subnet_ip_ranges = concat([google_compute_subnetwork.peer_subnet.ip_cidr_range],
  google_compute_subnetwork.peer_subnet.secondary_ip_range[*].ip_cidr_range)
}
