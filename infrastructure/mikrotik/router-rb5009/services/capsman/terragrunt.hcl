include "root" { path = find_in_parent_folders("root.hcl") }
include "provider" { path = find_in_parent_folders("provider.hcl") }

dependencies {
  paths = [find_in_parent_folders("mikrotik/router-rb5009")]
}

locals {
  mikrotik_globals = read_terragrunt_config(find_in_parent_folders("globals.hcl")).locals
}

terraform {
  source = find_in_parent_folders("modules/mikrotik-capsman")
}

inputs = {
  country            = "Romania"
  capsman_interfaces = ["all"]
  upgrade_policy     = "require-same-version"

  channel_settings = {
    "5ghz-ax" = {
      skip_dfs_channels = "all"
      frequency         = ["5180", "5200", "5220", "5240"] # UNII-1: Channels 36, 40, 44, 48 (non-DFS)
      width             = "20mhz"
    }
    "2ghz-ax" = {
      frequency = ["2437"] # Channel 6
      width     = "20mhz"
    }
  }

  wifi_networks = {
    home-5ghz = {
      ssid    = "badoink-5ghz"
      band    = "5ghz-ax"
      vlan_id = local.mikrotik_globals.vlans.Untrusted.vlan_id
    }
    home-2ghz = {
      ssid    = "badoink-2ghz"
      band    = "2ghz-ax"
      vlan_id = local.mikrotik_globals.vlans.Untrusted.vlan_id
    }

    guest = {
      ssid             = "badoink-guest"
      band             = "2ghz-ax"
      vlan_id          = local.mikrotik_globals.vlans.Guest.vlan_id
      client_isolation = true
    }
  }
}
