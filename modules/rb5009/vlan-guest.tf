# =================================================================================================
# VLAN Interface
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/interface_vlan
# =================================================================================================
resource "routeros_interface_vlan" "guest" {
  interface = routeros_interface_bridge.bridge.name
  name      = "Guest"
  vlan_id   = 1742
}


# =================================================================================================
# IP Address
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_address
# =================================================================================================
resource "routeros_ip_address" "guest" {
  address   = "172.16.42.1/24"
  interface = routeros_interface_vlan.guest.name
  network   = "172.16.42.0"
}


# =================================================================================================
# Bridge VLAN Interface
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/interface_bridge_vlan
# =================================================================================================
resource "routeros_interface_bridge_vlan" "guest" {
  bridge = routeros_interface_bridge.bridge.name

  vlan_ids = [
    routeros_interface_vlan.guest.vlan_id
  ]

  tagged = [
    routeros_interface_bridge.bridge.name,
    routeros_interface_ethernet.living_room.name,
    routeros_interface_ethernet.access_point.name
  ]

  untagged = [
  ]
}

# ================================================================================================
# DHCP Server Configuration
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_pool
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_dhcp_server_network
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_dhcp_server
# ================================================================================================
resource "routeros_ip_pool" "guest_dhcp" {
  name    = "guest-dhcp-pool"
  comment = "Guest DHCP Pool"
  ranges  = ["172.16.42.10-172.16.42.250"]
}
resource "routeros_ip_dhcp_server_network" "guest" {
  comment    = "Guest DHCP Network"
  domain     = "guest.home.mirceanton.com"
  address    = "172.16.42.0/24"
  gateway    = "172.16.42.1"
  dns_server = ["1.1.1.1", "1.0.0.1", "8.8.8.8"] #!no local dns
}
resource "routeros_ip_dhcp_server" "guest" {
  name               = "guest"
  comment            = "Guest DHCP Server"
  address_pool       = routeros_ip_pool.guest_dhcp.name
  interface          = routeros_interface_vlan.guest.name
  client_mac_limit   = 1
  conflict_detection = false
}
