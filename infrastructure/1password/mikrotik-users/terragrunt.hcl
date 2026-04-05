include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "switch-crs326" { config_path = find_in_parent_folders("mikrotik/switch-crs326") }
dependency "switch-hex" { config_path = find_in_parent_folders("mikrotik/switch-hex") }
dependency "switch-crs317" { config_path = find_in_parent_folders("mikrotik/switch-crs317") }
dependency "router-rb5009" { config_path = find_in_parent_folders("mikrotik/router-rb5009") }

locals {
  routeros_users = merge(
    { for user, pass in dependency.switch-crs326.outputs.user_passwords : "CRS326 - ${user}" => { username = user, password = pass } },
    { for user, pass in dependency.switch-hex.outputs.user_passwords : "HEX - ${user}" => { username = user, password = pass } },
    { for user, pass in dependency.switch-crs317.outputs.user_passwords : "CRS317 - ${user}" => { username = user, password = pass } },
    { for user, pass in dependency.router-rb5009.outputs.user_passwords : "RB5009 - ${user}" => { username = user, password = pass } },
  )
}

terraform {
  source = "git::https://github.com/mirceanton/terraform-modules-1password.git//modules/1password-item?ref=v0.1.0"
}

inputs = {
  vault_name = basename(get_terragrunt_dir())
  notes      = "Managed by Terraform in mirceanton/mikrotik-terraform."
  secrets    = { for k, v in local.routeros_users : k => merge(v, { category = "login" }) }
}
