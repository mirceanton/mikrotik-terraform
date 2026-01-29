include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependencies {
  paths = [
    find_in_parent_folders("mikrotik/router-rb5009")
  ]
}

locals {
  mikrotik_hostname = "10.0.0.4"
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
  hostname                = upper(split("-", get_terragrunt_dir())[2])
  timezone                = local.shared_locals.timezone
  ntp_servers             = [local.shared_locals.cloudflare_ntp]

  vlans = local.shared_locals.vlans
  ethernet_interfaces = {
    "ether1" = { comment = "Rack Downlink", tagged = local.shared_locals.all_vlans }
    "ether2" = { comment = "Zigbee Dongle", untagged = local.shared_locals.vlans.Management.name }
    "ether3" = {}
    "ether4" = { comment = "Router Uplink", tagged = local.shared_locals.all_vlans }
    "ether5" = { comment = "Smart TV", untagged = local.shared_locals.vlans.Untrusted.name }
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
