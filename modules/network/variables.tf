variable "vpc_name" {
  description = "Name of VPC to create."
  type        = string
  default     = "exafunction-vpc"

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\-]{3,63}$", var.vpc_name))
    error_message = "Invalid VPC name format."
  }
}

variable "subnet_name" {
  description = "Name of subnet to create."
  type        = string
  default     = "exafunction-subnet"

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\-]{3,63}$", var.subnet_name))
    error_message = "Invalid subnet name format."
  }
}

variable "region" {
  description = "Region for subnet."
  type        = string

  validation {
    condition     = can(regex("^[a-z]+-[a-z]+[0-9]$", var.region))
    error_message = "Invalid GCP region format."
  }
}

variable "nodes_ip_range" {
  description = "Primary IP address range for for the subnet to be used for all GKE node IP addresses."
  type        = string
  default     = "10.0.0.0/20"

  validation {
    condition     = can(regex("^[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}\\/[0-9]{1,2}$", var.nodes_ip_range))
    error_message = "Invalid node IP address range format."
  }
}

variable "pods_ip_range" {
  description = "Secondary IP address range for for the subnet to be used for all GKE pod IP addresses."
  type        = string
  default     = "10.1.0.0/16"

  validation {
    condition     = can(regex("^[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}\\/[0-9]{1,2}$", var.pods_ip_range))
    error_message = "Invalid pod IP address range format."
  }
}

variable "services_ip_range" {
  description = "Secondary IP address range for for the subnet to be used for all GKE service IP addresses."
  type        = string
  default     = "10.2.0.0/20"

  validation {
    condition     = can(regex("^[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}\\/[0-9]{1,2}$", var.services_ip_range))
    error_message = "Invalid service IP address range format."
  }
}

variable "allow_ssh" {
  description = "Allow ssh into instances in the VPC."
  type        = bool
  default     = false
}
