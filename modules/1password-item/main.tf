data "onepassword_vault" "vault" {
  name = var.vault
}

resource "onepassword_item" "items" {
  for_each = var.items

  vault    = data.onepassword_vault.vault.uuid
  title    = each.key
  category = each.value.category

  password_recipe {
    length  = length(each.value.password)
    digits  = true
    symbols = false
  }

  section {
    label = "Credentials"

    field {
      label = "password"
      type  = "CONCEALED"
      value = each.value.password
    }
  }

  section {
    label = "Notes"

    field {
      label = "notes"
      type  = "STRING"
      value = each.value.notes
    }
  }
}
