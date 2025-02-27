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
}