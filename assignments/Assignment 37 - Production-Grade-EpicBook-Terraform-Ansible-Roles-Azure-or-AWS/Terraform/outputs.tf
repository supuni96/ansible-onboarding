output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}
output "vm_public_ip" {
  value = module.compute.vm_public_ip
}
output "db_fqdn" {
  value = module.database.db_fqdn
}
