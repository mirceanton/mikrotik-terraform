# =================================================================================================
# Base System Configs
# =================================================================================================
module "hex" {
  source = "../../../modules/base"

  certificate_common_name = "10.0.0.4"
  hostname                = "HEX"
  vlans                   = var.vlans
  ethernet_interfaces = {
    "ether1" = { comment = "Rack Downlink", tagged = var.all_vlans }
    "ether2" = { comment = "SteamBox", untagged = var.vlans.Trusted.name }
    "ether3" = {}
    "ether4" = { comment = "Router Uplink", tagged = var.all_vlans }
    "ether5" = { comment = "Smart TV", untagged = var.vlans.IoT.name }
  }
}

# =================================================================================================
# DHCP Client
# =================================================================================================
resource "routeros_ip_dhcp_client" "hex" {
  interface    = var.vlans.Servers.name
  use_peer_dns = true
  use_peer_ntp = false
}
