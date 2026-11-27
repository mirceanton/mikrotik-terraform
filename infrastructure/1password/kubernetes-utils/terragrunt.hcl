include "root" { path = find_in_parent_folders("root.hcl") }
dependency "router-rb5009" { config_path = find_in_parent_folders("mikrotik/router-rb5009") }

terraform {
  source = "git::https://github.com/mirceanton/terraform-modules-1password.git//modules/1password-item?ref=v0.1.1"
}

inputs = {
  vault_name = basename(get_terragrunt_dir())
  notes      = "Managed by Terraform in mirceanton/mikrotik-terraform."
  #? The item name is what the utils cluster's external-dns ExternalSecret reads.
  #? Filtered with `for` so planning works before the router user exists.
  secrets = {
    for user, pass in dependency.router-rb5009.outputs.user_passwords :
    "RB5009 - external-dns" => { category = "login", username = user, password = pass }
    if user == "external-dns-utils"
  }
}
