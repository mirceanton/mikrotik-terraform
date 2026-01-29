include "root" { path = find_in_parent_folders("root.hcl") }
include "provider" { path = find_in_parent_folders("provider.hcl") }

dependencies {
  paths = [find_in_parent_folders("mikrotik/router-rb5009")]
}

terraform {
  source = find_in_parent_folders("modules/mikrotik-dhcp-server")
}

inputs = {
  interface   = "Trusted"
  address     = "192.168.69.1/24"
  network     = "192.168.69.0/24"
  gateway     = "192.168.69.1"
  dhcp_pool   = ["192.168.69.190-192.168.69.199"]
  dns_servers = ["192.168.69.1"]
  domain      = "trst.h.mirceanton.com"

  static_leases = {
    "192.168.69.69" = { name = "mirkputer", mac = "74:56:3C:B7:9B:D8" }
    "192.168.69.68" = { name = "bomkputer", mac = "24:4B:FE:52:D0:65" }
  }
}
