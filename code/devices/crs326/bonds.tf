# =================================================================================================
# Interface Bonds
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/interface_bonding
# =================================================================================================
resource "routeros_interface_bonding" "crs317" {
  name    = "bond-crs317"
  mode    = "802.3ad"
  comment = "CRS317"
  slaves = [
    routeros_interface_ethernet.crs317-1.name,
    routeros_interface_ethernet.crs317-2.name,
  ]
}

resource "routeros_interface_bonding" "virt" {
  name    = "bond-virt"
  mode    = "802.3ad"
  comment = "Virtualization server"
  slaves = [
    routeros_interface_ethernet.virt-1.name,
    routeros_interface_ethernet.virt-2.name,
  ]
}