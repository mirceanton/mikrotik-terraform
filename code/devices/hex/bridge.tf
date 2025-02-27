# =================================================================================================
# Bridge Interfaces
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/interface_bridge
# =================================================================================================
resource "routeros_interface_bridge" "bridge" {
  name           = "bridge1"
  comment        = ""
  disabled       = false
  vlan_filtering = true
}


# =================================================================================================
# Bridge Ports
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/interfa
# =================================================================================================ce_bridge_port
resource "routeros_interface_bridge_port" "ether1" {
  bridge    = routeros_interface_bridge.bridge.name
  interface = routeros_interface_ethernet.rack.name
  comment   = routeros_interface_ethernet.rack.comment
  pvid      = "1"
}
resource "routeros_interface_bridge_port" "ether2" {
  bridge    = routeros_interface_bridge.bridge.name
  interface = routeros_interface_ethernet.ether2.name
  comment   = routeros_interface_ethernet.ether2.comment
  pvid      = "1"
}
resource "routeros_interface_bridge_port" "ether3" {
  bridge    = routeros_interface_bridge.bridge.name
  interface = routeros_interface_ethernet.ether3.name
  comment   = routeros_interface_ethernet.ether3.comment
  pvid      = "1"
}
resource "routeros_interface_bridge_port" "ether4" {
  bridge    = routeros_interface_bridge.bridge.name
  interface = routeros_interface_ethernet.uplink.name
  comment   = routeros_interface_ethernet.uplink.comment
  pvid      = "1"
}
resource "routeros_interface_bridge_port" "ether5" {
  bridge    = routeros_interface_bridge.bridge.name
  interface = routeros_interface_ethernet.smarttv.name
  comment   = routeros_interface_ethernet.smarttv.comment
  pvid      = routeros_interface_vlan.iot.vlan_id
}
