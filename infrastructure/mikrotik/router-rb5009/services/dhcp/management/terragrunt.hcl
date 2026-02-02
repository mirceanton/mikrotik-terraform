include "root" { path = find_in_parent_folders("root.hcl") }
include "provider" { path = find_in_parent_folders("provider.hcl") }

dependencies {
  paths = [find_in_parent_folders("mikrotik/router-rb5009")]
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
  domain      = "mgmt.h.mirceanton.com"

  static_leases = {
    "10.0.0.2" = { name = "crs317", mac = "D4:01:C3:02:5D:52" }
    "10.0.0.3" = { name = "crs326", mac = "D4:01:C3:F8:46:EE" }
    "10.0.0.4" = { name = "hex", mac = "F4:1E:57:31:05:41" }
    "10.0.0.5" = { name = "cap-ax", mac = "D4:01:C3:01:26:EB" }

    "10.0.0.10" = { name = "bmc-homeprod", mac = "3C:EC:EF:39:1B:70" }
    "10.0.0.15" = { name = "homeprod", mac = "3c:ec:ef:20:be:42" }

    "10.0.0.21" = { name = "pve01", mac = "74:56:3c:9e:bf:1a" }
    "10.0.0.22" = { name = "pve02", mac = "74:56:3c:99:5b:ce" }
    "10.0.0.23" = { name = "pve03", mac = "74:56:3c:b2:e5:a8" }

    "10.0.0.30" = { name = "homeops", mac = "BC:24:11:75:B6:FF" }

    "10.0.0.99" = { name = "sonoff-dongle-max", mac = "94:54:C5:27:FC:DB" }

    "10.0.0.245" = { name = "nas", mac = "BC:24:11:C6:12:86" }
  }
}
