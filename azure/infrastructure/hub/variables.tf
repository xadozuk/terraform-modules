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