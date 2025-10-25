variable "env" {
  description = "Environment name (dev/prod). Terraform workspace is used if not provided."
  type        = string
  default     = "dev"
}

variable "allowed_ssh_ip" {
  description = "CIDR allowed to SSH (your public IP like 203.0.113.25/32). Use 0.0.0.0/0 only for testing."
  type        = string
}

variable "db_admin" {
  description = "DB admin username"
  type        = string
  default     = "epic_admin"
}

variable "db_password" {
  description = "DB admin password"
  type        = string
  sensitive   = true
}

variable "vm_user" {
  description = "VM admin username"
  type        = string
  default     = "azureuser"
}

variable "vm_password" {
  description = "VM admin password (or use SSH key instead)"
  type        = string
  sensitive   = true
}
