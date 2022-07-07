
variable "name" {
  description = "Virtual network name"
  type = string
}

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
  description = "Resource group object that will contains virtual network resources"

  type = object({
      name        = string
      location    = string
      tags        = map(string)
  })
}

variable "address_spaces" {
  description = "Adresse spaces of the virtual network"

  type = list(string)
}

variable "follow_subnet_naming_convention" {
  description = "Automatically name subnet according to Azure default naming convention"

  type    = bool
  default = true
}

variable "subnet_names" {
  description = "List of subnet names"

  type = list(string)
}

variable "subnet_prefixes" {
  description = "List of subnet prefixes"

  type = list(string)
}

variable "tags" {
  description = "Tags to apply to virtual network resources"

  type = map(string)

  default = {}
}

variable "include_tags_from_resource_group" {
  description = "Include tags from resource group"
  type        = bool
  default     = false
}

variable "network_security_group_ids" {
  description = "Existing network security groups to attach to subnet (if set to null for a specific subnet, will disable NSG creation)."

  type = map(string)

  default = {}
}
