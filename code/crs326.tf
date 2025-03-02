module "crs326" {
  source            = "./modules/switch"
  mikrotik_ip       = "10.0.0.3"
  mikrotik_username = var.mikrotik_username
  mikrotik_password = var.mikrotik_password
  mikrotik_insecure = true

  hostname              = "Rach Slow"
  timezone              = local.timezone
  ntp_servers           = [local.cloudflare_ntp]
  dhcp_client_interface = local.vlans.Servers.name

  vlans = local.vlans
  ethernet_interfaces = {
    "ether1" = { comment = "Old NAS Onboard", untagged = local.vlans.Servers.name }
    "ether2" = { comment = "PVE 01 Onboard", untagged = local.vlans.Servers.name }
    "ether3" = { comment = "PVE 02 Onboard", untagged = local.vlans.Servers.name }
    "ether4" = { comment = "PVE 03 Onboard", untagged = local.vlans.Servers.name }
    "ether5" = {
      comment  = "New NAS Onboard",
      tagged   = [local.vlans.Trusted.name, local.vlans.Untrusted.name],
      untagged = local.vlans.Servers.name
    }
    "ether6" = {}
    "ether7" = { comment = "TeSmart KVM", untagged = local.vlans.Servers.name }
    "ether8" = { comment = "BliKVM", untagged = local.vlans.Servers.name }
    "ether9" = {
      comment = "Old NAS Data 1",
      tagged  = [local.vlans.Kubernetes.name, local.vlans.Untrusted.name, local.vlans.Trusted.name],
    }
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
    "ether24"      = { comment = "mirkputer", untagged = local.vlans.Trusted.name }
    "sfp-sfpplus1" = {}
    "sfp-sfpplus2" = {}
  }
}
