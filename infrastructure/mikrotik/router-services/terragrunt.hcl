include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependencies {
  paths = [
    find_in_parent_folders("mikrotik/router-base")
  ]
}

generate "locals" {
  path      = "locals.tf"
  if_exists = "overwrite_terragrunt"
  contents  = file(find_in_parent_folders("locals.hcl"))
}

locals {
  mikrotik_hostname = "10.0.0.1"
}

terraform {
  source = find_in_parent_folders("modules/mikrotik-router-services")
}

inputs = {
  mikrotik_hostname = "https://${local.mikrotik_hostname}"
  mikrotik_username = get_env("MIKROTIK_USERNAME")
  mikrotik_password = get_env("MIKROTIK_PASSWORD")
  mikrotik_insecure = true

  digi_pppoe_password    = get_env("PPPOE_PASSWORD")
  digi_pppoe_username    = get_env("PPPOE_USERNAME")
  zerotier_central_token = get_env("ZEROTIER_CENTRAL_TOKEN")
}

