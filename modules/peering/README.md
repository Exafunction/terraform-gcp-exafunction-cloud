# Exafunction Peering Module
This Terraform module is used to set up peering between an Exafunction VPC and another VPC. It is responsible for creating VPC network peerings from both the peer VPC to Exafunction VPC and Exafunction VPC to peer VPC (both required to perform peering) as well as a firewall rule to allow ingress traffic from the peered VPC into the Exafunction VPC. In order for the peering setup to work, the VPC's subnets' IP address ranges must be disjoint and they can't be peered with other VPCs whose subnets' IP address ranges overlap the newly peered VPC.

Note that this only adds a firewall rule to the Exafunction VPC and not the peered VPC. This means that the peered VPC can initiate requests to the Exafunction VPC but the other direction is not allowed. Additionally, we recommend using peering to communicate between subnets in the same region to avoid costly cross-regional egress costs.

## Usage
```hcl
module "exafunction_peering" {
  # Set the module source and version to use this module.
  source = "Exafunction/exafunction-cloud/gcp//modules/peering"
  version = "x.y.z"

  # Set the Exafunction VPC self link.
  vpc_self_link      = google_compute_network.exafunction_vpc.self_link

  # Set the peer VPC self link and incoming IP ranges.
  peer_vpc_self_link = google_compute_network.peer_vpc.self_link
  peer_subnet_ip_ranges = concat(
    [google_compute_subnetwork.peer_subnet.ip_cidr_range],
    google_compute_subnetwork.peer_subnet.secondary_ip_range[*].ip_cidr_range)

  # ...
}
```
See the [Inputs section](#inputs) and [variables.tf](https://github.com/Exafunction/terraform-gcp-exafunction-cloud/tree/main/modules/peering/variables.tf) file for a full list of configuration options.

See [examples/simple_peering](https://github.com/Exafunction/terraform-gcp-exafunction-cloud/tree/main/modules/peering/examples/simple_peering) for an isolated working example of how to use this module or the repository's [root example](https://github.com/Exafunction/terraform-gcp-exafunction-cloud) for a full working example of how to use this module in conjunction with the other Exafunction modules.

<!-- BEGIN_TF_DOCS -->
## Resources

| Name | Type |
|------|------|
| [google_compute_firewall.ingress](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_network_peering.exafunction_to_peer](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network_peering) | resource |
| [google_compute_network_peering.peer_to_exafunction](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network_peering) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_peer_subnet_ip_ranges"></a> [peer\_subnet\_ip\_ranges](#input\_peer\_subnet\_ip\_ranges) | List of IP ranges the Exafunction VPC should accept incoming connections from. | `list(string)` | n/a | yes |
| <a name="input_peer_vpc_self_link"></a> [peer\_vpc\_self\_link](#input\_peer\_vpc\_self\_link) | Self link for the peer VPC. | `string` | n/a | yes |
| <a name="input_unique_suffix"></a> [unique\_suffix](#input\_unique\_suffix) | Unique suffix to add to peering resources. Necessary when trying to create multiple network peerings. | `string` | `""` | no |
| <a name="input_vpc_self_link"></a> [vpc\_self\_link](#input\_vpc\_self\_link) | Self link for the Exafunction VPC. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_egress_peering_id"></a> [egress\_peering\_id](#output\_egress\_peering\_id) | ID of the network peering from Exafunction VPC to peer VPC. |
| <a name="output_ingress_firewall_id"></a> [ingress\_firewall\_id](#output\_ingress\_firewall\_id) | ID of the firewall rule allowing ingress from peer VPC to Exafunction VPC. |
| <a name="output_ingress_firewall_self_link"></a> [ingress\_firewall\_self\_link](#output\_ingress\_firewall\_self\_link) | URI of the firewall rule allowing ingress from peer VPC to Exafunction VPC. |
| <a name="output_ingress_peering_id"></a> [ingress\_peering\_id](#output\_ingress\_peering\_id) | ID of the network peering from peer VPC to Exafunction VPC. |
<!-- END_TF_DOCS -->
