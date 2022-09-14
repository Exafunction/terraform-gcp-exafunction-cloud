provider "google" {
  project = "exafunction"
  region  = "us-west1"
}

module "exafunction_network" {
  source = "../../"

  vpc_name    = "exafunction-vpc-simple"
  subnet_name = "exafunction-subnet-simple"
  region      = "us-west1"

  nodes_ip_range    = "10.0.0.0/20"
  pods_ip_range     = "10.1.0.0/16"
  services_ip_range = "10.2.0.0/20"

  allow_ssh = true
}
