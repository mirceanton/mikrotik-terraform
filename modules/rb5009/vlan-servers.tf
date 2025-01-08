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

  untagged = []
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
  domain     = "servers.home.mirceanton.com"
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
    "CRS317"           = { address = "10.0.0.2", mac_address = "D4:01:C3:02:5D:52" }
    "CRS326"           = { address = "10.0.0.3", mac_address = "D4:01:C3:F8:46:EE" }
    "cAP-AX"           = { address = "10.0.0.5", mac_address = "D4:01:C3:01:26:EB" }
    "Cisco SG350 - TV" = { address = "10.0.0.4", mac_address = "00:EE:AB:28:1C:81" }
    "BliKVM"           = { address = "10.0.0.254", mac_address = "12:00:96:6F:5D:51" }
  }
  server = routeros_ip_dhcp_server.servers.name

  mac_address = each.value.mac_address
  address     = each.value.address
  comment     = each.key
}
