# Exafunction GCP Module

<img src="https://raw.githubusercontent.com/Exafunction/terraform-gcp-exafunction-cloud/main/images/banner.png" alt="Exafunction x GCP" width="1280"/>

This repository contains [modules](https://www.terraform.io/language/modules) used to set up [Google Cloud Platform (GCP)](https://cloud.google.com/) infrastructure for an [Exafunction](https://exafunction.com/) ExaDeploy system using [Terraform](https://www.terraform.io/).

This root folder is *an example* of how to use these modules together but is not meant for production use. This example is included here because Terraform requires the root module to contain Terraform code. For production use, use the modules detailed in [Modules](#modules). For details on how to use these modules in different infrastructure setups, see [Configuration](#configuration).

## System Diagram

![System Diagram](https://raw.githubusercontent.com/Exafunction/terraform-gcp-exafunction-cloud/main/images/system_diagram.png)

This diagram shows a typical setup of ExaDeploy on GCP (all within the user's cloud account). It consists of:
* A client [VPC](https://cloud.google.com/vpc/docs/overview) with client applications running on some GCP infrastructure. In this diagram, the applications are running on [GCE instances](https://cloud.google.com/compute/docs/instances), but they could also be running in a [GKE cluster](https://cloud.google.com/kubernetes-engine/docs/concepts/kubernetes-engine-overview), developer machine connected to the VPC using [GCP Cloud VPN](https://cloud.google.com/network-connectivity/docs/vpn/concepts/overview), or some other GCP infrastructure. The modules in this repository are not responsible for setting up any of this client infrastructure.
* An Exafunction VPC used to contain all Exafunction infrastructure components. This is set up by the [`modules/network`](https://github.com/Exafunction/terraform-gcp-exafunction-cloud/tree/main/modules/network) module.
* A VPC peering connection between the client VPC and the Exafunction VPC. This is set up by the [`modules/peering`](https://github.com/Exafunction/terraform-gcp-exafunction-cloud/tree/main/modules/peering) module.
* An [CloudSQL database](https://cloud.google.com/sql/docs/introduction) and [GCS bucket](https://cloud.google.com/storage/docs/introduction) used as a persistent backend for the ExaDeploy module repository. This is set up by the [`modules/module_repo_backend`](https://github.com/Exafunction/terraform-gcp-exafunction-cloud/tree/main/modules/module_repo_backend) module.
* An GKE cluster used to run the ExaDeploy system. This is set up by the [`modules/cluster`](https://github.com/Exafunction/terraform-gcp-exafunction-cloud/tree/main/modules/cluster) module.
* An ExaDeploy system running in the GKE cluster. The modules in this repository are not responsible for deploying this system. This is handled by the [`Exafunction/terraform-gcp-exafunction-kube`](https://github.com/Exafunction/terraform-gcp-exafunction-kube) repository which manages the ExaDeploy [Kubernetes](https://kubernetes.io/) resources.

## Modules

### [`modules/network`](https://github.com/Exafunction/terraform-gcp-exafunction-cloud/tree/main/modules/network)
This module is used to set up the network infrastructure for the ExaDeploy system. This includes creating a [VPC](https://cloud.google.com/vpc/docs/overview) and [subnets](https://cloud.google.com/vpc/docs/subnets) that will be used to deploy the Exafunction [GKE cluster](https://cloud.google.com/kubernetes-engine/docs/concepts/kubernetes-engine-overview) in.

### [`modules/cluster`](https://github.com/Exafunction/terraform-gcp-exafunction-cloud/tree/main/modules/cluster)
This module is used to set up a [GKE cluster](https://cloud.google.com/kubernetes-engine/docs/concepts/kubernetes-engine-overview) that will be used to deploy the ExaDeploy system in. This includes creating the GKE cluster as well as [node pools](https://cloud.google.com/kubernetes-engine/docs/concepts/node-pools) in that cluster. It is possible to configure the set of runner node pools in order to specify different [machine types](https://cloud.google.com/compute/docs/machine-types), [autoscaling limits](https://cloud.google.com/kubernetes-engine/docs/concepts/cluster-autoscaler), instance capacity types ([spot](https://cloud.google.com/compute/docs/instances/spot) vs. [preemptible](https://cloud.google.com/compute/docs/instances/preemptible) vs. on-demand), and other parameters.

### [`modules/module_repo_backend`](https://github.com/Exafunction/terraform-gcp-exafunction-cloud/tree/main/modules/module_repo_backend)
This module is used to set up a persistent backend for the ExaDeploy module repository. This includes a [GCS bucket](https://cloud.google.com/storage/docs/introduction) and a [CloudSQL instance](https://cloud.google.com/sql/docs/introduction) that will be used to store the module repository's objects and metadata respectively. These resources allows the data to be persisted even if the module repository pod is rescheduled. In addition to applying this module, the module repository must be configured to use these resources.

While persistence is a useful feature, it is not strictly required for an ExaDeploy system (though highly recommended in production). The module repository also supports a fully local backend (backed by its own local filesystem on disk) which is not persisted if the module repository pod is rescheduled. In this case, this module is not necessary and the module repository should not be configured to use a remote file storage or remote relational database.

### [`modules/peering`](https://github.com/Exafunction/terraform-gcp-exafunction-cloud/tree/main/modules/peering)
This module is used to set up peering between the Exafunction VPC and another VPC. This includes creating a [VPC peering connection](https://cloud.google.com/vpc/docs/vpc-peering) and a [firewall rule](https://cloud.google.com/vpc/docs/firewalls) to allow ingress traffic from the peer VPC into the Exafunction VPC. In order for the peering setup to work, the VPCs' subnets' [IP ranges](https://cloud.google.com/vpc/docs/subnets#ipv4-ranges) must be disjoint.

The main reason to peer VPCs is to enable client applications running in a separate VPC to offload remote work to the ExaDeploy system running in the Exafunction VPC. The peer VPC clients can run in various infrastructure setups (e.g. on [GCE instances](https://cloud.google.com/compute/docs/instances), in a [GKE cluster](https://cloud.google.com/kubernetes-engine/docs/concepts/kubernetes-engine-overview), from a user's local machine through [GCP Cloud VPN](https://cloud.google.com/network-connectivity/docs/vpn/concepts/overview), etc.). It is possible to call this module multiple times to create multiple peering connections between the Exafunction VPC and other VPCs which may be useful if client applications in multiple VPCs want to offload remote work to a single shared ExaDeploy system.

Peering is not strictly necessary to use the ExaDeploy system. Client applications running within the same VPC as the Exafunction GKE cluster can connect to the ExaDeploy system without requiring any peering setup.

## Configuration
This section covers how to use these modules for different infrastructure setups. To view details on how to configure individual modules (for example how to configure the set of runner node pools in the `cluster` module), visit the individual module `README`s.

### Basic
This root directory is an example of how to use the modules in this repository together and is not meant for production use. It provides a simple but complete setup that includes the Exafunction [VPC](https://cloud.google.com/vpc/docs/overview), an Exafunction [GKE cluster](https://cloud.google.com/kubernetes-engine/docs/concepts/kubernetes-engine-overview) within that network, remote storage ([GCS bucket](https://cloud.google.com/storage/docs/introduction) and [CloudSQL instance](https://cloud.google.com/sql/docs/introduction)) used as a persistent backend for the module repository, and [peering](https://cloud.google.com/vpc/docs/vpc-peering) between the Exafunction VPC and another VPC where client applications could run and connect to the ExaDeploy system. In this example, the `peer_vpc` is created in this Terraform module, but in a production setup, it may already exist / be managed elsewhere and have its information passed in to the peering module.

This type of configuration is applicable to most use cases where client applications are running within a single existing GCP [VPC](https://cloud.google.com/vpc/docs/overview) (the peer VPC). The applications can be running on raw [GCE instances](https://cloud.google.com/compute/docs/instances), in a [GKE cluster](https://cloud.google.com/kubernetes-engine/docs/concepts/kubernetes-engine-overview), from a user's local machine through [GCP Cloud VPN](https://cloud.google.com/network-connectivity/docs/vpn/concepts/overview), in some other GCP infrastructure, or a combination of the above as long as they are all running within the peer VPC.

### Multiple Peer VPCs
If client applications are running in multiple different VPCs, a multiple peer VPC setup can be used. This is similar to the basic setup, but the `peer_vpc` module is called multiple times to create multiple peering connections between the Exafunction VPC and the different peer VPCs. This allows client applications in each peer VPC to connect to the ExaDeploy system running in the Exafunction VPC.

It is important to note that while the peer VPCs are not peered with each other, they must still have disjoint IP ranges as they will all be peered with the Exafunction VPC.

### No Peer VPCs
It is also possible to use the ExaDeploy system without any peering setup. For this to work, client applications must run within the same VPC as the Exafunction GKE cluster. In this case, the `peer_vpc` module is not called at all.

Some examples of this setup include clients running as pods within the deployed Exafunction GKE cluster, as pods within a different GKE cluster in the same VPC, or on GCE instances within the same VPC.

### Local Module Repository Backend
As mentioned above, the persistent module repository backend is not strictly necessary in the ExaDeploy system. If using the local module repository backend (backed by its own local filesystem on disk), the `module_repo_backend` module should not be called.

## Additional Resources

To learn more about Exafunction, visit the [Exafunction website](https://exafunction.com/).

For technical support or questions, check out our [community Slack](https://join.slack.com/t/exa-community/shared_invite/zt-1fx9dgcz5-aUg_UWW7zJYc_tYfw1TyNw).

For additional documentation about Exafunction including system concepts, setup guides, tutorials, API reference, and more, check out the [Exafunction documentation](https://docs.exafunction.com/).

For an equivalent repository used to set up required infrastructure on [Amazon Web Services (AWS)](https://aws.amazon.com/) instead of GCP, visit [`Exafunction/terraform-aws-exafunction-cloud`](https://github.com/Exafunction/terraform-aws-exafunction-cloud).

To deploy the ExaDeploy system within the GKE cluster set up using this repository, visit [`Exafunction/terraform-gcp-exafunction-kube`](https://github.com/Exafunction/terraform-gcp-exafunction-kube).
