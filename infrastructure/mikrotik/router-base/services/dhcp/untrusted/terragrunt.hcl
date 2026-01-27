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
  source = find_in_parent_folders("modules/mikrotik-dhcp-server")
}

inputs = {
  interface   = "Untrusted"
  address     = "192.168.42.1/24"
  network     = "192.168.42.0/24"
  gateway     = "192.168.42.1"
  dhcp_pool   = ["192.168.42.100-192.168.42.199"]
  dns_servers = ["192.168.42.1"]
  domain      = "utrst.h.mirceanton.com"

  static_leases = {
    "192.168.42.69"  = { name = "MirkDesk Pi", mac = "E4:5F:01:03:61:34" }
    "192.168.42.70"  = { name = "LivingRoom Pi", mac = "DC:A6:32:37:D3:DD" }
    "192.168.42.180" = { name = "BomkPrinter", mac = "58:05:D9:3C:0A:C1" }
    "192.168.42.250" = { name = "Smart TV", mac = "38:26:56:E2:93:99" }
  }
}
