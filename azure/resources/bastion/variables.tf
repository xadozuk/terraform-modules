variable "subscription_type" {
  description = "Summary description of the purpose of the subscription that contains the virtual network resources (prod, shared, client, ...)."

  type = string
}

variable "instance_number" {
  description = "Instance number of the resource"

  type    = number
  default = 1
}

variable "resource_group" {
  description = "Resource group that will contains virtual network resources"

  type = object({
      name     = string
      location = string
      tags     = map(string)
  })
}

variable "name" {
  description = "Short name of the Azure Firewall"
  type        = string
}

variable "tags" {
  description = "Tags to apply to virtual network resources"

  type = map(string)

  default = {}
}

variable "subnet_id" {
  description = "ID of the AzureBastionSubnet subnet resource to use."
  type = string
}

variable "sku" {
  description = "Name of the SKU for the Azure firewall (Basic or Standard)."

  type = string
}