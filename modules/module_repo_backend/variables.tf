variable "vpc_id" {
  description = "The ID of the VPC to create the CloudSQL instance in."
  type        = string
}

variable "region" {
  description = "The region to create the CloudSQL instance in."
  type        = string
}

variable "exadeploy_id" {
  description = "Unique identifier for a deployment of the ExaDeploy system."
  type        = string
  default     = "exafunction"

  validation {
    condition     = can(regex("^[a-z0-9\\-]+$", var.exadeploy_id))
    error_message = "Invalid ExaDeploy ID."
  }

  validation {
    condition     = length(var.exadeploy_id) <= 23
    error_message = "ExaDeploy ID length must be <= 23."
  }
}

variable "postgres_version" {
  description = "CloudSQL Postgres version."
  type        = string
  default     = "POSTGRES_13"
}

variable "db_username" {
  description = "CloudSQL database username."
  type        = string
  default     = "postgres"
}

variable "db_machine_type" {
  description = "CloudSQL instance machine type."
  type        = string
  default     = "db-f1-micro"
}
