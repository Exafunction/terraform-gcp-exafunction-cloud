# Exafunction Module Repository Backend Module

This Terraform module is used to set up resources that provide a persistent backend for the ExaDeploy module repository. It is responsible for creating a GCS bucket and a CloudSQL instance that will be used to store the module repository's objects and metadata respectively. This backend allows the data to be persisted even if the module repository pod is rescheduled. As an alternative to this persistent backend, the module repository also supports a fully local backend (backed by its own local filesystem on disk) which is not persisted if the module repository pod is rescheduled.

## Usage
```hcl
module "exafunction_module_repo_backend" {
  # Set the module source and version to use this module.
  source = "Exafunction/exafunction-cloud/gcp//modules/module_repo_backend"
  version = "x.y.z"

  # Set the VPC to create the CloudSQL instance in.
  vpc_id = google_compute_network.vpc.id

  # Set the region to create the CloudSQL instance and GCS bucket in.
  region = "us-west1"

  # Set a unique identifier for created resources.
  exadeploy_id = "exafunction-mrbe-simple"

  # ...
}
```
See the [Inputs section](#inputs) and [variables.tf](https://github.com/Exafunction/terraform-gcp-exafunction-cloud/tree/main/modules/module_repo_backend/variables.tf) file for a full list of configuration options.

See [examples/simple_module_repo_backend](https://github.com/Exafunction/terraform-gcp-exafunction-cloud/tree/main/modules/module_repo_backend/examples/simple_module_repo_backend) for an isolated working example of how to use this module or the repository's [root example](https://github.com/Exafunction/terraform-gcp-exafunction-cloud) for a full working example of how to use this module in conjunction with the other Exafunction modules.

<!-- BEGIN_TF_DOCS -->
## Resources

| Name | Type |
|------|------|
| [google_compute_global_address.cloud_sql_address](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address) | resource |
| [google_service_account.gcs](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account_key.gcs](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_key) | resource |
| [google_service_networking_connection.cloud_sql_connection](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_networking_connection) | resource |
| [google_sql_database_instance.default_cloud_sql](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance) | resource |
| [google_sql_user.cloud_sql_user](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_user) | resource |
| [google_storage_bucket.module_repository_bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_storage_bucket_iam_member.service_account_member](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_member) | resource |
| [random_password.cloud_sql_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_string.bucket_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_db_flags"></a> [db\_flags](#input\_db\_flags) | CloudSQL Postgres flags. | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | `[]` | no |
| <a name="input_db_machine_type"></a> [db\_machine\_type](#input\_db\_machine\_type) | CloudSQL instance machine type. | `string` | `"db-f1-micro"` | no |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | CloudSQL database username. | `string` | `"postgres"` | no |
| <a name="input_exadeploy_id"></a> [exadeploy\_id](#input\_exadeploy\_id) | Unique identifier for a deployment of the ExaDeploy system. | `string` | `"exafunction"` | no |
| <a name="input_postgres_version"></a> [postgres\_version](#input\_postgres\_version) | CloudSQL Postgres version. | `string` | `"POSTGRES_13"` | no |
| <a name="input_region"></a> [region](#input\_region) | The region to create the CloudSQL instance in. | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC to create the CloudSQL instance in. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloud_sql_address"></a> [cloud\_sql\_address](#output\_cloud\_sql\_address) | Address for the CloudSQL instance. |
| <a name="output_cloud_sql_instance_name"></a> [cloud\_sql\_instance\_name](#output\_cloud\_sql\_instance\_name) | Name for the CloudSQL instance. |
| <a name="output_cloud_sql_password"></a> [cloud\_sql\_password](#output\_cloud\_sql\_password) | Password for the CloudSQL instance. |
| <a name="output_cloud_sql_port"></a> [cloud\_sql\_port](#output\_cloud\_sql\_port) | Port for the CloudSQL instance. |
| <a name="output_cloud_sql_username"></a> [cloud\_sql\_username](#output\_cloud\_sql\_username) | Username for the CloudSQL instance. |
| <a name="output_gcs_bucket_name"></a> [gcs\_bucket\_name](#output\_gcs\_bucket\_name) | Name of the GCS bucket. |
| <a name="output_gcs_bucket_self_link"></a> [gcs\_bucket\_self\_link](#output\_gcs\_bucket\_self\_link) | The URI for the GCS bucket. |
| <a name="output_gcs_bucket_url"></a> [gcs\_bucket\_url](#output\_gcs\_bucket\_url) | Base URL of the GCS bucket (gs://<bucket-name>). |
| <a name="output_gcs_credentials_json"></a> [gcs\_credentials\_json](#output\_gcs\_credentials\_json) | GCP credentials for the GCS service account. |
| <a name="output_gcs_service_account_email"></a> [gcs\_service\_account\_email](#output\_gcs\_service\_account\_email) | Email address of the GCS service account. |
| <a name="output_gcs_service_account_id"></a> [gcs\_service\_account\_id](#output\_gcs\_service\_account\_id) | ID of the GCS service account. |
| <a name="output_gcs_service_account_name"></a> [gcs\_service\_account\_name](#output\_gcs\_service\_account\_name) | Name of the GCS service account. |
<!-- END_TF_DOCS -->
