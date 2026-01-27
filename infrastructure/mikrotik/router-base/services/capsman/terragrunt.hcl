include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "common" {
  path   = find_in_parent_folders("common.hcl")
  expose = true
}

dependencies {
  paths = [find_in_parent_folders("mikrotik/router-base")]
}

terraform {
  source = find_in_parent_folders("modules/mikrotik-capsman")
}

inputs = {
  country            = "Romania"
  capsman_interfaces = ["all"]
  upgrade_policy     = "none"

  wifi_networks = {
    guest = {
      ssid             = "badoink-guest"
      band             = "2ghz-ax"
      vlan_id          = include.common.locals.shared_locals.vlans.Guest.vlan_id
      client_isolation = true
    }
    home = {
      ssid    = "badoink"
      band    = "5ghz-ax"
      vlan_id = include.common.locals.shared_locals.vlans.Untrusted.vlan_id
    }
  }
}
