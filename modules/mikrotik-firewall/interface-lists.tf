# =================================================================================================
# Interface Lists
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/interface_list
# =================================================================================================
resource "routeros_interface_list" "this" {
  for_each = var.interface_lists

  name    = each.key
  comment = each.value.comment
}


# =================================================================================================
# Interface List Members
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/interface_list_member
# =================================================================================================
locals {
  # Flatten interface list members into a map for for_each
  # Key format: "list_name/interface_name"
  interface_list_members = merge([
    for list_name, list_config in var.interface_lists : {
      for interface in list_config.interfaces :
      "${list_name}/${interface}" => {
        list      = list_name
        interface = interface
      }
    }
  ]...)
}

resource "routeros_interface_list_member" "this" {
  for_each = local.interface_list_members

  list      = routeros_interface_list.this[each.value.list].name
  interface = each.value.interface
}
