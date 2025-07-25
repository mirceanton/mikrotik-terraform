include "root" {
  path = find_in_parent_folders("root.hcl")
}
include "shared_provider" {
  path = find_in_parent_folders("provider.hcl")
}

dependencies {
  paths = [
    find_in_parent_folders("mikrotik/switch-crs326")
  ]
}

locals {
  mikrotik_hostname = "10.0.0.2"
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
  hostname                = "CRS317"
  timezone                = local.shared_locals.timezone
  ntp_servers             = [local.shared_locals.cloudflare_ntp]

  vlans = local.shared_locals.vlans
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
    "sfp-sfpplus16" = { comment = "CRS326", tagged = local.shared_locals.all_vlans }
    "ether1"        = {}
  }
  bond_interfaces = {
    "bond1" = {
      slaves  = ["sfp-sfpplus1", "sfp-sfpplus2"]
      comment = "NAS"
      tagged  = [for name, vlan in local.shared_locals.vlans : vlan.name if name != "Servers"]

    }
    "bond2" = {
      slaves  = ["sfp-sfpplus3", "sfp-sfpplus4"]
      comment = "PVE01"
      tagged  = [for name, vlan in local.shared_locals.vlans : vlan.name if name != "Servers"]
    }
    "bond3" = {
      slaves  = ["sfp-sfpplus5", "sfp-sfpplus6"]
      comment = "PVE02"
      tagged  = [for name, vlan in local.shared_locals.vlans : vlan.name if name != "Servers"]
    }
    "bond4" = {
      slaves  = ["sfp-sfpplus7", "sfp-sfpplus8"]
      comment = "PVE03"
      tagged  = [for name, vlan in local.shared_locals.vlans : vlan.name if name != "Servers"]
    }
  }
}

