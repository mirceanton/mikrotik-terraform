include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "router_base" {
  config_path = ".."
}

locals {
  mikrotik_hostname = "10.0.0.1"
}

terraform {
  source = find_in_parent_folders("modules/mikrotik-pppoe-client")
}

inputs = {
  mikrotik_hostname = "https://${local.mikrotik_hostname}"
  mikrotik_username = get_env("MIKROTIK_USERNAME")
  mikrotik_password = get_env("MIKROTIK_PASSWORD")
  mikrotik_insecure = true

  interface = "ether1"
  name      = "PPPoE-Digi"
  comment   = "Digi PPPoE Client"
  username  = get_env("PPPOE_USERNAME")
  password  = get_env("PPPOE_PASSWORD")
}
