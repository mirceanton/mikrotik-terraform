locals {
  timezone       = "Europe/Bucharest"
  cloudflare_ntp = "time.cloudflare.com"
}

module "rb5009_mig" {
  source = "./modules/base"
  mikrotik_ip       = "10.0.0.1"
  mikrotik_username = var.mikrotik_username
  mikrotik_password = var.mikrotik_password
  mikrotik_insecure = true

  hostname    = "Router"
  timezone    = local.timezone
  ntp_servers = [local.cloudflare_ntp]

  pppoe_client_enabled = true
  pppoe_client_interface = "ether1" # !FIXME
  pppoe_client_comment = "Digi PPPoE"
  pppoe_client_name = "pppoe-digi"
  pppoe_username = var.digi_pppoe_username
  pppoe_password = var.digi_pppoe_password
}

module "crs326_mig" {
  source = "./modules/base"
  mikrotik_ip       = "10.0.0.3"
  mikrotik_username = var.mikrotik_username
  mikrotik_password = var.mikrotik_password
  mikrotik_insecure = true

  hostname    = "Rach Slow"
  timezone    = local.timezone
  ntp_servers = [local.cloudflare_ntp]

  dhcp_client_enabled = true
  dhcp_client_interface = "Servers" # !FIXME
}

module "hex_mig" {
  source = "./modules/base"
  mikrotik_ip       = "10.0.0.4"
  mikrotik_username = var.mikrotik_username
  mikrotik_password = var.mikrotik_password
  mikrotik_insecure = true

  hostname    = "Living Room Switch"
  timezone    = local.timezone
  ntp_servers = [local.cloudflare_ntp]

  dhcp_client_enabled = true
  dhcp_client_interface = "Servers" # !FIXME
}

module "rb5009" {
  source                  = "./devices/rb5009"
  mikrotik_host_url       = "https://10.0.0.1"
  mikrotik_username       = var.mikrotik_username
  mikrotik_password       = var.mikrotik_password
  mikrotik_insecure       = true
  digi_pppoe_password     = var.digi_pppoe_password
  digi_pppoe_username     = var.digi_pppoe_username
  untrusted_wifi_password = var.untrusted_wifi_password
  guest_wifi_password     = var.guest_wifi_password
  iot_wifi_password       = var.iot_wifi_password
}

module "crs326" {
  source            = "./devices/crs326"
  mikrotik_host_url = "https://10.0.0.3"
  mikrotik_username = var.mikrotik_username
  mikrotik_password = var.mikrotik_password
  mikrotik_insecure = true
}

module "hex" {
  source            = "./devices/hex"
  mikrotik_host_url = "https://10.0.0.4"
  mikrotik_username = var.mikrotik_username
  mikrotik_password = var.mikrotik_password
  mikrotik_insecure = true
}
