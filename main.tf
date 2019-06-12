data "google_client_config" "default" {}

// Enable the container service in order to fix race conditions
resource "google_project_service" "container" {
  project            = "${var.project}"
  service            = "container.googleapis.com"
  disable_on_destroy = false
}

data "google_container_engine_versions" "engine_version" {
  location = "${var.location}"
  project  = "${var.project}"
}

resource "google_container_cluster" "k8s" {
  provider = "google-beta"
  // It is reccomended to ignore node count and versions specifications in the lifecycle
  lifecycle {
    ignore_changes = [
      "initial_node_count",
      "master_version",
      "min_master_version",
      "node_version"
    ]
  }

  name           = "${var.name}"
  project        = "${var.project}"
  depends_on     = ["google_project_service.container"]
  location       = "${var.location}"
  node_locations = "${var.node_locations}"

  // Use provided master version, fallback to latest version
  min_master_version = "${lookup(var.versions_config, "version", data.google_container_engine_versions.engine_version.latest_master_version)}"
  node_version       = "${lookup(var.versions_config, "version", data.google_container_engine_versions.engine_version.latest_node_version)}"

  // It is reccomended to remove default node pool and create node pools manually
  remove_default_node_pool = "true"
  initial_node_count       = 1

  // Cluster networking configuration
  network    = "${var.network}"
  subnetwork = "${var.subnetwork}"

  private_cluster_config {
    master_ipv4_cidr_block = "${var.master_ipv4_cidr_block}"
    enable_private_nodes   = "true"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "${var.cluster_range}"
    services_secondary_range_name = "${var.services_range}"
  }

  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = var.manc
      content {
        cidr_block       = cidr_blocks.value
        display_name     = cidr_blocks.key
      }
    }
  }

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = "${var.daily_maintenance_window_start_time}"
    }
  }

  // Production reccomended addons
  addons_config {
    http_load_balancing {
      disabled = false
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
    kubernetes_dashboard {
      disabled = true
    }
    network_policy_config {
      disabled = false
    }
    istio_config {
      disabled = var.disable_istio
      auth = var.istio_auth
    }
    cloudrun_config {
      disabled = var.disable_cloudrun
    }
  }

  network_policy {
    provider = "PROVIDER_UNSPECIFIED"
    enabled  = "true"
  }

  pod_security_policy_config {
    enabled = "${var.enable_psp}"
  }

  resource_labels = "${var.labels}"

  timeouts {
    create = "25m"
    update = "20m"
    delete = "35m"
  }
}
