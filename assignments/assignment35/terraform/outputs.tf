output "public_ips" {
  description = "Public IPs of all web servers"
  value       = azurerm_public_ip.publicip[*].ip_address
}
