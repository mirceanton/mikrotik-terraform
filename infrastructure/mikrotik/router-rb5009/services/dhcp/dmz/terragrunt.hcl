include "root" { path = find_in_parent_folders("root.hcl") }
include "provider" { path = find_in_parent_folders("provider.hcl") }
include "dhcp" { path = find_in_parent_folders("dhcp.hcl") }

terraform {
  source = "git::https://github.com/mirceanton/terraform-modules-routeros.git//modules/dhcp-server?ref=v0.4.0"
}

inputs = {
  interface   = "DMZ"
  address     = "10.0.20.1/24"
  network     = "10.0.20.0/24"
  gateway     = null
  dhcp_pool   = ["10.0.20.195-10.0.20.249"]
  dns_servers = ["10.0.20.1"]
  domain      = "dmz.h.mirceanton.com"

  static_leases = {}
}