# resource group variables

variable "name_prefix" {
  type        = string
  description = "name of resource"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "cluster_name" {
  description = "The name of the AKS cluster."
  type        = string
}

variable "sku_tier" {
  description = "The SKU Tier that should be used for this Kubernetes Cluster. Possible values are Free, Standard (which includes the Uptime SLA) and Premium. Defaults to Free"
  type = string
  default = "Standard"
}

variable "kubernetes_version" {
  description = "Kubernetes version for the AKS cluster."
  type        = string
  default     = "1.29.2"
}

variable "system_node_vm_size" {
  description = "VM size for the system node pool."
  type        = string
  default     = "Standard_B2s"
}

variable "user_node_vm_size" {
  description = "VM size for the user node pool (spot instances)."
  type        = string
  default     = "Standard_B2s"
}