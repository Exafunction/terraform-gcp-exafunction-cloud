# Exafunction Network Module

This Terraform module is used to set up the required network resources for an ExaDeploy system. It is responsible for creating a VPC and subnet that the Exafunction GKE cluster will be deployed to. The subnet will have a primary IP address range to be used for GKE node IP addresses and two secondary IP range ranges to be used for GKE pod and service IP addresses.

## Usage
```hcl
module "exafunction_network" {
  # Set the module source and version to use this module.
  source = "Exafunction/exafunction-cloud/gcp//modules/network"
  version = "0.1.0"

  # Set the VPC name, subnet name, and subnet region.
  vpc_name       = "exafunction-vpc-simple"
  subnet_name    = "exafunction-subnet-simple"
  region         = "us-west1"

  # Set the IP ranges for the subnet.
  nodes_ip_range = "10.0.0.0/20"
  pods_ip_range = "10.1.0.0/16"
  services_ip_range  = "10.2.0.0/20"

  # ...
}
```
See the [Inputs section](#inputs) and [variables.tf](https://github.com/Exafunction/terraform-gcp-exafunction-cloud/tree/main/modules/network/variables.tf) file for a full list of configuration options.

See [examples/simple_network](https://github.com/Exafunction/terraform-gcp-exafunction-cloud/tree/main/modules/network/examples/simple_network) for an isolated working example of how to use this module or the repository's [root example](https://github.com/Exafunction/terraform-gcp-exafunction-cloud) for a full working example of how to use this module in conjunction with the other Exafunction modules.

<!-- BEGIN_TF_DOCS -->
## Resources

| Name | Type |
|------|------|
| [google_compute_firewall.rules](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_network.vpc](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network) | resource |
| [google_compute_subnetwork.subnet](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_ssh"></a> [allow\_ssh](#input\_allow\_ssh) | Allow ssh into instances in the VPC. | `bool` | `false` | no |
| <a name="input_nodes_ip_range"></a> [nodes\_ip\_range](#input\_nodes\_ip\_range) | Primary IP address range for for the subnet to be used for all GKE node IP addresses. | `string` | `"10.0.0.0/20"` | no |
| <a name="input_pods_ip_range"></a> [pods\_ip\_range](#input\_pods\_ip\_range) | Secondary IP address range for for the subnet to be used for all GKE pod IP addresses. | `string` | `"10.1.0.0/16"` | no |
| <a name="input_region"></a> [region](#input\_region) | Region for subnet. | `string` | n/a | yes |
| <a name="input_services_ip_range"></a> [services\_ip\_range](#input\_services\_ip\_range) | Secondary IP address range for for the subnet to be used for all GKE service IP addresses. | `string` | `"10.2.0.0/20"` | no |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | Name of subnet to create. | `string` | `"exafunction-subnet"` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Name of VPC to create. | `string` | `"exafunction-vpc"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_pods_secondary_range_name"></a> [pods\_secondary\_range\_name](#output\_pods\_secondary\_range\_name) | Name of the secondary IP range in the subnet for pods. |
| <a name="output_region"></a> [region](#output\_region) | Region of the created subnet. |
| <a name="output_services_secondary_range_name"></a> [services\_secondary\_range\_name](#output\_services\_secondary\_range\_name) | Name of the secondary IP range in the subnet for services. |
| <a name="output_subnet_id"></a> [subnet\_id](#output\_subnet\_id) | ID of the created subnet. |
| <a name="output_subnet_name"></a> [subnet\_name](#output\_subnet\_name) | Name of the created subnet. |
| <a name="output_subnet_self_link"></a> [subnet\_self\_link](#output\_subnet\_self\_link) | The URI of the created subnet. |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | ID of the created VPC. |
| <a name="output_vpc_name"></a> [vpc\_name](#output\_vpc\_name) | Name of the created VPC. |
| <a name="output_vpc_self_link"></a> [vpc\_self\_link](#output\_vpc\_self\_link) | The URI of the created VPC. |
<!-- END_TF_DOCS -->
