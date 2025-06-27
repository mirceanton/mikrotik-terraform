# =================================================================================================
# Wireguard Interface
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/interface_wireguard
# =================================================================================================
resource "routeros_interface_wireguard" "wireguard" {
  name        = "wg0"
  comment     = "Wireguard VPN"
  listen_port = "13231"
  mtu         = 1420
}

# =================================================================================================
# Wireguard IP Address
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_address
# =================================================================================================
resource "routeros_ip_address" "wireguard" {
  address   = "192.168.250.1/24"
  interface = routeros_interface_wireguard.wireguard.name
  comment   = "Wireguard VPN"
  network   = "192.168.250.0"
}
