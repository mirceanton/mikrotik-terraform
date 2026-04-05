include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "capsman" { config_path = find_in_parent_folders("mikrotik/router-rb5009/services/capsman") }

terraform {
  source = "git::https://github.com/mirceanton/terraform-modules-1password.git//modules/1password-item?ref=v0.1.0"
}

inputs = {
  vault_name = basename(get_terragrunt_dir())
  notes      = "Managed by Terraform in mirceanton/mikrotik-terraform."
  secrets = {
    "WiFi - Badoink 5Ghz" = {
      category = "password"
      password = dependency.capsman.outputs.wifi_passphrases["home-5ghz"]
    }
    "WiFi - Badoink 2Ghz" = {
      category = "password"
      password = dependency.capsman.outputs.wifi_passphrases["home-2ghz"]
    }
    "WiFi - Guest" = {
      category = "password"
      password = dependency.capsman.outputs.wifi_passphrases["guest"]
    }
  }
}
