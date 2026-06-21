include "root" { path = find_in_parent_folders("root.hcl") }
include "provider" { path = find_in_parent_folders("provider.hcl") }

locals {
  peers_config = read_terragrunt_config(find_in_parent_folders("mikrotik/router-rb5009/services/wireguard/peers.hcl"))
}

dependency "wireguard_server" {
  config_path = find_in_parent_folders("wireguard/server")
}

terraform {
  source = "git::https://github.com/mirceanton/terraform-modules-routeros.git//modules/wireguard-peers?ref=v0.3.0"
}

inputs = {
  interface = dependency.wireguard_server.outputs.name

  peers = {
    for name, peer in local.peers_config.locals.peers : name => {
      allowed_address = concat([peer.address], peer.extra_routes)
      comment         = peer.comment
    }
  }
}