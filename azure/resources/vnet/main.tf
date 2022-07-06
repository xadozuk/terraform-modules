locals {
    subnets = zipmap(var.subnet_names, var.subnet_prefixes)

    rg_name  = var.resource_group.name
    location = var.resource_group.location

    rg_tags  = var.include_tags_from_resource_group ? var.resource_group.tags : tomap({})
    tags     = merge(local.rg_tags, var.tags)
}

resource "azurerm_virtual_network" "vnet" {
    resource_group_name = local.rg_name
    location            = local.location

    name = format(
        "vnet-%s-%s-%s-%03d",
        var.name,
        var.subscription_type,
        local.location,
        var.instance_number
    )

    address_space       = var.address_spaces
    tags                = local.tags
}

resource "azurerm_subnet" "subnet" {
    for_each = local.subnets

    resource_group_name  = local.rg_name
    virtual_network_name = azurerm_virtual_network.vnet.name

    name = format(
        "snet-%s-%s-%s",
        each.key,
        var.subscription_type,
        local.location
    )

    address_prefixes = [each.value]
}

# TODO: Permit user to specify his own NSG to bind to specific subnets
resource "azurerm_network_security_group" "nsg" {
    for_each = local.subnets

    resource_group_name = local.rg_name
    location            = local.location

    name = "nsg-snet-${each.key}"
    tags = local.tags
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg" {
    for_each = local.subnets

    network_security_group_id = azurerm_network_security_group.nsg[each.key].id
    subnet_id                 = azurerm_subnet.subnet[each.key].id
}