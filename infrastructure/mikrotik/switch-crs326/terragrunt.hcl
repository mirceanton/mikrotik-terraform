include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependencies {
  paths = [
    find_in_parent_folders("mikrotik/switch-hex")
  ]
}

locals {
  mikrotik_hostname = "10.0.0.3"
  shared_locals     = read_terragrunt_config(find_in_parent_folders("locals.hcl")).locals
}

terraform {
  source = find_in_parent_folders("modules/mikrotik-base")
}

inputs = {
  mikrotik_hostname = "https://${local.mikrotik_hostname}"
  mikrotik_username = get_env("MIKROTIK_USERNAME")
  mikrotik_password = get_env("MIKROTIK_PASSWORD")
  mikrotik_insecure = true

  certificate_common_name = local.mikrotik_hostname
  hostname                = "CRS326"
  timezone                = local.shared_locals.timezone
  ntp_servers             = [local.shared_locals.cloudflare_ntp]

  vlans = local.shared_locals.vlans
  ethernet_interfaces = {
    "ether1"       = {}
    "ether2"       = { comment = "PVE 01 Onboard", untagged = local.shared_locals.vlans.Servers.name }
    "ether3"       = { comment = "PVE 02 Onboard", untagged = local.shared_locals.vlans.Servers.name }
    "ether4"       = { comment = "PVE 03 Onboard", untagged = local.shared_locals.vlans.Servers.name }
    "ether5"       = { comment = "NAS Onboard", untagged = local.shared_locals.vlans.Servers.name }
    "ether6"       = {}
    "ether7"       = { comment = "TeSmart KVM", untagged = local.shared_locals.vlans.Servers.name }
    "ether8"       = { comment = "JetKVM", untagged = local.shared_locals.vlans.Servers.name }
    "ether9"       = {}
    "ether10"      = {}
    "ether11"      = { comment = "HomeAssistant", untagged = local.shared_locals.vlans.Untrusted.name }
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
    "ether23"      = { comment = "Uplink", tagged = local.shared_locals.all_vlans }
    "ether24"      = {}
    "sfp-sfpplus1" = { comment = "CRS317", tagged = local.shared_locals.all_vlans }
    "sfp-sfpplus2" = { comment = "Mirkputer", untagged = local.shared_locals.vlans.Trusted.name }
  }
}

