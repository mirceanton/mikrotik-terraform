module "base" {
  source = "../base"

  mikrotik_ip              = var.mikrotik_ip
  mikrotik_username        = var.mikrotik_username
  mikrotik_password        = var.mikrotik_password
  mikrotik_insecure        = var.mikrotik_insecure
  hostname                 = var.hostname
  timezone                 = var.timezone
  disable_ipv6             = var.disable_ipv6
  ntp_servers              = var.ntp_servers
  mac_server_interfaces    = var.mac_server_interfaces
  certificate_country      = var.certificate_country
  certificate_locality     = var.certificate_locality
  certificate_organization = var.certificate_organization
  certificate_unit         = var.certificate_unit
  vlans                    = var.vlans
  ethernet_interfaces      = var.ethernet_interfaces
}

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
