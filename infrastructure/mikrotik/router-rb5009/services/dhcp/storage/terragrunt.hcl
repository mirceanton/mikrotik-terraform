include "root" { path = find_in_parent_folders("root.hcl") }
include "provider" { path = find_in_parent_folders("provider.hcl") }
include "dhcp" { path = find_in_parent_folders("dhcp.hcl") }

terraform {
  source = "git::https://github.com/mirceanton/terraform-modules-routeros.git//modules/dhcp-server?ref=v0.1.3"
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
    "10.255.255.15" = { name = "home-ops", mac = "f4:52:14:87:14:90" }

    # Proxmox Cluster
    "10.255.255.22" = { name = "pve02", mac = "00:07:43:32:f4:b0" }
    "10.255.255.23" = { name = "pve03", mac = "00:07:43:32:f4:70" }

    # Other Devices
    "10.255.255.69"  = { name = "mirkputer", mac = "00:02:C9:54:76:3C" }
    "10.255.255.245" = { name = "nas", mac = "BC:24:11:77:C7:24" }
  }
}
