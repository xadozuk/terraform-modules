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

variable "address_spaces" {
  description = "Adresse spaces of the virtual network"

  type = list(string)
}

variable "tags" {
  description = "Tags to apply to virtual network resources"

  type = map(string)

  default = {}
}

variable "firewall" {
  description = "Firewall configuration. Setting this to null disable Azure Firewall in the hub."

  type = object({
    subnet_prefix = string
    sku_tier      = string
  })
}

variable "bastion" {
  description = "Azure Bastion configuration. Setting this to null disable Azure Bastion in the hub."

  type = object({
    subnet_prefix = string
    sku           = string
  })
}

variable "vnet_gateway" {
  description = "Azure Virtual Network (VPN) Gateway configuration. Setting this to null disable Azure VPN Gateway in the hub."
  type = object({
    subnet_prefix = string
    vpn = object({
      sku = string
    })
    express_route = object({
      sku = string
    })
  })
}