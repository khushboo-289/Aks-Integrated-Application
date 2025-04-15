variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
}

variable "location" {
  description = "Azure Region where resources will be deployed"
  type        = string
  default     = "eastus2"
}

variable "acr_name" {
  description = "Globally unique name for Azure Container Registry"
  type        = string
  default     = "khushacr989397"
}

variable "aks_name" {
  description = "Name of the Azure Kubernetes Service cluster"
  type        = string
  default     = "aksweb1221"
}

variable "node_count" {
  description = "Number of nodes in the AKS default node pool"
  type        = number
  default     = 2
}

variable "node_size" {
  description = "Size of virtual machines in the AKS node pool"
  type        = string
  default     = "Standard_B2ms"
}
