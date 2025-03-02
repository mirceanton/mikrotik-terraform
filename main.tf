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

module "crs326" {
  source            = "./modules/switch"
  mikrotik_ip       = "10.0.0.3"
  mikrotik_username = var.mikrotik_username
  mikrotik_password = var.mikrotik_password
  mikrotik_insecure = true

  hostname              = "Rach Slow"
  timezone              = local.timezone
  ntp_servers           = [local.cloudflare_ntp]
  dhcp_client_interface = local.vlans.Servers.name

  vlans = local.vlans
  ethernet_interfaces = {
    "ether1" = { comment = "Old NAS Onboard", untagged = local.vlans.Servers.name }
    "ether2" = { comment = "PVE 01 Onboard", untagged = local.vlans.Servers.name }
    "ether3" = { comment = "PVE 02 Onboard", untagged = local.vlans.Servers.name }
    "ether4" = { comment = "PVE 03 Onboard", untagged = local.vlans.Servers.name }
    "ether5" = {
      comment  = "New NAS Onboard",
      tagged   = [local.vlans.Trusted.name, local.vlans.Untrusted.name],
      untagged = local.vlans.Servers.name
    }
    "ether6" = {}
    "ether7" = { comment = "TeSmart KVM", untagged = local.vlans.Servers.name }
    "ether8" = { comment = "BliKVM", untagged = local.vlans.Servers.name }
    "ether9" = {
      comment = "Old NAS Data 1",
      tagged  = [local.vlans.Kubernetes.name, local.vlans.Untrusted.name, local.vlans.Trusted.name],
    }
    "ether10"      = {}
    "ether11"      = { comment = "HomeAssistant", untagged = local.vlans.Untrusted.name }
    "ether12"      = {}
    "ether13"      = {}
    "ether14"      = {}
    "ether15"      = {}
    "ether16"      = {}
    "ether17"      = {}
    "ether18"      = {}
    "ether19"      = {}
    "ether20"      = {}
    "ether21"      = {}
    "ether22"      = {}
    "ether23"      = { comment = "Uplink", tagged = local.all_vlans }
    "ether24"      = { comment = "mirkputer", untagged = local.vlans.Trusted.name }
    "sfp-sfpplus1" = {}
    "sfp-sfpplus2" = {}
  }
}

module "hex" {
  source            = "./modules/switch"
  mikrotik_ip       = "10.0.0.4"
  mikrotik_username = var.mikrotik_username
  mikrotik_password = var.mikrotik_password
  mikrotik_insecure = true

  hostname              = "Living Room Switch"
  timezone              = local.timezone
  ntp_servers           = [local.cloudflare_ntp]
  dhcp_client_interface = local.vlans.Servers.name

  vlans = local.vlans
  ethernet_interfaces = {
    "ether1" = { comment = "Rack Downlink", tagged = local.all_vlans }
    "ether2" = {}
    "ether3" = {}
    "ether4" = { comment = "Router Uplink", tagged = local.all_vlans }
    "ether5" = { comment = "Smart TV", untagged = local.vlans.IoT.name }
  }
}
