# =================================================================================================
# User Groups
# =================================================================================================
resource "routeros_system_user_group" "groups" {
  for_each = var.groups

  name    = each.key
  policy  = each.value.policies
  comment = each.value.comment
}


# =================================================================================================
# Random Passwords
# =================================================================================================
resource "random_password" "passwords" {
  for_each = { for k, v in var.users : k => v if v.password == null }

  length  = 16
  special = true
}
output "user_passwords" {
  description = "Map of user names to their passwords"
  value = {
    for k, v in var.users : k => v.password != null ? v.password : random_password.passwords[k].result
  }
  sensitive = true
}

# =================================================================================================
# Users
# =================================================================================================
resource "routeros_system_user" "users" {
  for_each = var.users

  name     = each.key
  group    = each.value.group
  password = each.value.password != null ? each.value.password : random_password.passwords[each.key].result
  comment  = each.value.comment
  address  = each.value.address

  depends_on = [routeros_system_user_group.groups]
}