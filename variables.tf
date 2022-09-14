variable "suffix" {
  description = "Suffix to add to created resources."
  type        = string
  default     = "example"
}

variable "project" {
  description = "GCP project to bring up Exafunction infrastructure in."
  type        = string
  default     = "exafunction"
}

variable "region" {
  description = "Region to bring up Exafunction infrastructure in."
  type        = string
  default     = "us-west1"
}
