include "root" { path = find_in_parent_folders("root.hcl") }
include "provider" {
  path   = "./provider.hcl"
  expose = true
}

dependencies {
  paths = [find_in_parent_folders("mikrotik/switch-crs326")]
}

locals {
  mikrotik_globals = read_terragrunt_config(find_in_parent_folders("globals.hcl")).locals
}

terraform {
  source = "git::https://github.com/mirceanton/terraform-modules-routeros.git//modules/base?ref=v0.2.1"
}
inputs = {
  hostname                 = upper(split("-", basename(get_terragrunt_dir()))[1])
  certificate_common_name  = include.provider.locals.mikrotik_hostname
  certificate_country      = local.mikrotik_globals.certificate_country
  certificate_locality     = local.mikrotik_globals.certificate_locality
  certificate_organization = local.mikrotik_globals.certificate_organization
  certificate_unit         = local.mikrotik_globals.certificate_unit
  disable_ipv6             = local.mikrotik_globals.disable_ipv6
  timezone                 = local.mikrotik_globals.timezone
  ntp_servers              = [local.mikrotik_globals.cloudflare_ntp]
  users                    = local.mikrotik_globals.default_users
  groups                   = local.mikrotik_globals.default_groups

  mac_server_interfaces = local.mikrotik_globals.mac_server_interfaces

  vlans = local.mikrotik_globals.vlans
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
    "sfp-sfpplus14" = {} #! TODO: LAGGed to CRS326 at some point
    "sfp-sfpplus15" = { comment = "CRS326", tagged = local.mikrotik_globals.all_vlans }
    "sfp-sfpplus16" = { comment = "Mirkputer 10G", untagged = local.mikrotik_globals.vlans.Storage.name, l2mtu = 9216, mtu = 9000 }
    "ether1"        = {}
  }
  bond_interfaces = {
    "bond1" = {
      comment = "NAS", mtu = 9000
      slaves  = ["sfp-sfpplus1", "sfp-sfpplus2"]
      tagged  = local.mikrotik_globals.all_but_management_vlans
    }
    "bond2" = {
      comment              = "PVE01", mtu = 9000
      slaves               = ["sfp-sfpplus3", "sfp-sfpplus4"]
      transmit_hash_policy = "layer-3-and-4"
      tagged               = local.mikrotik_globals.all_but_management_vlans
    }
    "bond3" = {
      comment              = "PVE02", mtu = 9000
      slaves               = ["sfp-sfpplus5", "sfp-sfpplus6"]
      transmit_hash_policy = "layer-3-and-4"
      tagged               = local.mikrotik_globals.all_but_management_vlans
    }
    "bond4" = {
      comment              = "PVE03", mtu = 9000
      slaves               = ["sfp-sfpplus7", "sfp-sfpplus8"]
      transmit_hash_policy = "layer-3-and-4"
      tagged               = local.mikrotik_globals.all_but_management_vlans
    }
  }
}
