variable "rg_name" { type = string }
variable "location" { type = string }
variable "env" { type = string }
variable "subnet_id" { type = string }
variable "db_admin" { type = string }
variable "db_password" { type = string }
variable "tags" { type = map(string) }
