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
    "sfp-sfpplus1"  = { comment = "NAS 10g 1", bridge_port = false, l2mtu = 9216, mtu = 9000 }
    "sfp-sfpplus2"  = { comment = "NAS 10g 2", bridge_port = false, l2mtu = 9216, mtu = 9000 }
    "sfp-sfpplus3"  = { comment = "PVE01 10g 1", bridge_port = false, l2mtu = 9216, mtu = 9000 }
    "sfp-sfpplus4"  = { comment = "PVE01 10g 2", bridge_port = false, l2mtu = 9216, mtu = 9000 }
    "sfp-sfpplus5"  = { comment = "PVE02 10g 1", bridge_port = false, l2mtu = 9216, mtu = 9000 }
    "sfp-sfpplus6"  = { comment = "PVE02 10g 2", bridge_port = false, l2mtu = 9216, mtu = 9000 }
    "sfp-sfpplus7"  = { comment = "PVE03 10g 1", bridge_port = false, l2mtu = 9216, mtu = 9000 }
    "sfp-sfpplus8"  = { comment = "PVE03 10g 2", bridge_port = false, l2mtu = 9216, mtu = 9000 }
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
      comment = "NAS", mtu = 9000
      slaves  = ["sfp-sfpplus1", "sfp-sfpplus2"]
      tagged  = [for name, vlan in local.shared_locals.vlans : vlan.name if name != local.shared_locals.vlans.Management.name]
    }
    "bond2" = {
      comment  = "PVE01", mtu = 9000
      slaves   = ["sfp-sfpplus3", "sfp-sfpplus4"]
      untagged = local.shared_locals.vlans.Storage.name
    }
    "bond3" = {
      comment  = "PVE02", mtu = 9000
      slaves   = ["sfp-sfpplus5", "sfp-sfpplus6"]
      untagged = local.shared_locals.vlans.Storage.name
    }
    "bond4" = {
      comment  = "PVE03", mtu = 9000
      slaves   = ["sfp-sfpplus7", "sfp-sfpplus8"]
      untagged = local.shared_locals.vlans.Storage.name
    }
  }
}

