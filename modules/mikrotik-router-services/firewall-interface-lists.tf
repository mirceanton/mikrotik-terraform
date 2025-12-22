# ================================================================================================
# Interface Lists
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/interface_list
# ================================================================================================
resource "routeros_interface_list" "wan" {
  name    = "WAN"
  comment = "All Public-Facing Interfaces"
}
resource "routeros_interface_list" "lan" {
  name    = "LAN"
  comment = "All Local Interfaces"
}


# ================================================================================================
# Interface List Members
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/interface_list_member
# ================================================================================================
resource "routeros_interface_list_member" "wan" {
  interface = routeros_interface_pppoe_client.digi.name
  list      = routeros_interface_list.wan.name
}
resource "routeros_interface_list_member" "vlan_lan" {
  for_each  = var.vlans
  interface = each.value.name
  list      = routeros_interface_list.lan.name
}
resource "routeros_interface_list_member" "bridge_lan" {
  interface = "bridge"
  list      = routeros_interface_list.lan.name
}
