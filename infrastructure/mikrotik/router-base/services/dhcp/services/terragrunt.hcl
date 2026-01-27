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
  interface   = "Services"
  address     = "10.0.10.1/24"
  network     = "10.0.10.0/24"
  gateway     = "10.0.10.1"
  dhcp_pool   = ["10.0.10.195-10.0.10.199"]
  dns_servers = ["10.0.10.1"]
  domain      = "svc.h.mirceanton.com"

  static_leases = {
    "10.0.10.15" = { name = "k8s-infra", mac = "00:a0:98:26:ec:53" }
    "10.0.10.31" = { name = "hops-01", mac = "BC:24:11:70:56:F4" }
    "10.0.10.32" = { name = "hops-02", mac = "BC:24:11:8E:12:1C" }
    "10.0.10.33" = { name = "hops-03", mac = "BC:24:11:FE:21:FA" }
  }
}
