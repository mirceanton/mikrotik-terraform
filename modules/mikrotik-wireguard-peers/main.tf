resource "routeros_wireguard_keys" "peers" {
  for_each = var.peers
  number   = 1
}

resource "routeros_interface_wireguard_peer" "this" {
  for_each = var.peers

  interface            = var.interface
  public_key           = routeros_wireguard_keys.peers[each.key].keys[0].public
  allowed_address      = each.value.allowed_address
  comment              = each.value.comment
  endpoint_address     = each.value.endpoint_address
  endpoint_port        = each.value.endpoint_port
  persistent_keepalive = each.value.persistent_keepalive
}

output "peers" {
  description = "Map of peer name to generated keys"
  sensitive   = true
  value = {
    for k, v in routeros_wireguard_keys.peers : k => {
      public_key    = v.keys[0].public
      private_key   = v.keys[0].private
      preshared_key = v.keys[0].preshared
    }
  }
}
