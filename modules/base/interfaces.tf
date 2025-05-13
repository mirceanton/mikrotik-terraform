resource "routeros_interface_ethernet" "ethernet" {
  for_each = var.ethernet_interfaces

  factory_name = each.key
  name         = each.key
  comment      = each.value.comment
  l2mtu        = each.value.mtu
  disabled     = each.value.disabled

  # Set sfp_shutdown_temperature if defined
  sfp_shutdown_temperature = each.value.sfp_shutdown_temperature
}
