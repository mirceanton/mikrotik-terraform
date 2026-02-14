terraform {
  required_providers {
    onepassword = {
      source  = "1Password/onepassword"
      version = "3.2.1"
    }
  }
}

data "onepassword_vault" "vaults" {
  for_each = toset([for item in var.items : item.vault])
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
