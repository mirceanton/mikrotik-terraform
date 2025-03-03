# =================================================================================================
# Provider Configuration
# =================================================================================================
provider "routeros" {
  alias    = "hex"
  hosturl  = "https://10.0.0.4"
  username = var.mikrotik_username
  password = var.mikrotik_password
  insecure = true
}

# =================================================================================================
# Base System Configs
# =================================================================================================
module "hex" {
  source    = "./modules/base"
  providers = { routeros = routeros.hex }

  certificate_common_name = "10.0.0.4"
  hostname                = "Living Room Switch"
  timezone                = local.timezone
  ntp_servers             = [local.cloudflare_ntp]

  vlans = local.vlans
  ethernet_interfaces = {
    "ether1" = { comment = "Rack Downlink", tagged = local.all_vlans }
    "ether2" = {}
    "ether3" = {}
    "ether4" = { comment = "Router Uplink", tagged = local.all_vlans }
    "ether5" = { comment = "Smart TV", untagged = local.vlans.IoT.name }
  }
}

# =================================================================================================
# DHCP Client
# =================================================================================================
resource "routeros_ip_dhcp_client" "hex" {
  provider     = routeros.hex
  interface    = local.vlans.Servers.name
  use_peer_dns = true
  use_peer_ntp = false
}
