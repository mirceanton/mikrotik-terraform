include "root" {
  path = find_in_parent_folders()
}

dependency "crs326" {
  config_path  = "../switch-crs326"
  skip_outputs = true
}

inputs = {
  mikrotik_username = get_env("MIKROTIK_USERNAME")
  mikrotik_password = get_env("MIKROTIK_PASSWORD")
}