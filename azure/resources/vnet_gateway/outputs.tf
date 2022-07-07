output "name" {
  description = "Name of the Azure Virtual Network Gateway"
  value       = azurerm_virtual_network_gateway.gateway.name
}

output "pip" {
  description = "Public IP address of the Azure Virtual Network Gateway"
  value       = azurerm_public_ip.pip.ip_address
}