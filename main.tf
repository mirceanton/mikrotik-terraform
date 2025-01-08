module "rb5009" {
  source              = "./modules/rb5009"
  mikrotik_host_url   = "https://192.168.88.1"
  mikrotik_username   = var.mikrotik_username
  mikrotik_password   = var.mikrotik_password
  mikrotik_insecure   = true
  digi_pppoe_password = var.digi_pppoe_password
  digi_pppoe_username = var.digi_pppoe_username
  wifi_password       = var.wifi_password
}

module "crs317" {
  source            = "./modules/crs317"
  mikrotik_host_url = "https://192.168.88.2"
  mikrotik_username = var.mikrotik_username
  mikrotik_password = var.mikrotik_password
  mikrotik_insecure = true
}

module "crs326" {
  source            = "./modules/crs326"
  mikrotik_host_url = "https://192.168.88.3"
  mikrotik_username = var.mikrotik_username
  mikrotik_password = var.mikrotik_password
  mikrotik_insecure = true
}
