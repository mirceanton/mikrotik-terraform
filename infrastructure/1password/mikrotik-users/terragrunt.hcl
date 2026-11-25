include "root" { path = find_in_parent_folders("root.hcl") }
dependency "switch-hex" { config_path = find_in_parent_folders("mikrotik/switch-hex") }
dependency "switch-crs310" { config_path = find_in_parent_folders("mikrotik/switch-crs310") }
dependency "router-rb5009" { config_path = find_in_parent_folders("mikrotik/router-rb5009") }
dependency "ap-capxl" { config_path = find_in_parent_folders("mikrotik/ap-capxl") }

terraform {
  source = "git::https://github.com/mirceanton/terraform-modules-1password.git//modules/1password-item?ref=v0.1.1"
}

inputs = {
  vault_name = basename(get_terragrunt_dir())
  notes      = "Managed by Terraform in mirceanton/mikrotik-terraform."
  secrets = merge(
    { for user, pass in dependency.switch-hex.outputs.user_passwords : "HEX - ${user}" => { category = "login", username = user, password = pass } },
    { for user, pass in dependency.switch-crs310.outputs.user_passwords : "CRS310 - ${user}" => { category = "login", username = user, password = pass } },
    { for user, pass in dependency.router-rb5009.outputs.user_passwords : "RB5009 - ${user}" => { category = "login", username = user, password = pass } },
    { for user, pass in dependency.ap-capxl.outputs.user_passwords : "CAPXL - ${user}" => { category = "login", username = user, password = pass } },
  )
}
