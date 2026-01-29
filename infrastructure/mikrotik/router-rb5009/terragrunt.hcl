include "root" { path = find_in_parent_folders("root.hcl") }
include "provider" {
  path   = "./provider.hcl"
  expose = true
}

locals {
  mikrotik_globals = read_terragrunt_config(find_in_parent_folders("globals.hcl")).locals
}

terraform { source = find_in_parent_folders("modules/mikrotik-base") }
inputs = {
  certificate_common_name = include.provider.locals.mikrotik_hostname
  hostname                = upper(split("-", basename(get_terragrunt_dir()))[1])
  timezone                = local.mikrotik_globals.timezone
  ntp_servers             = [local.mikrotik_globals.cloudflare_ntp]

  vlans = local.mikrotik_globals.vlans
  ethernet_interfaces = {
    "ether1" = { comment = "Digi Uplink", bridge_port = false }
    "ether2" = { comment = "Living Room", tagged = local.mikrotik_globals.all_vlans }
    "ether3" = { comment = "Sploinkhole", untagged = local.mikrotik_globals.vlans.Trusted.name }
    "ether4" = {}
    "ether5" = {}
    "ether6" = {}
    "ether7" = {}
    "ether8" = {
      comment  = "Access Point",
      untagged = local.mikrotik_globals.vlans.Management.name
      tagged   = [local.mikrotik_globals.vlans.Untrusted.name, local.mikrotik_globals.vlans.Guest.name]
    }
    "sfp-sfpplus1" = {}
  }

  user_groups = {
    metrics = {
      policies = ["api", "read"]
      comment  = "Metrics collection group"
    }
    "external-dns" = {
      policies = ["read", "write", "api", "rest-api"]
      comment  = "External DNS group"
    }
  }

  users = {
    metrics = {
      group   = "metrics"
      comment = "Prometheus metrics user"
    }
    "external-dns" = {
      group   = "external-dns"
      comment = "External DNS user"
    }
  }
}
