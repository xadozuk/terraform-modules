output "id" {
    description = "ID of the virtual network"
    value       = azurerm_virtual_network.vnet.id
}

output "name" {
    description = "Name of the virtual network"
    value       = azurerm_virtual_network.vnet.name
}

output "subnet_ids" {
    description = "Subnet IDs created inside the virtual network"
    value       = [for _, subnet in azurerm_subnet.subnet: subnet.id]
}