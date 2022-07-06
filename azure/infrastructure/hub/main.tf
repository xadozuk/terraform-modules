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
module "vnet" {
  source = "../../resources/vnet"


}