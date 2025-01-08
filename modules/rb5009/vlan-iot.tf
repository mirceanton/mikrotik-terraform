# =================================================================================================
# VLAN Interface
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/interface_vlan
# =================================================================================================
resource "routeros_interface_vlan" "iot" {
  interface = routeros_interface_bridge.bridge.name
  name      = "IoT"
  vlan_id   = 1769
}


# =================================================================================================
# IP Address
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_address
# =================================================================================================
resource "routeros_ip_address" "iot" {
  address   = "172.16.69.1/24"
  interface = routeros_interface_vlan.iot.name
  network   = "172.16.69.0"
}


# =================================================================================================
# Bridge VLAN Interface
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/interface_bridge_vlan
# =================================================================================================
resource "routeros_interface_bridge_vlan" "iot" {
  bridge = routeros_interface_bridge.bridge.name

  vlan_ids = [
    routeros_interface_vlan.iot.vlan_id
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
resource "routeros_ip_pool" "iot_dhcp" {
  name    = "iot-dhcp-pool"
  comment = "IoT DHCP Pool"
  ranges  = ["172.16.69.10-172.16.69.250"]
}
resource "routeros_ip_dhcp_server_network" "iot" {
  comment    = "IoT DHCP Network"
  domain     = "iot.home.mirceanton.com"
  address    = "172.16.69.0/24"
  gateway    = "172.16.69.1"
  dns_server = ["172.16.69.1"]
}
resource "routeros_ip_dhcp_server" "iot" {
  name               = "iot"
  comment            = "IoT DHCP Server"
  address_pool       = routeros_ip_pool.iot_dhcp.name
  interface          = routeros_interface_vlan.iot.name
  client_mac_limit   = 1
  conflict_detection = false
}

# ================================================================================================
# Leases for servers DHCP server
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_dhcp_server_lease
# ================================================================================================
resource "routeros_ip_dhcp_server_lease" "iot" {
  for_each = {}
  # TODO lease for HA and Smart TV?
  server = routeros_ip_dhcp_server.iot.name

  mac_address = each.value.mac_address
  address     = each.value.address
  comment     = each.key
}
