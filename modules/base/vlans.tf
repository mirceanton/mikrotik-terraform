locals {
  # Process all interfaces for VLAN assignments
  bridge_vlan_assignments = flatten([
    # Tagged interfaces
    flatten([
      for iface_name, iface in var.ethernet_interfaces : [
        for vlan_name in(iface.tagged != null ? iface.tagged : []) : {
          vlan_name = vlan_name
          iface     = iface_name
          type      = "tagged"
        }
      ] if iface.tagged != null
    ]),
    # Untagged interfaces
    [
      for iface_name, iface in var.ethernet_interfaces : {
        vlan_name = iface.untagged
        iface     = iface_name
        type      = "untagged"
      } if iface.untagged != null && iface.untagged != ""
    ],
    # Tagged bond interfaces
    flatten([
      for bond_name, bond in var.bond_interfaces : [
        for vlan_name in(bond.tagged != null ? bond.tagged : []) : {
          vlan_name = vlan_name
          iface     = bond_name
          type      = "tagged"
        }
      ] if bond.tagged != null
    ]),
    # Untagged bond interfaces
    [
      for bond_name, bond in var.bond_interfaces : {
        vlan_name = bond.untagged
        iface     = bond_name
        type      = "untagged"
      } if bond.untagged != null && bond.untagged != ""
    ]
  ])

  # Construct the final bridge_vlans data structure
  vlan_assignments = { for vlan_name, _ in { for k, v in var.vlans : v.name => v } : vlan_name => {
    tagged = distinct([
      for assignment in local.bridge_vlan_assignments :
      assignment.iface if assignment.vlan_name == vlan_name && assignment.type == "tagged"
    ]),
    untagged = distinct([
      for assignment in local.bridge_vlan_assignments :
      assignment.iface if assignment.vlan_name == vlan_name && assignment.type == "untagged"
    ])
  } }

  # Combine with bridge for all VLANs
  final_bridge_vlans = {
    for vlan_name, vlan in { for k, v in var.vlans : v.name => v } : vlan_name => {
      vlan_ids = [vlan.vlan_id]
      tagged = distinct(concat(
        [var.bridge_name], # !Always tag the bridge interface
        lookup(local.vlan_assignments, vlan_name, { tagged = [] }).tagged
      ))
      untagged = lookup(local.vlan_assignments, vlan_name, { untagged = [] }).untagged
    }
  }
}

# =================================================================================================
# VLANs
# =================================================================================================
resource "routeros_interface_vlan" "vlans" {
  for_each = var.vlans

  interface = var.bridge_name
  name      = each.value.name
  vlan_id   = each.value.vlan_id
}

# =================================================================================================
# Bridge VLANs
# =================================================================================================
resource "routeros_interface_bridge_vlan" "bridge_vlans" {
  for_each = local.final_bridge_vlans

  bridge   = routeros_interface_bridge.bridge.name
  comment  = each.key
  vlan_ids = each.value.vlan_ids

  tagged   = each.value.tagged
  untagged = each.value.untagged
}