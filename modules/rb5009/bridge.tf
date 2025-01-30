# =================================================================================================
# Bridge Interfaces
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/interface_bridge
# =================================================================================================
resource "routeros_interface_bridge" "bridge" {
  name           = "bridge"
  comment        = ""
  disabled       = false
  vlan_filtering = true
}

# =================================================================================================
# Interface List Member
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/interface_list_member
# =================================================================================================
resource "routeros_interface_list_member" "bridge_lan" {
  interface = routeros_interface_bridge.bridge.name
  list      = routeros_interface_list.lan.name
}


# =================================================================================================
# Bridge Ports
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/interfa
# =================================================================================================ce_bridge_port
resource "routeros_interface_bridge_port" "living_room" {
  bridge    = routeros_interface_bridge.bridge.name
  interface = routeros_interface_ethernet.living_room.name
  comment   = routeros_interface_ethernet.living_room.comment
  pvid      = "1"
}
resource "routeros_interface_bridge_port" "sploinkhole" {
  bridge    = routeros_interface_bridge.bridge.name
  interface = routeros_interface_ethernet.sploinkhole.name
  comment   = routeros_interface_ethernet.sploinkhole.comment
  pvid      = routeros_interface_vlan.trusted.vlan_id
}
resource "routeros_interface_bridge_port" "access_point" {
  bridge    = routeros_interface_bridge.bridge.name
  interface = routeros_interface_ethernet.access_point.name
  comment   = routeros_interface_ethernet.access_point.comment
  pvid      = routeros_interface_vlan.servers.vlan_id
}
