# =================================================================================================
# Provider Configuration
# =================================================================================================
provider "routeros" {
  alias    = "crs326"
  hosturl  = "https://10.0.0.3"
  username = var.mikrotik_username
  password = var.mikrotik_password
  insecure = true
}

# =================================================================================================
# Base System Configs
# =================================================================================================
module "crs326" {
  source    = "./modules/base"
  providers = { routeros = routeros.crs326 }

  certificate_common_name = "10.0.0.3"
  hostname                = "CRS326"
  timezone                = local.timezone
  ntp_servers             = [local.cloudflare_ntp]

  vlans = local.vlans
  ethernet_interfaces = {
    "ether1"       = {}
    "ether2"       = { comment = "PVE 01 Onboard", untagged = local.vlans.Servers.name }
    "ether3"       = { comment = "PVE 02 Onboard", untagged = local.vlans.Servers.name }
    "ether4"       = { comment = "PVE 03 Onboard", untagged = local.vlans.Servers.name }
    "ether5"       = { comment = "NAS Onboard", untagged = local.vlans.Servers.name }
    "ether6"       = {}
    "ether7"       = { comment = "TeSmart KVM", untagged = local.vlans.Servers.name }
    "ether8"       = { comment = "JetKVM", untagged = local.vlans.Servers.name }
    "ether9"       = {}
    "ether10"      = {}
    "ether11"      = { comment = "HomeAssistant", untagged = local.vlans.Untrusted.name }
    "ether12"      = {}
    "ether13"      = {}
    "ether14"      = {}
    "ether15"      = {}
    "ether16"      = {}
    "ether17"      = {}
    "ether18"      = {}
    "ether19"      = {}
    "ether20"      = {}
    "ether21"      = {}
    "ether22"      = {}
    "ether23"      = { comment = "Uplink", tagged = local.all_vlans }
    "ether24"      = {}
    "sfp-sfpplus1" = { comment = "CRS317", tagged = local.all_vlans }
    "sfp-sfpplus2" = { comment = "Mirkputer", untagged = local.vlans.Trusted.name }
  }
}

# =================================================================================================
# DHCP Client
# =================================================================================================
resource "routeros_ip_dhcp_client" "crs326" {
  provider     = routeros.crs326
  interface    = local.vlans.Servers.name
  use_peer_dns = true
  use_peer_ntp = false
}
