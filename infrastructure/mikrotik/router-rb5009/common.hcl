locals {
  mikrotik_hostname = "10.0.0.1"
  mikrotik_globals     = read_terragrunt_config(find_in_parent_folders("globals.hcl")).locals
}

inputs = {
  mikrotik_hostname = "https://${local.mikrotik_hostname}"
  mikrotik_username = get_env("MIKROTIK_USERNAME")
  mikrotik_password = get_env("MIKROTIK_PASSWORD")
  mikrotik_insecure = true
}
