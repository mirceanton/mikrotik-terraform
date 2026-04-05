include "root" { path = find_in_parent_folders("root.hcl") }
include "provider" { path = find_in_parent_folders("provider.hcl") }

dependencies {
  paths = [find_in_parent_folders("services/pppoe-client")]
}

terraform {
  source = "git::https://github.com/mirceanton/terraform-modules-routeros.git//modules/cloud?ref=v0.1.2"
}

inputs = {
  ddns_enabled         = true
  ddns_update_interval = "1m"
}
