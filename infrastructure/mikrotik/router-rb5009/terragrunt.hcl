include "root" { path = find_in_parent_folders("root.hcl") }
include "provider" {
  path   = "./provider.hcl"
  expose = true
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
  mac_server_interfaces    = local.mikrotik_globals.mac_server_interfaces
  vlans                    = local.mikrotik_globals.vlans

  users = merge(local.mikrotik_globals.default_users, {
    external-dns = {
      group              = "external-dns"
      comment            = "External DNS user"
      inactivity_policy  = "logout"
      inactivity_timeout = "00:02:00"
    }
    external-dns-utils = {
      group              = "external-dns"
      comment            = "External DNS user for the utils cluster"
      address            = "10.0.20.10/32"
      inactivity_policy  = "logout"
      inactivity_timeout = "00:02:00"
    }
  })
  groups = merge(local.mikrotik_globals.default_groups, {
    external-dns = {
      policies = ["read", "write", "api", "rest-api"]
      comment  = "External DNS group"
    }
  })

  ethernet_interfaces = {
    "sfp-sfpplus1" = {
      comment  = "CRS310",
      untagged = local.mikrotik_globals.vlans.Management.name
      tagged   = local.mikrotik_globals.all_but_management_vlans
    }
    "ether1" = {}
    "ether2" = { comment = "NAS BMC", untagged = local.mikrotik_globals.vlans.Management.name }
    "ether3" = { comment = "Comet X", untagged = local.mikrotik_globals.vlans.Management.name }
    "ether4" = { comment = "NAS eno1 (mgmt)", untagged = local.mikrotik_globals.vlans.Management.name }
    "ether5" = {
      comment  = "cAP XL"
      untagged = local.mikrotik_globals.vlans.Management.name
      tagged   = [local.mikrotik_globals.vlans.Untrusted.name, local.mikrotik_globals.vlans.Guest.name]
    }
    "ether6" = { comment = "NAS eno2 (Storage backup)", untagged = local.mikrotik_globals.vlans.Storage.name }
    "ether7" = { comment = "Lenovo Tiny", untagged = local.mikrotik_globals.vlans.DMZ.name }
    "ether8" = { comment = "Digi Uplink", bridge_port = false }
  }
}