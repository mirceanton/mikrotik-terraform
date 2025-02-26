# =================================================================================================
# Ethernet Interfaces
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/interface_ethernet
# =================================================================================================
resource "routeros_interface_ethernet" "ethernet" {
  for_each = var.ethernet_interfaces

  factory_name = each.key
  name         = each.key
  comment      = each.value.comment != null ? each.value.comment : ""
  l2mtu        = each.value.mtu != null ? each.value.mtu : 1514
  disabled     = each.value.disabled != null ? each.value.disabled : false

  sfp_shutdown_temperature = each.value.sfp_shutdown_temperature
}

# =================================================================================================
# Interface Bonds
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/interface_bonding
# =================================================================================================
resource "routeros_interface_bonding" "bond" {
  for_each = var.bond_interfaces

  name    = each.key
  mode    = each.value.mode
  comment = each.value.comment
  slaves  = each.value.slaves

  depends_on = [routeros_interface_ethernet.ethernet]
}
