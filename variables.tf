variable "versions_config" {
  type        = "map"
  description = "Specification of desired versions for Kubernetes components"
  default     = {}
}

variable "project" {
  description = "Project where the Kubernetes cluster compute resources will be created"
}

variable "network" {
  default     = "default"
  description = "Network name"
}

variable "subnetwork" {
  default     = "default"
  description = "Subnet name"
}

variable "cluster_range" {
  default     = "cluster-range"
  description = "Cluster range name"
}

variable "services_range" {
  default     = "services-range"
  description = "Services range name"
}

variable "location" {
  description = "Master location"
}

variable master_ipv4_cidr_block {
  description = "CIDR to allocate to master nodes on Google-managed VPC"
  default     = "10.128.0.0/28"
}

variable master_authorized_networks_config_cidr_blocks {
  description = "List of source addresses to allow remote connection"
  type        = "list"
  default     = ["127.0.0.1/32"]
}

variable "node_locations" {
  type        = "list"
  description = "Zones that will be added to node pools. For each additional zone an instance will be created. E.g. 1 main zone and 2 additional zones will mean that for node pool size=1 3 nodes will be created"
}

variable "name" {
  default     = "kube"
  description = "Kubernetes cluster name"
}

variable "daily_maintenance_window_start_time" {
  default     = "01:00"
  description = "Daily maintenance window start time"
}

variable "labels" {
  type        = "map"
  description = "Labels to associate with the resources"
  default     = {}
}

variable "manc" {
  type        = "map"
  description = "Master Authorized Network Config"
  default     = {
    Localhost = "127.0.0.1/32"
  }
}

variable "enable_private_endpoint" {
  description = "Enable private endpoint for Kubernetes masters"
  default     = "false"
}

variable "disable_istio" {
  description = "Disable Istio"
  default     = true
}

variable "istio_auth" {
  description = "Istion authentication"
  default     = "AUTH_MUTUAL_TLS"
}

variable "disable_cloudrun" {
  description = "Disable Cloud Run"
  default     = true
}

##
# Node pool variables
##

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