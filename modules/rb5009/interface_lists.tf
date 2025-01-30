# ================================================================================================
# Interface Lists
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/interface_list
# ================================================================================================
resource "routeros_interface_list" "wan" {
  name = "WAN"
  comment = "All Public-Facing Interfaces"
}
resource "routeros_interface_list" "lan" {
  name = "LAN"
  comment = "All Local Interfaces"
}
