locals {
  subnets = zipmap(var.subnet_names, var.subnet_prefixes)

  rg_name  = var.resource_group.name
  location = var.resource_group.location

  rg_tags  = var.include_tags_from_resource_group ? var.resource_group.tags : tomap({})
  tags     = merge(local.rg_tags, var.tags)

  network_security_groups_to_create = {
    for name, _ in local.subnets :
      name => name if try(var.network_security_group_ids[name], true) == true
  }

  network_security_groups_to_attach = {
    for name, _ in local.subnets :
      name => name if try(var.network_security_group_ids[name], true) != null
  }
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

  name = var.follow_subnet_naming_convention ? format(
                                                "snet-%s-%s-%s",
                                                each.key,
                                                var.subscription_type,
                                                local.location
                                              ) : each.key

  address_prefixes = [each.value]
}

resource "azurerm_network_security_group" "nsg" {
  for_each = local.network_security_groups_to_create

  resource_group_name = local.rg_name
  location            = local.location

  name = "nsg-snet-${each.key}"
  tags = local.tags
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg" {
  for_each = local.network_security_groups_to_attach

  network_security_group_id = try(var.network_security_group_ids[each.key], azurerm_network_security_group.nsg[each.key].id)
  subnet_id                 = azurerm_subnet.subnet[each.key].id
}