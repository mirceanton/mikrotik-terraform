# =================================================================================================
# Bridge Interfaces
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/interface_bridge
# =================================================================================================
resource "routeros_interface_bridge" "bridge" {
  name           = var.bridge_name
  comment        = var.bridge_comment
  disabled       = false
  vlan_filtering = true
}


# =================================================================================================
# Bridge Ports
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/interface_bridge_port
# =================================================================================================
resource "routeros_interface_bridge_port" "ethernet_ports" {
  for_each = var.ethernet_interfaces

  bridge    = routeros_interface_bridge.bridge.name
  interface = each.key
  comment   = each.value.comment != null ? each.value.comment : ""

  # If untagged VLAN is specified, find its VLAN ID as PVID
  pvid = (each.value.untagged != null && each.value.untagged != "") ? (
    [for k, v in var.vlans : v.vlan_id if v.name == each.value.untagged][0]
  ) : 1
}