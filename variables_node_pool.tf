variable deploy_nodepool1 {
  default     = true
  description = "Condition to deploy a default node pool"
}

variable "nodepool1_labels" {
  type        = "map"
  default     = {}
  description = "Kubernetes node labels that will be associated to the nodes in the node pool"
}

variable "nodepool1_initial_node_count" {
  default     = 1
  description = "(Optional) The initial node count for the pool. Changing this will force ssip of the resource."
}

variable "nodepool1_min_node_count" {
  default     = 1
  description = "(Required) Minimum number of nodes in the NodePool. Must be >=1 and <= nodepool1_max_node_count."
}

variable "nodepool1_max_node_count" {
  default     = 3
  description = "(Required) Maximum number of nodes in the NodePool. Must be >= nodepool1_min_node_count."
}

variable nodepool1_name {
  default     = "nodepool1"
  description = "Node pool name"
}

variable nodepool1_preemptible {
  default     = false
  description = "CHeck if node pool needs to be preemptible"
}

variable nodepool1_machine_type {
  default     = "n1-standard-2"
  description = "Instance size that will be used for the node pool"
}

variable nodepool1_min_cpu_platform {
  default     = "Intel Skylake"
  description = "Set minimal CPU platform for the node pool"
}

variable nodepool1_tags {
  type        = "list"
  default     = []
  description = "Firewall tags that will be associated to all nodes in the node pool"
}

variable nodepool1_service_account {
  description = "Service account and GKE cluster will take"
  default     = "create"
}

variable nodepool1_oauth_scopes {
  description = "OAuth scopes for the node pool"

  default = [
    "https://www.googleapis.com/auth/cloud-platform",
  ]
}

// Taints
variable nodepool1_taint_key {
  description = "Service account and GKE cluster will take"
  default     = ""
}

variable nodepool1_taint_value {
  description = "Service account and GKE cluster will take"
  default     = ""
}

variable nodepool1_taint_effect {
  description = "Default Taint Effect"
  default     = "PREFER_NO_SCHEDULE"
}

variable nodepool1_auto_repair {
  default     = true
  description = "Automatic repair"
}

variable nodepool1_auto_upgrade {
  default     = false
  description = "Automatic upgrades"
}