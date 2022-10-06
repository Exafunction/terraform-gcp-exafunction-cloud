variable "cluster_name" {
  description = "Name of the GKE cluster to create."
  type        = string
  default     = "exafunction-cluster"

  validation {
    condition     = can(regex("^[a-z0-9\\-]+$", var.cluster_name))
    error_message = "Invalid cluster name format."
  }

  validation {
    condition     = length(var.cluster_name) <= 43
    error_message = "Cluster name length must be <= 43."
  }
}

variable "region" {
  description = "Region to create the GKE cluster in."
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC to which the cluster is connected."
  type        = string
}

variable "subnet_name" {
  description = "The name of the subnetwork in which the cluster's instances are launched."
  type        = string
}

variable "pods_secondary_range_name" {
  description = "The name of the secondary range in the subnetwork to use for pod IP addresses."
  type        = string
}

variable "services_secondary_range_name" {
  description = "The name of the secondary range in the subnetwork to use for service IP addresses."
  type        = string
}

variable "runner_pools" {
  description = "Configuration parameters for Exafunction runner node pools."
  type = list(object({
    # Node group suffix.
    suffix = string
    # Machine type to use.
    machine_type = string
    # One of (ON_DEMAND, PREEMPTIBLE, SPOT).
    capacity_type = string
    # Disk size (GB).
    disk_size = number
    # Number of local SSDs to attach.
    local_ssd_count = number
    # Minimum number of nodes per zone.
    min_size = number
    # Maximum number of nodes per zone.
    max_size = number
    # Type of accelerator to attach. If empty, no accelerator is attached.
    accelerator_type = string
    # The number of accelerators to attach.
    accelerator_count = number
    # List of zones for the Exafunction runner node pool. Zones must be within the same region as
    # the cluster. For node pools with attached accelerators, must specify a list of zones where
    # the accelerators are available. If empty, use the default set of zones for the region.
    node_zones = list(string)
    # Additional taints.
    additional_taints = list(object({
      key    = string
      value  = string
      effect = string
    }))
    # Additional labels.
    additional_labels = map(string)
  }))
  default = [{
    suffix            = "gpu"
    machine_type      = "n1-standard-4"
    capacity_type     = "ON_DEMAND"
    disk_size         = 100
    local_ssd_count   = 0
    min_size          = 0
    max_size          = 3
    accelerator_type  = "nvidia-tesla-t4"
    accelerator_count = 1
    node_zones        = ["us-west1-a", "us-west1-b"]
    additional_taints = []
    additional_labels = {}
  }]
  validation {
    condition = alltrue([
      for runner_pool in var.runner_pools : contains(["ON_DEMAND", "PREEMPTIBLE", "SPOT"], runner_pool.capacity_type)
    ])
    error_message = "Capacity type must be one of [ON_DEMAND, PREEMPTIBLE, SPOT]."
  }
}
