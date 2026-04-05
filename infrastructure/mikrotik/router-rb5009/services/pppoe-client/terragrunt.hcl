include "root" { path = find_in_parent_folders("root.hcl") }
include "provider" { path = find_in_parent_folders("provider.hcl") }

dependencies {
  paths = [find_in_parent_folders("services/firewall")]
}

terraform {
  source = "git::https://github.com/mirceanton/terraform-modules-routeros.git//modules/pppoe-client?ref=v0.1.2"
}

inputs = {
  interface = "ether1"
  name      = "PPPoE-Digi"
  comment   = "Digi PPPoE Client"
  username  = get_env("PPPOE_USERNAME") #TODO: Fetch from 1Password
  password  = get_env("PPPOE_PASSWORD") #TODO: Fetch from 1Password
}
