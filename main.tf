module "rb5009" {
  source            = "./modules/router"
  mikrotik_ip       = "10.0.0.1"
  mikrotik_username = var.mikrotik_username
  mikrotik_password = var.mikrotik_password
  mikrotik_insecure = true

  hostname    = "Router"
  timezone    = local.timezone
  ntp_servers = [local.cloudflare_ntp]

  pppoe_client_interface = "ether1"
  pppoe_client_comment   = "Digi PPPoE Client"
  pppoe_client_name      = "PPPoE-Digi"
  pppoe_username         = var.digi_pppoe_username
  pppoe_password         = var.digi_pppoe_password

  mdns_repeat_ifaces = [local.vlans.IoT.name, local.vlans.Untrusted.name]
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

  vlans = local.vlans
  ethernet_interfaces = {
    "ether1" = { comment = "Digi Uplink", bridge_port = false }
    "ether2" = { comment = "Living Room", tagged = local.all_vlans }
    "ether3" = { comment = "Sploinkhole", untagged = local.vlans.Trusted.name }
    "ether4" = {}
    "ether5" = {}
    "ether6" = {}
    "ether7" = {}
    "ether8" = {
      comment  = "Access Point",
      untagged = local.vlans.Servers.name
      tagged   = [local.vlans.Untrusted.name, local.vlans.Guest.name, local.vlans.IoT.name]
    }
    "sfp-sfpplus1" = {}
  }


  untrusted_wifi_password = var.untrusted_wifi_password
  iot_wifi_password = var.iot_wifi_password
  guest_wifi_password = var.guest_wifi_password
}
