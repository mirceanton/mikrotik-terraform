include "root" { path = find_in_parent_folders("root.hcl") }
include "provider" { path = find_in_parent_folders("provider.hcl") }

dependencies {
  paths = [find_in_parent_folders("services/pppoe-client")]
}

terraform {
  source = find_in_parent_folders("modules/mikrotik-cloud")
}

inputs = {
  ddns_enabled         = true
  ddns_update_interval = "1m"
}
