# =================================================================================================
# DHCP Client
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_dhcp_client
# =================================================================================================
resource "routeros_ip_dhcp_client" "client" {
  interface    = var.dhcp_client_interface
  comment      = var.dhcp_client_comment
  use_peer_dns = var.dhcp_client_use_peer_dns
  use_peer_ntp = false
}
