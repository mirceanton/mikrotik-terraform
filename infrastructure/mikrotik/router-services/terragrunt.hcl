include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependencies {
  paths = [
    find_in_parent_folders("mikrotik/router-base")
  ]
}

locals {
  mikrotik_hostname = "10.0.0.1"
  network_config    = read_terragrunt_config(find_in_parent_folders("locals.hcl"))
}

terraform {
  source = find_in_parent_folders("modules/mikrotik-router-services")
}

inputs = {
  mikrotik_hostname = "https://${local.mikrotik_hostname}"
  mikrotik_username = get_env("MIKROTIK_USERNAME")
  mikrotik_password = get_env("MIKROTIK_PASSWORD")
  mikrotik_insecure = true

  digi_pppoe_password    = get_env("PPPOE_PASSWORD")
  digi_pppoe_username    = get_env("PPPOE_USERNAME")
  zerotier_central_token = get_env("ZEROTIER_CENTRAL_TOKEN")

  vlans        = local.network_config.locals.vlans
  static_dns   = local.network_config.locals.static_dns
  upstream_dns = local.network_config.locals.upstream_dns
  adlist       = local.network_config.locals.adlist
}
