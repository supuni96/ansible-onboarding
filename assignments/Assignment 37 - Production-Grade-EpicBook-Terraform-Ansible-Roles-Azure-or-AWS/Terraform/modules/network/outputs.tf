output "public_subnet_id" {
  value = azurerm_subnet.public.id
}

output "private_subnet_id" {
  value = azurerm_subnet.private.id
}

output "public_nic_id" {
  value = azurerm_network_interface.public_nic.id
}

output "public_ip" {
  value = azurerm_public_ip.vm_pip.ip_address
}
