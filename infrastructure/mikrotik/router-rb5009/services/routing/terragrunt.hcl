include "root" { path = find_in_parent_folders("root.hcl") }
include "provider" { path = find_in_parent_folders("provider.hcl") }

dependencies {
  paths = [find_in_parent_folders("mikrotik/router-rb5009")]
}

terraform {
  source = "git::https://github.com/mirceanton/terraform-modules-routeros.git//modules/routing?ref=v0.4.0"
}

inputs = {
  static_routes = {
    "ashome-via-vpn" = {
      dst_address = "192.168.10.0/24"
      gateway     = "wg1"
      comment     = "AS Home over WireGuard"
    }
  }
}
