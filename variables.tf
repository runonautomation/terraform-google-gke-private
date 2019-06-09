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
