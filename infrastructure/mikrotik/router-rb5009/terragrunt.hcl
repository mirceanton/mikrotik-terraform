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
  timezone                = include.common.locals.mikrotik_globals.timezone
  ntp_servers             = [include.common.locals.mikrotik_globals.cloudflare_ntp]

  vlans = include.common.locals.mikrotik_globals.vlans
   ethernet_interfaces = {
     "ether1" = { comment = "Digi Uplink", bridge_port = false }
     "ether2" = { comment = "Living Room", tagged = include.common.locals.mikrotik_globals.all_vlans }
     "ether3" = { comment = "Sploinkhole", untagged = include.common.locals.mikrotik_globals.vlans.Trusted.name }
     "ether4" = {}
     "ether5" = {}
     "ether6" = {}
     "ether7" = {}
     "ether8" = {
       comment  = "Access Point",
       untagged = include.common.locals.mikrotik_globals.vlans.Management.name
       tagged   = [include.common.locals.mikrotik_globals.vlans.Untrusted.name, include.common.locals.mikrotik_globals.vlans.Guest.name]
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
