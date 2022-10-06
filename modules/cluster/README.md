# Exafunction Cluster Module

This Terraform module is used to set up the required cluster resources for an ExaDeploy system. It is responsible for creating a GKE cluster that the ExaDeploy system will be deployed in as well as node pools in that cluster.

## Usage
```hcl
module "exafunction_cluster" {
  # Set the module source and version to use this module.
  source = "Exafunction/exafunction-cloud/gcp//modules/cluster"
  version = "x.y.z"

  # Set the cluster name and region.
  cluster_name = "exafunction-cluster-simple"
  region       = "us-west1"

  # Set the VPC and subnet to deploy the cluster in.
  vpc_name                      = google_compute_network.vpc.name
  subnet_name                   = google_compute_subnetwork.subnet.name
  pods_secondary_range_name     = "pod-ip-range"
  services_secondary_range_name = "service-ip-range"

  # Configure the ExaDeploy runner pools.
  runner_pools = [{
    suffix            = "gpu"
    machine_type      = "n1-standard-4"
    capacity_type     = "ON_DEMAND"
    disk_size         = 100
    local_ssd_count   = 0
    min_size          = 0
    max_size          = 3
    accelerator_count = 1
    accelerator_type  = "nvidia-tesla-t4"
    node_zones        = ["us-west1-a", "us-west1-b"]
    additional_taints = []
    additional_labels = {}
  }]

  # ...
}
```
See the [Inputs section](#inputs) and [variables.tf](https://github.com/Exafunction/terraform-gcp-exafunction-cloud/tree/main/modules/cluster/variables.tf) file for a full list of configuration options.

See [examples/simple_cluster](https://github.com/Exafunction/terraform-gcp-exafunction-cloud/tree/main/modules/cluster/examples/simple_cluster) for an isolated working example of how to use this module or the repository's [root example](https://github.com/Exafunction/terraform-gcp-exafunction-cloud) for a full working example of how to use this module in conjunction with the other Exafunction modules.

<!-- BEGIN_TF_DOCS -->
## Resources

| Name | Type |
|------|------|
| [google_container_cluster.exafunction](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster) | resource |
| [google_container_node_pool.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool) | resource |
| [google_container_node_pool.module_repository](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool) | resource |
| [google_container_node_pool.prometheus](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool) | resource |
| [google_container_node_pool.runner_pools](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool) | resource |
| [google_container_node_pool.scheduler](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the GKE cluster to create. | `string` | `"exafunction-cluster"` | no |
| <a name="input_pods_secondary_range_name"></a> [pods\_secondary\_range\_name](#input\_pods\_secondary\_range\_name) | The name of the secondary range in the subnetwork to use for pod IP addresses. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region to create the GKE cluster in. | `string` | n/a | yes |
| <a name="input_runner_pools"></a> [runner\_pools](#input\_runner\_pools) | Configuration parameters for Exafunction runner node pools. | <pre>list(object({<br>    # Node group suffix.<br>    suffix = string<br>    # Machine type to use.<br>    machine_type = string<br>    # One of (ON_DEMAND, PREEMPTIBLE, SPOT).<br>    capacity_type = string<br>    # Disk size (GB).<br>    disk_size = number<br>    # Number of local SSDs to attach.<br>    local_ssd_count = number<br>    # Minimum number of nodes per zone.<br>    min_size = number<br>    # Maximum number of nodes per zone.<br>    max_size = number<br>    # Type of accelerator to attach. If empty, no accelerator is attached.<br>    accelerator_type = string<br>    # The number of accelerators to attach.<br>    accelerator_count = number<br>    # List of zones for the Exafunction runner node pool. Zones must be within the same region as<br>    # the cluster. For node pools with attached accelerators, must specify a list of zones where<br>    # the accelerators are available. If empty, use the default set of zones for the region.<br>    node_zones = list(string)<br>    # Additional taints.<br>    additional_taints = list(object({<br>      key    = string<br>      value  = string<br>      effect = string<br>    }))<br>    # Additional labels.<br>    additional_labels = map(string)<br>  }))</pre> | <pre>[<br>  {<br>    "accelerator_count": 1,<br>    "accelerator_type": "nvidia-tesla-t4",<br>    "additional_labels": {},<br>    "additional_taints": [],<br>    "capacity_type": "ON_DEMAND",<br>    "disk_size": 100,<br>    "local_ssd_count": 0,<br>    "machine_type": "n1-standard-4",<br>    "max_size": 3,<br>    "min_size": 0,<br>    "node_zones": [<br>      "us-west1-a",<br>      "us-west1-b"<br>    ],<br>    "suffix": "gpu"<br>  }<br>]</pre> | no |
| <a name="input_services_secondary_range_name"></a> [services\_secondary\_range\_name](#input\_services\_secondary\_range\_name) | The name of the secondary range in the subnetwork to use for service IP addresses. | `string` | n/a | yes |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | The name of the subnetwork in which the cluster's instances are launched. | `string` | n/a | yes |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | The name of the VPC to which the cluster is connected. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | ID of the GKE cluster. |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Name of the GKE cluster. |
| <a name="output_cluster_self_link"></a> [cluster\_self\_link](#output\_cluster\_self\_link) | Th server-defined URL for the GKE cluster. |
<!-- END_TF_DOCS -->
