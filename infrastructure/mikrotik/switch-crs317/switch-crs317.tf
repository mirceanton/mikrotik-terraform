# =================================================================================================
# Provider Configuration
# =================================================================================================
provider "routeros" {
  alias    = "crs317"
  hosturl  = "https://10.0.0.2"
  username = var.mikrotik_username
  password = var.mikrotik_password
  insecure = true
}

# =================================================================================================
# Base System Configs
# =================================================================================================
module "crs317" {
  source    = "../../../modules/base"
  providers = { routeros = routeros.crs317 }

  certificate_common_name = "10.0.0.2"
  hostname                = "CRS317"
  timezone                = local.timezone
  ntp_servers             = [local.cloudflare_ntp]

  vlans = local.vlans
  ethernet_interfaces = {
    "sfp-sfpplus1"  = { comment = "NAS 10g 1", bridge_port = false }
    "sfp-sfpplus2"  = { comment = "NAS 10g 2", bridge_port = false }
    "sfp-sfpplus3"  = { comment = "PVE01 10g 1", bridge_port = false }
    "sfp-sfpplus4"  = { comment = "PVE01 10g 2", bridge_port = false }
    "sfp-sfpplus5"  = { comment = "PVE02 10g 1", bridge_port = false }
    "sfp-sfpplus6"  = { comment = "PVE02 10g 2", bridge_port = false }
    "sfp-sfpplus7"  = { comment = "PVE03 10g 1", bridge_port = false }
    "sfp-sfpplus8"  = { comment = "PVE03 10g 2", bridge_port = false }
    "sfp-sfpplus9"  = {}
    "sfp-sfpplus10" = {}
    "sfp-sfpplus11" = {}
    "sfp-sfpplus12" = {}
    "sfp-sfpplus13" = {}
    "sfp-sfpplus14" = {}
    "sfp-sfpplus15" = {}
    "sfp-sfpplus16" = { comment = "CRS326", tagged = local.all_vlans }
    "ether1"        = {}
  }
  bond_interfaces = {
    "bond1" = {
      slaves  = ["sfp-sfpplus1", "sfp-sfpplus2"]
      comment = "NAS"
      tagged  = [for name, vlan in local.vlans : vlan.name if name != "Servers"]

    }
    "bond2" = {
      slaves  = ["sfp-sfpplus3", "sfp-sfpplus4"]
      comment = "PVE01"
      tagged  = [for name, vlan in local.vlans : vlan.name if name != "Servers"]
    }
    "bond3" = {
      slaves  = ["sfp-sfpplus5", "sfp-sfpplus6"]
      comment = "PVE02"
      tagged  = [for name, vlan in local.vlans : vlan.name if name != "Servers"]
    }
    "bond4" = {
      slaves  = ["sfp-sfpplus7", "sfp-sfpplus8"]
      comment = "PVE03"
      tagged  = [for name, vlan in local.vlans : vlan.name if name != "Servers"]
    }
  }
}

# =================================================================================================
# DHCP Client
# =================================================================================================
resource "routeros_ip_dhcp_client" "crs317" {
  provider     = routeros.crs317
  interface    = local.vlans.Servers.name
  use_peer_dns = true
  use_peer_ntp = false
}
