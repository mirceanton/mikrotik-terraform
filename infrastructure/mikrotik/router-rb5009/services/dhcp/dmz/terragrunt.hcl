include "root" { path = find_in_parent_folders("root.hcl") }
include "provider" { path = find_in_parent_folders("provider.hcl") }
include "dhcp" { path = find_in_parent_folders("dhcp.hcl") }

terraform {
  source = "git::https://github.com/mirceanton/terraform-modules-routeros.git//modules/dhcp-server?ref=v0.3.0"
}

inputs = {
  interface   = "DMZ"
  address     = "10.0.30.1/24"
  network     = "10.0.30.0/24"
  gateway     = "10.0.30.1"
  dhcp_pool   = ["10.0.30.10-10.0.30.10"]
  dns_servers = ["10.0.30.1"]
  domain      = "dmz.h.mirceanton.com"

  # Single-node Talos cluster. Pool hands out exactly one address (.10).
  # A static lease pinning .10 to the node's MAC will be added once known.
  static_leases = {}
}
