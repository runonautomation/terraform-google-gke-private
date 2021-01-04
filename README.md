### Disclaimer
Terraform 0.11+

### Description
This module creates a private Kubernetes cluster with an optional
node pool. Additional node pools can be created as external resources.

### Key features showcased in this module
- Private IP for Kubernetes nodes
- Supports Shared VPC in GCP
- Ability to extend cluster with multiple node pools externally and an optional node pool inside the module
- Default minimalistic IAM for the node pool
- Compatible with Terraform 11-14 (with warnings for backwards-compatible features)