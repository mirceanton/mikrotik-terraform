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
  source = find_in_parent_folders("modules/mikrotik-base")
}

inputs = {
  hostname                = upper(split("-", basename(get_terragrunt_dir()))[1])
  certificate_common_name = include.provider.locals.mikrotik_hostname
  timezone                = local.mikrotik_globals.timezone
  ntp_servers             = [local.mikrotik_globals.cloudflare_ntp]
  users                   = local.mikrotik_globals.default_users
  groups                  = local.mikrotik_globals.default_groups

  vlans = local.mikrotik_globals.vlans
  ethernet_interfaces = {
    "ether1" = { comment = "Rack Downlink", tagged = local.mikrotik_globals.all_vlans }
    "ether2" = { comment = "Zigbee Dongle", untagged = local.mikrotik_globals.vlans.Management.name }
    "ether3" = {}
    "ether4" = { comment = "Router Uplink", tagged = local.mikrotik_globals.all_vlans }
    "ether5" = { comment = "Smart TV", untagged = local.mikrotik_globals.vlans.Untrusted.name }
  }
}
