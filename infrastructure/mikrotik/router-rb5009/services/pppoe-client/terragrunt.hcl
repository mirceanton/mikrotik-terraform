include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "common" {
  path   = find_in_parent_folders("common.hcl")
  expose = true
}

dependencies {
  paths = [find_in_parent_folders("mikrotik/router-rb5009/services/firewall")]
}

terraform {
  source = find_in_parent_folders("modules/mikrotik-pppoe-client")
}

inputs = {
  interface = "ether1"
  name      = "PPPoE-Digi"
  comment   = "Digi PPPoE Client"
  username  = get_env("PPPOE_USERNAME")
  password  = get_env("PPPOE_PASSWORD")
}
