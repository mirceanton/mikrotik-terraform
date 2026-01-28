# =================================================================================================
# User Passwords
# =================================================================================================
output "user_passwords" {
  description = "Map of user names to their passwords"
  value = {
    for k, v in var.users : k => v.password != null ? v.password : random_password.passwords[k].result
  }
  sensitive = true
}