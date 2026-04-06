include "root" { path = find_in_parent_folders("root.hcl") }
include "provider" { path = find_in_parent_folders("provider.hcl") }

dependencies {
  paths = [find_in_parent_folders("mikrotik/router-rb5009")]
}

terraform {
  source = "git::https://github.com/mirceanton/terraform-modules-routeros.git//modules/wireguard-server?ref=v0.2.0"
}

inputs = {
  name        = "wg1"
  address     = "172.16.69.1/24"
  listen_port = 13231
  comment     = "WireGuard VPN server"
}
