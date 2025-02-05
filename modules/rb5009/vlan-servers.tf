# =================================================================================================
# VLAN Interface
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/interface_vlan
# =================================================================================================
resource "routeros_interface_vlan" "servers" {
  interface = routeros_interface_bridge.bridge.name
  name      = "Servers"
  vlan_id   = 1000
}

# =================================================================================================
# Interface List Member
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/interface_list_member
# =================================================================================================
resource "routeros_interface_list_member" "servers_lan" {
  interface = routeros_interface_vlan.servers.name
  list      = routeros_interface_list.lan.name
}


# =================================================================================================
# IP Address
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_address
# =================================================================================================
resource "routeros_ip_address" "servers" {
  address   = "10.0.0.1/24"
  interface = routeros_interface_vlan.servers.name
  network   = "10.0.0.0"
}


# =================================================================================================
# Bridge VLAN Interface
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/interface_bridge_vlan
# =================================================================================================
resource "routeros_interface_bridge_vlan" "servers" {
  bridge = routeros_interface_bridge.bridge.name

  vlan_ids = [routeros_interface_vlan.servers.vlan_id]

  tagged = [
    routeros_interface_bridge.bridge.name,
    routeros_interface_ethernet.living_room.name
  ]

  untagged = [
    routeros_interface_ethernet.access_point.name
  ]
}


# ================================================================================================
# DHCP Server Configuration
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_pool
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_dhcp_server_network
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_dhcp_server
# ================================================================================================
resource "routeros_ip_pool" "servers_dhcp" {
  name    = "servers-dhcp-pool"
  comment = "Servers DHCP Pool"
  ranges  = ["10.0.0.100-10.0.0.199"]
}
resource "routeros_ip_dhcp_server_network" "servers" {
  comment    = "Servers DHCP Network"
  domain     = "srv.h.mirceanton.com"
  address    = "10.0.0.0/24"
  gateway    = "10.0.0.1"
  dns_server = ["10.0.0.1"]
}
resource "routeros_ip_dhcp_server" "servers" {
  name               = "servers"
  comment            = "Servers DHCP Server"
  address_pool       = routeros_ip_pool.servers_dhcp.name
  interface          = routeros_interface_vlan.servers.name
  client_mac_limit   = 1
  conflict_detection = false
}

# ================================================================================================
# Leases for servers DHCP server
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_dhcp_server_lease
# ================================================================================================
resource "routeros_ip_dhcp_server_lease" "servers" {
  for_each = {
    "CRS317" = { address = "10.0.0.2", mac_address = "D4:01:C3:02:5D:52" }
    "CRS326" = { address = "10.0.0.3", mac_address = "D4:01:C3:F8:47:04" }
    "hex"    = { address = "10.0.0.4", mac_address = "F4:1E:57:31:05:44" }
    "cAP-AX" = { address = "10.0.0.5", mac_address = "D4:01:C3:01:26:EB" }
    "PVE01"  = { address = "10.0.0.21", mac_address = "74:56:3C:9E:BF:1A" }
    "PVE02"  = { address = "10.0.0.22", mac_address = "74:56:3C:99:5B:CE" }
    "PVE03"  = { address = "10.0.0.23", mac_address = "74:56:3C:B2:E5:A8" }
    "BliKVM" = { address = "10.0.0.254", mac_address = "12:00:96:6F:5D:51" }
  }
  server = routeros_ip_dhcp_server.servers.name

  mac_address = each.value.mac_address
  address     = each.value.address
  comment     = each.key
}
