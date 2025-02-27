locals {
  timezone       = "Europe/Bucharest"
  cloudflare_ntp = "time.cloudflare.com"
}

module "rb5009_mig" {
  source            = "./modules/router"
  mikrotik_ip       = "10.0.0.1"
  mikrotik_username = var.mikrotik_username
  mikrotik_password = var.mikrotik_password
  mikrotik_insecure = true

  hostname    = "Router"
  timezone    = local.timezone
  ntp_servers = [local.cloudflare_ntp]

  pppoe_client_interface = "ether1" # !FIXME
  pppoe_client_comment   = "Digi PPPoE Client"
  pppoe_client_name      = "PPPoE-Digi"
  pppoe_username         = var.digi_pppoe_username
  pppoe_password         = var.digi_pppoe_password

  mdns_repeat_ifaces = ["IoT", "Untrusted"] #! FIXME
  adlist_url         = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
  static_dns = {
    "nas.trst.h.mirceanton.com"  = { address = "192.168.69.245", type = "A", comment = "TrueNAS Trusted" },
    "nas.utrst.h.mirceanton.com" = { address = "192.168.42.245", type = "A", comment = "TrueNAS Untrusted" },
    "nas.k8s.h.mirceanton.com"   = { address = "10.0.10.245", type = "A", comment = "TrueNAS K8S" },
    "nas.srv.h.mirceanton.com"   = { address = "10.0.0.245", type = "A", comment = "TrueNAS Servers" },

    "hass.home.mirceanton.com"    = { address = "192.168.42.253", type = "A", comment = "HomeAssistant Odroid" },
    "truenas.home.mirceanton.com" = { address = "10.0.0.245", type = "A", comment = "TrueNAS Management Interface" },
    "proxmox.home.mirceanton.com" = { address = "10.0.0.240", type = "A", comment = "Proxmox Management Interface" },
  }
}

module "crs326_mig" {
  source            = "./modules/switch"
  mikrotik_ip       = "10.0.0.3"
  mikrotik_username = var.mikrotik_username
  mikrotik_password = var.mikrotik_password
  mikrotik_insecure = true

  hostname              = "Rach Slow"
  timezone              = local.timezone
  ntp_servers           = [local.cloudflare_ntp]
  dhcp_client_interface = "Servers" # !FIXME
}

module "hex_mig" {
  source            = "./modules/switch"
  mikrotik_ip       = "10.0.0.4"
  mikrotik_username = var.mikrotik_username
  mikrotik_password = var.mikrotik_password
  mikrotik_insecure = true

  hostname              = "Living Room Switch"
  timezone              = local.timezone
  ntp_servers           = [local.cloudflare_ntp]
  dhcp_client_interface = "Servers" # !FIXME
}