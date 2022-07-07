# Inputs
# - Resource group object
# - Adress space
# - Subnets
# - Tags

# - VNet
# - ExpressRoute GW
# - VPN Gateway
# - LogAnalytics
# - Peering
# - Network Watcher
# - DNS

locals {
  firewall_enabled      = var.firewall != null
  bastion_enabled       = var.bastion != null
  vnet_gateway_enabled  = var.vnet_gateway != null

  vnet_gateway_vpn_enabled          = try(var.vnet_gateway.vpn != null, false)
  vnet_gateway_express_route_enabled = try(var.vnet_gateway.express_route != null, false)

  subnet_names = compact([
    local.firewall_enabled      ? "AzureFirewallSubnet" : null,
    local.bastion_enabled       ? "AzureBastionSubnet" : null,
    local.vnet_gateway_enabled  ? "GatewaySubnet" : null
  ])

  subnet_prefixes = compact([
    local.firewall_enabled      ? var.firewall.subnet_prefix : null,
    local.bastion_enabled       ? var.bastion.subnet_prefix : null,
    local.vnet_gateway_enabled  ? var.vnet_gateway.subnet_prefix : null
  ])
}

module "vnet" {
  source = "../../resources/vnet"

  resource_group = var.resource_group

  name              = "hub"
  subscription_type = var.subscription_type
  instance_number   = var.instance_number

  address_spaces    = var.address_spaces

  tags              = var.tags

  subnet_names                  = local.subnet_names
  subnet_prefixes               = local.subnet_prefixes

  follow_subnet_naming_convention = false

  # Disable NSG for Firewall/Bastion/Vnet Gateway subnets
  network_security_group_ids = {
    AzureFirewallSubnet = null
    AzureBastionSubnet  = null
    GatewaySubnet       = null
  }
}

module "firewall" {
  source = "../../resources/firewall"
  count = local.firewall_enabled ? 1 : 0

  resource_group = var.resource_group

  name              = "hub"
  subscription_type = var.subscription_type
  instance_number   = var.instance_number

  sku_name  = "AZFW_VNet"
  sku_tier  = var.firewall.sku_tier
  tags      = var.tags
  subnet_id = module.vnet.subnet_ids["AzureFirewallSubnet"]
}

module "bastion" {
  source = "../../resources/bastion"
  count = local.bastion_enabled ? 1 : 0

  resource_group = var.resource_group

  name              = "hub"
  subscription_type = var.subscription_type
  instance_number   = var.instance_number

  sku       = var.bastion.sku
  tags      = var.tags
  subnet_id = module.vnet.subnet_ids["AzureBastionSubnet"]
}

module "vpn_gateway" {
  source = "../../resources/vnet_gateway"
  count = local.vnet_gateway_vpn_enabled ? 1 : 0

  resource_group = var.resource_group

  name              = "hub"
  subscription_type = var.subscription_type
  instance_number   = var.instance_number

  sku       = var.vnet_gateway.vpn.sku
  type      = "Vpn"
  tags      = var.tags
  subnet_id = module.vnet.subnet_ids["GatewaySubnet"]
}

module "express_route_gateway" {
  source = "../../resources/vnet_gateway"
  count = local.vnet_gateway_express_route_enabled ? 1 : 0

  resource_group = var.resource_group

  name              = "hub"
  subscription_type = var.subscription_type
  instance_number   = var.instance_number

  sku       = var.vnet_gateway.express_route.sku
  type      = "ExpressRoute"
  tags      = var.tags
  subnet_id = module.vnet.subnet_ids["GatewaySubnet"]
}