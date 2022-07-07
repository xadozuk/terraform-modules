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
  description = "Short name of the Azure VPN Gateway"
  type        = string
}

variable "tags" {
  description = "Tags to apply to virtual network resources"

  type = map(string)

  default = {}
}

variable "subnet_id" {
  description = "ID of the GatewaySubnet subnet resource to use."
  type = string
}

variable "sku" {
  description = "SKU of the Virtual Network Gateway"
  type        = string
}

variable "type" {
  description = "Type of ther Virtual Network Gateway (Vpn or ExpressRoute)"
  type        = string
}