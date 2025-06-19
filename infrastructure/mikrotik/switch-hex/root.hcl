# infrastructure/mikrotik/switch-hex/terragrunt.hcl
include "root" {
  path = find_in_parent_folders()
}

dependency "router" {
  config_path  = "../router-rb5009"
  skip_outputs = true
}

inputs = {
  mikrotik_username = get_env("MIKROTIK_USERNAME")
  mikrotik_password = get_env("MIKROTIK_PASSWORD")
}