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
  interface   = "Storage"
  address     = "10.255.255.1/24"
  network     = "10.255.255.0/24"
  gateway     = "10.255.255.1"
  dhcp_pool   = ["10.255.255.195-10.255.255.199"]
  dns_servers = ["10.255.255.1"]
  domain      = "stor.h.mirceanton.com"

  static_leases = {
    "10.255.255.15" = { name = "Infra-K8S", mac = "00:a0:98:45:ee:df" }

    "10.255.255.31" = { name = "HOPS-01", mac = "BC:24:11:29:C6:82" }
    "10.255.255.32" = { name = "HOPS-02", mac = "BC:24:11:6C:CA:40" }
    "10.255.255.33" = { name = "HOPS-03", mac = "BC:24:11:2A:82:ED" }

    "10.255.255.69" = { name = "MirkPuter", mac = "00:02:C9:54:76:3C" }
  }
}
