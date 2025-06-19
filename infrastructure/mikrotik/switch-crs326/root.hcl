include "root" {
  path = find_in_parent_folders()
}

dependency "hex" {
  config_path  = "../switch-hex"
  skip_outputs = true
}

inputs = {
  mikrotik_username = get_env("MIKROTIK_USERNAME")
  mikrotik_password = get_env("MIKROTIK_PASSWORD")
}