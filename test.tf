locals {
  tags = {
    WorkloadName        = "TerraformTest"
    DataClassification  = "Non-business"
    Criticality         = "Low"
    BusinessUnit        = "IT"
    OpsCommitment       = "Baseline only"
    OpsTeam             = "Network"
  }
}

#region infrastructure/hub

resource "azurerm_resource_group" "rg2" {
  location = "francecentral"
  name     = "rg-terraform-test-001"

  tags     = local.tags
}

module "hub" {
  source = "./azure/infrastructure/hub"

  subscription_type = "shared"

  address_spaces  = ["192.168.0.0/16"]
  instance_number = 2
  resource_group  = azurerm_resource_group.rg2
  tags            = local.tags

  firewall = {
    subnet_prefix = "192.168.1.0/26"
    sku_tier      = "Standard"
  }

  bastion = {
    subnet_prefix = "192.168.2.0/26"
    sku           = "Basic"
  }

  vnet_gateway = {
    subnet_prefix = "192.168.3.0/26"
    vpn           = null
    express_route = null
  }
}

#endregion