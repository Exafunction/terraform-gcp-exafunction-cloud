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

module "exafunction_module_repo_backend" {
  source = "../../"

  vpc_id = google_compute_network.vpc.id
  region = "us-west1"

  exadeploy_id = "exafunction-mrbe-simple"

  postgres_version = "POSTGRES_13"
  db_username      = "test_user"
  db_machine_type  = "db-f1-micro"
  db_flags = [{
    name  = "max_connections"
    value = "100"
  }]
}
