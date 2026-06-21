include "root" { path = find_in_parent_folders("root.hcl") }
dependency "wireguard-server" { config_path = find_in_parent_folders("mikrotik/router-rb5009/services/wireguard/server") }
dependency "wireguard-peers" { config_path = find_in_parent_folders("mikrotik/router-rb5009/services/wireguard/peers") }

locals {
  peers_config = read_terragrunt_config(find_in_parent_folders("mikrotik/router-rb5009/services/wireguard/peers.hcl"))
}

terraform {
  source = "git::https://github.com/mirceanton/terraform-modules-1password.git//modules/1password-item?ref=v0.1.1"
}

inputs = {
  vault_name = basename(get_terragrunt_dir())
  notes      = "Managed by Terraform in mirceanton/mikrotik-terraform."
  secrets = merge(
    { "Homelab - WireGuard" = { category = "login", username = dependency.wireguard-server.outputs.public_key, password = dependency.wireguard-server.outputs.private_key } },
    {
      for name, keys in dependency.wireguard-peers.outputs.peers : "WireGuard - ${name}" => {
        category = "login"
        username = keys.public_key
        password = keys.private_key
        sections = [
          {
            label = "WireGuard"
            fields = [
              {
                label = "wireguard.conf"
                type  = "STRING"
                value = <<-EOT
                  [Interface]
                  # Name = mirceanton
                  # PublicKey = ${keys.public_key}
                  PrivateKey = ${keys.private_key}
                  Address = ${local.peers_config.locals.peers[name].address}
                  DNS = 10.0.10.1

                  [Peer]
                  PublicKey = ${dependency.wireguard-server.outputs.public_key}
                  Endpoint = vpn.mirceanton.com:${dependency.wireguard-server.outputs.listen_port}
                  AllowedIPs = 10.0.10.0/24
                  EOT
              },
            ]
          },
        ]
      }
    },
  )
}
