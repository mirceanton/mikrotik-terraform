include "root" { path = find_in_parent_folders("root.hcl") }
include "provider" { path = find_in_parent_folders("provider.hcl") }

dependency "wireguard_server" {
  config_path = find_in_parent_folders("services/wireguard-server")
}

terraform {
  source = find_in_parent_folders("modules/mikrotik-wireguard-peers")
}

inputs = {
  interface = dependency.wireguard_server.outputs.name

  peers = {
    "ashome"     = { allowed_address = ["172.16.69.10/32", "192.168.10.0/24"], comment = "AS Home" }
    "mirkphone"  = { allowed_address = ["172.16.69.11/32"], comment = "Mirkphone" }
    "soarephone" = { allowed_address = ["172.16.69.12/32"], comment = "Cristi Soare Mobil" }
    "vladputer"  = { allowed_address = ["172.16.69.13/32"], comment = "Vlad Computer" }
  }
}
