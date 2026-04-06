include "root" { path = find_in_parent_folders("root.hcl") }
include "provider" { path = find_in_parent_folders("provider.hcl") }
include "dhcp" { path = find_in_parent_folders("dhcp.hcl") }

terraform {
  source = "git::https://github.com/mirceanton/terraform-modules-routeros.git//modules/dhcp-server?ref=v0.1.2"
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
    "10.0.10.15"  = { name = "home-ops", mac = "F4:52:14:87:14:90" }
    "10.0.10.245" = { name = "nas", mac = "BC:24:11:DA:9A:E4", match_subdomain = true }
  }
}
