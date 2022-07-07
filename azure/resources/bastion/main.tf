resource "azurerm_public_ip" "pip" {
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location

  allocation_method = "Static"
  sku               = "Standard"

  name = format(
    "pip-bas-%s-%s-%s-%03d",
    var.name,
    var.subscription_type,
    var.resource_group.location,
    var.instance_number
  )

  tags = var.tags
}

resource "azurerm_bastion_host" "bastion" {
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location

  name = format(
    "bas-%s-%s-%s-%03d",
    var.name,
    var.subscription_type,
    var.resource_group.location,
    var.instance_number
  )

  sku = var.sku

  ip_configuration {
    name                  = "ipconfig1"
    subnet_id             = var.subnet_id
    public_ip_address_id  = azurerm_public_ip.pip.id
  }
}