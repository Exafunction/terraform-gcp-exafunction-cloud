resource "google_container_cluster" "exafunction" {
  name     = var.cluster_name
  location = var.region

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = var.vpc_name
  subnetwork = var.subnet_name

  ip_allocation_policy {
    cluster_secondary_range_name  = var.pods_secondary_range_name
    services_secondary_range_name = var.services_secondary_range_name
  }
}

locals {
  runner_pool_map = {
    for runner_pool in var.runner_pools : runner_pool.suffix => runner_pool
  }
}

resource "google_container_node_pool" "runner_pools" {
  for_each = local.runner_pool_map

  name     = "runner-${each.value.suffix}"
  location = var.region
  cluster  = google_container_cluster.exafunction.name

  autoscaling {
    min_node_count = each.value.min_size
    max_node_count = each.value.max_size
  }

  node_locations = length(each.value.node_zones) > 0 ? each.value.node_zones : null

  node_config {
    preemptible  = each.value.capacity_type == "PREEMPTIBLE" ? true : false
    spot         = each.value.capacity_type == "SPOT" ? true : false
    machine_type = each.value.machine_type
    guest_accelerator = each.value.accelerator_type != "" ? [{
      count              = each.value.accelerator_count
      type               = each.value.accelerator_type
      gpu_partition_size = null
    }] : []
    disk_size_gb    = each.value.disk_size
    local_ssd_count = each.value.local_ssd_count
    metadata = {
      disable-legacy-endpoints = "true"
    }
    gvnic {
      enabled = each.value.enable_gvnic
    }
    labels = merge({
      role = "runner"
      },
    each.value.additional_labels)
    taint = concat([
      {
        key    = "dedicated"
        value  = "runner"
        effect = "NO_SCHEDULE"
      }],
      each.value.accelerator_type != "" ? [{
        key    = "nvidia.com/gpu"
        value  = "present"
        effect = "NO_SCHEDULE"
      }] : [],
      each.value.additional_taints
    )
    oauth_scopes = concat([
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      ],
      each.value.accelerator_type != "" ? [
        "https://www.googleapis.com/auth/devstorage.read_only"
    ] : [])
  }
}

resource "google_container_node_pool" "default" {
  name     = "default"
  location = var.region
  cluster  = google_container_cluster.exafunction.name

  autoscaling {
    min_node_count = 1
    max_node_count = 10
  }

  node_config {
    labels = {
      role = "default"
    }

    machine_type = "n2-standard-4"
    disk_size_gb = 100
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}

resource "google_container_node_pool" "scheduler" {
  name     = "scheduler"
  location = var.region
  cluster  = google_container_cluster.exafunction.name

  autoscaling {
    min_node_count = 0
    max_node_count = 1
  }

  node_config {
    machine_type = "n2-standard-4"
    disk_size_gb = 100
    metadata = {
      disable-legacy-endpoints = "true"
    }
    labels = {
      role = "scheduler"
    }
    taint = [
      {
        key    = "dedicated"
        value  = "scheduler"
        effect = "NO_SCHEDULE"
      }
    ]
  }
}

resource "google_container_node_pool" "module_repository" {
  name     = "module-repository"
  location = var.region
  cluster  = google_container_cluster.exafunction.name

  autoscaling {
    min_node_count = 0
    max_node_count = 1
  }

  node_config {
    machine_type = "n2-standard-4"
    disk_size_gb = 100
    metadata = {
      disable-legacy-endpoints = "true"
    }
    labels = {
      role = "module-repository"
    }
    taint = [
      {
        key    = "dedicated"
        value  = "module-repository"
        effect = "NO_SCHEDULE"
      }
    ]
  }
}

resource "google_container_node_pool" "prometheus" {
  name     = "prometheus"
  location = var.region
  cluster  = google_container_cluster.exafunction.name

  autoscaling {
    min_node_count = 0
    max_node_count = 1
  }

  node_config {
    machine_type = "n2-standard-4"
    disk_size_gb = 100
    metadata = {
      disable-legacy-endpoints = "true"
    }
    labels = {
      role = "prometheus"
    }
    taint = [
      {
        key    = "dedicated"
        value  = "prometheus"
        effect = "NO_SCHEDULE"
      }
    ]
  }
}
