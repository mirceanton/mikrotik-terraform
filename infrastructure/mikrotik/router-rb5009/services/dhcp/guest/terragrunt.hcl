include "root" { path = find_in_parent_folders("root.hcl") }
include "provider" { path = find_in_parent_folders("provider.hcl") }
include "dhcp" { path = find_in_parent_folders("dhcp.hcl") }

terraform {
  source = "git::https://github.com/mirceanton/terraform-modules-routeros.git//modules/dhcp-server?ref=v0.1.3"
}

inputs = {
  interface   = "Guest"
  address     = "172.16.42.1/24"
  network     = "172.16.42.0/24"
  gateway     = "172.16.42.1"
  dhcp_pool   = ["172.16.42.10-172.16.42.250"]
  dns_servers = ["1.1.1.1", "1.0.0.1", "8.8.8.8"]
  domain      = "gst.h.mirceanton.com"

  static_leases = {}
}
