# =================================================================================================
# Provider Configuration
# =================================================================================================
provider "routeros" {
  alias    = "rb5009"
  hosturl  = "https://10.0.0.1"
  username = var.mikrotik_username
  password = var.mikrotik_password
  insecure = true
}

# =================================================================================================
# Base System Configs
# =================================================================================================
module "rb5009" {
  source    = "../../../modules/base"
  providers = { routeros = routeros.rb5009 }

  certificate_common_name = "10.0.0.1"
  hostname                = "Router"
  timezone                = local.timezone
  ntp_servers             = [local.cloudflare_ntp]

  vlans = local.vlans
  ethernet_interfaces = {
    "ether1" = { comment = "Digi Uplink", bridge_port = false }
    "ether2" = { comment = "Living Room", tagged = local.all_vlans }
    "ether3" = { comment = "Sploinkhole", untagged = local.vlans.Trusted.name }
    "ether4" = {}
    "ether5" = {}
    "ether6" = {}
    "ether7" = {}
    "ether8" = {
      comment  = "Access Point",
      untagged = local.vlans.Servers.name
      tagged   = [local.vlans.Untrusted.name, local.vlans.Guest.name, local.vlans.IoT.name]
    }
    "sfp-sfpplus1" = {}
  }
}
