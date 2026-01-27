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
  interface   = "Management"
  address     = "10.0.0.1/24"
  network     = "10.0.0.0/24"
  gateway     = "10.0.0.1"
  dhcp_pool   = ["10.0.0.195-10.0.0.199"]
  dns_servers = ["10.0.0.1"]
  domain      = "srv.h.mirceanton.com"

  static_leases = {
    "10.0.0.2" = { name = "CRS317", mac = "D4:01:C3:02:5D:52" }
    "10.0.0.3" = { name = "CRS326", mac = "D4:01:C3:F8:46:EE" }
    "10.0.0.4" = { name = "hex", mac = "F4:1E:57:31:05:41" }
    "10.0.0.5" = { name = "cAP-AX", mac = "D4:01:C3:01:26:EB" }

    "10.0.0.10" = { name = "NAS BMC", mac = "3C:EC:EF:39:1B:70" }

    "10.0.0.15" = { name = "Infra-K8S", mac = "00:a0:98:73:d8:d7" }

    "10.0.0.21" = { name = "PVE01", mac = "74:56:3C:9E:BF:1A" }
    "10.0.0.22" = { name = "PVE02", mac = "74:56:3C:99:5B:CE" }
    "10.0.0.23" = { name = "PVE03", mac = "74:56:3C:B2:E5:A8" }

    "10.0.0.31" = { name = "HOPS-01", mac = "BC:24:11:CB:48:88" }
    "10.0.0.32" = { name = "HOPS-02", mac = "BC:24:11:1E:FA:52" }
    "10.0.0.33" = { name = "HOPS-03", mac = "BC:24:11:EA:C5:58" }

    "10.0.0.99" = { name = "Sonoff Dongle MAX", mac = "94:54:C5:27:FC:DB" }
  }
}
