# =================================================================================================
# VLAN Interface
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/interface_vlan
# =================================================================================================
resource "routeros_interface_vlan" "untrusted" {
  interface = routeros_interface_bridge.bridge.name
  name      = "Untrusted"
  vlan_id   = 1942
}

# =================================================================================================
# Interface List Member
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/interface_list_member
# =================================================================================================
resource "routeros_interface_list_member" "untrusted_lan" {
  interface = routeros_interface_vlan.untrusted.name
  list      = routeros_interface_list.lan.name
}



# =================================================================================================
# IP Address
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_address
# =================================================================================================
resource "routeros_ip_address" "untrusted" {
  address   = "192.168.42.1/24"
  interface = routeros_interface_vlan.untrusted.name
  network   = "192.168.42.0"
}


# =================================================================================================
# Bridge VLAN Interface
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/interface_bridge_vlan
# =================================================================================================
resource "routeros_interface_bridge_vlan" "untrusted" {
  bridge   = routeros_interface_bridge.bridge.name
  vlan_ids = [routeros_interface_vlan.untrusted.vlan_id]

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
resource "routeros_ip_pool" "untrusted_dhcp" {
  name    = "untrusted-dhcp-pool"
  comment = "Untrusted DHCP Pool"
  ranges  = ["192.168.42.100-192.168.42.199"]
}
resource "routeros_ip_dhcp_server_network" "untrusted" {
  comment    = "Untrusted DHCP Network"
  domain     = "utrst.h.mirceanton.com"
  address    = "192.168.42.0/24"
  gateway    = "192.168.42.1"
  dns_server = ["192.168.42.1"]
}
resource "routeros_ip_dhcp_server" "untrusted" {
  name               = "untrusted"
  comment            = "Untrusted DHCP Server"
  address_pool       = routeros_ip_pool.untrusted_dhcp.name
  interface          = routeros_interface_vlan.untrusted.name
  client_mac_limit   = 1
  conflict_detection = false
}

# ================================================================================================
# Leases for servers DHCP server
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_dhcp_server_lease
# ================================================================================================
resource "routeros_ip_dhcp_server_lease" "untrusted" {
  for_each = {
    "HomeAssistant" = { address = "192.168.42.253", mac_address = "00:1E:06:42:C7:73" }
    "Mirk Phone"    = { address = "192.168.42.69", mac_address = "04:29:2E:ED:1B:4D" }
    "Bomk Phone"    = { address = "192.168.42.68", mac_address = "5C:70:17:F3:5F:F8" }
  }
  server = routeros_ip_dhcp_server.untrusted.name

  mac_address = each.value.mac_address
  address     = each.value.address
  comment     = each.key
}
