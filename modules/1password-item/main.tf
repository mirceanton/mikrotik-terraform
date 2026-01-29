locals {
  vaults = toset([for item in var.items : item.vault])
}

data "onepassword_vault" "vaults" {
  for_each = local.vaults
  name     = each.value
}

resource "onepassword_item" "items" {
  for_each = var.items

  vault      = data.onepassword_vault.vaults[each.value.vault].uuid
  title      = each.key
  category   = each.value.category
  username   = each.value.username
  password   = each.value.password
  note_value = each.value.notes
}
