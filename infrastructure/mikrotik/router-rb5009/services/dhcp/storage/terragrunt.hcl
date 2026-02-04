include "root" { path = find_in_parent_folders("root.hcl") }
include "provider" { path = find_in_parent_folders("provider.hcl") }

dependencies {
  paths = [find_in_parent_folders("mikrotik/router-rb5009")]
}

terraform {
  source = find_in_parent_folders("modules/mikrotik-dhcp-server")
}

inputs = {
  interface   = "Storage"
  address     = "10.255.255.1/24"
  network     = "10.255.255.0/24"
  gateway     = null
  dhcp_pool   = ["10.255.255.195-10.255.255.199"]
  dns_servers = ["10.255.255.1"]
  domain      = "stor.h.mirceanton.com"

  static_leases = {
    # Proxmox Cluster
    "10.255.255.21" = { name = "pve01", mac = "f4:52:14:87:14:90" }
    "10.255.255.22" = { name = "pve02", mac = "00:07:43:32:f4:b0" }
    "10.255.255.23" = { name = "pve03", mac = "00:07:43:32:f4:70" }

    # HomeOps K8s Cluster
    "10.255.255.31" = { name = "hops-01", mac = "BC:24:11:6E:38:45" }
    "10.255.255.32" = { name = "hops-02", mac = "BC:24:11:79:84:DF" }
    "10.255.255.33" = { name = "hops-03", mac = "BC:24:11:D7:3A:E7" }

    # Other Devices
    "10.255.255.69"  = { name = "mirkputer", mac = "00:02:C9:54:76:3C" }
    "10.255.255.245" = { name = "nas", mac = "BC:24:11:77:C7:24" }
  }
}
