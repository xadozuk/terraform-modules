output "name" {
  description = "Name of the Azure Bastion"
  value       = azurerm_bastion_host.bastion.name
}

output "pip" {
  description = "Public IP address of the Azure Bastion"
  value       = azurerm_public_ip.pip.ip_address
}