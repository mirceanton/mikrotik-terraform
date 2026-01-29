include "root" { path = find_in_parent_folders("root.hcl") }
include "provider" {
  path   = "./provider.hcl"
  expose = true
}

dependencies {
  paths = [find_in_parent_folders("mikrotik/switch-hex")]
}

locals {
  mikrotik_globals = read_terragrunt_config(find_in_parent_folders("globals.hcl")).locals
}

terraform {
  source = find_in_parent_folders("modules/mikrotik-base")
}

inputs = {
  certificate_common_name = include.provider.locals.mikrotik_hostname
  hostname                = upper(split("-", get_terragrunt_dir())[2])
  timezone                = local.mikrotik_globals.timezone
  ntp_servers             = [local.mikrotik_globals.cloudflare_ntp]

  vlans = local.mikrotik_globals.vlans
  ethernet_interfaces = {
    "ether1" = { comment = "NAS BMC", untagged = local.mikrotik_globals.vlans.Management.name }
    "ether2" = { comment = "NAS Onboard L", untagged = local.mikrotik_globals.vlans.Management.name }
    "ether3" = { comment = "NAS Onboard R", untagged = local.mikrotik_globals.vlans.Services.name }
    "ether4" = {}
    "ether5" = {} # Reserved for future use. ?PVE01 BMC?
    "ether6" = {
      comment  = "PVE 01 Onboard"
      untagged = local.mikrotik_globals.vlans.Management.name
      tagged   = local.mikrotik_globals.all_but_management_vlans
    }
    "ether7" = {} # Reserved for future use. ?PVE02 BMC?
    "ether8" = {
      comment  = "PVE 02 Onboard"
      untagged = local.mikrotik_globals.vlans.Management.name
      tagged   = local.mikrotik_globals.all_but_management_vlans
    }
    "ether9" = {} # Reserved for future use. ?PVE03 BMC?
    "ether10" = {
      comment  = "PVE 03 Onboard"
      untagged = local.mikrotik_globals.vlans.Management.name
      tagged   = local.mikrotik_globals.all_but_management_vlans
    }
    "ether11"      = {}
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
    "ether23"      = { comment = "HEX Uplink", tagged = local.mikrotik_globals.all_vlans }
    "ether24"      = { comment = "Mirkputer 1g", untagged = local.mikrotik_globals.vlans.Trusted.name }
    "sfp-sfpplus1" = { comment = "CRS317", tagged = local.mikrotik_globals.all_vlans }
    "sfp-sfpplus2" = {} #! TODO: LAGG to CRS317 at some point
  }

  user_groups = {
    metrics = {
      policies = ["api", "read"]
      comment  = "Metrics collection group"
    }
  }

  users = {
    metrics = {
      group   = "metrics"
      comment = "Prometheus metrics user"
    }
  }
}
