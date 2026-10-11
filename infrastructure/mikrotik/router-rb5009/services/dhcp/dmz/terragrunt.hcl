include "root" { path = find_in_parent_folders("root.hcl") }
include "provider" { path = find_in_parent_folders("provider.hcl") }
include "dhcp" { path = find_in_parent_folders("dhcp.hcl") }

terraform {
  source = "git::https://github.com/mirceanton/terraform-modules-routeros.git//modules/dhcp-server?ref=v0.4.0"
}

inputs = {
  interface   = "DMZ"
  address     = "172.16.30.1/24"
  network     = "172.16.30.0/24"
  gateway     = "172.16.30.1"
  dhcp_pool   = ["172.16.30.195-172.16.30.199"]
  dns_servers = ["1.1.1.1", "1.0.0.1", "8.8.8.8"]
  domain      = "dmz.h.mirceanton.com"

  static_leases = {
    "172.16.30.10" = { name = "letiny", mac = "90:2E:16:D1:E7:64" }
  }
}
