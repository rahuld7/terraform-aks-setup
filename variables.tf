variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default     = "k8s-demo-rg"
}

variable "location" {
  description = "The location of the resources"
  type        = string
  default     = "East US"
}

variable "aks_name" {
  description = "The name of the AKS cluster"
  type        = string
  default     = "k8s-demo-cluster"
}

variable "dns_prefix" {
  description = "DNS prefix for the AKS cluster"
  type        = string
  default     = "k8sdemo"
}

variable "node_count" {
  description = "Number of nodes in the AKS cluster"
  type        = number
  default     = 2
}

variable "vm_size" {
  description = "VM size for the AKS nodes"
  type        = string
  default     = "Standard_DS2_v2"
}

variable "acr_name" {
  description = "The name of the Azure Container Registry"
  type        = string
  default     = "k8sdemoacr"
}
