include "root" { path = find_in_parent_folders("root.hcl") }
include "provider" { path = find_in_parent_folders("provider.hcl") }

dependencies {
  paths = [find_in_parent_folders("mikrotik/router-rb5009")]
}

terraform {
  source = find_in_parent_folders("modules/mikrotik-dhcp-server")
}

inputs = {
  interface   = "Services"
  address     = "10.0.10.1/24"
  network     = "10.0.10.0/24"
  gateway     = null
  dhcp_pool   = ["10.0.10.195-10.0.10.199"]
  dns_servers = ["10.0.10.1"]
  domain      = "svc.h.mirceanton.com"

  static_leases = {
    "10.0.10.30"  = { name = "homeops", mac = "BC:24:11:DF:7E:28" }
    "10.0.10.245" = { name = "nas", mac = "BC:24:11:DA:9A:E4" }
  }
}
