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
# Bridge Ports
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/interfa
# =================================================================================================ce_bridge_port
resource "routeros_interface_bridge_port" "nas" {
  bridge    = routeros_interface_bridge.bridge.name
  interface = routeros_interface_bonding.nas.name
  comment   = routeros_interface_bonding.nas.comment
  pvid      = "1"
}
resource "routeros_interface_bridge_port" "kube01" {
  bridge    = routeros_interface_bridge.bridge.name
  interface = routeros_interface_bonding.kube01.name
  comment   = routeros_interface_bonding.kube01.comment
  pvid      = "1"
}
resource "routeros_interface_bridge_port" "kube02" {
  bridge    = routeros_interface_bridge.bridge.name
  interface = routeros_interface_bonding.kube02.name
  comment   = routeros_interface_bonding.kube02.comment
  pvid      = "1"
}
resource "routeros_interface_bridge_port" "kube03" {
  bridge    = routeros_interface_bridge.bridge.name
  interface = routeros_interface_bonding.kube03.name
  comment   = routeros_interface_bonding.kube03.comment
  pvid      = "1"
}
resource "routeros_interface_bridge_port" "pve" {
  bridge    = routeros_interface_bridge.bridge.name
  interface = routeros_interface_bonding.pve.name
  comment   = routeros_interface_bonding.pve.comment
  pvid      = "1"
}
resource "routeros_interface_bridge_port" "crs326" {
  bridge    = routeros_interface_bridge.bridge.name
  interface = routeros_interface_bonding.crs326.name
  comment   = routeros_interface_bonding.crs326.comment
  pvid      = "1"
}
resource "routeros_interface_bridge_port" "mirk-desktop" {
  bridge    = routeros_interface_bridge.bridge.name
  interface = routeros_interface_ethernet.mirk-desktop.name
  comment   = routeros_interface_ethernet.mirk-desktop.comment
  pvid      = "1"
}

