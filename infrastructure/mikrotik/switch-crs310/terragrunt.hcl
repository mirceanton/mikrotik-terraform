include "root" { path = find_in_parent_folders("root.hcl") }
include "provider" {
  path   = "./provider.hcl"
  expose = true
}

dependencies {
  paths = [find_in_parent_folders("mikrotik/router-rb5009")]
}

locals {
  mikrotik_globals = read_terragrunt_config(find_in_parent_folders("globals.hcl")).locals
}

terraform {
  source = "git::https://github.com/mirceanton/terraform-modules-routeros.git//modules/base?ref=v0.4.0"
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
  ip_services              = local.mikrotik_globals.ip_services
  users                    = local.mikrotik_globals.default_users
  groups                   = local.mikrotik_globals.default_groups

  mac_server_interfaces = local.mikrotik_globals.mac_server_interfaces

  vlans = local.mikrotik_globals.vlans
  ethernet_interfaces = {
    "ether1" = {}
    "ether2" = { comment = "Living Room", tagged = local.mikrotik_globals.all_vlans }
    "ether3" = { comment = "Zimaboard L", untagged = local.mikrotik_globals.vlans.Utils.name }
    "ether4" = { comment = "Sploinkhole", untagged = local.mikrotik_globals.vlans.Trusted.name }
    "ether5" = { comment = "Zimaboard R", untagged = local.mikrotik_globals.vlans.Utils.name }
    "ether6" = {}
    "ether7" = { comment = "ASUS PN64", untagged = local.mikrotik_globals.vlans.Services.name }
    "ether8" = { comment = "NAS 10g", untagged = local.mikrotik_globals.vlans.Storage.name }
    "sfp-sfpplus1" = {
      comment  = "RB5009"
      untagged = local.mikrotik_globals.vlans.Management.name
      tagged   = local.mikrotik_globals.all_but_management_vlans
    }
    "sfp-sfpplus2" = {}
  }
}
