# =================================================================================================
# Base System Configs
# =================================================================================================
module "crs326" {
  source = "../../../modules/base"

  certificate_common_name = "10.0.0.3"
  hostname                = "CRS326"
  vlans                   = var.vlans
  ethernet_interfaces = {
    "ether1"       = {}
    "ether2"       = { comment = "PVE 01 Onboard", untagged = var.vlans.Servers.name }
    "ether3"       = { comment = "PVE 02 Onboard", untagged = var.vlans.Servers.name }
    "ether4"       = { comment = "PVE 03 Onboard", untagged = var.vlans.Servers.name }
    "ether5"       = { comment = "NAS Onboard", untagged = var.vlans.Servers.name }
    "ether6"       = {}
    "ether7"       = { comment = "TeSmart KVM", untagged = var.vlans.Servers.name }
    "ether8"       = { comment = "JetKVM", untagged = var.vlans.Servers.name }
    "ether9"       = {}
    "ether10"      = {}
    "ether11"      = { comment = "HomeAssistant", untagged = var.vlans.Untrusted.name }
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
    "ether23"      = { comment = "Uplink", tagged = var.all_vlans }
    "ether24"      = {}
    "sfp-sfpplus1" = { comment = "CRS317", tagged = var.all_vlans }
    "sfp-sfpplus2" = { comment = "Mirkputer", untagged = var.vlans.Trusted.name }
  }
}

# =================================================================================================
# DHCP Client
# =================================================================================================
resource "routeros_ip_dhcp_client" "crs326" {
  interface    = var.vlans.Servers.name
  use_peer_dns = true
  use_peer_ntp = false
}
