module "rb5009" {
  source                  = "./modules/rb5009"
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

module "crs317" {
  source            = "./modules/crs317"
  mikrotik_host_url = "https://10.0.0.2"
  mikrotik_username = var.mikrotik_username
  mikrotik_password = var.mikrotik_password
  mikrotik_insecure = true
}

module "crs326" {
  source            = "./modules/crs326"
  mikrotik_host_url = "https://10.0.0.3"
  mikrotik_username = var.mikrotik_username
  mikrotik_password = var.mikrotik_password
  mikrotik_insecure = true
}

module "hex" {
  source            = "./modules/hex"
  mikrotik_host_url = "https://10.0.0.4"
  mikrotik_username = var.mikrotik_username
  mikrotik_password = var.mikrotik_password
  mikrotik_insecure = true
}
