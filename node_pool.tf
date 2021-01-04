locals {
  if_service_account_create = "${var.nodepool1_service_account == "create" ? 1 : 0}"
  nodepool1_taint_key       = "${var.nodepool1_taint_key == "" ? "dedicated" : var.nodepool1_taint_key}"
  nodepool1_taint_value     = "${var.nodepool1_taint_value == "" ? var.nodepool1_name : var.nodepool1_taint_value}"
}

/*
Creating a default node pool. Most probably initially for the
environments a single node pool of generic instances will be used.
Additional node pools can be created outside of the module by
referencing the container cluster.
*/
resource "google_container_node_pool" "nodepool1" {
  count    = "${var.deploy_nodepool1 ? 1 : 0}"
  provider = "google-beta"

  lifecycle {
    // Manually update version during upgrade operations
    ignore_changes = ["node_count", "version", "initial_node_count", "node_config[0].metadata"]
  }

  name               = "${var.nodepool1_name}"
  project            = "${var.project}"
  version            = "${lookup(var.versions_config, "version", data.google_container_engine_versions.engine_version.latest_node_version)}"
  location           = "${var.location}"
  cluster            = "${google_container_cluster.k8s.name}"
  initial_node_count = "${var.nodepool1_initial_node_count}"

  autoscaling {
    min_node_count = "${var.nodepool1_min_node_count}"
    max_node_count = "${var.nodepool1_max_node_count}"
  }

  management {
    auto_repair  = "${var.nodepool1_auto_repair}"
    auto_upgrade = "${var.nodepool1_auto_upgrade}"
  }

  node_config {
    preemptible      = "${var.nodepool1_preemptible}"
    min_cpu_platform = "${var.nodepool1_min_cpu_platform}"
    labels           = "${var.nodepool1_labels}"
    machine_type     = "${var.nodepool1_machine_type}"
    service_account  = "${var.nodepool1_service_account == "create" ? google_service_account.nodepool1.0.email : var.nodepool1_service_account}"
    oauth_scopes     = "${var.nodepool1_oauth_scopes}"
    tags             = var.nodepool1_tags

    taint {
      key    = "${local.nodepool1_taint_key}"
      value  = "${local.nodepool1_taint_value}"
      effect = "${var.nodepool1_taint_effect}"
    }
  }

  timeouts {
    create = "20m"
    update = "40m"
    delete = "40m"
  }
}

// IAM for the node pool based on best practices
resource "google_service_account" "nodepool1" {
  count        = "${local.if_service_account_create}"
  account_id   = "${var.name}-${var.nodepool1_name}"
  display_name = "Service account for GKE cluster ${var.name}"
  project      = "${var.project}"
}

resource "google_project_iam_member" "nodepool1_logging_log_writer" {
  count   = "${local.if_service_account_create}"
  role    = "roles/logging.logWriter"
  project = "${var.project}"
  member  = "serviceAccount:${google_service_account.nodepool1.0.email}"
}

resource "google_project_iam_member" "nodepool1_monitoring_metric_writer" {
  count   = "${local.if_service_account_create}"
  role    = "roles/monitoring.metricWriter"
  project = "${var.project}"
  member  = "serviceAccount:${google_service_account.nodepool1.0.email}"
}

resource "google_project_iam_member" "nodepool1_monitoring_viewer" {
  count   = "${local.if_service_account_create}"
  role    = "roles/monitoring.viewer"
  project = "${var.project}"
  member  = "serviceAccount:${google_service_account.nodepool1.0.email}"
}
