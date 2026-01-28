include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "common" {
  path   = "${get_terragrunt_dir()}/common.hcl"
  expose = true
}

terraform {
  source = find_in_parent_folders("modules/mikrotik-base")
}

inputs = {
  certificate_common_name = include.common.locals.mikrotik_hostname
  hostname                = "Router"
  timezone                = include.common.locals.shared_locals.timezone
  ntp_servers             = [include.common.locals.shared_locals.cloudflare_ntp]

  vlans = include.common.locals.shared_locals.vlans
  ethernet_interfaces = {
    "ether1" = { comment = "Digi Uplink", bridge_port = false }
    "ether2" = { comment = "Living Room", tagged = include.common.locals.shared_locals.all_vlans }
    "ether3" = { comment = "Sploinkhole", untagged = include.common.locals.shared_locals.vlans.Trusted.name }
    "ether4" = {}
    "ether5" = {}
    "ether6" = {}
    "ether7" = {}
    "ether8" = {
      comment  = "Access Point",
      untagged = include.common.locals.shared_locals.vlans.Management.name
      tagged   = [include.common.locals.shared_locals.vlans.Untrusted.name, include.common.locals.shared_locals.vlans.Guest.name]
    }
    "sfp-sfpplus1" = {}
  }
}
