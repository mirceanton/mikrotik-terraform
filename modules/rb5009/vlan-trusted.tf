# =================================================================================================
# VLAN Interface
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/interface_vlan
# =================================================================================================
resource "routeros_interface_vlan" "trusted" {
  interface = routeros_interface_bridge.bridge.name
  name      = "Trusted"
  vlan_id   = 1969
}



# =================================================================================================
# IP Address
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_address
# =================================================================================================
resource "routeros_ip_address" "trusted" {
  address   = "192.168.69.1/24"
  interface = routeros_interface_vlan.trusted.name
  network   = "192.168.69.0"
}


# =================================================================================================
# Bridge VLAN Interface
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/interface_bridge_vlan
# =================================================================================================
resource "routeros_interface_bridge_vlan" "trusted" {
  bridge = routeros_interface_bridge.bridge.name

  vlan_ids = [
    routeros_interface_vlan.trusted.vlan_id
  ]

  tagged = [
    routeros_interface_bridge.bridge.name,
    routeros_interface_ethernet.living_room.name
  ]

  untagged = [
    routeros_interface_ethernet.sploinkhole.name
  ]
}


# ================================================================================================
# DHCP Server Configuration
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_pool
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_dhcp_server_network
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_dhcp_server
# ================================================================================================
resource "routeros_ip_pool" "trusted_dhcp" {
  name    = "trusted-dhcp-pool"
  comment = "Trusted DHCP Pool"
  ranges  = ["192.168.69.190-192.168.69.199"]
}
resource "routeros_ip_dhcp_server_network" "trusted" {
  comment    = "Trusted DHCP Network"
  domain     = "trusted.home.mirceanton.com"
  address    = "192.168.69.0/24"
  gateway    = "192.168.69.1"
  dns_server = ["192.168.69.1"]
}
resource "routeros_ip_dhcp_server" "trusted" {
  name               = "trusted"
  comment            = "Trusted DHCP Server"
  address_pool       = routeros_ip_pool.trusted_dhcp.name
  interface          = routeros_interface_vlan.trusted.name
  client_mac_limit   = 1
  conflict_detection = false
}


# ================================================================================================
# Leases for servers DHCP server
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_dhcp_server_lease
# ================================================================================================
resource "routeros_ip_dhcp_server_lease" "trusted" {
  for_each = {
    "MirkPuter-10g" = { address = "192.168.69.69", mac_address = "24:2F:D0:7F:FA:1F" }
    "BomkPuter"     = { address = "192.168.69.68", mac_address = "24:4B:FE:52:D0:65" }
  }
  server = routeros_ip_dhcp_server.trusted.name

  mac_address = each.value.mac_address
  address     = each.value.address
  comment     = each.key
}
