include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependencies {
  paths = [
    find_in_parent_folders("mikrotik/router-rb5009")
  ]
}

generate "locals" {
  path      = "locals.tf"
  if_exists = "overwrite_terragrunt"
  contents  = file(find_in_parent_folders("locals.hcl"))
}

terraform {
  source = "${get_repo_root()}//infrastructure/mikrotik/router-rb5009/services"
}

inputs = {
  mikrotik_hostname = "https://${read_terragrunt_config(find_in_parent_folders("terragrunt.hcl")).locals.mikrotik_hostname}"
  mikrotik_username = get_env("MIKROTIK_USERNAME")
  mikrotik_password = get_env("MIKROTIK_PASSWORD")
  mikrotik_insecure = true

  digi_pppoe_password = get_env("DIGI_PPPOE_PASSWORD")
  digi_pppoe_username = get_env("DIGI_PPPOE_USERNAME")
  untrusted_wifi_password = get_env("UNTRUSTED_WIFI_PASSWORD")
  guest_wifi_password = get_env("GUEST_WIFI_PASSWORD")
  iot_wifi_password = get_env("IOT_WIFI_PASSWORD")
}

