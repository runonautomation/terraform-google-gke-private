output "cluster_ca_certificate" {
  value       = "${google_container_cluster.k8s.master_auth.0.cluster_ca_certificate}"
  description = "Kubernetes cluster CA certificate"
}

output "endpoint" {
  value       = "https://${google_container_cluster.k8s.endpoint}"
  description = "Kubernetes cluster API server endpoint"
}

output "nodepool1_service_account" {
  value       = "${ local.if_service_account_create == 1 ? google_service_account.nodepool1.0.email : ""}"
  description = "Service account email for auto-generated service account"
}
