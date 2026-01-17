include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "router_base" {
  config_path = "../.."
}

locals {
  mikrotik_hostname = "10.0.0.1"
  network_config    = read_terragrunt_config(find_in_parent_folders("locals.hcl"))
  vlan              = local.network_config.locals.vlans.Storage
}

terraform {
  source = find_in_parent_folders("modules/mikrotik-dhcp-server")
}

inputs = {
  mikrotik_hostname = "https://${local.mikrotik_hostname}"
  mikrotik_username = get_env("MIKROTIK_USERNAME")
  mikrotik_password = get_env("MIKROTIK_PASSWORD")
  mikrotik_insecure = true

  interface     = local.vlan.name
  address       = "${local.vlan.gateway}/${local.vlan.cidr_suffix}"
  network       = "${local.vlan.network}/${local.vlan.cidr_suffix}"
  gateway       = local.vlan.gateway
  dhcp_pool     = local.vlan.dhcp_pool
  dns_servers   = local.vlan.dns_servers
  domain        = local.vlan.domain
  static_leases = local.vlan.static_leases
}
