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
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/interface_bridge_port
# =================================================================================================
resource "routeros_interface_bridge_port" "ethernet_ports" {
  for_each = {
    for idx, intf in var.ethernet_interfaces :
    intf.name != "" ? intf.name : idx => intf
    if intf.bridge_port != null
  }

  bridge    = routeros_interface_bridge.bridge.name
  interface = each.key
  comment   = each.value.comment
  pvid      = each.value.bridge_port.pvid
}

# Bridge ports for bond interfaces
resource "routeros_interface_bridge_port" "bond_ports" {
  for_each = {
    for name, bond in var.bond_interfaces :
    name => bond
    if bond.bridge_port != null
  }

  bridge    = routeros_interface_bridge.bridge.name
  interface = each.key
  comment   = each.value.comment
  pvid      = each.value.bridge_port.pvid
}