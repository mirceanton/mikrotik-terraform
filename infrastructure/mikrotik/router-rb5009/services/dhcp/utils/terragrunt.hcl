include "root" { path = find_in_parent_folders("root.hcl") }
include "provider" { path = find_in_parent_folders("provider.hcl") }
include "dhcp" { path = find_in_parent_folders("dhcp.hcl") }

terraform {
  source = "git::https://github.com/mirceanton/terraform-modules-routeros.git//modules/dhcp-server?ref=v0.4.0"
}

inputs = {
  interface   = "Utils"
  address     = "10.0.20.1/24"
  network     = "10.0.20.0/24"
  gateway     = "10.0.20.1"
  dhcp_pool   = ["10.0.20.195-10.0.20.199"]
  dns_servers = ["10.0.20.1"]
  domain      = "utils.h.mirceanton.com"

  static_leases = {
    "10.0.20.10" = { name = "zimaboard", mac = "00:E0:4C:69:DB:DF" }
    # "10.0.20.11" = { name = "zimaboard22", mac = "00:E0:4C:69:DB:E0" }
  }
}
