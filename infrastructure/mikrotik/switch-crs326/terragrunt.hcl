include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependencies {
  paths = [
    find_in_parent_folders("mikrotik/switch-hex")
  ]
}

locals {
  mikrotik_hostname = "10.0.0.3"
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
  hostname                = "CRS326"
  timezone                = local.shared_locals.timezone
  ntp_servers             = [local.shared_locals.cloudflare_ntp]

  vlans = local.shared_locals.vlans
   ethernet_interfaces = {
     "ether1" = { comment = "NAS BMC", untagged = local.shared_locals.vlans.Management.name }
     "ether2" = { comment = "NAS Onboard L", untagged = local.shared_locals.vlans.Management.name }
     "ether3" = { comment = "NAS Onboard R", untagged = local.shared_locals.vlans.Services.name }
     "ether4" = {}
     "ether5" = {} # Reserved for future use. ?PVE01 BMC?
     "ether6" = {
       comment  = "PVE 01 Onboard"
       untagged = local.shared_locals.vlans.Management.name
       tagged   = [for name, vlan in local.shared_locals.vlans : vlan.name if name != local.shared_locals.vlans.Management.name]
     }
     "ether7" = {} # Reserved for future use. ?PVE02 BMC?
     "ether8" = {
       comment  = "PVE 02 Onboard"
       untagged = local.shared_locals.vlans.Management.name
       tagged   = [for name, vlan in local.shared_locals.vlans : vlan.name if name != local.shared_locals.vlans.Management.name]
     }
     "ether9" = {} # Reserved for future use. ?PVE03 BMC?
     "ether10" = {
       comment  = "PVE 03 Onboard"
       untagged = local.shared_locals.vlans.Management.name
       tagged   = [for name, vlan in local.shared_locals.vlans : vlan.name if name != local.shared_locals.vlans.Management.name]
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
     "ether23"      = { comment = "HEX Uplink", tagged = local.shared_locals.all_vlans }
     "ether24"      = { comment = "Mirkputer 1g", untagged = local.shared_locals.vlans.Trusted.name }
     "sfp-sfpplus1" = { comment = "CRS317", tagged = local.shared_locals.all_vlans }
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
