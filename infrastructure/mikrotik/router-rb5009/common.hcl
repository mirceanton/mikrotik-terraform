locals {
  mikrotik_hostname = "10.0.0.1"
  shared_locals     = read_terragrunt_config(find_in_parent_folders("locals.hcl")).locals
}

inputs = {
  mikrotik_hostname = "https://${local.mikrotik_hostname}"
  mikrotik_username = get_env("MIKROTIK_USERNAME")
  mikrotik_password = get_env("MIKROTIK_PASSWORD")
  mikrotik_insecure = true
}
