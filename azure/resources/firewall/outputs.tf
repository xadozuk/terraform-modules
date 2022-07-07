output "name" {
  description = "Name of the Azure Firewall"
  value       = azurerm_firewall.firewall.name
}

output "pip" {
  description = "Public IP address of the Azure Firewall"
  value       = azurerm_public_ip.pip.ip_address
}