variable "prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "ansibleweb"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "westeurope"
}

variable "vm_count" {
  description = "Number of web VMs"
  type        = number
  default     = 2
}

variable "admin_username" {
  description = "Admin username for VM"
  type        = string
  default     = "azureuser"
}

#variable "ssh_public_key" {
  #description = "Your public SSH key"
  #type        = string
#}
