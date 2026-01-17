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
  source = find_in_parent_folders("modules/mikrotik-capsman")
}

inputs = {
  mikrotik_hostname = "https://${local.mikrotik_hostname}"
  mikrotik_username = get_env("MIKROTIK_USERNAME")
  mikrotik_password = get_env("MIKROTIK_PASSWORD")
  mikrotik_insecure = true

  country            = "Romania"
  capsman_interfaces = ["all"]
  upgrade_policy     = "none"

  wifi_networks = {
    guest = {
      ssid             = "badoink-guest"
      band             = "2ghz-ax"
      vlan_id          = 1742  # Guest VLAN
      client_isolation = true
    }
    untrusted_2ghz = {
      ssid    = "badoink-2ghz"
      band    = "2ghz-ax"
      vlan_id = 1942  # Untrusted VLAN
    }
    untrusted_5ghz = {
      ssid    = "badoink-5ghz"
      band    = "5ghz-ax"
      vlan_id = 1942  # Untrusted VLAN
    }
  }
}
