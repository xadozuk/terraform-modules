resource "azurerm_public_ip" "pip" {
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location

  allocation_method = "Static"
  sku               = "Standard"

  name = format(
    "pip-afw-%s-%s-%s-%03d",
    var.name,
    var.subscription_type,
    var.resource_group.location,
    var.instance_number
  )

  tags = var.tags
}

resource "azurerm_firewall" "firewall" {
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location

  name     = format(
    "afw-%s-%s-%s-%03d",
    var.name,
    var.subscription_type,
    var.resource_group.location,
    var.instance_number
  )

  sku_name = var.sku_name
  sku_tier = var.sku_tier

  tags     = var.tags

  ip_configuration {
    name                 = "ipconfig1"
    subnet_id            = var.subnet_id
    public_ip_address_id = azurerm_public_ip.pip.id
  }
}