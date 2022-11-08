provider "google" {
  project = "exafunction"
  region  = "us-west1"
}

resource "google_compute_network" "vpc" {
  name                    = "exafunction-vpc-simple"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "subnet" {
  name          = "exafunction-subnet-simple"
  region        = "us-west1"
  network       = google_compute_network.vpc.name
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

module "exafunction_cluster" {
  source = "../.."

  cluster_name = "exafunction-cluster-simple"
  region       = "us-west1"

  vpc_name                      = google_compute_network.vpc.name
  subnet_name                   = google_compute_subnetwork.subnet.name
  pods_secondary_range_name     = "pod-ip-range"
  services_secondary_range_name = "service-ip-range"

  runner_pools = [
    {
      suffix            = "cpu"
      machine_type      = "n2-standard-4"
      capacity_type     = "SPOT"
      disk_size         = 100
      local_ssd_count   = 0
      min_size          = 1
      max_size          = 2
      accelerator_count = 0
      accelerator_type  = ""
      node_zones        = []
      additional_taints = [{
        key    = "test-taint"
        value  = "exafunction-taint-cpu"
        effect = "NO_SCHEDULE"
      }]
      additional_labels = {
        "test-label" = "exafunction-label-cpu"
      }
      enable_gvnic = false
    },
    {
      suffix            = "gpu"
      machine_type      = "n1-standard-4"
      capacity_type     = "ON_DEMAND"
      disk_size         = 100
      local_ssd_count   = 1
      min_size          = 0
      max_size          = 3
      accelerator_count = 1
      accelerator_type  = "nvidia-tesla-t4"
      node_zones        = ["us-west1-a", "us-west1-b"]
      additional_taints = [{
        key    = "test-taint"
        value  = "exafunction-taint-gpu"
        effect = "NO_SCHEDULE"
      }]
      additional_labels = {
        "test-label" = "exafunction-label-gpu"
      }
      enable_gvnic = true
    }
  ]
}
