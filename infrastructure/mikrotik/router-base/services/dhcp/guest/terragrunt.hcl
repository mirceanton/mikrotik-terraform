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
  interface   = "Guest"
  address     = "172.16.42.1/24"
  network     = "172.16.42.0/24"
  gateway     = "172.16.42.1"
  dhcp_pool   = ["172.16.42.10-172.16.42.250"]
  dns_servers = ["1.1.1.1", "1.0.0.1", "8.8.8.8"]
  domain      = "gst.h.mirceanton.com"

  static_leases = {}
}
