# =================================================================================================
# Base System Configs
# =================================================================================================
module "rb5009" {
  source = "../../../modules/base"

  certificate_common_name = "10.0.0.1"
  hostname                = "Router"
  vlans = var.vlans
  ethernet_interfaces = {
    "ether1" = { comment = "Digi Uplink", bridge_port = false }
    "ether2" = { comment = "Living Room", tagged = var.all_vlans }
    "ether3" = { comment = "Sploinkhole", untagged = var.vlans.Trusted.name }
    "ether4" = {}
    "ether5" = {}
    "ether6" = {}
    "ether7" = {}
    "ether8" = {
      comment  = "Access Point",
      untagged = var.vlans.Servers.name
      tagged   = [var.vlans.Untrusted.name, var.vlans.Guest.name, var.vlans.IoT.name]
    }
    "sfp-sfpplus1" = {}
  }
}

# =================================================================================================
# PPPoE Client
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/interface_pppoe_client
# =================================================================================================
resource "routeros_interface_pppoe_client" "digi" {
  interface         = "ether1"
  name              = "PPPoE-Digi"
  comment           = "Digi PPPoE Client"
  add_default_route = true
  use_peer_dns      = false
  password          = var.digi_pppoe_password
  user              = var.digi_pppoe_username
}
