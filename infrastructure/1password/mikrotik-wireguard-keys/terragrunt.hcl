include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "wireguard-server" { config_path = find_in_parent_folders("mikrotik/router-rb5009/services/wireguard/server") }
dependency "wireguard-peers" { config_path = find_in_parent_folders("mikrotik/router-rb5009/services/wireguard/peers") }

locals {
  wireguard_keys = merge(
    { "Homelab - WireGuard" = { username = dependency.wireguard-server.outputs.public_key, password = dependency.wireguard-server.outputs.private_key } },
    { for name, keys in dependency.wireguard-peers.outputs.peers : "WireGuard - ${name}" => { username = keys.public_key, password = keys.private_key } },
  )
}

terraform {
  source = "git::https://github.com/mirceanton/terraform-modules-1password.git//modules/1password-item?ref=v0.1.0"
}

inputs = {
  vault_name = basename(get_terragrunt_dir())
  notes      = "Managed by Terraform in mirceanton/mikrotik-terraform."
  secrets    = { for k, v in local.wireguard_keys : k => merge(v, { category = "login" }) }
}
