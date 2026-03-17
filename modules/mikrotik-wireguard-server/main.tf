# WireGuard interface
resource "routeros_interface_wireguard" "this" {
  name        = var.name
  comment     = var.comment
  listen_port = var.listen_port
  mtu         = var.mtu
  private_key = var.private_key
}

# IP address assigned to the WireGuard interface
resource "routeros_ip_address" "this" {
  address   = var.address
  interface = routeros_interface_wireguard.this.name
  comment   = var.comment
}


# =================================================================================================
# Outputs
# =================================================================================================
output "name" {
  description = "WireGuard interface name (e.g. 'wg0')"
  value       = routeros_interface_wireguard.this.name
}

output "public_key" {
  description = "WireGuard public key for this server interface"
  value       = routeros_interface_wireguard.this.public_key
}

output "private_key" {
  description = "WireGuard private key for this server interface (sensitive)"
  value       = routeros_interface_wireguard.this.private_key
  sensitive   = true
}

